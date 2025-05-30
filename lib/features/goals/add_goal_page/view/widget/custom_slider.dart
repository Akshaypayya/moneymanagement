import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';

class CustomSlider extends ConsumerWidget {
  final double value;
  final Color activeColor;
  final ValueChanged<double>? onChanged;
  final StateProvider<double> stateProvider;
  final bool isSteppedAmount;

  const CustomSlider({
    Key? key,
    required this.value,
    required this.activeColor,
    this.onChanged,
    required this.stateProvider,
    this.isSteppedAmount = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final sliderValue = ref.watch(stateProvider);

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 8,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 12,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 20,
        ),
        activeTrackColor: activeColor,
        inactiveTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
        thumbColor: activeColor,
        overlayColor: activeColor.withOpacity(0.3),
      ),
      child: Slider(
        value: sliderValue,
        divisions: isSteppedAmount ? 99 : null,
        onChanged: (newValue) {
          ref.read(stateProvider.notifier).state = newValue;
          if (onChanged != null) {
            onChanged!(newValue);
          }
        },
      ),
    );
  }
}
