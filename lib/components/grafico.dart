import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../model/transaction.dart';
import 'package:intl/intl.dart';
import 'barra_grafico.dart';

class Grafico extends StatelessWidget {
  final List<Transacao> TransacoesRecentes;

  Grafico(this.TransacoesRecentes);

  List<Map<String, Object>> get TransacoesAgrupadas {
    return List.generate(7, (index) {
      final diaDaSemana = DateTime.now().subtract(Duration(days: index));

      double somaTotal = 0.0;

      for (var i = 0; i < TransacoesRecentes.length; i++) {
        bool mesmoDia = TransacoesRecentes[i].data.day == diaDaSemana.day;
        bool mesmoMes = TransacoesRecentes[i].data.month == diaDaSemana.month;
        bool mesmoAno = TransacoesRecentes[i].data.year == diaDaSemana.year;

        if (mesmoDia && mesmoMes && mesmoAno) {
          somaTotal += TransacoesRecentes[i].valor;
        }
      }

      return {
        'day': DateFormat.E().format(diaDaSemana)[0],
        'value': somaTotal,
      };
    }).reversed.toList();
  }

  double get _valorTotalSemana {
    return TransacoesAgrupadas.fold(0.0, (somaSum, transac) {
      return somaSum + (transac['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: TransacoesAgrupadas.map((transac) {
            return Flexible(
              fit: FlexFit.tight,
              child: BarraGrafico(
                  label: transac['day'].toString(),
                  value: transac['value'] as double,
                  percentage: _valorTotalSemana == 0
                      ? 0
                      : (transac['value'] as double) / _valorTotalSemana),
            );
          }).toList(),
        ),
      ),
    );
  }
}
