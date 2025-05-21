// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:growk_v2/core/constants/app_space.dart';
// import 'package:growk_v2/views.dart';
// import 'package:growk_v2/features/goals/add_goal_page/repo/create_goal_repo.dart';
// import 'package:growk_v2/features/goals/add_goal_page/view/widget/frequency_slector.dart';
// import 'package:growk_v2/features/goals/add_goal_page/view/widget/auto_deposit_option.dart';
// import 'package:growk_v2/features/goals/add_goal_page/view/widget/custom_slider.dart';

// final goalNameProvider = StateProvider<String>((ref) => '');
// final selectedGoalIconProvider = StateProvider<String>((ref) => 'home.png');
// final selectedImageFileProvider = StateProvider<XFile?>((ref) => null);

// final createGoalImageProvider = Provider<CreateGoalController>((ref) {
//   return CreateGoalController(ref);
// });

// final createGoalRepositoryProvider = Provider<CreateGoalRepository>((ref) {
//   final networkService = ref.watch(networkServiceProvider);
//   return CreateGoalRepository(networkService, ref);
// });

// final networkServiceProvider = Provider<NetworkService>((ref) {
//   return NetworkService(
//     client: createUnsafeClient(),
//     baseUrl: AppUrl.baseUrl,
//   );
// });

// class CreateGoalController {
//   final Ref ref;

//   const CreateGoalController(this.ref);

