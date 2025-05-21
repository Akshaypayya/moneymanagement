import 'package:money_mangmnt/views.dart';

class GrowkBottomNavBar extends ConsumerWidget {
  final Function(int) onTap;

  const GrowkBottomNavBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavBarProvider);
    final isDark = ref.watch(isDarkProvider);

    final items = [
      {"icon": AppImages.tabHome, "label": "Home"},
      {"icon": AppImages.tabTransactions, "label": "Transactions"},
      {"icon": AppImages.tabGoals, "label": "Goals"},
      {"icon": AppImages.tabProfile, "label": "Profile"},
      {"icon": AppImages.tabSettings, "label": "Settings"},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.current(isDark).background,
        border: Border(
          top: BorderSide(
            color: AppColors.current(isDark).scaffoldBackground,
            width: 5,
          ),
        ),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(12),
              splashColor: AppColors.current(isDark).primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      items[index]["icon"]!,
                      height: 28,
                      color: isSelected
                          ? AppColors.current(isDark).primary
                          : AppColors.current(isDark).labelText,
                    ),
                    const SizedBox(height: 4),
                    ReusableText(
                      text: items[index]["label"]!,
                      style: AppTextStyle(
                        textColor: isSelected
                            ? AppColors.current(isDark).primary
                            : AppColors.current(isDark).labelText,
                      ).titleBottomNav,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
