import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_button.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/initiate_sell_gold_transaction_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/sell_gold_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/inititate_sell_gold_transacation_provider.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/sell_gold_provider.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/goal_detail_controller.dart';

class SellGoldBottomSheet extends ConsumerStatefulWidget {
  final String goalName;
  final VoidCallback? onConfirm;

  const SellGoldBottomSheet({
    super.key,
    required this.goalName,
    this.onConfirm,
  });

  @override
  ConsumerState<SellGoldBottomSheet> createState() =>
      _SellGoldBottomSheetState();
}

class _SellGoldBottomSheetState extends ConsumerState<SellGoldBottomSheet> {
  Timer? _timer;
  int _remainingSeconds = 20;
  bool _isTransactionExpired = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initiateSellGold();
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    debugPrint('SELL GOLD TIMER: Starting 20-second countdown');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            debugPrint('SELL GOLD TIMER: $_remainingSeconds seconds remaining');
          } else {
            _isTransactionExpired = true;
            _timer?.cancel();
            debugPrint('SELL GOLD TIMER: Transaction expired');
            if (mounted) {
              showGrowkSnackBar(
                context: context,
                ref: ref,
                message: 'Transaction time expired. Please try again.',
                type: SnackType.error,
              );
            }
          }
        });
      }
    });
  }
  Future<void> _initiateSellGold() async {
    final controller = ref.read(initiateSellGoldControllerProvider);
    final result = await controller.initiateSellGold(
      context: context,
      goalName: widget.goalName,
      widgetRef: ref,
    );

    if (result != null && mounted) {
      _startTimer();
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final sellController = ref.read(sellGoldControllerProvider);
    final isSellLoading = ref.watch(isSellGoldLoadingProvider);
    final isInitiateLoading = ref.watch(isInitiateSellGoldLoadingProvider);
    final initiateSellData = ref.watch(initiateSellGoldDataProvider);
    final goalDetailState = ref.watch(goalDetailStateProvider(widget.goalName));

    double goldBalance = 0.0;
    if (goalDetailState.value?.data != null) {
      goldBalance = goalDetailState.value!.data!.goldBalance;
    }

    double currentGoldPrice = 0.0;
    if (goalDetailState.value?.data != null) {
      currentGoldPrice = goalDetailState.value!.data!.currentPrice;
    }
    double walletBalance = 0.0;
    if (goalDetailState.value?.data != null) {
      walletBalance = goalDetailState.value!.data!.walletBalance;
    }

    final bool isConfirmDisabled = isSellLoading ||
        isInitiateLoading ||
        initiateSellData == null ||
        _isTransactionExpired;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              size: 30,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sell Gold',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          if (initiateSellData != null && !isInitiateLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isTransactionExpired
                    ? Colors.red.withOpacity(0.1)
                    : _remainingSeconds <= 5
                        ? Colors.orange.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isTransactionExpired
                      ? Colors.red
                      : _remainingSeconds <= 5
                          ? Colors.orange
                          : Colors.green,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isTransactionExpired ? Icons.timer_off : Icons.timer,
                    size: 16,
                    color: _isTransactionExpired
                        ? Colors.red
                        : _remainingSeconds <= 5
                            ? Colors.orange
                            : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isTransactionExpired
                        ? 'Transaction Expired'
                        : 'Expires in ${_formatTime(_remainingSeconds)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: _isTransactionExpired
                          ? Colors.red
                          : _remainingSeconds <= 5
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'Selling the gold in this goal will terminate the goal and credit the equivalent amount to your main wallet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          if (isInitiateLoading)
            _buildLoadingState(isDark)
          else if (initiateSellData != null)
            _buildOrderData(isDark, initiateSellData, goldBalance,
                walletBalance, currentGoldPrice)
          else
            _buildErrorState(isDark),
          const SizedBox(height: 32),
          Row(children: [
            Expanded(
              child: GrowkButton(
                title: _isTransactionExpired ? 'Close' : 'Cancel',
                onTap: (isSellLoading || isInitiateLoading)
                    ? null
                    : () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 16),
            _isTransactionExpired == false
                ? Expanded(
                    child: GrowkButton(
                      // title: _isTransactionExpired ? 'Expired' : 'Confirm',
                      title: 'Confirm',
                      onTap: isConfirmDisabled
                          ? null
                          : () async {
                              final responseMessage =
                                  await sellController.sellGold(
                                      context: context,
                                      goalName: widget.goalName,
                                      widgetRef: ref,
                                      transactionId:
                                          initiateSellData!.transactionId);

                              if (responseMessage ==
                                      "No gold balance available." ||
                                  responseMessage ==
                                      "Goal already completed." ||
                                  responseMessage ==
                                      "Transaction time expired.") {
                                Navigator.of(context).pop(responseMessage);
                                showGrowkSnackBar(
                                    context: context,
                                    ref: ref,
                                    message: responseMessage.toString(),
                                    type: SnackType.error);
                                return;
                              }
                              Navigator.of(context).pop(responseMessage);
                              if (widget.onConfirm != null) {
                                widget.onConfirm!();
                              }
                            },
                    ),
                  )
                : SizedBox.shrink()
          ]),
          if (_isTransactionExpired)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Please close and try again to initiate a new transaction.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: isDark ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 16),
            Text(
              'Calculating sell order...',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load sell order details',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _initiateSellGold,
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.teal,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderData(bool isDark, dynamic initiateSellData,
      double goldBalance, double walletBalance, double currentGoldPrice) {
    final double goldSellPrice = initiateSellData.sellPrice;
    final double convenienceFee = initiateSellData.chargeAmount;

    final double goldAmount = goldBalance * goldSellPrice;
    final double totalReceivable =
        (goldAmount + walletBalance) - convenienceFee;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Review Your Order",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 15),
        buildOrderDataRow(
            "Gold Sell Price", "${goldSellPrice.toString()}/g", isDark),
        const SizedBox(height: 8),
        buildOrderDataRow(
            "Gold Quantity", "${goldBalance.toString()} gm", isDark,
            showSar: false),
        const SizedBox(height: 8),
        buildOrderDataRow("Gold Purity", "999.9", isDark, showSar: true),
        const SizedBox(height: 8),
        buildOrderDataRow("Wallet Balance", walletBalance.toString(), isDark,
            showSar: true),
        const SizedBox(height: 8),
        buildOrderDataRow("Gold Amount", goldAmount.toStringAsFixed(2), isDark),
        const SizedBox(height: 8),
        buildOrderDataRow("Convenience Fee", convenienceFee.toString(), isDark),
        const SizedBox(height: 8),
        buildOrderDataRow("Taxes", "0.00", isDark),
        const SizedBox(height: 8),
        Divider(color: isDark ? Colors.grey[600] : Colors.grey[300]),
        const SizedBox(height: 8),
        buildOrderDataRow("Total Receivable Amount",
            totalReceivable.toStringAsFixed(2), isDark,
            isBold: true),
      ],
    );
  }
}

Widget buildOrderDataRow(String label, String value, bool isDark,
    {bool isBold = false, bool showSar = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
            fontSize: 12,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        if (showSar)
          SarAmountWidget(
            text: value,
            height: 12,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: isBold ? 16 : 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: isBold ? 16 : 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
      ],
    ),
  );
}

void showSellGoldBottomSheet(
  BuildContext context,
  String goalName,
  double walletBalance,
  double currentGoldPrice, {
  VoidCallback? onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => SellGoldBottomSheet(
      goalName: goalName,
      onConfirm: onConfirm,
    ),
  );
}
