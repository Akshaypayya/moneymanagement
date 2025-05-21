import '../../../views.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      // 👇 Trigger refresh once
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.refresh(homeDetailsProvider);
      });
      _isFirstLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    return ScalingFactor(
      child: CustomScaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        body: GrowkRefreshIndicator(
          providerToRefresh: homeDetailsProvider,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ReusableColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                HomeHeader(),
                HomeSavingsOverviewWidget(),
                TrackYourSavingsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
