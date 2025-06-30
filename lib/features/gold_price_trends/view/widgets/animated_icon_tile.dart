import '../../../../views.dart';

class AnimatedIconTile extends ConsumerWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const AnimatedIconTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyle.current(isDark).graphLabel,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style:  AppTextStyle.current(isDark).titleRegular,
            ),
          ],
        ),
      ],
    );
  }
}
