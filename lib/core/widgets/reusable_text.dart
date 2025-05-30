import 'package:growk_v2/views.dart';

class ReusableText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final StrutStyle? strutStyle;

  const ReusableText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow=TextOverflow.ellipsis,
    this.maxLines = 1,
    this.textWidthBasis,
    this.strutStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
        strutStyle: strutStyle,
      ),
    );
  }
}
