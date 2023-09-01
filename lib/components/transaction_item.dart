import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:despesas/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transac,
    required this.quandoRemover,
  });

  final Transacao transac;
  final void Function(String p1) quandoRemover;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: FittedBox(
              child: Text(
                '€${transac.valor.toStringAsFixed(2)}',
              ),
            ),
          ),
        ),
        title: Text(
          transac.titulo,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat('d MMM y').format(transac.data),
          style: const TextStyle(
              color: Color.fromARGB(255, 78, 78, 78),
              fontSize: 15),
        ),
        trailing: MediaQuery.of(context).size.width > 480 ?
        TextButton.icon(
          onPressed: ()=> quandoRemover(transac.id),
           icon: const Icon(Icons.delete),
           style: TextButton.styleFrom(foregroundColor: Colors.red),
            label: const Text('Excluir',
            style: TextStyle(color: Colors.red)),
            )
            : IconButton(
          onPressed: () async {
            if (await confirm(
              context,
              content: const Text(
                "Realmente deseja remover?",
              ),
            )) {
              quandoRemover(transac.id);
            }
          },
          icon: const Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}