//   void pickGoalImageActionSheet(BuildContext context, WidgetRef widgetRef) {
//     final isDark = widgetRef.watch(isDarkProvider);

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//       ),
//       backgroundColor: isDark ? Colors.grey[900] : Colors.white,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Choose Photo',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: isDark ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 GapSpace.height30,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     showGoalIcon(
//                         image: 'home.png',
//                         context: context,
//                         ref: widgetRef,
//                         onTap: () {
//                           _selectPresetIcon('home.png');
//                           Navigator.of(context).pop();
//                         },
//                         label: 'Home'),
//                     showGoalIcon(
//                         image: 'education.png',
//                         context: context,
//                         ref: widgetRef,
//                         onTap: () {
//                           _selectPresetIcon('education.png');
//                           Navigator.of(context).pop();
//                         },
//                         label: 'Education'),
//                     showGoalIcon(
//                         image: 'wedding.png',
//                         context: context,
//                         ref: widgetRef,
//                         onTap: () {
//                           _selectPresetIcon('wedding.png');
//                           Navigator.of(context).pop();
//                         },
//                         label: 'Wedding'),
//                   ],
//                 ),
//                 GapSpace.height30,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     showGoalIcon(
//                         image: 'trip.png',
//                         context: context,
//                         ref: widgetRef,
//                         onTap: () {
//                           _selectPresetIcon('trip.png');
//                           Navigator.of(context).pop();
//                         },
//                         label: 'Trip'),
//                     showGoalIcon(
//                         image: 'customgoals.png',
//                         context: context,
//                         ref: widgetRef,
//                         onTap: () {
//                           _selectPresetIcon('customgoals.png');
//                           Navigator.of(context).pop();
//                         },
//                         label: 'Custom Goal'),
//                   ],
//                 ),
//                 GapSpace.height30,
//                 Divider(
//                   thickness: 0.2,
//                   color: isDark ? Colors.white : Colors.black,
//                 ),
//                 GapSpace.height30,
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     MinimalOption(
//                       icon: Icons.camera_alt,
//                       label: 'Camera',
//                       isDark: isDark,
//                       onTap: () async {
//                         Navigator.of(context).pop();
//                         await _pickImageFromCamera();
//                       },
//                     ),
//                     MinimalOption(
//                       icon: Icons.photo_library,
//                       label: 'Gallery',
//                       isDark: isDark,
//                       onTap: () async {
//                         Navigator.of(context).pop();
//                         await _pickImageFromGallery();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _selectPresetIcon(String iconName) {
//     ref.read(selectedGoalIconProvider.notifier).state = iconName;
//     ref.read(selectedImageFileProvider.notifier).state = null;
//   }

//   Future<void> _pickImageFromCamera() async {
//     final picker = ImagePicker();
//     final image = await picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       final compressedImage = await resizeImage(image);
//       ref.read(selectedImageFileProvider.notifier).state = compressedImage;
//       ref.read(selectedGoalIconProvider.notifier).state = '';
//     }
//   }

//   Future<void> _pickImageFromGallery() async {
//     final picker = ImagePicker();
//     final image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       final compressedImage = await resizeImage(image);
//       ref.read(selectedImageFileProvider.notifier).state = compressedImage;
//       ref.read(selectedGoalIconProvider.notifier).state = '';
//     }
//   }

//   Future<XFile> resizeImage(XFile imageFile) async {
//     final Uint8List? imageBytes = await FlutterImageCompress.compressWithFile(
//       imageFile.path,
//       minWidth: 800,
//       minHeight: 600,
//       quality: 90,
//     );

//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     String appDocPath = appDocDir.path;
//     String compressedImagePath = path.join(appDocPath, imageFile.name);
//     await File(compressedImagePath).writeAsBytes(imageBytes as List<int>);

//     return XFile(compressedImagePath);
//   }

//   Future<void> createGoal(BuildContext context) async {
//     print('CONTROLLER: Starting goal creation...');
//     try {
//       final goalName = ref.read(goalNameProvider);
//       final selectedFrequency = ref.read(frequencyProvider);
//       final yearValue = ref.read(yearSliderProvider);
//       final amountValue = ref.read(amountSliderProvider);
//       final autoDeposit = ref.read(autoDepositProvider);
//       final selectedImage = ref.read(selectedImageFileProvider);
//       final selectedIcon = ref.read(selectedGoalIconProvider);

//       print('CONTROLLER: Form data collected');
//       print('CONTROLLER: Goal name: $goalName');
//       print('CONTROLLER: Frequency: $selectedFrequency');
//       print('CONTROLLER: Year value: $yearValue');
//       print('CONTROLLER: Amount value: $amountValue');
//       print('CONTROLLER: Auto deposit: $autoDeposit');
//       print('CONTROLLER: Selected icon: $selectedIcon');
//       print('CONTROLLER: Has custom image: ${selectedImage != null}');

//       final targetYear = 2025 + (yearValue * 25).round();
//       final targetAmount = 10000 + (amountValue * (1000000 - 10000)).round();

//       final durationInYears = (targetYear - 2025);
//       final duration = durationInYears > 3 ? 3 : durationInYears;
//       final actualDurationInMonths = duration * 12;

//       double transactionAmount;
//       int debitDate;

//       switch (selectedFrequency) {
//         case 'Daily':
//           transactionAmount = targetAmount / (actualDurationInMonths * 30);
//           debitDate = 1;
//           break;
//         case 'Weekly':
//           transactionAmount = targetAmount / (actualDurationInMonths * 4);
//           debitDate = 7;
//           break;
//         case 'Monthly':
//         default:
//           transactionAmount = targetAmount / actualDurationInMonths;
//           debitDate = 5;
//           break;
//       }

//       print('CONTROLLER: Calculated values');
//       print('CONTROLLER: Target year: $targetYear');
//       print('CONTROLLER: Target amount: $targetAmount');
//       print(
//           'CONTROLLER: Duration: $duration years ($actualDurationInMonths months)');
//       print('CONTROLLER: Transaction amount: ${transactionAmount.round()}');
//       print('CONTROLLER: Debit date: $debitDate');

//       if (goalName.isEmpty) {
//         print('CONTROLLER ERROR: Goal name is empty');
//         _showSnackBar(context, 'Please enter a goal name');
//         return;
//       }

//       final Map<String, dynamic> goalData = {
//         "goalName": goalName,
//         "targetYear": targetYear,
//         "targetAmount": targetAmount,
//         "duration": duration,
//         "debitDate": debitDate,
//         "transactionAmount": transactionAmount.round(),
//         "goldInvestment": "Y",
//         "frequency": selectedFrequency,
//         "autoDeposit": autoDeposit ? "Y" : "N",
//         if (selectedIcon.isNotEmpty) "iconName": selectedIcon,
//       };

//       print('CONTROLLER: Goal data prepared: $goalData');

//       File formDataFile = await saveFileAsBytesTemp(
//         context,
//         'goal_data',
//         'json',
//         goalData,
//       );

//       print('CONTROLLER: Temp file created: ${formDataFile.path}');

//       final accessToken =
//           SharedPreferencesHelper.getString('access_token') ?? '';

//       if (accessToken.isEmpty) {
//         print('CONTROLLER ERROR: No access token found');
//         _showSnackBar(context, 'Please login first');
//         return;
//       }

//       print('CONTROLLER: Access token found, proceeding with API call');

//       _showLoadingDialog(context);

//       final repository = ref.read(createGoalRepositoryProvider);
//       final result = await repository.addGoalApi(
//         accessToken,
//         selectedImage,
//         formDataFile,
//       );

//       Navigator.of(context).pop();

//       print('CONTROLLER: API call completed');
//       print('CONTROLLER: Result status: ${result.status}');
//       print('CONTROLLER: Result message: ${result.message}');

//       if (result.isSuccess) {
//         print('CONTROLLER: Goal created successfully');

//         print('CONTROLLER: Resetting form to default state...');
//         ref.read(goalNameProvider.notifier).state = '';
//         ref.read(selectedGoalIconProvider.notifier).state = 'home.png';
//         ref.read(selectedImageFileProvider.notifier).state = null;
//         ref.read(yearSliderProvider.notifier).state = 0.12;
//         ref.read(amountSliderProvider.notifier).state = 0.65;
//         ref.read(frequencyProvider.notifier).state = 'Monthly';
//         ref.read(autoDepositProvider.notifier).state = false;
//         print('CONTROLLER: Form reset completed - all fields back to default');

//         _showSnackBar(context, 'Goal created successfully!');

//         Navigator.of(context).pop();
//       } else if (result.isValidationFailed) {
//         print('CONTROLLER ERROR: Validation failed');
//         _showSnackBar(context, 'Validation Error: ${result.validationErrors}');
//       } else {
//         print('CONTROLLER ERROR: Goal creation failed');
//         _showSnackBar(context, result.message);
//       }
//     } catch (e, stackTrace) {
//       print('CONTROLLER EXCEPTION: $e');
//       print('CONTROLLER STACK TRACE: $stackTrace');

//       if (Navigator.of(context).canPop()) {
//         Navigator.of(context).pop();
//       }
//       _showSnackBar(context, 'Error creating goal: ${e.toString()}');
//     }
//   }

//   void resetFormState() {
//     print('CONTROLLER: Manual form state reset');
//     ref.read(goalNameProvider.notifier).state = '';
//     ref.read(selectedGoalIconProvider.notifier).state = 'home.png';
//     ref.read(selectedImageFileProvider.notifier).state = null;
//     ref.read(yearSliderProvider.notifier).state = 0.12;
//     ref.read(amountSliderProvider.notifier).state = 0.65;
//     ref.read(frequencyProvider.notifier).state = 'Monthly';
//     ref.read(autoDepositProvider.notifier).state = false;
//     print('CONTROLLER: Manual reset completed');
//   }

//   Future<File> saveFileAsBytesTemp(BuildContext context, String fileName,
//       String extension, Map<String, dynamic> data) async {
//     Directory directory;
//     if (Platform.isAndroid) {
//       directory = await getApplicationCacheDirectory();
//     } else {
//       directory = await getApplicationDocumentsDirectory();
//     }

//     final exPath = directory.path;
//     print("Saved Path: $exPath");
//     await Directory(exPath).create(recursive: true);
//     final jsonString = jsonEncode(data);
//     final file = File('$exPath/$fileName.$extension');
//     await file.writeAsString(jsonString);

//     print("File saved at: ${file.path}");
//     return file;
//   }

//   void _showSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.black87,
//       ),
//     );
//   }

//   void _showLoadingDialog(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: isDark ? Colors.grey[900] : Colors.white,
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   isDark ? Colors.white : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Creating goal...',
//                 style: TextStyle(
//                   color: isDark ? Colors.white : Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget showGoalIcon({
//     required String image,
//     required BuildContext context,
//     required WidgetRef ref,
//     required VoidCallback onTap,
//     required String label,
//   }) {
//     final isDark = ref.watch(isDarkProvider);
//     final selectedIcon = ref.watch(selectedGoalIconProvider);
//     final isSelected = selectedIcon == image;

//     return InkWell(
//       borderRadius: BorderRadius.circular(10),
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 26,
//             backgroundColor: isSelected
//                 ? Colors.teal
//                 : isDark
//                     ? Colors.grey[800]
//                     : Colors.grey[200],
//             child: Image.asset(
//               'assets/$image',
//               height: 30,
//               width: 30,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 13.5,
//               fontWeight: FontWeight.w500,
//               color: isSelected
//                   ? Colors.teal
//                   : isDark
//                       ? Colors.white70
//                       : Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:money_mangmnt/core/constants/app_space.dart';
import 'package:money_mangmnt/views.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:money_mangmnt/core/storage/shared_preference/shared_preference_service.dart';

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
    ref.read(selectedGoalIconProvider.notifier).state = iconName;
    ref.read(selectedImageFileProvider.notifier).state = null;
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final compressedImage = await resizeImage(image);
      ref.read(selectedImageFileProvider.notifier).state = compressedImage;
      ref.read(selectedGoalIconProvider.notifier).state = '';
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final compressedImage = await resizeImage(image);
      ref.read(selectedImageFileProvider.notifier).state = compressedImage;
      ref.read(selectedGoalIconProvider.notifier).state = '';
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

  Future<void> createGoal(BuildContext context) async {
    print('CONTROLLER: Starting goal creation...');
    try {
      final goalName = ref.read(goalNameProvider);
      final selectedFrequency = ref.read(frequencyProvider);
      final autoDeposit = ref.read(autoDepositProvider);
      final selectedImage = ref.read(selectedImageFileProvider);
      final selectedIcon = ref.read(selectedGoalIconProvider);

      final targetYear = ref.read(calculatedYearProvider);
      final targetAmount = ref.read(calculatedAmountProvider).round();

      print('CONTROLLER: Form data collected');
      print('CONTROLLER: Goal name: $goalName');
      print('CONTROLLER: Frequency: $selectedFrequency');
      print('CONTROLLER: Target year: $targetYear');
      print('CONTROLLER: Target amount: $targetAmount');
      print('CONTROLLER: Auto deposit: $autoDeposit');
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
      print('CONTROLLER: Transaction amount: ${transactionAmount.round()}');
      print('CONTROLLER: Debit date: $debitDate');

      if (goalName.isEmpty) {
        print('CONTROLLER ERROR: Goal name is empty');
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
        "frequency": selectedFrequency,
        if (selectedIcon.isNotEmpty) "iconName": selectedIcon,
      };

      print('CONTROLLER: Goal data prepared: $goalData');

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
        _showSnackBar(context, 'Please login first');
        return;
      }

      print('CONTROLLER: Access token found, proceeding with API call');

      _showLoadingDialog(context);

      final repository = ref.read(createGoalRepositoryProvider);
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

        resetFormState();
        print('CONTROLLER: Form reset completed - all fields back to default');

        _showSnackBar(context, 'Goal created successfully!');

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } else if (result.isValidationFailed) {
        print('CONTROLLER ERROR: Validation failed');
        _showSnackBar(context, 'Validation Error: ${result.validationErrors}');
      } else {
        print('CONTROLLER ERROR: Goal creation failed');
        _showSnackBar(context, result.message);
      }
    } catch (e, stackTrace) {
      print('CONTROLLER EXCEPTION: $e');
      print('CONTROLLER STACK TRACE: $stackTrace');

      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        _showSnackBar(context, 'Error creating goal: ${e.toString()}');
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
