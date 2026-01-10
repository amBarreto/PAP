// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicamento.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMedicamentoCollection on Isar {
  IsarCollection<Medicamento> get medicamentos => this.collection();
}

const MedicamentoSchema = CollectionSchema(
  name: r'Medicamento',
  id: 673612425840967858,
  properties: {
    r'dataFim': PropertySchema(
      id: 0,
      name: r'dataFim',
      type: IsarType.dateTime,
    ),
    r'dataInicio': PropertySchema(
      id: 1,
      name: r'dataInicio',
      type: IsarType.dateTime,
    ),
    r'diasSemana': PropertySchema(
      id: 2,
      name: r'diasSemana',
      type: IsarType.longList,
    ),
    r'dosagem': PropertySchema(
      id: 3,
      name: r'dosagem',
      type: IsarType.string,
    ),
    r'hora': PropertySchema(
      id: 4,
      name: r'hora',
      type: IsarType.string,
    ),
    r'intervaloHoras': PropertySchema(
      id: 5,
      name: r'intervaloHoras',
      type: IsarType.long,
    ),
    r'medicamento': PropertySchema(
      id: 6,
      name: r'medicamento',
      type: IsarType.string,
    ),
    r'permanente': PropertySchema(
      id: 7,
      name: r'permanente',
      type: IsarType.bool,
    ),
    r'recorrente': PropertySchema(
      id: 8,
      name: r'recorrente',
      type: IsarType.bool,
    ),
    r'utente': PropertySchema(
      id: 9,
      name: r'utente',
      type: IsarType.string,
    )
  },
  estimateSize: _medicamentoEstimateSize,
  serialize: _medicamentoSerialize,
  deserialize: _medicamentoDeserialize,
  deserializeProp: _medicamentoDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _medicamentoGetId,
  getLinks: _medicamentoGetLinks,
  attach: _medicamentoAttach,
  version: '3.1.0+1',
);

int _medicamentoEstimateSize(
  Medicamento object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.diasSemana.length * 8;
  bytesCount += 3 + object.dosagem.length * 3;
  bytesCount += 3 + object.hora.length * 3;
  bytesCount += 3 + object.medicamento.length * 3;
  bytesCount += 3 + object.utente.length * 3;
  return bytesCount;
}

void _medicamentoSerialize(
  Medicamento object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dataFim);
  writer.writeDateTime(offsets[1], object.dataInicio);
  writer.writeLongList(offsets[2], object.diasSemana);
  writer.writeString(offsets[3], object.dosagem);
  writer.writeString(offsets[4], object.hora);
  writer.writeLong(offsets[5], object.intervaloHoras);
  writer.writeString(offsets[6], object.medicamento);
  writer.writeBool(offsets[7], object.permanente);
  writer.writeBool(offsets[8], object.recorrente);
  writer.writeString(offsets[9], object.utente);
}

Medicamento _medicamentoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Medicamento(
    dataFim: reader.readDateTimeOrNull(offsets[0]),
    dataInicio: reader.readDateTimeOrNull(offsets[1]),
    diasSemana: reader.readLongList(offsets[2]) ?? [],
    dosagem: reader.readString(offsets[3]),
    hora: reader.readString(offsets[4]),
    intervaloHoras: reader.readLongOrNull(offsets[5]),
    medicamento: reader.readString(offsets[6]),
    permanente: reader.readBool(offsets[7]),
    recorrente: reader.readBoolOrNull(offsets[8]) ?? false,
    utente: reader.readString(offsets[9]),
  );
  object.id = id;
  return object;
}

