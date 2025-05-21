import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/widgets/growk_button.dart';
import 'package:money_mangmnt/core/widgets/sar_amount_widget.dart';
import 'package:money_mangmnt/views.dart';

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
    return ScalingFactor(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
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
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    // Check if value contains ₱ symbol
                    value.contains('₱')
                        ? SarAmountWidget(
                            text: value.replaceAll('₱', '').trim(),
                            height: 13,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        : Text(
                            value,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
