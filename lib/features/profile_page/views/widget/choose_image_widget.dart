import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/views.dart';

void showImageSourceActionSheet(BuildContext context, WidgetRef ref,
    {required VoidCallback cameraOnTap, required VoidCallback galleryOnTap}) {
  final isDark = ref.watch(isDarkProvider);

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: isDark ? Colors.white : Colors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text('|',
                          style: TextStyle(
                            fontSize: 30,
                            color: !isDark ? Colors.white : Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text('Choose an action',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: !isDark ? Colors.white : Colors.black,
                        )),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: cameraOnTap,
                          child: Column(
                            children: [
                              Image.asset(AppImages.camera,
                                  height: 30,
                                  width: 30,
                                  color: !isDark ? Colors.white : Colors.black),
                              Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Camera',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          !isDark ? Colors.white : Colors.black,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Image.asset(AppImages.line,
                            height: 40,
                            width: 40,
                            color: !isDark ? Colors.white : Colors.black),
                        InkWell(
                          onTap: galleryOnTap,
                          child: Column(
                            children: [
                              Image.asset(AppImages.gallery,
                                  height: 25,
                                  width: 25,
                                  color: !isDark ? Colors.white : Colors.black),
                              Padding(
                                  padding: const EdgeInsets.only(top: 11),
                                  child: Text(
                                    'Gallery',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          !isDark ? Colors.white : Colors.black,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // if (ref.watch(profilePictureFileProvider) != null)
            //   ListTile(
            //     leading: const Icon(Icons.delete, color: Colors.red),
            //     title: const Text('Remove Photo',
            //         style: TextStyle(color: Colors.red)),
            //     onTap: () {
            //       Navigator.of(context).pop();
            //       ref
            //           .read(profilePictureControllerProvider)
            //           .clearProfilePicture(ref);
            //     },
            //   ),
          ],
        ),
      );
    },
  );
}