P _medicamentoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _medicamentoGetId(Medicamento object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _medicamentoGetLinks(Medicamento object) {
  return [];
}

void _medicamentoAttach(
    IsarCollection<dynamic> col, Id id, Medicamento object) {
  object.id = id;
}

extension MedicamentoQueryWhereSort
    on QueryBuilder<Medicamento, Medicamento, QWhere> {
  QueryBuilder<Medicamento, Medicamento, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MedicamentoQueryWhere
    on QueryBuilder<Medicamento, Medicamento, QWhereClause> {
  QueryBuilder<Medicamento, Medicamento, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<Medicamento, Medicamento, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterWhereClause> idBetween(
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

extension MedicamentoQueryFilter
    on QueryBuilder<Medicamento, Medicamento, QFilterCondition> {
  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataFimIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataFim',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataFimIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataFim',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dataFimEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataFim',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataFimGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataFim',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dataFimLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataFim',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dataFimBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataFim',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataInicioIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataInicio',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataInicioIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataInicio',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataInicioEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataInicio',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataInicioGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataInicio',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataInicioLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataInicio',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dataInicioBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataInicio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diasSemana',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'diasSemana',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'diasSemana',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'diasSemana',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diasSemana',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diasSemana',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diasSemana',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diasSemana',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diasSemana',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      diasSemanaLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'diasSemana',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dosagemEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosagem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dosagemGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dosagem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dosagemLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dosagem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dosagemBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dosagem',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dosagemStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dosagem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dosagemEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dosagem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dosagemContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dosagem',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> dosagemMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dosagem',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dosagemIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dosagem',
        value: '',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      dosagemIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dosagem',
        value: '',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hora',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hora',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hora',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hora',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hora',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hora',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hora',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hora',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> horaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hora',
        value: '',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      horaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hora',
        value: '',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      intervaloHorasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intervaloHoras',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      intervaloHorasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intervaloHoras',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      intervaloHorasEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervaloHoras',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      intervaloHorasGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervaloHoras',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      intervaloHorasLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervaloHoras',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      intervaloHorasBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervaloHoras',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicamento',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medicamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medicamento',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicamento',
        value: '',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      medicamentoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medicamento',
        value: '',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      permanenteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'permanente',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      recorrenteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recorrente',
        value: value,
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> utenteEqualTo(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      utenteGreaterThan(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> utenteLessThan(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> utenteBetween(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      utenteStartsWith(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> utenteEndsWith(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> utenteContains(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition> utenteMatches(
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

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      utenteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'utente',
        value: '',
      ));
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterFilterCondition>
      utenteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'utente',
        value: '',
      ));
    });
  }
}

extension MedicamentoQueryObject
    on QueryBuilder<Medicamento, Medicamento, QFilterCondition> {}

extension MedicamentoQueryLinks
    on QueryBuilder<Medicamento, Medicamento, QFilterCondition> {}

extension MedicamentoQuerySortBy
    on QueryBuilder<Medicamento, Medicamento, QSortBy> {
  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByDataFim() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataFim', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByDataFimDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataFim', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByDataInicio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataInicio', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByDataInicioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataInicio', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByDosagem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosagem', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByDosagemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosagem', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByHora() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hora', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByHoraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hora', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByIntervaloHoras() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervaloHoras', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy>
      sortByIntervaloHorasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervaloHoras', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByMedicamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicamento', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByMedicamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicamento', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByPermanente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permanente', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByPermanenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permanente', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByRecorrente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recorrente', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByRecorrenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recorrente', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByUtente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'utente', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> sortByUtenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'utente', Sort.desc);
    });
  }
}

extension MedicamentoQuerySortThenBy
    on QueryBuilder<Medicamento, Medicamento, QSortThenBy> {
  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByDataFim() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataFim', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByDataFimDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataFim', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByDataInicio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataInicio', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByDataInicioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataInicio', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByDosagem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosagem', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByDosagemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dosagem', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByHora() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hora', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByHoraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hora', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByIntervaloHoras() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervaloHoras', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy>
      thenByIntervaloHorasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervaloHoras', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByMedicamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicamento', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByMedicamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicamento', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByPermanente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permanente', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByPermanenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'permanente', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByRecorrente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recorrente', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByRecorrenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recorrente', Sort.desc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByUtente() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'utente', Sort.asc);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QAfterSortBy> thenByUtenteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'utente', Sort.desc);
    });
  }
}

extension MedicamentoQueryWhereDistinct
    on QueryBuilder<Medicamento, Medicamento, QDistinct> {
  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByDataFim() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataFim');
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByDataInicio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataInicio');
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByDiasSemana() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diasSemana');
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByDosagem(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dosagem', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByHora(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hora', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByIntervaloHoras() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervaloHoras');
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByMedicamento(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicamento', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByPermanente() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'permanente');
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByRecorrente() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recorrente');
    });
  }

  QueryBuilder<Medicamento, Medicamento, QDistinct> distinctByUtente(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'utente', caseSensitive: caseSensitive);
    });
  }
}

extension MedicamentoQueryProperty
    on QueryBuilder<Medicamento, Medicamento, QQueryProperty> {
  QueryBuilder<Medicamento, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Medicamento, DateTime?, QQueryOperations> dataFimProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataFim');
    });
  }

  QueryBuilder<Medicamento, DateTime?, QQueryOperations> dataInicioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataInicio');
    });
  }

  QueryBuilder<Medicamento, List<int>, QQueryOperations> diasSemanaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diasSemana');
    });
  }

  QueryBuilder<Medicamento, String, QQueryOperations> dosagemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dosagem');
    });
  }

  QueryBuilder<Medicamento, String, QQueryOperations> horaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hora');
    });
  }

  QueryBuilder<Medicamento, int?, QQueryOperations> intervaloHorasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervaloHoras');
    });
  }

  QueryBuilder<Medicamento, String, QQueryOperations> medicamentoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicamento');
    });
  }

  QueryBuilder<Medicamento, bool, QQueryOperations> permanenteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'permanente');
    });
  }

  QueryBuilder<Medicamento, bool, QQueryOperations> recorrenteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recorrente');
    });
  }

  QueryBuilder<Medicamento, String, QQueryOperations> utenteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'utente');
    });
  }
}
