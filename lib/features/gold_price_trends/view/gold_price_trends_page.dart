import '../../../views.dart';

class GoldPriceTrendsPage extends ConsumerStatefulWidget {
  const GoldPriceTrendsPage({super.key});

  @override
  ConsumerState<GoldPriceTrendsPage> createState() => _GoldPriceTrendsPageState();
}

class _GoldPriceTrendsPageState extends ConsumerState<GoldPriceTrendsPage> {
  @override
  Widget build(BuildContext context) {
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final periods = ['1M', '3M', '6M', '1Y', '3Y', '5Y'];
    final isDark = ref.watch(isDarkProvider);
    final investmentAmount = ref.watch(investmentAmountProvider);
    final historyAsync = ref.watch(goldHistorySpotsProvider);
    final lastChartSpots = ref.watch(lastChartSpotsProvider);
    void clearGoldPriceTrendsState(WidgetRef ref) {
      ref.invalidate(selectedPeriodProvider);
      ref.invalidate(investmentAmountProvider);
      ref.invalidate(goldHistorySpotsProvider);
      ref.invalidate(lastChartSpotsProvider);
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          clearGoldPriceTrendsState(ref);
        }
      },
      child: ScalingFactor(
        child: Scaffold(
          backgroundColor: AppColors.current(isDark).scaffoldBackground,
          appBar: GrowkAppBar(title: 'Gold Price Trends', isBackBtnNeeded: true),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableWhiteContainerWithPadding(
                  widget: ReusableColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text("Growth Calculator",
                          style: AppTextStyle.current(isDark).titleRegular),
                      const SizedBox(height: 8),
                      Text(
                        "Check how much your past gold investment would be worth today. Select the investment amount and time period to calculate your total returns based on historical price trends.",
                        style: AppTextStyle.current(isDark).bodyKycSmall
                      ),
                      const SizedBox(height: 30),
                      YearSelectionWidget(
                        buttonCount: periods.length,
                        buttonNames: periods,
                        onYearSelected: (String period) =>
                        ref.read(selectedPeriodProvider.notifier).state = period,
                        selectedYear: selectedPeriod,
                      ),
                      const SizedBox(height: 20),
                      AspectRatio(
                        aspectRatio: 1.6,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: historyAsync.when(
                              data: (chartSpots) => _buildChart(
                                  chartSpots, investmentAmount, false,isDark,
                                  selectedPeriod: selectedPeriod),
                              loading: () => _buildChart(
                                  lastChartSpots, investmentAmount, true,isDark,
                                  selectedPeriod: selectedPeriod),
                              error: (e, st) => Center(child: Text('Error loading chart',style: AppTextStyle.current(isDark).bodySmall,)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ReusableWhiteContainerWithPadding(
                  widget: _buildSlider(ref, investmentAmount,isDark),
                ),
                ReusableWhiteContainerWithPadding(
                  widget: historyAsync.when(
                    data: (chartSpots) {
                      if (chartSpots.isEmpty) {
                        return Center(
                          child: ReusableText(
                              text: 'Loading',
                              style: AppTextStyle.current(isDark).titleRegular),
                        );
                      }
                      final start = chartSpots.first.y;
                      final end = chartSpots.last.y;
                      final returnMultiplier = start > 0 ? end / start : 1;
                      final totalReturns = investmentAmount * returnMultiplier;
                      final profit = totalReturns - investmentAmount;
                      final percent = totalReturns == 0
                          ? 0.0
                          : (profit / totalReturns).clamp(0, 1);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("Gold Investment Returns",
                              style: AppTextStyle.current(isDark).titleSmall),
                          const SizedBox(height: 25),
                          _buildSummarySection(investmentAmount, percent.toDouble(),
                              totalReturns, profit,isDark,false),
                        ],
                      );
                    },
                    loading: () =>   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Gold Investment Returns",
                            style: AppTextStyle.current(isDark).titleSmall),
                        const SizedBox(height: 25),
                        _buildSummarySection(investmentAmount,0.00,
                            1.00, 1.00,isDark,true),
                      ],
                    ),
                    error: (e, st) => const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(
      List<FlSpot> chartSpots,
      double investmentAmount,
      bool isLoading,
      bool isDark, {
        required String selectedPeriod,
      }) {
    if (chartSpots.isEmpty) {
      return const Center(child: Text('Loading...'));
    }

    final start = chartSpots.first.y;
    final end = chartSpots.last.y;
    final returnMultiplier = start > 0 ? end / start : 1;
    final totalReturns = investmentAmount * returnMultiplier;
    final profit = totalReturns - investmentAmount;
    final percent = totalReturns == 0 ? 0.0 : (profit / totalReturns).clamp(0, 1);

    final periodInDays = {
      '1M': 30,
      '3M': 90,
      '6M': 180,
      '1Y': 365,
      '3Y': 1095,
      '5Y': 1825,
    };

    final days = periodInDays[selectedPeriod] ?? 30;
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: days));

    return LineChart(
      LineChartData(
        minY: chartSpots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 10,
        maxY: chartSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 10,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.05),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 50,
              reservedSize: 36,
              getTitlesWidget: (value, meta) => Text(
                "${value.toInt()}",
                style: _labelStyle(isDark),
              ),
            ),
          ),
          bottomTitles:AxisTitles(
          sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            final length = chartSpots.length;
            if (length == 0 || index >= length) return const SizedBox.shrink();

            final start = 0;
            final middle = length ~/ 2;
            final end = length - 1;

            // Calculate date for each index
            DateTime date;
            if (index == end) {
              date = DateTime.now(); // set last label as today
            } else {
              date = startDate.add(Duration(days: index));
            }

            if (index == start || index == middle || index == end) {
              final label = '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)}';
              final subLabel = '${date.year}';

              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ReusableColumn(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(label, style: _labelStyle(isDark), textAlign: TextAlign.center),
                    Text(subLabel, style: _labelStyle(isDark), textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
          interval: 1,
        ),
      ),

      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          enabled: !isLoading,
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 6,
            fitInsideHorizontally: true,
            getTooltipItems: (spots) {
              return spots.map((spot) {
                final date = startDate.add(Duration(days: spot.x.toInt()));
                return LineTooltipItem(
                  "${date.day}/${date.month}\n${spot.y.toStringAsFixed(2)}",
                  TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: Colors.teal, strokeWidth: 1),
                FlDotData(show: true),
              );
            }).toList();
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: chartSpots,
            isCurved: true,
            curveSmoothness: 0.25,
            color: Colors.teal,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.teal.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildDateTitle(double value, List<FlSpot> spots, DateTime startDate,bool isDark) {
    if (spots.isEmpty) return const SizedBox.shrink();

    final index = value.toInt();
    final isStart = index == 0;
    final isEnd = index == spots.length - 1;

    if (isStart || isEnd) {
      final date = startDate.add(Duration(days: index));
      final label =
          "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}";
      return _buildDateLabel(label,isDark);
    }

    return const SizedBox.shrink();
  }


  Widget _buildDateLabel(String text,bool isDark) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
    child: Text(
      text,
      style: _labelStyle(isDark),
      textAlign: TextAlign.center,
    ),
  );

  TextStyle _labelStyle(bool isDark) => AppTextStyle.current(isDark).graphLabel;

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  Widget _buildSlider(WidgetRef ref, double investmentAmount,bool isDark) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Investment Amount (SAR)",
          style: AppTextStyle.current(isDark).titleSmall),
      const SizedBox(height: 12),
      Row(
        children: [
          Text("10K", style: AppTextStyle.current(isDark).graphLabel),
          Expanded(
            child: Slider(
              min: 10000,
              max: 1000000,
              value: investmentAmount,
              onChanged: (value) => ref
                  .read(investmentAmountProvider.notifier)
                  .state = value,
              activeColor: Colors.teal,
              inactiveColor: Colors.grey.shade300,
            ),
          ),
           Text("1M", style: AppTextStyle.current(isDark).graphLabel),
        ],
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          "SAR ${investmentAmount.toStringAsFixed(2)}",
          style: AppTextStyle.current(isDark).titleSmall.copyWith(fontSize: 16,color: Colors.teal),
        ),
      ),
    ],
  );

  Widget _buildSummarySection(double investmentAmount, double percent,
      double totalReturns, double profit,bool isDark,bool isLoading) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircularPercentIndicator(
          radius: 65,
          lineWidth: 10,
          animation: false,
          percent: percent,
          backgroundColor: Colors.grey.shade200,
          progressColor: Colors.teal,
          circularStrokeCap: CircularStrokeCap.round,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total Return", style: AppTextStyle.current(isDark).graphLabel),
              const SizedBox(height: 4),
              SarAmountWidget(
                alignment: Alignment.center,
                height: 12,
                text:  isLoading==true?'Loading..':totalReturns.toStringAsFixed(2),
                style: AppTextStyle.current(isDark).titleSmall.copyWith(fontSize: 16),)
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedIconTile(
                icon: Icons.account_balance_wallet,
                label: "Investment",
                value: isLoading==true?'Loading..':"SAR ${investmentAmount.toStringAsFixed(2)}",
                iconColor: Colors.teal,
              ),
              const SizedBox(height: 14),
              AnimatedIconTile(
                icon: Icons.trending_up,
                label: "Profit",
                value:  isLoading==true?'Loading..':"SAR ${profit.toStringAsFixed(2)}",
                iconColor: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
