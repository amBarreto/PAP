import 'package:isar/isar.dart';

part 'medicamento.g.dart';

@collection
class Medicamento {
  Id id = Isar.autoIncrement;

  final String medicamento;
  final String hora;
  final String utente;
  final DateTime dataInicio;
  final DateTime dataFim;
  final List<int> diasSemana;

  Medicamento({
    required this.medicamento,
    required this.hora,
    required this.utente,
    required this.dataInicio,
    required this.dataFim,
    required this.diasSemana,
  });
}
