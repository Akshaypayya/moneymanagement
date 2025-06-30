import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/btm_shet_stndng_instrctn.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/stnding_instrction_botom_sheet.dart';
import 'package:growk_v2/features/goals/goal_page_checker/view/goal_page_checker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/services/icon_mapping_service.dart';
import 'package:growk_v2/views.dart';
import 'package:growk_v2/features/goals/edit_goal_page/repo/edit_goal_repo.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:growk_v2/core/utils/app_permission.dart';

class CreateGoalController {
  final Ref ref;

  const CreateGoalController(this.ref);

  void pickGoalImageActionSheet(BuildContext context, WidgetRef widgetRef) {
    final isDark = widgetRef.watch(isDarkProvider);

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
                  'Choose Goal Picture',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                GapSpace.height30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showGoalIcon(
                        image: 'homepng.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('home.jpg');
                          Navigator.of(context).pop();
                        },
                        label: 'Home'),
                    showGoalIcon(
                        image: 'educationpng.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('education.jpg');
                          Navigator.of(context).pop();
                        },
                        label: 'Education'),
                    showGoalIcon(
                        image: 'weddingpng.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('wedding.jpg');
                          Navigator.of(context).pop();
                        },
                        label: 'Wedding'),
                  ],
                ),
                GapSpace.height30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    showGoalIcon(
                        image: 'trippng.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('trip.jpg');
                          Navigator.of(context).pop();
                        },
                        label: 'Trip'),
                    showGoalIcon(
                        image: 'customgoalspng.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('customgoals.jpg');
                          Navigator.of(context).pop();
                        },
                        label: 'Custom Goal'),
                  ],
                ),
                GapSpace.height30,
                Divider(
                  thickness: 0.2,
                  color: isDark ? Colors.white : Colors.black,
                ),
                GapSpace.height30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MinimalOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      isDark: isDark,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _pickImageFromCamera(context, widgetRef);
                      },
                    ),
                    MinimalOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      isDark: isDark,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _pickImageFromGallery(context, widgetRef);
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

  // String? validateGoalName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter a goal name';
  //   }
  //   if (value.length > 50) {
  //     return 'Goal name cannot exceed 50 characters';
  //   }
  //   return null;
  // }
  String? validateGoalName(String? value) {
    final trimmedValue = value?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return 'Please enter a goal name';
    }
    if (trimmedValue.length > 50) {
      return 'Goal name cannot exceed 50 characters';
    }
    return null;
  }

  void _selectPresetIcon(String iconName) {
    print('CREATE CONTROLLER: Selecting preset icon: $iconName');
    ref.read(selectedGoalIconProvider.notifier).state = iconName;
    ref.read(selectedImageFileProvider.notifier).state = null;
  }

  Future<void> _pickImageFromCamera(BuildContext context, WidgetRef ref) async {
    try {
      if (!context.mounted) return;

      final hasPermission =
          await PermissionService.requestCameraPermission(context);
      if (!hasPermission) return;

      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (image != null) {
        final imageFile = File(image.path);
        final croppedImage = await _cropGoalImage(imageFile, ref);

        if (croppedImage != null) {
          final croppedXFile = XFile(croppedImage.path);
          ref.read(selectedImageFileProvider.notifier).state = croppedXFile;
          ref.read(selectedGoalIconProvider.notifier).state = '';

          debugPrint(
              'CREATE CONTROLLER: Image captured and cropped successfully');
        }
      }
    } catch (e) {
      debugPrint(
          'CREATE CONTROLLER ERROR: Failed to capture and crop image: $e');
      if (context.mounted) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Failed to capture image',
          type: SnackType.error,
        );
      }
    }
  }

  Future<void> _pickImageFromGallery(
      BuildContext context, WidgetRef ref) async {
    try {
      if (!context.mounted) return;

      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (image != null) {
        final imageFile = File(image.path);
        final croppedImage = await _cropGoalImage(imageFile, ref);

        if (croppedImage != null) {
          final croppedXFile = XFile(croppedImage.path);
          ref.read(selectedImageFileProvider.notifier).state = croppedXFile;
          ref.read(selectedGoalIconProvider.notifier).state = '';

          debugPrint(
              'CREATE CONTROLLER: Image selected and cropped successfully');
        }
      }
    } catch (e) {
      debugPrint('CREATE CONTROLLER ERROR: Failed to pick and crop image: $e');
      if (context.mounted) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Failed to select image',
          type: SnackType.error,
        );
      }
    }
  }

  Future<File?> _cropGoalImage(File imageFile, WidgetRef ref) async {
    final isDark = ref.watch(isDarkProvider);

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 4),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.current(isDark).background,
          backgroundColor: AppColors.current(isDark).background,
          cropStyle: CropStyle.circle,
          toolbarWidgetColor: AppColors.current(isDark).text,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          cropFrameColor: Colors.transparent,
          cropGridColor: Colors.transparent,
          hideBottomControls: true,
          statusBarColor: AppColors.current(isDark).text,
          activeControlsWidgetColor: Colors.black,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          cropStyle: CropStyle.circle,
        ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  Future<void> recropSelectedImage(BuildContext context, WidgetRef ref) async {
    final currentImage = ref.read(selectedImageFileProvider);

    if (currentImage == null) {
      if (context.mounted) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'No image selected to crop',
          type: SnackType.error,
        );
      }
      return;
    }

    try {
      final imageFile = File(currentImage.path);
      final croppedImage = await _cropGoalImage(imageFile, ref);

      if (croppedImage != null) {
        final croppedXFile = XFile(croppedImage.path);
        ref.read(selectedImageFileProvider.notifier).state = croppedXFile;

        if (context.mounted) {
          showGrowkSnackBar(
            context: context,
            ref: ref,
            message: 'Image cropped successfully',
            type: SnackType.success,
          );
        }
      }
    } catch (e) {
      debugPrint('CREATE CONTROLLER ERROR: Failed to re-crop image: $e');
      if (context.mounted) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Failed to crop image',
          type: SnackType.error,
        );
      }
    }
  }

  Future<XFile> resizeImage(XFile imageFile) async {
    try {
      final Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        minWidth: 800,
        minHeight: 600,
        quality: 90,
      );

      if (imageBytes == null) {
        return imageFile;
      }

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String compressedImagePath = path.join(appDocPath,
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}');
      await File(compressedImagePath).writeAsBytes(imageBytes);

      return XFile(compressedImagePath);
    } catch (e) {
      print('Error resizing image: $e');
      return imageFile;
    }
  }

  Future<void> createGoal(BuildContext context, WidgetRef ref) async {
    print('CONTROLLER: Starting goal creation...');
    try {
      final goalName = ref.read(goalNameProvider);
      final selectedFrequency = ref.read(frequencyProvider);

      final validationError = validateGoalName(goalName);
      if (validationError != null) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: validationError,
          type: SnackType.error,
        );
        return;
      }

      print('CONTROLLER: Reading autoDepositProvider...');
      final autoDeposit = ref.read(autoDepositProvider);
      print('CONTROLLER: autoDeposit value: $autoDeposit');
      print('CONTROLLER: autoDeposit type: ${autoDeposit.runtimeType}');
      final selectedImage = ref.read(selectedImageFileProvider);
      final selectedIcon = ref.read(selectedGoalIconProvider);

      final targetYear = ref.read(calculatedYearProvider);
      final targetAmount = ref.read(calculatedAmountProvider).round();

      print('CONTROLLER: Form data collected');
      print('CONTROLLER: Goal name: $goalName');
      print('CONTROLLER: Frequency: $selectedFrequency');
      print('CONTROLLER: Target year: $targetYear');
      print('CONTROLLER: Target amount: $targetAmount');
      print('CONTROLLER: Auto deposit (raw): $autoDeposit');
      print('CONTROLLER: Auto deposit (will send): ${autoDeposit ? "Y" : "N"}');
      print('CONTROLLER: Selected icon: $selectedIcon');
      print('CONTROLLER: Has custom image: ${selectedImage != null}');

      final durationInYears = (targetYear - 2025);
      final duration = durationInYears > 3 ? 3 : durationInYears;
      final actualDurationInMonths = duration * 12;

      double transactionAmount;
      int debitDate;

      switch (selectedFrequency) {
        case 'Daily':
          transactionAmount = targetAmount / (actualDurationInMonths * 30);
          debitDate = 1;
          break;
        case 'Weekly':
          transactionAmount = targetAmount / (actualDurationInMonths * 4);
          debitDate = 7;
          break;
        case 'Monthly':
        default:
          transactionAmount = targetAmount / actualDurationInMonths;
          debitDate = 5;
          break;
      }

      print('CONTROLLER: Calculated values');
      print(
          'CONTROLLER: Duration: $duration years ($actualDurationInMonths months)');
      print('CONTROLLER: Transaction amount: ${transactionAmount}');
      print(
          'CONTROLLER: Transaction amount rounded: ${transactionAmount.round()}');
      print('CONTROLLER: Debit date: $debitDate');

      if (goalName.isEmpty) {
        print('CONTROLLER ERROR: Goal name is empty');
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Please enter a goal name',
          type: SnackType.error,
        );

        return;
      }

      final Map<String, dynamic> goalData = {
        "goalName": goalName,
        "targetYear": targetYear,
        "targetAmount": targetAmount,
        "duration": duration,
        "debitDate": debitDate,
        "transactionAmount": transactionAmount.round(),
        // "transactionAmount": transactionAmount,
        "goldInvestment": autoDeposit ? "Y" : "N",
        "frequency": selectedFrequency,
        if (selectedIcon.isNotEmpty && selectedImage == null)
          "iconName": selectedIcon,
      };
      print('CONTROLLER: Goal data prepared: $goalData');
      print(
          'CONTROLLER: goldInvestment field value: ${goalData["goldInvestment"]}');

      final finalAutoDepositCheck = ref.read(autoDepositProvider);
      print(
          'CONTROLLER: Final autoDeposit check before API: $finalAutoDepositCheck');

      File formDataFile = await saveFileAsBytesTemp(
        context,
        'goal_data',
        'json',
        goalData,
      );

      print('CONTROLLER: Temp file created: ${formDataFile.path}');

      final accessToken =
          SharedPreferencesHelper.getString('access_token') ?? '';
      if (accessToken.isEmpty) {
        print('CONTROLLER ERROR: No access token found');
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Please login first',
          type: SnackType.error,
        );

        return;
      }

      print('CONTROLLER: Access token found, proceeding with API call');
      _showLoadingDialog(context);

      final repository = ref.read(createGoalRepositoryProvider);

      //   if (context.mounted) {
      //     await showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       isDismissible: false,
      //       enableDrag: false,
      //       shape: const RoundedRectangleBorder(
      //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      //       ),
      //       builder: (context) => const  showStandingInstructionBottomSheet(
      //       context,
      //       virtualAccount,
      //       transactionAmount,
      //       selectedFrequency,
      //       goalName,
      //       onClose: () {
      //         resetFormState();
      //         Navigator.of(context).pop();
      //         ref.read(goalsRefreshTriggerProvider.notifier).state++;
      //       },
      //     ),
      //     );

      //     if (context.mounted) {
      //       Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => const GoalPageChecker()),
      //         (route) => false,
      //       );
      //     }
      //   }
      final result = await repository.addGoalApi(
        accessToken,
        selectedImage,
        formDataFile,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      print('CONTROLLER: API call completed');
      print('CONTROLLER: Result status: ${result.status}');
      print('CONTROLLER: Result message: ${result.message}');

      if (result.isSuccess) {
        print('CONTROLLER: Goal created successfully');

        final selectedIcon = ref.read(selectedGoalIconProvider);
        if (selectedIcon.isNotEmpty) {
          IconMappingService.storeGoalIcon(goalName, selectedIcon);
          print('CONTROLLER: Stored icon mapping - $goalName -> $selectedIcon');
        }

        // resetFormState();
        print('CONTROLLER: Form reset completed - all fields back to default');
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Goal created successfully!',
          type: SnackType.success,
        );

        final virtualAccount = result.data?.virtualAccount ?? 'Not Available';

        if (context.mounted) {
          await Future.delayed(const Duration(milliseconds: 500));

          showStandingInstructionBottomSheet(
            context,
            virtualAccount,
            transactionAmount,
            selectedFrequency,
            goalName,
            onClose: () {
              Navigator.of(context).pop();

              ref.read(goalsRefreshTriggerProvider.notifier).state++;
              Future.delayed(const Duration(milliseconds: 100), () {
                resetFormState();
              });
            },
          );
        }
      } else if (result.isValidationFailed) {
        print('CONTROLLER ERROR: Validation failed');
        if (context.mounted) {
          showGrowkSnackBar(
            context: context,
            ref: ref,
            message: 'Validation Error: ${result.validationErrors}',
            type: SnackType.error,
          );
        }
      } else {
        print('CONTROLLER ERROR: Goal creation failed');
        if (context.mounted) {
          showGrowkSnackBar(
            context: context,
            ref: ref,
            message: result.message,
            type: SnackType.error,
          );
        }
      }
    } catch (e, stackTrace) {
      print('CONTROLLER EXCEPTION: $e');
      print('CONTROLLER STACK TRACE: $stackTrace');

      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Error creating goal: ${e.toString()}',
          type: SnackType.error,
        );
      }
    }
  }

  void resetFormState() {
    print('CONTROLLER: Resetting form state...');
    ref.read(goalNameProvider.notifier).state = '';
    ref.read(selectedGoalIconProvider.notifier).state = '';
    ref.read(selectedImageFileProvider.notifier).state = null;
    ref.read(yearSliderProvider.notifier).state = 0.12;
    ref.read(amountSliderProvider.notifier).state = 0.65;
    ref.read(frequencyProvider.notifier).state = 'Monthly';
    ref.read(autoDepositProvider.notifier).state = false;
    print('CONTROLLER: Form reset completed');
  }

  Future<File> assetImageToFile(String assetName) async {
    final ByteData byteData = await rootBundle.load('assets/$assetName');
    final Uint8List pngBytes = byteData.buffer.asUint8List();

    img.Image? image = img.decodeImage(pngBytes);
    if (image == null) {
      throw Exception('Failed to decode asset image');
    }

    final List<int> jpegBytes = img.encodeJpg(image, quality: 90);

    final tempDir = await getTemporaryDirectory();
    final fileName = path.basenameWithoutExtension(assetName) + '.jpg';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(jpegBytes);
    return file;
  }

  Future<File> saveFileAsBytesTemp(BuildContext context, String fileName,
      String extension, Map<String, dynamic> data) async {
    Directory directory;
    if (Platform.isAndroid) {
      directory = await getApplicationCacheDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    final jsonString = jsonEncode(data);
    final file = File('$exPath/$fileName.$extension');
    await file.writeAsString(jsonString);

    print("File saved at: ${file.path}");
    return file;
  }

  void _showLoadingDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Creating goal...',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget showGoalIcon({
    required String image,
    required BuildContext context,
    required WidgetRef ref,
    required VoidCallback onTap,
    required String label,
  }) {
    final isDark = ref.watch(isDarkProvider);
    final selectedIcon = ref.watch(selectedGoalIconProvider);
    // final isSelected = selectedIcon == image;
    final isSelected = selectedIcon == image.replaceAll('png.png', '.jpg');

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: isSelected
                ? Colors.teal
                : isDark
                    ? Colors.grey[800]
                    : Colors.grey[200],
            child: Image.asset(
              'assets/$image',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Colors.teal
                  : isDark
                      ? Colors.white
                      : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class MinimalOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const MinimalOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
