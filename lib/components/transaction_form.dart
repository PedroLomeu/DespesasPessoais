import 'package:flutter/material.dart';
import './adaptative_button.dart';
import './adaptative_text_field.dart';
import './adaptative_date_picker.dart';

class FormalurioDeTransacao extends StatefulWidget {
  final void Function(String, double, DateTime) quandoEnviado;

  const FormalurioDeTransacao(this.quandoEnviado, {super.key});

  @override
  State<FormalurioDeTransacao> createState() => _FormalurioDeTransacaoState();
}

class _FormalurioDeTransacaoState extends State<FormalurioDeTransacao> {
  final controladorTitulo = TextEditingController();
  final controladorValor = TextEditingController();

  DateTime _dataSelecionada = DateTime.now();

  _enviarFormulario() {
    final titulo = controladorTitulo.text;
    final valor = double.tryParse(controladorValor.text) ?? 0.0;

    if (titulo.isEmpty || valor <= 0 || _dataSelecionada == null) {
      // ''|| = OU''
      return;
    }
    widget.quandoEnviado(titulo, valor, _dataSelecionada);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 5 + MediaQuery.of(context).viewInsets.bottom,
            left: 5,
            right: 5,
            top: 5,
          ),
          child: Column(
            children: [
              AdaptativeTextField(
                controller: controladorTitulo,
                onSubmitted: (_) => _enviarFormulario(),
                label: 'Insira Transacao',
              ),
              AdaptativeTextField(
                controller: controladorValor,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _enviarFormulario(),
                label: 'Valor (€)',
              ),
              AdaptativeDatePicker(
                  selectedDate: _dataSelecionada,
                  onDateChanged: (newDate) {
                    setState(() {
                      _dataSelecionada = newDate;
                    });
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BotaoAdaptativo(
                      label: 'Nova Transacao', onPressed: _enviarFormulario)
                  // ElevatedButton(
                  //   style:
                  //       TextButton.styleFrom(foregroundColor: Colors.white),
                  //   onPressed: _enviarFormulario,
                  //   child: Text('Nova Transacao',),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
