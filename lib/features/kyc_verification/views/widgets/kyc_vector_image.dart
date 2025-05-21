import 'package:money_mangmnt/views.dart';

class KycVectorImage extends StatelessWidget {
  const KycVectorImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableContainer(
      height: 250,
      width: 250,
      child: Center(
        child: ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0.2126,
            0.7152,
            0.0722,
            0,
            0,
            0,
            0,
            0,
            1,
            0,
          ]),
          child: Image(image: AssetImage(AppImages.kycImage)),
        ),
      ),
    );
  }
}
