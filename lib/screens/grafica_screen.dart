import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class GraficaScreen extends StatelessWidget {
  final String mensaje;

  const GraficaScreen({Key? key, required this.mensaje}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Budget> data = extractDataFromMessage(mensaje);

    double totalBudget =
        data.fold(0, (sum, budget) => sum + budget.amount);

    final series = [
      charts.Series(
        id: 'Budget',
        data: data,
        domainFn: (Budget budget, _) => budget.category,
        measureFn: (Budget budget, _) => budget.amount,
        labelAccessorFn: (Budget budget, _) => '€${budget.amount}',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        insideLabelStyleAccessorFn: (_, __) => charts.TextStyleSpec(
          color: charts.MaterialPalette.white,
          fontSize: 14,
        ),
      ),
    ];

    final chart = charts.BarChart(
      series,
      animate: true,
      vertical: false,
      behaviors: [
        charts.ChartTitle('Presupuesto estimado:',
            subTitle: 'Presupuesto total: €$totalBudget',
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection) {
              final selectedDatum = model.selectedDatum.first;
              final category = selectedDatum.datum.category;
              final amount = selectedDatum.datum.amount;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Categoría: $category\nCantidad: €$amount'),
                ),
              );
            }
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Gestión de presupuesto'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: chart,
      ),
    );
  }

  List<Budget> extractDataFromMessage(String message) {
RegExp flightsRegExp = RegExp(r'Vuelos: (?:["€]?([\d.]+)|([\d.]+)["€]?|([\d.]+))');
RegExp accommodationRegExp = RegExp(r'Alojamiento: (?:["€]?([\d.]+)|([\d.]+)["€]?|([\d.]+))');
RegExp transportationRegExp = RegExp(r'Transporte: (?:["€]?([\d.]+)|([\d.]+)["€]?|([\d.]+))');
RegExp foodRegExp = RegExp(r'Comida: (?:["€]?([\d.]+)|([\d.]+)["€]?|([\d.]+))');
RegExp ticketsRegExp = RegExp(r'Entradas: (?:["€]?([\d.]+)|([\d.]+)["€]?|([\d.]+))');



    double flightsPrice =
        double.parse(flightsRegExp.firstMatch(message)?.group(1) ?? '0');
    double accommodationPrice =
        double.parse(accommodationRegExp.firstMatch(message)?.group(1) ?? '0');
    double transportationPrice =
        double.parse(transportationRegExp.firstMatch(message)?.group(1) ?? '0');
    double foodPrice = double.parse(foodRegExp.firstMatch(message)?.group(1) ?? '0');
    double ticketsPrice = double.parse(ticketsRegExp.firstMatch(message)?.group(1) ?? '0');

    return [
      Budget('Vuelos', flightsPrice),
      Budget('Alojamiento', accommodationPrice),
      Budget('Transporte', transportationPrice),
      Budget('Comida', foodPrice),
      Budget('Entradas', ticketsPrice),
    ];
  }
}

class Budget {
  final String category;
  final double amount;

  Budget(this.category, this.amount);
}
