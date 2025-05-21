import '../../../views.dart';

class ApplyReferalCodeScreen extends ConsumerWidget {
  const ApplyReferalCodeScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return ScalingFactor(child: CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 22,right: 22),
        child: ReusableColumn(children: <Widget>[
          ApplyRefCodeTopIcon(),
          ApplyRefCodeTopText(),
          ApplyRefCodeTextField(),
          ApplyRefCodeSubmit()
        ]),
      ),
    ));
  }
}
