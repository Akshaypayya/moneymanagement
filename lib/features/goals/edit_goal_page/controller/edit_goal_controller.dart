import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:money_mangmnt/core/constants/app_space.dart';
import 'package:money_mangmnt/core/services/icon_mapping_service.dart';
import 'package:money_mangmnt/views.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/repo/edit_goal_repo.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/model/goal_view_model.dart';

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

    final yearSliderValue =
        goalData.targetYear > 2025 ? (goalData.targetYear - 2025) / 25.0 : 0.0;
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

    if (goalData.iconName != null && goalData.iconName!.isNotEmpty) {
      iconName = goalData.iconName!;
      print('EDIT CONTROLLER: Using iconName from goal data: $iconName');
    } else {
      final storedIcon = IconMappingService.getStoredIcon(goalData.goalName);
      if (storedIcon != null) {
        iconName = storedIcon;
        print('EDIT CONTROLLER: Using stored icon mapping: $iconName');
      } else {
        iconName = _getIconFromGoalName(goalData.goalName);
        print('EDIT CONTROLLER: Using name-based detection: $iconName');
      }
    }

    ref.read(editSelectedGoalIconProvider.notifier).state = iconName;
    ref.read(editSelectedImageFileProvider.notifier).state = null;

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
      return 'home.png';
    } else if (lowercaseName.contains('education') ||
        lowercaseName.contains('study')) {
      return 'education.png';
    } else if (lowercaseName.contains('wedding') ||
        lowercaseName.contains('marriage')) {
      return 'wedding.png';
    } else if (lowercaseName.contains('trip') ||
        lowercaseName.contains('travel')) {
      return 'trip.png';
    } else {
      return 'customgoals.png';
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
                  'Choose Photo',
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
                        image: 'home.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('home.png');
                          Navigator.of(context).pop();
                        },
                        label: 'Home'),
                    showGoalIcon(
                        image: 'education.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('education.png');
                          Navigator.of(context).pop();
                        },
                        label: 'Education'),
                    showGoalIcon(
                        image: 'wedding.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('wedding.png');
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
                        image: 'trip.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('trip.png');
                          Navigator.of(context).pop();
                        },
                        label: 'Trip'),
                    showGoalIcon(
                        image: 'customgoals.png',
                        context: context,
                        ref: widgetRef,
                        onTap: () {
                          _selectPresetIcon('customgoals.png');
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
                        await _pickImageFromCamera();
                      },
                    ),
                    MinimalOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      isDark: isDark,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _pickImageFromGallery();
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

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final compressedImage = await resizeImage(image);
      ref.read(editSelectedImageFileProvider.notifier).state = compressedImage;
      ref.read(editSelectedGoalIconProvider.notifier).state = '';
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final compressedImage = await resizeImage(image);
      ref.read(editSelectedImageFileProvider.notifier).state = compressedImage;
      ref.read(editSelectedGoalIconProvider.notifier).state = '';
    }
  }

  Future<XFile> resizeImage(XFile imageFile) async {
    final Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: 800,
      minHeight: 600,
      quality: 90,
    );

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String compressedImagePath = path.join(appDocPath, imageFile.name);
    await File(compressedImagePath).writeAsBytes(imageBytes as List<int>);

    return XFile(compressedImagePath);
  }

  Future<void> updateGoal(BuildContext context, String originalGoalName) async {
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

      final targetYear = 2025 + (yearValue * 25).round();
      final targetAmount = 10000 + (amountValue * (1000000 - 10000)).round();

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

      print('EDIT CONTROLLER: Calculated values');
      print('EDIT CONTROLLER: Target year: $targetYear');
      print('EDIT CONTROLLER: Target amount: $targetAmount');
      print(
          'EDIT CONTROLLER: Duration: $duration years ($actualDurationInMonths months)');
      print(
          'EDIT CONTROLLER: Transaction amount: ${transactionAmount.round()}');
      print('EDIT CONTROLLER: Debit date: $debitDate');

      if (goalName.isEmpty) {
        print('EDIT CONTROLLER ERROR: Goal name is empty');
        _showSnackBar(context, 'Please enter a goal name');
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
        _showSnackBar(context, 'Please login first');
        return;
      }

      print('EDIT CONTROLLER: Access token found, proceeding with API call');

      _showLoadingDialog(context);

      final repository = ref.read(editGoalRepositoryProvider);
      final result = await repository.updateGoalApi(
        accessToken,
        selectedImage,
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

        if (selectedIcon.isNotEmpty && selectedImage == null) {
          IconMappingService.storeGoalIcon(goalName, selectedIcon);
          print(
              'EDIT CONTROLLER: Stored icon mapping - $goalName -> $selectedIcon');
        } else if (selectedImage != null) {
          IconMappingService.clearMapping(goalName);
          print(
              'EDIT CONTROLLER: Cleared icon mapping for custom image - $goalName');
        }

        if (originalGoalName != goalName) {
          final storedIcon = IconMappingService.getStoredIcon(originalGoalName);
          if (storedIcon != null) {
            IconMappingService.clearMapping(originalGoalName);
            if (selectedIcon.isNotEmpty && selectedImage == null) {
              IconMappingService.storeGoalIcon(goalName, selectedIcon);
            }
            print(
                'EDIT CONTROLLER: Updated mapping due to name change: $originalGoalName -> $goalName');
          }
        }

        _showSnackBar(context, 'Goal updated successfully!');

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } else if (result.isValidationFailed) {
        print('EDIT CONTROLLER ERROR: Validation failed');
        _showSnackBar(context, 'Validation Error: ${result.message}');
      } else {
        print('EDIT CONTROLLER ERROR: Goal update failed');
        _showSnackBar(context, result.message);
      }
    } catch (e, stackTrace) {
      print('EDIT CONTROLLER EXCEPTION: $e');
      print('EDIT CONTROLLER STACK TRACE: $stackTrace');

      if (context.mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        _showSnackBar(context, 'Error updating goal: ${e.toString()}');
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

  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.black87,
        ),
      );
    }
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

  Widget showGoalIcon({
    required String image,
    required BuildContext context,
    required WidgetRef ref,
    required VoidCallback onTap,
    required String label,
  }) {
    final isDark = ref.watch(isDarkProvider);
    final selectedIcon = ref.watch(editSelectedGoalIconProvider);
    final isSelected = selectedIcon == image;

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
              height: 30,
              width: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.teal
                  : isDark
                      ? Colors.white70
                      : Colors.black87,
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
      onTap: onTap,
      child: Column(
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
    );
  }
}
