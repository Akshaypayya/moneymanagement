import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import 'package:growk_v2/features/gold_price_trends/view/widgets/year_selection_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../views.dart';
import '../../goals/add_goal_page/view/widget/custom_slider.dart';

class GoldPriceTrendsPage extends StatefulWidget {
  const GoldPriceTrendsPage({super.key});

  @override
  State<GoldPriceTrendsPage> createState() => _GoldPriceTrendsPageState();
}

class _GoldPriceTrendsPageState extends State<GoldPriceTrendsPage> {
  int selectedPeriod = 10; // in years
  double investmentAmount = 150000;
  final double returnMultiplier = 1.616; // example: 10Y return 161.6%

  List<int> periods = [10, 5, 3, 1, 0];
  Map<int, List<FlSpot>> chartDataMap = {};

  @override
  void initState() {
    super.initState();
    _generateChartData();
  }

  void _generateChartData() {
    chartDataMap = {
      10: [
        FlSpot(0, 110),
        FlSpot(1, 115),
        FlSpot(2, 125),
        FlSpot(3, 135),
        FlSpot(4, 145),
        FlSpot(5, 150),
        FlSpot(6, 160),
        FlSpot(7, 165),
        FlSpot(8, 180),
        FlSpot(9, 200),
        FlSpot(10, 210),
        FlSpot(11, 225),
        FlSpot(12, 250),
        FlSpot(13, 240),
        FlSpot(14, 260),
        FlSpot(15, 275),
        FlSpot(16, 290),
        FlSpot(17, 310),
        FlSpot(18, 330),
        FlSpot(19, 350),
      ],
      5: [
        FlSpot(0, 150),
        FlSpot(1, 165),
        FlSpot(2, 180),
        FlSpot(3, 200),
        FlSpot(4, 220),
        FlSpot(5, 240),
        FlSpot(6, 255),
        FlSpot(7, 275),
        FlSpot(8, 300),
        FlSpot(9, 320),
      ],
      3: [
        FlSpot(0, 180),
        FlSpot(1, 195),
        FlSpot(2, 215),
        FlSpot(3, 240),
        FlSpot(4, 270),
        FlSpot(5, 290),
      ],
      1: [
        FlSpot(0, 250),
        FlSpot(1, 265),
        FlSpot(2, 280),
        FlSpot(3, 310),
      ],
      0: [
        FlSpot(0, 280),
        FlSpot(1, 290),
        FlSpot(2, 305),
        FlSpot(3, 325),
      ],
    };
  }

  double get totalReturns => investmentAmount * returnMultiplier;

  double get profit => totalReturns - investmentAmount;

  @override
  Widget build(BuildContext context) {
    final spots = chartDataMap[selectedPeriod]!;
    final double totalReturns = investmentAmount * returnMultiplier;
    final double profit = totalReturns - investmentAmount;

// Avoid zero division
    final double percent = totalReturns == 0 ? 0 : profit / totalReturns;

    return Scaffold(
      appBar: GrowkAppBar(
        title: 'Gold Price Trends',
        isBackBtnNeeded: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Growth Calculator",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text(
              "Check how much your past gold investment would be worth today. Select the investment amount and time period to calculate your total returns based on historical price trends.",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            // const SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: periods.map((year) {
            //     return ElevatedButton(
            //       onPressed: () => setState(() => selectedPeriod = year),
            //       style: ElevatedButton.styleFrom(
            //         elevation: 0,
            //         backgroundColor:
            //             selectedPeriod == year ? Colors.teal : Colors.white,
            //         foregroundColor:
            //             selectedPeriod == year ? Colors.white : Colors.black,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(5),
            //           side: const BorderSide(color: Colors.grey),
            //         ),
            //       ),
            //       child: Text(year == 0 ? "6 M" : "$year Y"),
            //     );
            //   }).toList(),
            // ),
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
            const SizedBox(height: 50),
            AspectRatio(
              aspectRatio: 1.6,
              child: LineChart(
                LineChartData(
                  minY: 100,
                  maxY: 350,
                  backgroundColor: Colors.white,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 50,
                    verticalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 0.7,
                      // dashArray: [5, 8],
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.transparent,
                      strokeWidth: 1,
                      // dashArray: [5, 8],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 50,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              "${value.toInt()}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          String label;
                          if (selectedPeriod == 0) {
                            label =
                                "${(value * 1.5).toInt()}M"; // Approx months
                          } else {
                            label = value.toInt().toString();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            "Year ${spot.x.toInt()}: ${spot.y.toStringAsFixed(1)}",
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                    touchCallback: (event, response) {},
                    getTouchedSpotIndicator: (barData, spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          FlLine(color: Colors.teal, strokeWidth: 3),
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) =>
                                FlDotCirclePainter(
                              radius: 6,
                              color: Colors.white,
                              strokeWidth: 3,
                              strokeColor: Colors.teal,
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.0,
                      color: Colors.teal,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.transparent,
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.withOpacity(0.4),
                            Colors.teal.withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Select Investment Amount (SAR)",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Slider(
                  min: 10000,
                  max: 1000000,
                  value: investmentAmount,
                  onChanged: (value) =>
                      setState(() => investmentAmount = value),
                  activeColor: Colors.teal,
                  inactiveColor: Colors.grey.shade300,
                ),
                // Min & Max Labels Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("10K", style: TextStyle(fontSize: 13)),
                    Text("1 M", style: TextStyle(fontSize: 13)),
                  ],
                ),
                // Amount Display
                Align(
                  alignment: Alignment.centerRight,
                  child: SarAmountWidget(
                    alignment: Alignment.centerRight,
                    height: 15,
                    text: "Amount:${investmentAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text("Gold Investment Returns",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Pie Chart
                CircularPercentIndicator(
                  radius: 70,
                  lineWidth: 10,
                  percent: investmentAmount / totalReturns,
                  // Clamp to avoid overflow
                  backgroundColor: Colors.grey.shade300,
                  progressColor: Colors.teal,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Total Return",
                          style: TextStyle(fontSize: 12)),
                      Center(
                        child: SarAmountWidget(
                          alignment: Alignment.center,
                          height: 12,
                          text: totalReturns.toStringAsFixed(2),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),

                // Legends
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendItem(
                        color: Colors.teal,
                        title: "Investment Amount",
                        value: investmentAmount.toStringAsFixed(2),
                      ),
                      const SizedBox(height: 10),
                      _legendItem(
                        color: Colors.grey,
                        title: "Profit Earned",
                        value: "₦${profit.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowItem(String title, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text("₨${value.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

Widget _legendItem(
    {required Color color, required String title, required String value}) {
  return Row(
    children: [
      Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 2),
          SarAmountWidget(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              height: 12),
        ],
      ),
    ],
  );
}
