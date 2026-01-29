import 'package:isar/isar.dart';

part 'consultas.g.dart';

@collection
class Consulta {
  Id id = Isar.autoIncrement;

  final String utente;
  final String medico;
  final String especialidade;
  final String local;
  final String? observacoes;

  final DateTime dataHora;

  final bool notificar1DiaAntes;
  final bool notificar1HoraAntes;

  Consulta({
    required this.utente,
    required this.medico,
    required this.especialidade,
    required this.local,
    this.observacoes,
    required this.dataHora,
    this.notificar1DiaAntes = true,
    this.notificar1HoraAntes = true,
  });
}