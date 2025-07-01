import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/views.dart';

class CommonTabWidget extends ConsumerWidget {
  final int itemCount;
  final List<String> itemNames;
  final String selectedItem;
  final Function(String) onItemSelected;

  const CommonTabWidget({
    super.key,
    required this.itemCount,
    required this.itemNames,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = itemNames.indexOf(selectedItem);
    final isDark = ref.watch(isDarkProvider);

    return ScalingFactor(
      child: ReusableContainer(
        height: 50,
        width: double.infinity,
        color: isDark?Colors.grey.shade900:Colors.grey.shade100,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / itemCount;

            return Stack(
              children: [
                // Sliding indicator
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 150), // 🔥 faster
                  curve: Curves.easeInOut,
                  left: tabWidth * selectedIndex,
                  top: 5,
                  bottom: 5,
                  width: tabWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tab labels
                Row(
                  children: List.generate(itemCount, (index) {
                    final item = itemNames[index];
                    final isSelected = item == selectedItem;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onItemSelected(item),
                        child: Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 120), // 🔥 faster
                            curve: Curves.easeInOut,
                            style:isSelected?AppTextStyle.current(isDark).titleSmall.copyWith(color:Colors.black):AppTextStyle.current(isDark).labelSmall,
                            // TextStyle(
                            //   color: isSelected ? Colors.black : Colors.black45,
                            //   fontWeight:
                            //   isSelected ? FontWeight.bold : FontWeight.normal,
                            //   fontSize: 14,
                            // ),
                            child: Text(item),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
