import 'package:money_mangmnt/views.dart';

class CommonTitleAndDescription extends StatelessWidget {
  final String title;
  final String description;

  const CommonTitleAndDescription(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
        child: Align(
      alignment: Alignment.centerLeft,
      child: ReusableColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ReusableSizedBox(
              height: 15,
            ),
            ReusableText(
                text: title,
                style: AppTextStyle.current(false).titleRegularMedium),
            ReusableSizedBox(
              height: 5,
            ),
            ReusableText(
                textAlign: TextAlign.justify,
                maxLines: 3,
                text: description,
                style: AppTextStyle.current(false).bodySmall),
          ]),
    ));
  }
}
