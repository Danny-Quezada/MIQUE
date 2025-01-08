import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/providers/book_provider.dart';
import 'package:mi_que/providers/user_provider.dart';
import 'package:mi_que/ui/utils/date_converter.dart';
import 'package:mi_que/ui/utils/setting_color.dart';
import 'package:mi_que/ui/widgets/amount_container_widget.dart';
import 'package:mi_que/ui/widgets/safe_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';

class DashboardPage extends StatelessWidget {
  CategoryAxis categoryAxis = CategoryAxis(
      majorGridLines: const MajorGridLines(width: 0),
      minorGridLines: const MinorGridLines(width: 0),
      axisLine: const AxisLine(width: 0));
  NumericAxis numericAxis = NumericAxis(isVisible: false);
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    return SafeScaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Resumen de Transacciones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<Iterable<TransactionModel>>(
        stream:
            bookProvider.readTransactionByUser(userProvider.firebaseUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error al cargar el dashboard."),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonView();
          }
          if (snapshot.hasData) {
            final transactions = snapshot.data!.toList();

            final incomes = transactions
                .where((x) => x.amount > 0)
                .fold<double>(0.0, (sum, element) => sum + element.amount);

            final expenses = transactions
                .where((x) => x.amount < 0)
                .fold<double>(0.0, (sum, element) => sum + element.amount);

            return transactions.length == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/add.png",
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        Text("Agrega transacciones para poder ver resumen")
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AmountContainerWidget(
                            amount: incomes + expenses,
                            title: "Balance neto total",
                            color: (incomes + expenses) < 0
                                ? SettingColor.redColor
                                : SettingColor.greenColor),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildIncomeExpenseChart(incomes, expenses.abs()),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildFutureProjectionLineChart(transactions),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildMonthlyLineChart(transactions),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildDailyExpenseChart(transactions),
                      ],
                    ),
                  );
          }

          return Container();
        },
      ),
    );
  }

  ChartTitle _chartTitle(String title) {
    return ChartTitle(
        text: title,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        alignment: ChartAlignment.near);
  }

  // Gráfico de barras: Ingresos vs Gastos
  Widget _buildIncomeExpenseChart(double incomes, double expenses) {
    final data = [
      ChartData('Ingresos', incomes, color: SettingColor.greenColor),
      ChartData('Gastos', expenses, color: SettingColor.redColor),
    ];

    return SfCartesianChart(
      margin: EdgeInsets.zero,
      primaryXAxis: categoryAxis,
      primaryYAxis: numericAxis,
      borderWidth: 0,
      plotAreaBorderWidth: 0,
      title: _chartTitle("Ingresos vs Gastos"),
      series: <CartesianSeries>[
        ColumnSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          pointColorMapper: (ChartData data, _) => data.color,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildMonthlyLineChart(List<TransactionModel> transactions) {
    final Map<String, double> monthlyTotals = {};

    // Agrupar transacciones por mes y año
    for (var tx in transactions) {
      final date = DateConverter.parseDate(tx.date);
      final monthYear = '${date.month}-${date.year}';
      monthlyTotals.update(
        monthYear,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }

    // Generar lista de ChartData y mapear con DateTime para ordenarlo
    final List<MapEntry<ChartData, DateTime>> chartDataWithDate =
        monthlyTotals.entries.map((entry) {
      final parts = entry.key.split('-');
      final month = int.parse(parts[0]);
      final year = int.parse(parts[1]);
      final date = DateTime(year, month);

      return MapEntry(
        ChartData('${parts[0]}/${parts[1]}', entry.value),
        date,
      );
    }).toList();

    // Ordenar por DateTime
    chartDataWithDate.sort((a, b) => a.value.compareTo(b.value));

    // Extraer solo los datos de ChartData después de ordenar
    final List<ChartData> chartData =
        chartDataWithDate.map((entry) => entry.key).toList();

    return SfCartesianChart(
      margin: EdgeInsets.zero,
      primaryXAxis: categoryAxis,
      primaryYAxis: numericAxis,
      borderWidth: 0,
      plotAreaBorderWidth: 0,
      title: _chartTitle('Evolución Mensual'),
      series: <LineSeries<ChartData, String>>[
        LineSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          pointColorMapper: (ChartData data, _) =>
              data.isPrediction == true ? Colors.orange : Colors.blue,
        ),
      ],
    );
  }

  Widget _buildFutureProjectionLineChart(List<TransactionModel> transactions) {
    final Map<String, double> monthlyTotals = {};

    // Agrupar transacciones por mes y calcular totales
    for (var tx in transactions) {
      final date = DateConverter.parseDate(tx.date);
      final monthYear = '${date.month}-${date.year}';
      monthlyTotals.update(
        monthYear,
        (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }

    // Ordenar las fechas por orden cronológico
    final sortedKeys = monthlyTotals.keys.toList()
      ..sort((a, b) {
        final aParts = a.split('-');
        final bParts = b.split('-');
        final aDate = DateTime(int.parse(aParts[1]), int.parse(aParts[0]));
        final bDate = DateTime(int.parse(bParts[1]), int.parse(bParts[0]));
        return aDate.compareTo(bDate);
      });

    final chartData = <ChartData>[];
    double total = 0;
    int count = 0;

    // Agregar datos al gráfico
    for (var key in sortedKeys) {
      chartData.add(ChartData(key, monthlyTotals[key]!));
      total += monthlyTotals[key]!;
      count++;
    }

    // Calcular el promedio de ingresos/gastos por mes
    final double average = count > 0 ? total / count : 0;

    // Predecir el próximo mes
    if (sortedKeys.isNotEmpty) {
      final lastDateParts = sortedKeys.last.split('-');
      final lastMonth = int.parse(lastDateParts[0]);
      final lastYear = int.parse(lastDateParts[1]);

      final nextMonthDate = DateTime(
        lastMonth == 12 ? lastYear + 1 : lastYear,
        lastMonth == 12 ? 1 : lastMonth + 1,
      );

      final nextMonthKey = '${nextMonthDate.month}-${nextMonthDate.year}';
      chartData.add(ChartData(nextMonthKey, average, isPrediction: true));
    }

    return SfCartesianChart(
      margin: EdgeInsets.zero,
      primaryXAxis: categoryAxis,
      primaryYAxis: numericAxis,
      borderWidth: 0,
      plotAreaBorderWidth: 0,
      title: _chartTitle('Proyección de Ingresos/Gastos'),
      series: <LineSeries<ChartData, String>>[
        LineSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          pointColorMapper: (ChartData data, _) => data.isPrediction == true
              ? data.value < 0
                  ? SettingColor.redColor
                  : SettingColor.greenColor
              : Colors.blue,
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
          ),
        ),
      ],
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: Text(
            'Estimación: \$${average.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          coordinateUnit: CoordinateUnit.point,
          x: chartData.last.category,
          y: chartData.last.value,
        ),
      ],
    );
  }

  Widget _buildDailyExpenseChart(List<TransactionModel> transactions) {
    final today = DateTime.now();
    final currentMonthTransactions = transactions
        .where((tx) => DateConverter.parseDate(tx.date).month == today.month)
        .toList();

    final Map<int, double> dailyTotals = {};

    for (var tx in currentMonthTransactions) {
      final date = DateConverter.parseDate(tx.date);
      dailyTotals.update(date.day, (value) => value + tx.amount,
          ifAbsent: () => tx.amount);
    }

    final chartData = dailyTotals.entries
        .map((entry) => ChartData(entry.key.toString(), entry.value))
        .toList();

    return SfCartesianChart(
      margin: EdgeInsets.zero,
      primaryXAxis: CategoryAxis(),
      primaryYAxis: numericAxis,
      title: _chartTitle('Gastos Diarios'),
      series: <LineSeries<ChartData, String>>[
        LineSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final double value;
  final Color? color;
  bool? isPrediction;
  ChartData(this.category, this.value, {this.color, this.isPrediction});
}

class SkeletonView extends StatelessWidget {
  const SkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(height: 100, width: double.infinity),
          ),
          SkeletonParagraph(
            style: const SkeletonParagraphStyle(lines: 1),
          ),
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(height: 300, width: double.infinity),
          ),
          SkeletonParagraph(
            style: const SkeletonParagraphStyle(lines: 1),
          ),
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(height: 300, width: double.infinity),
          )
        ],
      ),
    ));
  }
}
