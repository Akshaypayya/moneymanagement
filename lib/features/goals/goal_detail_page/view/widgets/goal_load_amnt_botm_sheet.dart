import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_button.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/goals_funds_controller.dart';

class LoadFundsBottomSheet extends ConsumerStatefulWidget {
  final String? goalName;
  final VoidCallback? onSuccess;

  const LoadFundsBottomSheet({
    Key? key,
    this.goalName,
    this.onSuccess,
  }) : super(key: key);

  @override
  ConsumerState<LoadFundsBottomSheet> createState() =>
      _LoadFundsBottomSheetState();
}

class _LoadFundsBottomSheetState extends ConsumerState<LoadFundsBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen(loadAmountProvider, (previous, current) {
        if (_amountController.text != current) {
          _amountController.text = current;
        }
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(loadFundsControllerProvider);
    final loadAmount = ref.watch(loadAmountProvider);
    final isLoading = ref.watch(isLoadingFundsProvider);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Load Funds Manually',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Move money from your main wallet and get one step closer to your dream.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                _buildAmountInputSection(isDark, controller),

                const SizedBox(height: 32),

                _buildLoadAmountButton(context, isDark, controller, isLoading),
                // GrowkButton(
                //     title: 'Load Fund',
                //     onTap: () => controller.loadFunds(
                //           context,
                //           widget.goalName ?? '',
                //           ref,
                //           onSuccess: widget.onSuccess,
                //         )),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInputSection(bool isDark, LoadFundsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Amount',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
              width: 1,
            ),
            color:
                isDark ? Colors.grey[800]?.withOpacity(0.3) : Colors.grey[50],
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.sarSymbol,
                      height: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 20,
                      color: isDark ? Colors.grey[600] : Colors.grey[300],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[0-9]*\.?[0-9]*')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  onChanged: (value) {
                    controller.updateLoadAmount(value);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildQuickAmountButtons(isDark, controller),
      ],
    );
  }

  Widget _buildQuickAmountButtons(bool isDark, LoadFundsController controller) {
    final quickAmounts = ['100', '500', '1000', '5000'];

    return Row(
      children: quickAmounts.map((amount) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: quickAmounts.indexOf(amount) == quickAmounts.length - 1
                  ? 0
                  : 8,
            ),
            child: GestureDetector(
              onTap: () {
                controller.updateLoadAmount(amount);
                _amountController.text = amount;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 1,
                  ),
                  color: _amountController.text == amount
                      ? Colors.teal
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    amount,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: isDark
                          ? Colors.grey[300]
                          : _amountController.text == amount
                              ? Colors.white
                              : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadAmountButton(
    BuildContext context,
    bool isDark,
    LoadFundsController controller,
    bool isLoading,
  ) {
    return Center(
      child: SizedBox(
        height: 45,
        width: 250,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  if (_amountController.text.trim().isEmpty) {
                    Navigator.pop(context);
                    showGrowkSnackBar(
                        context: context,
                        ref: ref,
                        message: 'Enter any amount to load',
                        type: SnackType.error);

                    return;
                  }
                  controller.loadFunds(
                    context,
                    widget.goalName ?? '',
                    ref,
                    onSuccess: widget.onSuccess,
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.black,
            foregroundColor: isDark ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? Colors.black : Colors.white,
                    ),
                  ),
                )
              : ReusableText(
                  text: 'Load Fund',
                  style: AppTextStyle(
                    textColor: AppColors.current(isDark).background,
                  ).titleSmall),
        ),
      ),
    );
  }
}
