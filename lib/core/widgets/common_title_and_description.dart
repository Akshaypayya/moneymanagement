import 'package:growk_v2/views.dart';

class CommonTitleAndDescription extends ConsumerWidget {
  final String title;
  final String description;

  const CommonTitleAndDescription({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
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
            style: AppTextStyle.current(isDark).titleRegularMedium),
        ReusableSizedBox(
          height: 5,
        ),
        ReusableText(
          textAlign: TextAlign.justify,
          maxLines: 3,
            text: description,
            style: AppTextStyle.current(isDark).bodySmall),
      ]),
    ));
  }
}
