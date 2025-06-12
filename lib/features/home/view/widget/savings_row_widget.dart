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
  final String ?goldAmount;

  const SavingsRowWidget( {
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
      final errorMessage = e.toString().contains('KYC not completed')
          ? 'KYC not verified. Please complete KYC to access this feature.'
          : 'Something went wrong. Please try again later.';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ReusableRow(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(widget.actionIcon,
                        height: 15, color: Colors.white),
                    const SizedBox(width: 5),
                    ReusableText(
                      text: widget.action,
                      style: AppTextStyle(textColor: Colors.white).labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ReusableColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReusableColumn(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ReusableText(
                      text: 'Profit',
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
                    Image.asset(AppImages.upGreen, height: 10),
                    const SizedBox(width: 2),
                    Text(
                      widget.growth,
                      style: AppTextStyle(
                        textColor: AppColors.current(isDark).text,
                      ).titleSmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.received == true
                      ? 'Received: '
                      : widget.goldSavings == true
                          ? 'Gold Savings: '
                          : 'Invested: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.current(isDark).text,
                  ),
                ),
                widget.goldSavings==true?ReusableSizedBox():Image.asset(AppImages.sarSymbol,
                    color: AppColors.current(isDark).text, height: 10),
                const SizedBox(width: 2),
                Text(
                  widget.invested,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.current(isDark).text,
                  ),
                ),
                if(widget.goldSavings==true)Row(
                  children: [
                    Text(
                      '(',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.current(isDark).text,
                      ),
                    ),
                    Image.asset(AppImages.sarSymbol,
                        color: AppColors.current(isDark).text, height: 10),
                    ReusableSizedBox(width: 3,),
                    Text(
                      '${widget.goldAmount}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.current(isDark).text,
                      ),
                    ),
                    Text(
                      ')',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.current(isDark).text,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'Current: ${widget.current}',
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
