import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/core/widgets/sar_amount_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
          children: [
            const Text("Growth Calculator",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text(
              "Check how much your past gold investment would be worth today. Select the investment amount and time period to calculate your total returns based on historical price trends.",
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: periods.map((year) {
                return ElevatedButton(
                  onPressed: () => setState(() => selectedPeriod = year),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                        selectedPeriod == year ? Colors.teal : Colors.white,
                    foregroundColor:
                        selectedPeriod == year ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(year == 0 ? "6 M" : "$year Y"),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.6,
              child: LineChart(
                LineChartData(
                  minY: 100,
                  maxY: 370,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 50,
                        reservedSize: 35,
                        getTitlesWidget: (value, _) => Text("${value.toInt()}",
                            style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.black,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                      spots: spots,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Investment Amount (SAR)",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // Min & Max Labels Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("10K", style: TextStyle(fontSize: 13)),
                    Text("1 M", style: TextStyle(fontSize: 13)),
                  ],
                ),

                // Full-width slider
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 10000,
                        max: 1000000,
                        divisions: 100,
                        value: investmentAmount,
                        onChanged: (value) =>
                            setState(() => investmentAmount = value),
                        activeColor: Colors.teal,
                        inactiveColor: Colors.grey.shade300,
                      ),
                    ),
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
            const SizedBox(height: 24),
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
                          text: "${totalReturns.toStringAsFixed(2)}",
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
                        value: "${investmentAmount.toStringAsFixed(2)}",
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
