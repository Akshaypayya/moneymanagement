import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import 'package:growk_v2/features/gold_price_trends/view/widgets/animated_icon_tile.dart';
import 'package:growk_v2/features/gold_price_trends/view/widgets/year_selection_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../views.dart';
import '../../goals/add_goal_page/view/widget/custom_slider.dart';

class GoldPriceTrendsPage extends ConsumerStatefulWidget {
  const GoldPriceTrendsPage({super.key});

  @override
  ConsumerState<GoldPriceTrendsPage> createState() => _GoldPriceTrendsPageState();
}

class _GoldPriceTrendsPageState extends ConsumerState<GoldPriceTrendsPage> {
  int selectedPeriod = 10;
  double investmentAmount = 150000;
  final double returnMultiplier = 1.616;

  List<int> periods = [10, 5, 3, 1, 0];
  Map<int, List<FlSpot>> chartDataMap = {};

  @override
  void initState() {
    super.initState();
    _generateChartData();
  }

  void _generateChartData() {
    chartDataMap = {
      10: [FlSpot(0, 110), FlSpot(1, 115), FlSpot(2, 125), FlSpot(3, 135), FlSpot(4, 145), FlSpot(5, 150), FlSpot(6, 160), FlSpot(7, 165), FlSpot(8, 180), FlSpot(9, 200), FlSpot(10, 210), FlSpot(11, 225), FlSpot(12, 250), FlSpot(13, 240), FlSpot(14, 260), FlSpot(15, 275), FlSpot(16, 290), FlSpot(17, 310), FlSpot(18, 330), FlSpot(19, 350)],
      5: [FlSpot(0, 150), FlSpot(1, 165), FlSpot(2, 180), FlSpot(3, 200), FlSpot(4, 220), FlSpot(5, 240), FlSpot(6, 255), FlSpot(7, 275), FlSpot(8, 300), FlSpot(9, 320)],
      3: [FlSpot(0, 180), FlSpot(1, 195), FlSpot(2, 215), FlSpot(3, 240), FlSpot(4, 270), FlSpot(5, 290)],
      1: [FlSpot(0, 250), FlSpot(1, 265), FlSpot(2, 280), FlSpot(3, 310)],
      0: [FlSpot(0, 280), FlSpot(1, 290), FlSpot(2, 305), FlSpot(3, 325)],
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final spots = chartDataMap[selectedPeriod]!;
    final double totalReturns = investmentAmount * returnMultiplier;
    final double profit = totalReturns - investmentAmount;
    final double percent = totalReturns == 0 ? 0 : profit / totalReturns;

    return Scaffold(
      backgroundColor: AppColors.current(isDark).scaffoldBackground,
      appBar: GrowkAppBar(title: 'Gold Price Trends', isBackBtnNeeded: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableWhiteContainerWithPadding(
              widget: ReusableColumn(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Growth Calculator", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                    "Check how much your past gold investment would be worth today. Select the investment amount and time period to calculate your total returns based on historical price trends.",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 30),
                  YearSelectionWidget(
                    buttonCount: periods.length,
                    buttonNames: periods,
                    onYearSelected: (int year) {
                      setState(() {
                        selectedPeriod = year;
                      });
                    },
                    selectedYear: selectedPeriod,
                  ),
                  const SizedBox(height: 20),
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                       
                      ),
                      padding: const EdgeInsets.all(10),
                      child: LineChart(
                        LineChartData(
                          minY: 100,
                          maxY: 350,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 50,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.withOpacity(0.15),
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
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 2,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  String label = selectedPeriod == 0 ? "${(value * 1.5).toInt()}M" : "${value.toInt()}";
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          lineTouchData: LineTouchData(enabled: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: Colors.teal,
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.teal.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ReusableWhiteContainerWithPadding(widget: _buildSlider()),
            ReusableWhiteContainerWithPadding(
              widget: Column(
                children: [
                  const Text("Gold Investment Returns", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildSummarySection(percent, totalReturns, profit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Investment Amount (SAR)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      Row(
        children: [
          const Text("10K", style: TextStyle(fontSize: 12)),
          Expanded(
            child: Slider(
              min: 10000,
              max: 1000000,
              value: investmentAmount,
              onChanged: (value) => setState(() => investmentAmount = value),
              activeColor: Colors.teal,
              inactiveColor: Colors.grey.shade300,
            ),
          ),
          const Text("1M", style: TextStyle(fontSize: 12)),
        ],
      ),
      const SizedBox(height: 12),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          "SAR ${investmentAmount.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal),
        ),
      ),
    ],
  );

  Widget _buildSummarySection(double percent, double totalReturns, double profit) {
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
              const Text("Total Return", style: TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              SarAmountWidget(
                alignment: Alignment.center,
                height: 12,
                text: totalReturns.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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
                value: "SAR ${investmentAmount.toStringAsFixed(2)}",
                iconColor: Colors.teal,
              ),
              const SizedBox(height: 14),
              AnimatedIconTile(
                icon: Icons.trending_up,
                label: "Profit",
                value: "SAR ${profit.toStringAsFixed(2)}",
                iconColor: Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}