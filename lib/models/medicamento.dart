import 'package:isar/isar.dart';

part 'medicamento.g.dart';

@collection
class Medicamento {
  Id id = Isar.autoIncrement;

  final String medicamento;
  final String hora;
  final String utente;

  final bool permanente;

  final DateTime? dataInicio;
  final DateTime? dataFim;

  final List<int> diasSemana;

  Medicamento({
    required this.medicamento,
    required this.hora,
    required this.utente,
    required this.permanente,
    this.dataInicio,
    this.dataFim,
    required this.diasSemana,
  });
}
