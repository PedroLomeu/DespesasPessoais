import 'dart:io';
import 'package:despesas/components/grafico.dart';
import 'package:despesas/components/transaction_form.dart';
import 'package:despesas/components/transaction_list.dart';
import 'package:despesas/model/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

main() {
  runApp(const DespesasApp());
}

class DespesasApp extends StatelessWidget {
  const DespesasApp({super.key});

  //expensesApp

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: const MinhaPaginaInicial(),
      theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
            primary: Colors.deepPurple,
            secondary: Colors.amber,
          ),
          textTheme: tema.textTheme.copyWith(
            titleLarge: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ))),
    );
  }
}

class MinhaPaginaInicial extends StatefulWidget {
  const MinhaPaginaInicial({super.key});

  @override
  State<MinhaPaginaInicial> createState() => _MinhaPaginaInicialState();
}

class _MinhaPaginaInicialState extends State<MinhaPaginaInicial> {
  final List<Transacao> _transacoes = [];
  bool _exibirGrafico = false;

  List<Transacao> get _transacoesRecentes {
    return _transacoes.where((transac) {
      return transac.data.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _adicionarTransacao(String titulo, double valor, DateTime data) {
    final novaTransacao = Transacao(
      id: titulo.hashCode.toString() +
          valor.hashCode.toString() +
          data.hashCode.toString(),
      titulo: titulo,
      valor: valor,
      data: data,
    );

    setState(() {
      _transacoes.add(novaTransacao);
    });

    Navigator.of(context).pop();
  }

  _excluirTransacao(String id) {
    setState(() {
      _transacoes.removeWhere((transac) => transac.id == id);
    });
  }

  _abrirModalFormularioTransacao(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return FormalurioDeTransacao(_adicionarTransacao);
        });
  }

  String simboloMoeda = '€';

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(
            icon: Icon(icon),
            onPressed: fn,
          );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final iconList =
        Platform.isIOS ? CupertinoIcons.chart_bar_square_fill : Icons.list;
    final chartList =
        Platform.isIOS ? CupertinoIcons.chart_bar_square_fill : Icons.pie_chart;

    final actions = [
      if (isLandscape)
        _getIconButton(
          _exibirGrafico ? iconList : chartList,
          () {
            setState(() {
              _exibirGrafico = !_exibirGrafico;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _abrirModalFormularioTransacao(context),
      ),
    ];

    final PreferredSizeWidget appBar = AppBar(
      title: const Text(
        'Despesas Pessoais',
      ),
      actions: actions,
      backgroundColor: const Color.fromARGB(255, 122, 81, 197),
    );
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandscape)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text('Exibir Grafico'),
              //     Switch.adaptive(
              //       activeColor: Theme.of(context).primaryColor,
              //       value: _exibirGrafico, onChanged: (value){  // o ".adaptive" muda entre ios android
              //       setState(() {
              //         _exibirGrafico = value;
              //       });
              //     },),
              //   ],
              // ),
              if (_exibirGrafico || !isLandscape)
                SizedBox(           // ERA CONTAINER  ERA CONTAINER ERA CONTAINER 
                  height: availableHeight * (isLandscape ? 0.6 : 0.23),
                  child: Grafico(_transacoesRecentes),
                ),
            if (!_exibirGrafico || !isLandscape)
              SizedBox(                 // ERA CONTAINER ERA CONTAINER ERA CONTAINER 
                height: availableHeight * (isLandscape ? 0.9 : 0.65),
                child: ListaDeTransacao(_transacoes, _excluirTransacao),
              ),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Despesas Pessoais'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    // Platform.isSISTEMAOPERACIONAL
                    child: const Icon(Icons.add),
                    // backgroundColor: Colors.deepPurple,
                    onPressed: () => _abrirModalFormularioTransacao(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
