import 'package:despesas/model/transaction.dart';
import 'package:flutter/material.dart';
import './transaction_item.dart';

class ListaDeTransacao extends StatelessWidget {
  final List<Transacao> transacoes;
  final void Function(String) quandoRemover;

  const ListaDeTransacao(this.transacoes, this.quandoRemover, {super.key});

  @override
  Widget build(BuildContext context) {
    return transacoes.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  SizedBox(
                    // ERA CONTAINER ERA CONTAINER ERA CONTAINER
                    height: constraints.maxHeight * 0.3,
                    child: Text(
                      'Nenhuma transacao cadastrada!',
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  SizedBox(
                    // ERA CONTAINER ERA CONTAINER ERA CONTAINER
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transacoes.length,
            itemBuilder: ((ctx, index) {
              final transac = transacoes[index];
              return TransactionItem(
                transac: transac,
                quandoRemover: quandoRemover,
              );
            }),
          );
  }
}
