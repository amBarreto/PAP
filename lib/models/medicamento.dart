import 'package:isar/isar.dart';

part 'medicamento.g.dart';

@Collection()
class Medicamento {
  Id id = Isar.autoIncrement;

  late String medicamento;
  late String hora;
  late String utente;
  late DateTime dataInicio;
  late DateTime dataFim;
  late List<int> diasSemana;

  Medicamento({
    required this.medicamento,
    required this.hora,
    required this.utente,
    required this.dataInicio,
    required this.dataFim,
    required this.diasSemana,
  });
}
