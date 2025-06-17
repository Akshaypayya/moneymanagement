import 'package:growk_v2/views.dart';
import 'package:intl/intl.dart';

final editUserControllerProvider = Provider<EditUserController>((ref) {
  return const EditUserController();
});

class EditUserController {
  const EditUserController();

  TextEditingController nameController(WidgetRef ref) =>
      ref.read(nameControllerProvider);

  TextEditingController emailController(WidgetRef ref) =>
      ref.read(emailControllerProvider);

  void showDateOfBirthPicker(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();

    final pickedDate = await DatePickerUtils.showThemedDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final backendFormatted = DateFormat('yyyy-MM-dd').format(pickedDate);
      final uiFormatted = DateFormat('dd/MM/yyyy').format(pickedDate);

      ref.read(dobProvider.notifier).state = backendFormatted;
      ref.read(dobUiProvider.notifier).state = uiFormatted;
      ref.read(dobErrorProvider.notifier).state = null;
    }
  }

  void showGenderSheet(BuildContext context, WidgetRef ref) {
    FocusScope.of(context).unfocus(); // 👈 Remove keyboard

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommonBottomSheet(
        title: 'Select Gender',
        options: ['Male', 'Female', 'Other'],
        onSelected: (value) {
          ref.read(genderProvider.notifier).state = value;
          ref.read(genderErrorProvider.notifier).state = null;
        },
      ),
    );
  }

  Future<void> prefillUserData(WidgetRef ref) async {
    final existingData = ref.read(userProfileStateProvider).userData;
    if (existingData == null) {
      final controller = ref.read(userProfileControllerProvider);
      await controller.getUserProfile(ref);
    }

    final userData = ref.read(userProfileStateProvider).userData;
    if (userData != null) {
      ref.read(nameControllerProvider).text = userData.userName ?? '';
      ref.read(emailControllerProvider).text = userData.emailId ?? '';

      final genderCode = (userData.gender ?? '').toUpperCase();
      final genderText = switch (genderCode) {
        'M' => 'Male',
        'F' => 'Female',
        'T' => 'Other',
        _ => ''
      };
      ref.read(genderProvider.notifier).state = genderText;

      final dob = userData.dob ?? '';
      ref.read(dobProvider.notifier).state = dob;

      if (dob.isNotEmpty) {
        try {
          final parsedDate = DateFormat('yyyy-MM-dd').parse(dob);
          final formattedUiDate = DateFormat('dd/MM/yyyy').format(parsedDate);
          ref.read(dobUiProvider.notifier).state = formattedUiDate;
        } catch (e) {
          debugPrint('❌ Failed to parse DOB: $e');
          ref.read(dobUiProvider.notifier).state = '';
        }
      } else {
        ref.read(dobUiProvider.notifier).state = '';
      }
    }
  }

  bool validateInputs(BuildContext context, WidgetRef ref) {
    final name = nameController(ref).text.trim();
    final email = emailController(ref).text.trim();
    final gender = ref.read(genderProvider).trim();
    final dob = ref.read(dobProvider).trim();
    final imageFile = ref.read(profilePictureFileProvider);

    bool isValid = true;

    // Reset all errors
    ref.read(nameErrorProvider.notifier).state = null;
    ref.read(emailErrorProvider.notifier).state = null;
    ref.read(genderErrorProvider.notifier).state = null;
    ref.read(dobErrorProvider.notifier).state = null;
    ref.read(imageErrorProvider.notifier).state = null;

    if (name.isEmpty) {
      const msg = 'Name is required';
      ref.read(nameErrorProvider.notifier).state = msg;
      debugPrint('❌ Validation: $msg');
      isValid = false;
    }

    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w]{2,}$');
    if (email.isEmpty) {
      const msg = 'Email is required';
      ref.read(emailErrorProvider.notifier).state = msg;
      debugPrint('❌ Validation: $msg');
      isValid = false;
    } else if (!emailRegex.hasMatch(email)) {
      const msg = 'Enter a valid email address';
      ref.read(emailErrorProvider.notifier).state = msg;
      debugPrint('❌ Validation: $msg');
      isValid = false;
    }

    if (gender.isEmpty) {
      const msg = 'Please select gender';
      ref.read(genderErrorProvider.notifier).state = msg;
      debugPrint('❌ Validation: $msg');
      isValid = false;
    }

    if (dob.isEmpty) {
      const msg = 'Please select your date of birth';
      ref.read(dobErrorProvider.notifier).state = msg;
      debugPrint('❌ Validation: $msg');
      isValid = false;
    }

    // if (imageFile == null) {
    //   const msg = 'Please upload a profile picture';
    //   ref.read(imageErrorProvider.notifier).state = msg;
    //   debugPrint('❌ Validation: $msg');
    //   isValid = false;
    // }

    return isValid;
  }

  Future<void> saveUserDetails(BuildContext context, WidgetRef ref) async {
    ref.read(isButtonLoadingProvider.notifier).state = true;

    final name = nameController(ref).text.trim();
    final email = emailController(ref).text.trim();
    final dob = ref.read(dobProvider);
    final genderText = ref.read(genderProvider);

    if (!validateInputs(context, ref)) {
      ref.read(isButtonLoadingProvider.notifier).state = false;
      return;
    }

    final imageFile = ref.read(profilePictureFileProvider); // read once here

    if (imageFile != null) {
      ref.read(profilePictureUploadStateProvider.notifier).setLoading();
      await ref
          .read(profilePictureControllerProvider)
          .uploadProfilePicture(ref, context);

      final uploadState = ref.read(profilePictureUploadStateProvider);
      if (uploadState.status != UploadStatus.success) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: uploadState.message ?? "Profile picture upload failed.",
          type: SnackType.error,
        );
        ref.read(isButtonLoadingProvider.notifier).state = false;
        return;
      }
    }

    final genderCode = switch (genderText.toLowerCase()) {
      'male' => 'M',
      'female' => 'F',
      'other' => 'T',
      _ => '',
    };

    if (genderCode.isEmpty) {
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'Invalid gender selection.',
        type: SnackType.error,
      );
      ref.read(isButtonLoadingProvider.notifier).state = false;
      return;
    }

    final useCase = ref.read(updateUserDetailsUseCaseProvider);
    try {
      final response = await useCase.call(
        userName: name,
        emailId: email,
        dob: dob,
        gender: genderCode,
      );

      if (response.status.toLowerCase() != 'success') {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: response.message ?? 'Failed to update user details.',
          type: SnackType.error,
        );
        ref.read(isButtonLoadingProvider.notifier).state = false;
        return;
      }

      debugPrint('✅ User updated successfully: ${response.message}');
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'Profile updated successfully!',
        type: SnackType.success,
      );
    } catch (e) {
      debugPrint('❌ API Error: $e');
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'Something went wrong while updating user.',
        type: SnackType.error,
      );
    } finally {
      ref.read(isButtonLoadingProvider.notifier).state = false;
    }

    final profile = ref.read(userProfileProvider);
    final hasProfileData = profile != null && profile.dob.isNotEmpty;

    debugPrint('PROFILE CHECK: ${hasProfileData ? "Has Data ✅" : "No Data ❌"}');
    ref.read(bottomNavBarProvider.notifier).state = hasProfileData ? 3 : 0;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.mainScreen,
      (route) => false,
    );
  }

  void showImageSourceActionSheet(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MinimalOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      isDark: isDark,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await ref
                            .read(profilePictureControllerProvider)
                            .captureProfilePicture(ref, context);
                        ref.read(imageErrorProvider.notifier).state =
                            null; // ✅ clear on select
                      },
                    ),
                    MinimalOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      isDark: isDark,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await ref
                            .read(profilePictureControllerProvider)
                            .pickProfilePicture(ref, context);
                        ref.read(imageErrorProvider.notifier).state =
                            null; // ✅ clear on select
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showError(BuildContext context, String message, WidgetRef ref) {
    showGrowkSnackBar(
      context: context,
      ref: ref,
      message: message,
      type: SnackType.error,
    );
  }
}
