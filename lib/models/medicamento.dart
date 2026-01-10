import 'package:isar/isar.dart';

part 'medicamento.g.dart';

@collection
class Medicamento {
  Id id = Isar.autoIncrement;

  final String medicamento;
  final String hora;
  final String utente;
  final String dosagem;

  final bool permanente;
  final bool recorrente;        // indica se é recorrente
  final int? intervaloHoras;    // intervalo em horas, se recorrente

  final DateTime? dataInicio;
  final DateTime? dataFim;

  final List<int> diasSemana;

  Medicamento({
    required this.medicamento,
    required this.hora,
    required this.utente,
    required this.dosagem,
    required this.permanente,
    this.recorrente = false,     // padrão a false
    this.intervaloHoras,         // opcional
    this.dataInicio,
    this.dataFim,
    required this.diasSemana,
  });
}
