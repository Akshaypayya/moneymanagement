import 'package:intl/intl.dart';
import '../../../../views.dart';

class SavingsRowWidget extends ConsumerStatefulWidget {
  final String emoji;
  final String title;
  final String profit;
  final Color profitColor;
  final String action;
  final String invested;
  final String current;
  final String growth;
  final String actionIcon;
  final bool? received;
  final bool? goldSavings;
  final int index;
  final String? goldAmount;

  const SavingsRowWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.profit,
    required this.profitColor,
    required this.action,
    required this.invested,
    required this.current,
    required this.growth,
    required this.actionIcon,
    required this.index,
    required this.goldSavings,
    this.goldAmount,
    this.received,
  });

  @override
  ConsumerState<SavingsRowWidget> createState() => _SavingsRowWidgetState();
}

class _SavingsRowWidgetState extends ConsumerState<SavingsRowWidget> {
  bool _isNavigating = false;
  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 2);

  Future<void> _handleTap() async {
    if (_isNavigating) return;

    setState(() => _isNavigating = true);
    try {
      await ref.refresh(homeDetailsProvider.future);

      if (widget.index == 0) {
        await Navigator.pushNamed(context, AppRouter.buyGoldInstantly);
      } else if (widget.index == 1) {
        await Navigator.pushNamed(context, AppRouter.createGoalScreen);
      } else if (widget.index == 2) {
        await Navigator.pushNamed(context, AppRouter.referralRewards);
      }
    } catch (e) {
      final texts = ref.read(appTextsProvider);
      final errorMessage = e.toString().contains('KYC not completed')
          ? texts.kycNotVerifiedError
          : texts.genericError;

      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: errorMessage,
        type: SnackType.error,
      );

      await Navigator.pushNamed(context, AppRouter.kycVerificationScreen);
    } finally {
      if (mounted) setState(() => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final texts = ref.watch(appTextsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Row with Emoji + Title + Action
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(widget.emoji,
                    height: widget.emoji == AppImages.instantGold ? 12 : 20),
                const SizedBox(width: 8),
                ReusableText(
                  text: widget.title,
                  style: AppTextStyle(textColor: AppColors.current(isDark).text)
                      .titleSmall,
                ),
              ],
            ),
            GestureDetector(
              onTap: _handleTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.current(isDark).primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ReusableRow(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(widget.actionIcon,
                        height: 15,
                        color: isDark ? Colors.black : Colors.white),
                    const SizedBox(width: 5),
                    ReusableText(
                      text: widget.action,
                      style: AppTextStyle(
                          textColor: isDark ? Colors.black : Colors.white)
                          .labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// Profit + Growth
        ReusableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReusableColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ReusableText(
                      text: texts.profit,
                      style: AppTextStyle(
                        textColor: AppColors.current(isDark).text,
                      ).labelSmall,
                    ),
                    Row(
                      children: [
                        Image.asset(AppImages.sarSymbol,
                            color: widget.profitColor, height: 15),
                        const SizedBox(width: 2),
                        ReusableText(
                          text: widget.profit,
                          style: TextStyle(
                            color: widget.profitColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Transform.rotate(
                      angle: widget.growth.trim().startsWith('-') ? 3.14 : 0,
                      child: Image.asset(
                        AppImages.upGreen,
                        height: 10,
                        color: widget.growth.trim().startsWith('-')
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      widget.growth,
                      style: AppTextStyle(
                        textColor: widget.growth.trim().startsWith('-')
                            ? Colors.red
                            : Colors.green,
                      ).titleSmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 4),

        /// Invested / Received / Gold + Current
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.received == true
                      ? '${texts.received}: '
                      : widget.goldSavings == true
                      ? '${texts.goldLabel}: '
                      : '${texts.invested}: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.current(isDark).text,
                  ),
                ),
                widget.goldSavings == true
                    ? ReusableSizedBox()
                    : Image.asset(AppImages.sarSymbol,
                    color: AppColors.current(isDark).text, height: 10),
                const SizedBox(width: 2),
                Text(
                  widget.invested,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.current(isDark).text,
                  ),
                ),
                if (widget.goldSavings == true)
                  Row(
                    children: [
                      Text('(',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.current(isDark).text)),
                      Image.asset(AppImages.sarSymbol,
                          color: AppColors.current(isDark).text, height: 10),
                      const ReusableSizedBox(width: 3),
                      Text('${widget.goldAmount}',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.current(isDark).text)),
                      Text(')',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.current(isDark).text)),
                    ],
                  ),
              ],
            ),
            Text(
              '${texts.current}: ${widget.current}',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.current(isDark).text,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
