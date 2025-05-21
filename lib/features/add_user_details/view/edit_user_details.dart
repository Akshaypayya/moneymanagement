import 'package:money_mangmnt/features/add_user_details/provider/update_user_provider.dart';
import 'package:money_mangmnt/views.dart';

class EditUserDetails extends ConsumerStatefulWidget {
  const EditUserDetails({super.key});

  @override
  ConsumerState<EditUserDetails> createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends ConsumerState<EditUserDetails> {
  bool _isPrefilled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isPrefilled) {
        _isPrefilled = true;
        ref.read(editUserControllerProvider).prefillUserData(ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(editUserControllerProvider);
    final imageFile = ref.watch(profilePictureFileProvider);
    final uploadState = ref.watch(profilePictureUploadStateProvider);
    final profileState = ref.watch(userProfileStateProvider);
    final userData = profileState.userData;
    final hasProfilePictureFromApi =
        userData?.profilePicture?.isNotEmpty == true;
    final isUploading = uploadState.status == UploadStatus.loading;
    final isSaving = ref.watch(isButtonLoadingProvider);
    final genderError = ref.watch(genderErrorProvider);
    final dobError = ref.watch(dobErrorProvider);
    final imageError = ref.watch(imageErrorProvider);
    final profile = ref.watch(userProfileProvider);
    final hasProfileData = (profile?.dob ?? '').isNotEmpty;

    debugPrint('PROFILE CHECK: ${hasProfileData ? "Has Data ✅" : "No Data ❌"}');

    return ScalingFactor(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScaffold(
          appBar: GrowkAppBar(
            title: 'Edit User Details',
            isBackBtnNeeded: hasProfileData,
          ),
          body: SingleChildScrollView(
            child: ReusablePadding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: isUploading
                              ? null
                              : () => controller.showImageSourceActionSheet(
                                  context, ref),
                          child: Stack(
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[200],
                                  image: imageFile != null
                                      ? DecorationImage(
                                          image: FileImage(imageFile),
                                          fit: BoxFit.cover,
                                        )
                                      : hasProfilePictureFromApi
                                          ? DecorationImage(
                                              image: MemoryImage(
                                                base64Decode(
                                                    userData!.profilePicture!),
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                ),
                                child: (imageFile == null &&
                                        !hasProfilePictureFromApi)
                                    ? const Icon(Icons.person,
                                        size: 60, color: Colors.grey)
                                    : (isUploading && !isSaving)
                                        ? Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: isUploading
                                      ? const SizedBox()
                                      : const Icon(Icons.camera_alt,
                                          color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (imageError != null && imageError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              imageError,
                              style: AppTextStyle(textColor: Colors.red)
                                  .labelSmall,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Name
                  ReusableTextField(
                    isMandatory: true,
                    label: 'Name',
                    icon: Icons.person,
                    inputFormatters: AppInputFormatters.nameFormatter(),
                    controller: controller.nameController(ref),
                    hintText: 'Enter your full name',
                    errorText: ref.watch(nameErrorProvider),
                    onChanged: (value) {
                      if (ref.read(nameErrorProvider) != null) {
                        ref.read(nameErrorProvider.notifier).state = null;
                      }
                    },
                  ),

                  /// Email
                  ReusableTextField(
                    isMandatory: true,
                    label: 'Email',
                    icon: Icons.email,
                    inputFormatters: AppInputFormatters.emailFormatter(),
                    controller: controller.emailController(ref),
                    hintText: 'Enter your email address',
                    errorText: ref.watch(emailErrorProvider),
                    onChanged: (value) {
                      if (ref.read(emailErrorProvider) != null) {
                        ref.read(emailErrorProvider.notifier).state = null;
                      }
                    },
                  ),

                  /// Gender
                  GrowkBottomSheetNavigator(
                    isMandatory: true,
                    label: 'Gender',
                    icon: Icons.male,
                    valueText: ref.watch(genderProvider).isEmpty
                        ? 'Select gender'
                        : ref.watch(genderProvider),
                    onTap: () {
                      if (ref.read(genderErrorProvider) != null) {
                        ref.read(genderErrorProvider.notifier).state = null;
                      }
                      controller.showGenderSheet(context, ref);
                    },
                    // onClear: () => ref.read(genderProvider.notifier).state = '', // 👈 Reset on cancel
                    errorText: genderError,
                  ),

                  /// DOB
                  GrowkBottomSheetNavigator(
                    isMandatory: true,
                    label: 'Date of Birth',
                    icon: Icons.cake,
                    valueText: ref.watch(dobProvider).isEmpty
                        ? 'Select your date of birth'
                        : ref.watch(dobProvider),
                    onTap: () {
                      if (ref.read(dobErrorProvider) != null) {
                        ref.read(dobErrorProvider.notifier).state = null;
                      }
                      controller.showDateOfBirthPicker(context, ref);
                    },
                    errorText: dobError,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),

                  GrowkButton(
                    title: 'Save',
                    onTap: () => controller.saveUserDetails(context, ref),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
