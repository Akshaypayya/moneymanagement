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
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final buttonWidth = (screenWidth - 60) /
        buttonCount; // subtract padding/margins

    return ScalingFactor(
      child: ReusableContainer(
        height: 50,
        width: double.infinity,
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(buttonCount, (index) {
            final year = buttonNames[index];
            final isSelected = year == selectedYear;

            return GestureDetector(
              onTap: () => onYearSelected(year),
              child: Container(
                height: 40,
                width: buttonWidth.clamp(60.0, 120.0),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                      : [],
                ),
                child: Text(
                  '$year Y',
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.black45,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight
                        .normal,
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