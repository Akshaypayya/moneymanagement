import 'package:growk_v2/views.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final texts = ref.watch(appTextsProvider);

    return ScalingFactor(
      child: Scaffold(
          backgroundColor: AppColors.current(isDark).scaffoldBackground,
          appBar: GrowkAppBar(
            title: texts.yourSavingGoals,
            isBackBtnNeeded: false,
          ),
          floatingActionButton: goalsFab(context, ref),
          body: goalsListPageBody(isDark, ref)),
    );
  }
}
