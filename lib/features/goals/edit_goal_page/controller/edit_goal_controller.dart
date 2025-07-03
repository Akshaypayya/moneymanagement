import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/services/icon_mapping_service.dart';
import 'package:growk_v2/views.dart';
import 'package:growk_v2/features/goals/edit_goal_page/repo/edit_goal_repo.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:growk_v2/core/utils/app_permission.dart';

final editGoalNameProvider = StateProvider<String>((ref) => '');
final editSelectedGoalIconProvider = StateProvider<String>((ref) => '');
final editSelectedImageFileProvider = StateProvider<XFile?>((ref) => null);
final editYearSliderProvider = StateProvider<double>((ref) => 0.12);
final editAmountSliderProvider = StateProvider<double>((ref) => 0.65);
final editFrequencyProvider = StateProvider<String>((ref) => 'Monthly');
final editAutoDepositProvider = StateProvider<bool>((ref) => false);

final editGoalControllerProvider = Provider<EditGoalController>((ref) {
  return EditGoalController(ref);
});

final editGoalRepositoryProvider = Provider<EditGoalRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return EditGoalRepository(networkService, ref);
});

class EditGoalController {
  final Ref ref;

  const EditGoalController(this.ref);

  void initializeWithGoalData(GoalData goalData) {
    print('EDIT CONTROLLER: Initializing form with goal data');

    ref.read(editGoalNameProvider.notifier).state = goalData.goalName;

    DateTime today = DateTime.now();

    final yearSliderValue = goalData.targetYear > today.year
        ? (goalData.targetYear - today.year) / 25.0
        : 0.0;
    ref.read(editYearSliderProvider.notifier).state =
        yearSliderValue < 1.0 ? yearSliderValue : 1.0;

    final amountSliderValue = goalData.targetAmount > 10000
        ? (goalData.targetAmount - 10000) / (1000000 - 10000)
        : 0.0;
    ref.read(editAmountSliderProvider.notifier).state =
        amountSliderValue < 1.0 ? amountSliderValue : 1.0;

    String frequency = 'Monthly';
    if (goalData.debitDate == 1) {
      frequency = 'Daily';
    } else if (goalData.debitDate == 7) {
      frequency = 'Weekly';
    }
    ref.read(editFrequencyProvider.notifier).state = frequency;

    ref.read(editAutoDepositProvider.notifier).state =
        goalData.goldInvestment == 'Y';

    String iconName = '';
    if (goalData.goalPic != null && goalData.goalPic!.isNotEmpty) {
      ref.read(editSelectedImageFileProvider.notifier).state =
          XFile(goalData.goalPic!);
      ref.read(editSelectedGoalIconProvider.notifier).state = '';
    } else if (goalData.iconName != null && goalData.iconName!.isNotEmpty) {
      ref.read(editSelectedGoalIconProvider.notifier).state =
          goalData.iconName!;
      ref.read(editSelectedImageFileProvider.notifier).state = null;
    } else {
      final storedIcon = IconMappingService.getStoredIcon(goalData.goalName);
      if (storedIcon != null) {
        iconName = storedIcon;
        print('EDIT CONTROLLER: Using stored icon mapping: $iconName');
      } else {
        iconName = _getIconFromGoalName(goalData.goalName);
        print('EDIT CONTROLLER: Using name-based detection: $iconName');
      }
      ref.read(editSelectedGoalIconProvider.notifier).state = iconName;
    }

    print('EDIT CONTROLLER: Form initialized with goal data');
    print('EDIT CONTROLLER: Goal name: ${goalData.goalName}');
    print(
        'EDIT CONTROLLER: Target year: ${goalData.targetYear} (slider: $yearSliderValue)');
    print(
        'EDIT CONTROLLER: Target amount: ${goalData.targetAmount} (slider: $amountSliderValue)');
    print('EDIT CONTROLLER: Frequency: $frequency');
    print('EDIT CONTROLLER: Auto deposit: ${goalData.goldInvestment == 'Y'}');
    print('EDIT CONTROLLER: Selected icon: $iconName');
  }

  String _getIconFromGoalName(String goalName) {
    final lowercaseName = goalName.toLowerCase();
    if (lowercaseName.contains('home') || lowercaseName.contains('house')) {
      return 'home.jpg';
    } else if (lowercaseName.contains('education') ||
        lowercaseName.contains('study')) {
      return 'education.jpg';
    } else if (lowercaseName.contains('wedding') ||
        lowercaseName.contains('marriage')) {
      return 'wedding.jpg';
    } else if (lowercaseName.contains('trip') ||
        lowercaseName.contains('travel')) {
      return 'trip.jpg';
    } else {
      return 'customgoals.jpg';
    }
  }

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

