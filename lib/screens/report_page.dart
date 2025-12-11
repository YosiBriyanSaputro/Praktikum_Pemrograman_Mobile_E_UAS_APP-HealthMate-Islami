import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// Helpers
import '../logic/report_range_helper.dart';

// Services
import '../services/exercise_report_service.dart';
import '../services/food_report_service.dart';
import '../services/water_report_service.dart';

// Models
import '../models/exercise_report_model.dart';
import '../models/food_report_model.dart';
import '../models/water_report_model.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final user = FirebaseAuth.instance.currentUser;

  ReportRange _range = ReportRange.week;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  // ---------------------------------------------------------------------------
  // 🌟 PREMIUM SUMMARY CARD
  // ---------------------------------------------------------------------------
  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(.15),
            color.withOpacity(.05),
          ],
        ),
        border: Border.all(color: color.withOpacity(.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon Glass Effect
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),

          // Title & Value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🌟 PREMIUM BAR CHART (Rounded + Shadow + Smooth UI)
  // ---------------------------------------------------------------------------
  Widget _barChart(List<double> values, List<String> dates, Color color) {
    final bars = <BarChartGroupData>[];

    for (int i = 0; i < values.length; i++) {
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: values[i],
              width: 20,
              color: color,
              borderRadius: BorderRadius.circular(12),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: values.reduce((a, b) => a > b ? a : b),
                color: color.withOpacity(.08),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: bars,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          // Axis Titles
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, meta) {
                  int i = v.toInt();
                  if (i < 0 || i >= dates.length) return const SizedBox();
                  final shortDate = DateFormat("MM/dd")
                      .format(DateTime.parse(dates[i]));
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(shortDate, style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🌟 REPORT WRAPPER (Card + Chart + List)
  // ---------------------------------------------------------------------------
  Widget _reportWrapper({
    required Widget summary,
    required Widget chart,
    required List<Widget> items,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            summary,
            const SizedBox(height: 14),

            // Chart Container Premium
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color:
                    Theme.of(context).cardColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: chart,
            ),

            const SizedBox(height: 14),

            // List Items
            ...items.map((e) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: e,
                ))
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EXERCISE REPORT
  // ---------------------------------------------------------------------------
  Widget _exerciseReport() {
    final uid = user!.uid;
    final dates = ReportRangeHelper.rangeDates(_range);

    return FutureBuilder<List<ExerciseReportModel>>(
      future: ExerciseReportService().getReport(uid: uid, dates: dates),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());

        final data = snap.data!;
        final values = data.map((e) => e.totalDuration.toDouble()).toList();
        final total = data.fold(0, (a, b) => a + b.totalDuration);

        return _reportWrapper(
          summary: _summaryCard("Total Durasi", "$total menit",
              Icons.fitness_center, Colors.teal),
          chart: _barChart(values, dates, Colors.teal),
          items: data
              .map((e) => ListTile(
                    title: Text("${e.totalDuration} menit"),
                    subtitle: Text(e.date),
                  ))
              .toList(),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // FOOD REPORT
  // ---------------------------------------------------------------------------
  Widget _foodReport() {
    final uid = user!.uid;
    final dates = ReportRangeHelper.rangeDates(_range);

    return FutureBuilder<List<FoodReportModel>>(
      future: FoodReportService().getReport(uid: uid, dates: dates),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());

        final data = snap.data!;
        final values = data.map((e) => e.totalCalories.toDouble()).toList();
        final total = data.fold(0, (a, b) => a + b.totalCalories);

        return _reportWrapper(
          summary: _summaryCard("Total Kalori", "$total kkal",
              Icons.fastfood, Colors.orange),
          chart: _barChart(values, dates, Colors.orange),
          items: data
              .map((e) => ListTile(
                    title: Text("${e.totalCalories} kkal"),
                    subtitle: Text(e.date),
                  ))
              .toList(),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // WATER REPORT
  // ---------------------------------------------------------------------------
  Widget _waterReport() {
    final uid = user!.uid;
    final dates = ReportRangeHelper.rangeDates(_range);

    return FutureBuilder<List<WaterReportModel>>(
      future: WaterReportService().getReport(uid: uid, dates: dates),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());

        final data = snap.data!;
        final values = data.map((e) => e.cups.toDouble()).toList();
        final total = data.fold(0, (a, b) => a + b.cups);

        return _reportWrapper(
          summary: _summaryCard("Total Gelas", "$total gelas",
              Icons.water_drop, Colors.blue),
          chart: _barChart(values, dates, Colors.blue),
          items: data
              .map((e) => ListTile(
                    title: Text("${e.cups} gelas"),
                    subtitle: Text(e.date),
                  ))
              .toList(),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER (Dropdown)
  // ---------------------------------------------------------------------------
  Widget _filterDropdown() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: DropdownButton<ReportRange>(
        value: _range,
        isExpanded: true,
        borderRadius: BorderRadius.circular(14),
        items: const [
          DropdownMenuItem(value: ReportRange.today, child: Text("Hari ini")),
          DropdownMenuItem(value: ReportRange.week, child: Text("7 hari")),
          DropdownMenuItem(value: ReportRange.twoWeeks, child: Text("14 hari")),
        ],
        onChanged: (v) => setState(() => _range = v!),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Kesehatan"),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: Colors.teal,
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center), text: "Exercise"),
            Tab(icon: Icon(Icons.fastfood), text: "Food"),
            Tab(icon: Icon(Icons.water_drop), text: "Water"),
          ],
        ),
      ),

      body: Column(
        children: [
          _filterDropdown(),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _exerciseReport(),
                _foodReport(),
                _waterReport(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
