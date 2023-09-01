
class Transacao {       // crie a classe e defina os atributos,
  final String id;
  final String titulo;
  final double valor;
  final DateTime data;

  Transacao({        // depois crie o construtor e defina os atributos requeridos
    required this.id,
    required this.titulo,
    required this.valor,
    required this.data,
  });
}