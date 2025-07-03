import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/widgets/growk_button.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import 'package:growk_v2/views.dart';

class SuccessBottomSheet extends ConsumerWidget {
  final String title;
  final String description;
  final Map<String, String> details;
  final VoidCallback onClose;

  const SuccessBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.details,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return ScalingFactor(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark?Colors.grey.shade900:Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/success.png', height: 60, width: 60),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyle.current(isDark).titleSmall.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: AppTextStyle.current(isDark).bodyKycSmall.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GridView.builder(
              padding: EdgeInsets.only(left: 30),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3,
              ),
              itemCount: details.length,
              itemBuilder: (context, index) {
                final key = details.keys.elementAt(index);
                final value = details.values.elementAt(index);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key,
                      style:
                         AppTextStyle.current(isDark).bodyKycSmall.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    // Check if value contains ₱ symbol
                    value.contains('₱')
                        ? SarAmountWidget(
                            text: value.replaceAll('₱', '').trim(),
                            height: 13,
                            style:AppTextStyle.current(isDark).bodyKycSmall.copyWith(fontSize: 14,fontWeight: FontWeight.w600),
                          )
                        : Text(
                            value,
                            style:AppTextStyle.current(isDark).bodyKycSmall.copyWith(fontSize: 14,fontWeight: FontWeight.bold)
                          ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: GrowkButton(
                title: 'Close',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.mainScreen,
                    (route) => false,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