  void _selectPresetIcon(String iconName) {
    print('EDIT CONTROLLER: Selecting preset icon: $iconName');
    ref.read(editSelectedGoalIconProvider.notifier).state = iconName;
    ref.read(editSelectedImageFileProvider.notifier).state = null;
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
          ref.read(editSelectedImageFileProvider.notifier).state = croppedXFile;
          ref.read(editSelectedGoalIconProvider.notifier).state = '';

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
  // Future<void> _pickImageFromCamera(BuildContext context, WidgetRef ref) async {
  //   try {
  //     if (!context.mounted) return;

  //     final hasPermission =
  //         await PermissionService.requestCameraPermission(context);
  //     if (!hasPermission) return;

  //     final picker = ImagePicker();
  //     final image = await picker.pickImage(source: ImageSource.camera);
  //     if (image != null) {
  //       final compressedImage = await resizeImage(image);
  // ref.read(editSelectedImageFileProvider.notifier).state =
  //     compressedImage;
  // ref.read(editSelectedGoalIconProvider.notifier).state = '';
  //     }
  //   } catch (e) {
  //     print('Error picking image from camera: $e');
  //     if (context.mounted) {
  //       showGrowkSnackBar(
  //         context: context,
  //         ref: ref,
  //         message: 'Failed to capture image',
  //         type: SnackType.error,
  //       );
  //     }
  //   }
  // }
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
          ref.read(editSelectedImageFileProvider.notifier).state = croppedXFile;
          ref.read(editSelectedGoalIconProvider.notifier).state = '';

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

  // Future<void> _pickImageFromGallery(
  //     BuildContext context, WidgetRef ref) async {
  //   try {
  //     if (!context.mounted) return;

  //     final hasPermission =
  //         await PermissionService.requestGalleryPermission(context);
  //     if (!hasPermission) return;

  //     final picker = ImagePicker();
  //     final image = await picker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       final compressedImage = await resizeImage(image);
  //       ref.read(editSelectedImageFileProvider.notifier).state =
  //           compressedImage;
  //       ref.read(editSelectedGoalIconProvider.notifier).state = '';
  //     }
  //   } catch (e) {
  //     print('Error picking image from gallery: $e');
  //     if (context.mounted) {
  //       showGrowkSnackBar(
  //         context: context,
  //         ref: ref,
  //         message: 'Failed to select image',
  //         type: SnackType.error,
  //       );
  //     }
  //   }
  // }

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
    final currentImage = ref.read(editSelectedImageFileProvider);

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
        ref.read(editSelectedImageFileProvider.notifier).state = croppedXFile;

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

  Future<void> updateGoal(
      BuildContext context, String originalGoalName, WidgetRef ref) async {
    print('EDIT CONTROLLER: Starting goal update...');
    try {
      final goalName = ref.read(editGoalNameProvider);
      final selectedFrequency = ref.read(editFrequencyProvider);
      final yearValue = ref.read(editYearSliderProvider);
      final amountValue = ref.read(editAmountSliderProvider);
      final autoDeposit = ref.read(editAutoDepositProvider);
      final selectedImage = ref.read(editSelectedImageFileProvider);
      final selectedIcon = ref.read(editSelectedGoalIconProvider);

      print('EDIT CONTROLLER: Form data collected');
      print('EDIT CONTROLLER: Goal name: $goalName');
      print('EDIT CONTROLLER: Frequency: $selectedFrequency');
      print('EDIT CONTROLLER: Year value: $yearValue');
      print('EDIT CONTROLLER: Amount value: $amountValue');
      print('EDIT CONTROLLER: Auto deposit: $autoDeposit');
      print('EDIT CONTROLLER: Selected icon: $selectedIcon');
      print('EDIT CONTROLLER: Has custom image: ${selectedImage != null}');
      DateTime today = DateTime.now();
      final targetYear = today.year + (yearValue * 25).round();
      final minAmount = 10000.0;
      final maxAmount = 1000000.0;
      final targetAmount =
          (minAmount + (amountValue * (maxAmount - minAmount))).round();

      print('EDIT CONTROLLER: Calculated values');
      print('EDIT CONTROLLER: Target year: $targetYear');
      print('EDIT CONTROLLER: Target amount: $targetAmount');

      final durationInYears = (targetYear - today.year);
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

      print('EDIT CONTROLLER: Calculated values');
      print(
          'EDIT CONTROLLER: Duration: $duration years ($actualDurationInMonths months)');
      print(
          'EDIT CONTROLLER: Transaction amount: ${transactionAmount.round()}');
      print('EDIT CONTROLLER: Debit date: $debitDate');

      if (goalName.isEmpty) {
        print('EDIT CONTROLLER ERROR: Goal name is empty');
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
        "goldInvestment": autoDeposit ? "Y" : "N",
        "frequency": selectedFrequency,
        if (selectedIcon.isNotEmpty && selectedImage == null)
          "iconName": selectedIcon,
      };

      print('EDIT CONTROLLER: Goal data prepared: $goalData');

      File formDataFile = await saveFileAsBytesTemp(
        context,
        'goal_data',
        'json',
        goalData,
      );

      print('EDIT CONTROLLER: Temp file created: ${formDataFile.path}');

      final accessToken =
          SharedPreferencesHelper.getString('access_token') ?? '';
      if (accessToken.isEmpty) {
        print('EDIT CONTROLLER ERROR: No access token found');
        if (context.mounted) {
          showGrowkSnackBar(
            context: context,
            ref: ref,
            message: 'Please login first',
            type: SnackType.error,
          );
        }

        return;
      }

      print('EDIT CONTROLLER: Access token found, proceeding with API call');
      _showLoadingDialog(context);

      final repository = ref.read(editGoalRepositoryProvider);

      XFile? validImageFile;
      if (selectedImage != null) {
        print('EDIT CONTROLLER: Original image path: ${selectedImage.path}');

        if (selectedImage.path.startsWith('/9j/') ||
            selectedImage.path.startsWith('data:') ||
            selectedImage.path.contains('4AAQSkZJRgAB')) {
          print(
              'EDIT CONTROLLER: Detected base64 data in path, need to create proper file');

          try {
            final bytes = base64Decode(selectedImage.path);

            final tempDir = await getTemporaryDirectory();
            final tempFile = File(
                '${tempDir.path}/edit_goal_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
            await tempFile.writeAsBytes(bytes);

            validImageFile = XFile(tempFile.path);
            print(
                'EDIT CONTROLLER: Created temporary file at: ${tempFile.path}');
          } catch (e) {
            print(
                'EDIT CONTROLLER ERROR: Failed to create file from base64: $e');
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            if (context.mounted) {
              showGrowkSnackBar(
                context: context,
                ref: ref,
                message: 'Error processing selected image',
                type: SnackType.error,
              );
            }

            return;
          }
        } else {
          final file = File(selectedImage.path);
          if (await file.exists()) {
            validImageFile = selectedImage;
            print(
                'EDIT CONTROLLER: Using existing file at: ${selectedImage.path}');
          } else {
            print(
                'EDIT CONTROLLER ERROR: File does not exist at: ${selectedImage.path}');
            if (context.mounted) {
              Navigator.of(context).pop();
            }
            if (context.mounted) {
              showGrowkSnackBar(
                context: context,
                ref: ref,
                message: 'Selected image file not found',
                type: SnackType.error,
              );
            }

            return;
          }
        }
      }

      final result = await repository.updateGoalApi(
        accessToken,
        validImageFile,
        formDataFile,
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }

      print('EDIT CONTROLLER: API call completed');
      print('EDIT CONTROLLER: Result status: ${result.status}');
      print('EDIT CONTROLLER: Result message: ${result.message}');

      if (result.isSuccess) {
        print('EDIT CONTROLLER: Goal updated successfully');

        final selectedIcon = ref.read(editSelectedGoalIconProvider);
        if (selectedIcon.isNotEmpty) {
          IconMappingService.storeGoalIcon(goalName, selectedIcon);
          print(
              'EDIT CONTROLLER: Updated icon mapping - $goalName -> $selectedIcon');
        }
        if (context.mounted) {
          showGrowkSnackBar(
            context: context,
            ref: ref,
            message: 'Goal updated successfully!',
            type: SnackType.success,
          );
        }

        if (context.mounted) {
          Navigator.of(context).pop(true);
        }
      } else if (result.isValidationFailed) {
        print('EDIT CONTROLLER ERROR: Validation failed');
        if (context.mounted) {
          showGrowkSnackBar(
            context: context,
            ref: ref,
            message: 'Validation Error: ${result.validationErrors}',
            type: SnackType.error,
          );
        }
      } else {
        print('EDIT CONTROLLER ERROR: Goal update failed');
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
      print('EDIT CONTROLLER EXCEPTION: $e');
      print('EDIT CONTROLLER STACK TRACE: $stackTrace');

      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Error updating goal: ${e.toString()}',
          type: SnackType.error,
        );
      }
    }
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
                'Updating goal...',
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
}

Widget showGoalIcon({
  required String image,
  required BuildContext context,
  required WidgetRef ref,
  required VoidCallback onTap,
  required String label,
}) {
  final isDark = ref.watch(isDarkProvider);
  final selectedIcon = ref.watch(editSelectedGoalIconProvider);
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
