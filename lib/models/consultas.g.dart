// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultas.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetConsultaCollection on Isar {
  IsarCollection<Consulta> get consultas => this.collection();
}

const ConsultaSchema = CollectionSchema(
  name: r'Consulta',
  id: -4852547541681172471,
  properties: {
    r'dataHora': PropertySchema(
      id: 0,
      name: r'dataHora',
      type: IsarType.dateTime,
    ),
    r'especialidade': PropertySchema(
      id: 1,
      name: r'especialidade',
      type: IsarType.string,
    ),
    r'local': PropertySchema(
      id: 2,
      name: r'local',
      type: IsarType.string,
    ),
    r'medico': PropertySchema(
      id: 3,
      name: r'medico',
      type: IsarType.string,
    ),
    r'notificar1DiaAntes': PropertySchema(
      id: 4,
      name: r'notificar1DiaAntes',
      type: IsarType.bool,
    ),
    r'notificar1HoraAntes': PropertySchema(
      id: 5,
      name: r'notificar1HoraAntes',
      type: IsarType.bool,
    ),
    r'observacoes': PropertySchema(
      id: 6,
      name: r'observacoes',
      type: IsarType.string,
    ),
    r'utente': PropertySchema(
      id: 7,
      name: r'utente',
      type: IsarType.string,
    )
  },
  estimateSize: _consultaEstimateSize,
  serialize: _consultaSerialize,
  deserialize: _consultaDeserialize,
  deserializeProp: _consultaDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _consultaGetId,
  getLinks: _consultaGetLinks,
  attach: _consultaAttach,
  version: '3.1.0+1',
);

int _consultaEstimateSize(
  Consulta object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.especialidade.length * 3;
  bytesCount += 3 + object.local.length * 3;
  bytesCount += 3 + object.medico.length * 3;
  {
    final value = object.observacoes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.utente.length * 3;
  return bytesCount;
}

void _consultaSerialize(
  Consulta object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dataHora);
  writer.writeString(offsets[1], object.especialidade);
  writer.writeString(offsets[2], object.local);
  writer.writeString(offsets[3], object.medico);
  writer.writeBool(offsets[4], object.notificar1DiaAntes);
  writer.writeBool(offsets[5], object.notificar1HoraAntes);
  writer.writeString(offsets[6], object.observacoes);
  writer.writeString(offsets[7], object.utente);
}

Consulta _consultaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Consulta(
    dataHora: reader.readDateTime(offsets[0]),
    especialidade: reader.readString(offsets[1]),
    local: reader.readString(offsets[2]),
    medico: reader.readString(offsets[3]),
    notificar1DiaAntes: reader.readBoolOrNull(offsets[4]) ?? true,
    notificar1HoraAntes: reader.readBoolOrNull(offsets[5]) ?? true,
    observacoes: reader.readStringOrNull(offsets[6]),
    utente: reader.readString(offsets[7]),
  );
  object.id = id;
  return object;
}

P _consultaDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _consultaGetId(Consulta object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _consultaGetLinks(Consulta object) {
  return [];
}

void _consultaAttach(IsarCollection<dynamic> col, Id id, Consulta object) {
  object.id = id;
}

extension ConsultaQueryWhereSort on QueryBuilder<Consulta, Consulta, QWhere> {
  QueryBuilder<Consulta, Consulta, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ConsultaQueryWhere on QueryBuilder<Consulta, Consulta, QWhereClause> {
  QueryBuilder<Consulta, Consulta, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ConsultaQueryFilter
    on QueryBuilder<Consulta, Consulta, QFilterCondition> {
  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> dataHoraEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataHora',
        value: value,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> dataHoraGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataHora',
        value: value,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> dataHoraLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataHora',
        value: value,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> dataHoraBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataHora',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> especialidadeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'especialidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      especialidadeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'especialidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> especialidadeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'especialidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> especialidadeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'especialidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      especialidadeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'especialidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> especialidadeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'especialidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> especialidadeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'especialidade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> especialidadeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'especialidade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      especialidadeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'especialidade',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      especialidadeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'especialidade',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'local',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'local',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'local',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'local',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> localIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'local',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medico',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medico',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medico',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medico',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medico',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medico',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medico',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medico',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medico',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> medicoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medico',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      notificar1DiaAntesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificar1DiaAntes',
        value: value,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      notificar1HoraAntesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificar1HoraAntes',
        value: value,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'observacoes',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      observacoesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'observacoes',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      observacoesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observacoes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'observacoes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> observacoesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacoes',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition>
      observacoesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'observacoes',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'utente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'utente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'utente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'utente',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'utente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'utente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'utente',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'utente',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'utente',
        value: '',
      ));
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterFilterCondition> utenteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'utente',
        value: '',
      ));
    });
  }
}

