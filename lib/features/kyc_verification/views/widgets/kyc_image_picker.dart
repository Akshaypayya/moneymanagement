// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:growk_v2/core/widgets/reusable_column.dart';
// import 'package:growk_v2/core/widgets/reusable_sized_box.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:growk_v2/features/kyc_verification/provider/kyc_providers.dart';
//
// class KycImagePicker extends ConsumerWidget {
//   const KycImagePicker({super.key});
//
//   Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
//     final picker = ImagePicker();
//
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) =>
//           SafeArea(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.photo),
//                   title: const Text('Choose from Gallery'),
//                   onTap: () async {
//                     final picked = await picker.pickImage(
//                         source: ImageSource.gallery);
//                     if (picked != null) {
//                       ref
//                           .read(kycImageFileProvider.notifier)
//                           .state = File(picked.path);
//                       ref
//                           .read(kycImageErrorProvider.notifier)
//                           .state = null;
//                     }
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text('Take a Photo'),
//                   onTap: () async {
//                     final picked = await picker.pickImage(
//                         source: ImageSource.camera);
//                     if (picked != null) {
//                       ref
//                           .read(kycImageFileProvider.notifier)
//                           .state = File(picked.path);
//                     }
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final imageFile = ref.watch(kycImageFileProvider);
//     final imageError = ref.watch(kycImageErrorProvider);
//
//     return GestureDetector(
//       onTap: () => _pickImage(context, ref),
//       child: ReusableColumn(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ReusableSizedBox(height: 30),
//           Row(
//             children: const [
//               Text(
//                 'Upload ID Proof',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black54,
//                 ),
//               ),
//               Text(
//                 ' *',
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Container(
//             width: double.infinity,
//             height: 170,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: imageError != null ? Colors.red : Colors.grey.shade300,
//               ),
//               color: Colors.grey.shade100,
//             ),
//             child: imageFile == null
//                 ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Tap to upload ID image',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 if (imageError != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(
//                       imageError,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//               ],
//             )
//                 : ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.file(
//                 imageFile,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }