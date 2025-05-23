import 'package:money_mangmnt/features/goals/goal_page_checker/view/goal_page_checker.dart';
import 'package:money_mangmnt/features/profile_page/views/profile_page.dart';
import 'package:money_mangmnt/features/settings_page/settings_page.dart';
import 'package:money_mangmnt/features/transaction_page/transactions_page.dart';
import 'package:money_mangmnt/views.dart';

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
    final index = ref.read(bottomNavBarProvider);
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    return ScalingFactor(
      child: CustomScaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) =>
              ref.read(bottomNavBarProvider.notifier).state = index,
          children: const <Widget>[
            HomeScreen(),
            TransactionsPage(),
            GoalPageWrapper(),
            ProfilePage(),
            SettingsPage()
          ],
        ),
        bottomNavigationBar: GrowkBottomNavBar(
          onTap: (index) {
            ref.read(bottomNavBarProvider.notifier).state = index;
            _pageController.jumpToPage(index);
            debugPrint(
                'BottomNav Selected Index: ${ref.read(bottomNavBarProvider)}');
          },
        ),
      ),
    );
  }
}
