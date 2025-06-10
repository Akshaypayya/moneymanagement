import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/views.dart';

class YearSelectionWidget extends ConsumerWidget {
  final int buttonCount;
  final List<int> buttonNames;
  final int selectedYear;
  final Function(int) onYearSelected;

  const YearSelectionWidget({
    super.key,
    required this.buttonCount,
    required this.buttonNames,
    required this.selectedYear,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScalingFactor(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(buttonCount, (index) {
            final year = buttonNames[index];
            final isSelected = year == selectedYear;
            final label = year == 0 ? "6M" : "${year}Y";

            return Expanded(
              child: GestureDetector(
                onTap: () => onYearSelected(year),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