extension ConsultaQueryObject
    on QueryBuilder<Consulta, Consulta, QFilterCondition> {}

extension ConsultaQueryLinks
    on QueryBuilder<Consulta, Consulta, QFilterCondition> {}

extension ConsultaQuerySortBy on QueryBuilder<Consulta, Consulta, QSortBy> {
  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByDataHora() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataHora', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByDataHoraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataHora', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByEspecialidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'especialidade', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByEspecialidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'especialidade', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'local', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'local', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByMedico() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medico', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByMedicoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medico', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByNotificar1DiaAntes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificar1DiaAntes', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy>
      sortByNotificar1DiaAntesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificar1DiaAntes', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByNotificar1HoraAntes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificar1HoraAntes', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy>
      sortByNotificar1HoraAntesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificar1HoraAntes', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByObservacoes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByObservacoesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByUtente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'utente', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> sortByUtenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'utente', Sort.desc);
    });
  }
}

extension ConsultaQuerySortThenBy
    on QueryBuilder<Consulta, Consulta, QSortThenBy> {
  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByDataHora() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataHora', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByDataHoraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataHora', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByEspecialidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'especialidade', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByEspecialidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'especialidade', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByLocal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'local', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByLocalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'local', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByMedico() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medico', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByMedicoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medico', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByNotificar1DiaAntes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificar1DiaAntes', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy>
      thenByNotificar1DiaAntesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificar1DiaAntes', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByNotificar1HoraAntes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificar1HoraAntes', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy>
      thenByNotificar1HoraAntesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificar1HoraAntes', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByObservacoes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByObservacoesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.desc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByUtente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'utente', Sort.asc);
    });
  }

  QueryBuilder<Consulta, Consulta, QAfterSortBy> thenByUtenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'utente', Sort.desc);
    });
  }
}

extension ConsultaQueryWhereDistinct
    on QueryBuilder<Consulta, Consulta, QDistinct> {
  QueryBuilder<Consulta, Consulta, QDistinct> distinctByDataHora() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataHora');
    });
  }

  QueryBuilder<Consulta, Consulta, QDistinct> distinctByEspecialidade(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'especialidade',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Consulta, Consulta, QDistinct> distinctByLocal(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'local', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Consulta, Consulta, QDistinct> distinctByMedico(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medico', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Consulta, Consulta, QDistinct> distinctByNotificar1DiaAntes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificar1DiaAntes');
    });
  }

  QueryBuilder<Consulta, Consulta, QDistinct> distinctByNotificar1HoraAntes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificar1HoraAntes');
    });
  }

  QueryBuilder<Consulta, Consulta, QDistinct> distinctByObservacoes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observacoes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Consulta, Consulta, QDistinct> distinctByUtente(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'utente', caseSensitive: caseSensitive);
    });
  }
}

extension ConsultaQueryProperty
    on QueryBuilder<Consulta, Consulta, QQueryProperty> {
  QueryBuilder<Consulta, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Consulta, DateTime, QQueryOperations> dataHoraProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataHora');
    });
  }

  QueryBuilder<Consulta, String, QQueryOperations> especialidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'especialidade');
    });
  }

  QueryBuilder<Consulta, String, QQueryOperations> localProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'local');
    });
  }

  QueryBuilder<Consulta, String, QQueryOperations> medicoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medico');
    });
  }

  QueryBuilder<Consulta, bool, QQueryOperations> notificar1DiaAntesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificar1DiaAntes');
    });
  }

  QueryBuilder<Consulta, bool, QQueryOperations> notificar1HoraAntesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificar1HoraAntes');
    });
  }

  QueryBuilder<Consulta, String?, QQueryOperations> observacoesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observacoes');
    });
  }

  QueryBuilder<Consulta, String, QQueryOperations> utenteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'utente');
    });
  }
}
