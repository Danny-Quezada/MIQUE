import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:mi_que/domain/entities/transaction_model.dart';
import 'package:mi_que/providers/book_provider.dart';
import 'package:mi_que/providers/user_provider.dart';
import 'package:mi_que/ui/utils/date_converter.dart';
import 'package:mi_que/ui/utils/setting_color.dart';
import 'package:mi_que/ui/widgets/ai_button.dart';
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
        elevation: 0,
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
          } else if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
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
                        const Text(
                            "Agrega transacciones para poder ver resumen")
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
                        _buildIncomeExpenseChart(
                            incomes, expenses.abs(), context),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildFutureProjectionLineChart(transactions, context),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildMonthlyLineChart(transactions, context),
                        const SizedBox(
                          height: 30,
                        ),
                        _buildDailyExpenseChart(transactions, context),
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
  Widget _buildIncomeExpenseChart(
      double incomes, double expenses, BuildContext context) {
    final data = [
      ChartData('Ingresos', incomes, color: SettingColor.greenColor),
      ChartData('Gastos', expenses, color: SettingColor.redColor),
    ];

    return GestureDetector(
      onTap: () async {
        await aiButton("""
**📊 Ingresos vs Gastos**

**🔹 Ingresos totales:** \$${incomes.toStringAsFixed(2)}  
**🔸 Gastos totales:** \$${expenses.toStringAsFixed(2)}

---

### 💡 **Consejos financieros para mejorar tu situación:**

1. **¿Cómo puedo aumentar mis ingresos de manera eficiente y sostenible?**
2. **¿Cuáles son los hábitos financieros que debo evitar para controlar mis gastos?**
3. **¿Qué pasos debo seguir para equilibrar de manera óptima mis ingresos y gastos?**
4. **💼 ¿Cómo puedo crear un plan de ahorro y crecimiento financiero a largo plazo?**

**¡Gracias por tu ayuda!** 🙏
""", context);
      },
      child: SfCartesianChart(
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
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              builder: (data, point, series, pointIndex, seriesIndex) => Text(
                "${data.value.toStringAsFixed(2)}",
                style: TextStyle(
                  color: data.category == 'Ingresos'
                      ? SettingColor.greenColor
                      : SettingColor.redColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyLineChart(
      List<TransactionModel> transactions, BuildContext context) {
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

    return GestureDetector(
      onTap: () async {
        // Construir el mapeo de datos en formato de tabla para la IA
        String mappedData = "📊 **Datos Mensuales**\n\n";
        mappedData += "| Mes/Año  | Total |\n";
        mappedData += "|----------|-------|\n";
        for (var entry in monthlyTotals.entries) {
          mappedData +=
              "| ${entry.key} | \$${entry.value.toStringAsFixed(2)} |\n";
        }

        await aiButton(
          """
Tengo una gráfica de evolución mensual basada en transacciones financieras.  

📊 **Datos:**  
Cada punto representa la suma de las transacciones de un mes específico.  
Los datos están ordenados cronológicamente para visualizar tendencias.  

🔹 **Aquí están los datos procesados:**  
$mappedData

❓ **Preguntas:**  
1️⃣ ¿Puedes analizar la tendencia de estos datos y ayudarme a identificar patrones en los ingresos/gastos mensuales?  
2️⃣ ¿Cómo podría mejorar la visualización de la gráfica para hacerla más clara y comprensible?  
3️⃣ ¿Qué tipo de predicciones podríamos hacer con esta información y qué técnicas recomendarías para ello?  
4️⃣ ¿Cómo puedo optimizar el rendimiento de este gráfico si manejo grandes volúmenes de datos?  
        """,
          context,
        );
      },
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
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
      ),
    );
  }

  Widget _buildFutureProjectionLineChart(
      List<TransactionModel> transactions, BuildContext context) {
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

    return GestureDetector(
      onTap: () async {
        await aiButton("""
📈 **Análisis de Proyección Financiera**  

Hemos analizado los ingresos y gastos mensuales y proyectado el balance futuro con base en los datos anteriores.  

📊 **Datos históricos registrados:**  
${chartData.sublist(0, chartData.length - 1).map((data) => "- ${data.category}: \$${data.value}").join("\n")}  

📉 **Promedio mensual estimado:** \$$average  
🔮 **Proyección para el próximo mes (${chartData.last.category}):** \$${chartData.last.value}  

🧐 **Instrucciones para el análisis:**  
- Evalúa la tendencia financiera observada en los datos.  
- Indica si la proyección sugiere estabilidad, mejora o riesgo financiero.  
- Proporciona consejos para optimizar el balance futuro, considerando patrones previos.  

🔍 **Concéntrate en ofrecer un análisis financiero claro y estrategias prácticas.**  
""", context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SfCartesianChart(
            margin: EdgeInsets.zero,
            primaryXAxis: CategoryAxis(),
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
                pointColorMapper: (ChartData data, _) =>
                    data.isPrediction == true
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
          ),
          Text.rich(TextSpan(children: [
            const TextSpan(text: "El circulo "),
            TextSpan(
                text: average < 0 ? "rojo " : "verde ",
                style: TextStyle(
                    color: average < 0
                        ? SettingColor.redColor
                        : SettingColor.greenColor)),
            TextSpan(
                text:
                    "indica un valor futuro de balance neto de ${DateConverter.monthNames[int.parse(chartData[chartData.length - 1].category.substring(0, 1)) - 1]}.")
          ]))
        ],
      ),
    );
  }

  Widget _buildDailyExpenseChart(
      List<TransactionModel> transactions, BuildContext context) {
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

    return GestureDetector(
      onTap: () async {
        await aiButton("""
📊 **Análisis del Balance Diario - ${DateConverter.monthNames[today.month - 1].toUpperCase()}**  

Este gráfico muestra el balance neto registrado por día en el mes actual.  

📅 **Datos del mes:**  
${chartData.map((data) => "- Día ${data.category}: \$${data.value}").join("\n")}  

📈 **Instrucciones para el análisis:**  
- Identifica patrones en el gasto diario.  
- Determina si hay días con gastos elevados y analiza posibles razones.  
- Sugiere estrategias para distribuir mejor los gastos y mejorar la estabilidad financiera diaria.  

🔍 **Concéntrate en proporcionar recomendaciones prácticas y accionables para la gestión del dinero a corto plazo.**  
""", context);
      },
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        primaryXAxis: CategoryAxis(),
        primaryYAxis: numericAxis,
        title: _chartTitle(
            'Balance neto por día de: ${DateConverter.monthNames[today.month - 1].toUpperCase()}'),
        series: <LineSeries<ChartData, String>>[
          LineSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
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
