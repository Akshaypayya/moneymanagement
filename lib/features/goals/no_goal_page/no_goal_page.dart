import 'package:money_mangmnt/core/constants/app_space.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/view/widget/goals_header.dart';
import 'package:money_mangmnt/features/goals/no_goal_page/components/create_goal_btn.dart';
import 'package:money_mangmnt/features/goals/no_goal_page/components/no_goal_description.dart';
import 'package:money_mangmnt/features/goals/no_goal_page/components/no_goal_image.dart';
import 'package:money_mangmnt/views.dart';

class NoGoalPage extends ConsumerStatefulWidget {
  const NoGoalPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoGoalPageState();
}

class _NoGoalPageState extends ConsumerState<NoGoalPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    return Scaffold(
      backgroundColor: AppColors.current(isDark).scaffoldBackground,
      appBar: GrowkAppBar(
        title: 'Your Savings Goals',
        isBackBtnNeeded: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: isDark ? Colors.black : Colors.white,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoalsHeader(),
              GapSpace.height60,
              noGoalImage(),
              GapSpace.height30,
              noGoalDescription(
                ref: ref,
              ),
              GapSpace.height60,
              createGoalButton(
                ref: ref,
                context: context,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
