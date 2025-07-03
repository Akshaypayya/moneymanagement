import 'package:growk_v2/features/goals/goal_page_checker/view/goal_page_checker.dart';
import 'package:growk_v2/features/profile_page/views/profile_page.dart';
import 'package:growk_v2/features/settings_page/settings_page.dart';
import 'package:growk_v2/features/transaction_page/transactions_page.dart';
import 'package:growk_v2/views.dart';
import 'dart:io'; // ⬅️ add this instead

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final notificationIndex = ref.read(notificationNavigationIndexProvider);
    final fallbackIndex = ref.read(bottomNavBarProvider);
    final targetIndex = notificationIndex ?? fallbackIndex;

    // ✅ Safely update after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bottomNavBarProvider.notifier).state = targetIndex;
    });

    _pageController = PageController(initialPage: targetIndex);

    if (notificationIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(notificationNavigationIndexProvider.notifier).state = null;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: isDark?Colors.grey.shade900:Colors.white,
            title:  Text("Exit App",style: AppTextStyle.current(isDark).titleLrg,),
            content:  Text("Do you want to close the app?",style:AppTextStyle.current(isDark).bodyKycSmall),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No",style: TextStyle(color: Colors.white),),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child:  Text("Yes",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );

        if (shouldExit == true) {
          exit(0); // ✅ forcefully closes the app
        }
      },
      child: ScalingFactor(
        child: CustomScaffold(
          backgroundColor: AppColors.current(isDark).scaffoldBackground,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              ref.read(bottomNavBarProvider.notifier).state = index;
            },
            children: const [
              HomeScreen(),
              TransactionsPage(),
              GoalPageWrapper(),
              ProfilePage(),
              SettingsPage(),
            ],
          ),
          bottomNavigationBar: GrowkBottomNavBar(
            onTap: (index) {
              ref.read(bottomNavBarProvider.notifier).state = index;
              _pageController.jumpToPage(index);
            },
          ),
        ),
      ),
    );
  }
}
