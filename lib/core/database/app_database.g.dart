// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FilterRuleRowsTable extends FilterRuleRows
    with TableInfo<$FilterRuleRowsTable, FilterRuleRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilterRuleRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patternMeta = const VerificationMeta(
    'pattern',
  );
  @override
  late final GeneratedColumn<String> pattern = GeneratedColumn<String>(
    'pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    pattern,
    isEnabled,
    priority,
    description,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'filter_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<FilterRuleRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pattern')) {
      context.handle(
        _patternMeta,
        pattern.isAcceptableOrUnknown(data['pattern']!, _patternMeta),
      );
    } else if (isInserting) {
      context.missing(_patternMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FilterRuleRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FilterRuleRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FilterRuleRowsTable createAlias(String alias) {
    return $FilterRuleRowsTable(attachedDatabase, alias);
  }
}

class FilterRuleRecord extends DataClass
    implements Insertable<FilterRuleRecord> {
  final String id;
  final String name;
  final String pattern;
  final bool isEnabled;
  final int priority;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FilterRuleRecord({
    required this.id,
    required this.name,
    required this.pattern,
    required this.isEnabled,
    required this.priority,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['pattern'] = Variable<String>(pattern);
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FilterRuleRowsCompanion toCompanion(bool nullToAbsent) {
    return FilterRuleRowsCompanion(
      id: Value(id),
      name: Value(name),
      pattern: Value(pattern),
      isEnabled: Value(isEnabled),
      priority: Value(priority),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FilterRuleRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FilterRuleRecord(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pattern: serializer.fromJson<String>(json['pattern']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      priority: serializer.fromJson<int>(json['priority']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'pattern': serializer.toJson<String>(pattern),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'priority': serializer.toJson<int>(priority),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FilterRuleRecord copyWith({
    String? id,
    String? name,
    String? pattern,
    bool? isEnabled,
    int? priority,
    Value<String?> description = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FilterRuleRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    pattern: pattern ?? this.pattern,
    isEnabled: isEnabled ?? this.isEnabled,
    priority: priority ?? this.priority,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FilterRuleRecord copyWithCompanion(FilterRuleRowsCompanion data) {
    return FilterRuleRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      priority: data.priority.present ? data.priority.value : this.priority,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FilterRuleRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pattern: $pattern, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('priority: $priority, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    pattern,
    isEnabled,
    priority,
    description,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilterRuleRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.pattern == this.pattern &&
          other.isEnabled == this.isEnabled &&
          other.priority == this.priority &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FilterRuleRowsCompanion extends UpdateCompanion<FilterRuleRecord> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> pattern;
  final Value<bool> isEnabled;
  final Value<int> priority;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FilterRuleRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pattern = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.priority = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FilterRuleRowsCompanion.insert({
    required String id,
    required String name,
    required String pattern,
    this.isEnabled = const Value.absent(),
    this.priority = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       pattern = Value(pattern),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FilterRuleRecord> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? pattern,
    Expression<bool>? isEnabled,
    Expression<int>? priority,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pattern != null) 'pattern': pattern,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (priority != null) 'priority': priority,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FilterRuleRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? pattern,
    Value<bool>? isEnabled,
    Value<int>? priority,
    Value<String?>? description,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FilterRuleRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pattern: pattern ?? this.pattern,
      isEnabled: isEnabled ?? this.isEnabled,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(pattern.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilterRuleRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pattern: $pattern, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('priority: $priority, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WhitelistRowsTable extends WhitelistRows
    with TableInfo<$WhitelistRowsTable, WhitelistEntryRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WhitelistRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, phoneNumber, label, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'whitelist_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WhitelistEntryRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {phoneNumber},
  ];
  @override
  WhitelistEntryRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WhitelistEntryRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WhitelistRowsTable createAlias(String alias) {
    return $WhitelistRowsTable(attachedDatabase, alias);
  }
}

class WhitelistEntryRecord extends DataClass
    implements Insertable<WhitelistEntryRecord> {
  final String id;
  final String phoneNumber;
  final String label;
  final DateTime createdAt;
  const WhitelistEntryRecord({
    required this.id,
    required this.phoneNumber,
    required this.label,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WhitelistRowsCompanion toCompanion(bool nullToAbsent) {
    return WhitelistRowsCompanion(
      id: Value(id),
      phoneNumber: Value(phoneNumber),
      label: Value(label),
      createdAt: Value(createdAt),
    );
  }

  factory WhitelistEntryRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WhitelistEntryRecord(
      id: serializer.fromJson<String>(json['id']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WhitelistEntryRecord copyWith({
    String? id,
    String? phoneNumber,
    String? label,
    DateTime? createdAt,
  }) => WhitelistEntryRecord(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    label: label ?? this.label,
    createdAt: createdAt ?? this.createdAt,
  );
  WhitelistEntryRecord copyWithCompanion(WhitelistRowsCompanion data) {
    return WhitelistEntryRecord(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WhitelistEntryRecord(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phoneNumber, label, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhitelistEntryRecord &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.label == this.label &&
          other.createdAt == this.createdAt);
}

class WhitelistRowsCompanion extends UpdateCompanion<WhitelistEntryRecord> {
  final Value<String> id;
  final Value<String> phoneNumber;
  final Value<String> label;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WhitelistRowsCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WhitelistRowsCompanion.insert({
    required String id,
    required String phoneNumber,
    this.label = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phoneNumber = Value(phoneNumber),
       createdAt = Value(createdAt);
  static Insertable<WhitelistEntryRecord> custom({
    Expression<String>? id,
    Expression<String>? phoneNumber,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WhitelistRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? phoneNumber,
    Value<String>? label,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WhitelistRowsCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WhitelistRowsCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BlockedCallRowsTable extends BlockedCallRows
    with TableInfo<$BlockedCallRowsTable, BlockedCallRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockedCallRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationNameMeta = const VerificationMeta(
    'organizationName',
  );
  @override
  late final GeneratedColumn<String> organizationName = GeneratedColumn<String>(
    'organization_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ruleNameMeta = const VerificationMeta(
    'ruleName',
  );
  @override
  late final GeneratedColumn<String> ruleName = GeneratedColumn<String>(
    'rule_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _blockedAtMeta = const VerificationMeta(
    'blockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> blockedAt = GeneratedColumn<DateTime>(
    'blocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phoneNumber,
    organizationName,
    ruleId,
    ruleName,
    blockedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocked_calls';
  @override
  VerificationContext validateIntegrity(
    Insertable<BlockedCallRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('organization_name')) {
      context.handle(
        _organizationNameMeta,
        organizationName.isAcceptableOrUnknown(
          data['organization_name']!,
          _organizationNameMeta,
        ),
      );
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    }
    if (data.containsKey('rule_name')) {
      context.handle(
        _ruleNameMeta,
        ruleName.isAcceptableOrUnknown(data['rule_name']!, _ruleNameMeta),
      );
    }
    if (data.containsKey('blocked_at')) {
      context.handle(
        _blockedAtMeta,
        blockedAt.isAcceptableOrUnknown(data['blocked_at']!, _blockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_blockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockedCallRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockedCallRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      organizationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_name'],
      ),
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      ),
      ruleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_name'],
      ),
      blockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}blocked_at'],
      )!,
    );
  }

  @override
  $BlockedCallRowsTable createAlias(String alias) {
    return $BlockedCallRowsTable(attachedDatabase, alias);
  }
}

class BlockedCallRecord extends DataClass
    implements Insertable<BlockedCallRecord> {
  final String id;
  final String phoneNumber;
  final String? organizationName;
  final String? ruleId;
  final String? ruleName;
  final DateTime blockedAt;
  const BlockedCallRecord({
    required this.id,
    required this.phoneNumber,
    this.organizationName,
    this.ruleId,
    this.ruleName,
    required this.blockedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone_number'] = Variable<String>(phoneNumber);
    if (!nullToAbsent || organizationName != null) {
      map['organization_name'] = Variable<String>(organizationName);
    }
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<String>(ruleId);
    }
    if (!nullToAbsent || ruleName != null) {
      map['rule_name'] = Variable<String>(ruleName);
    }
    map['blocked_at'] = Variable<DateTime>(blockedAt);
    return map;
  }

  BlockedCallRowsCompanion toCompanion(bool nullToAbsent) {
    return BlockedCallRowsCompanion(
      id: Value(id),
      phoneNumber: Value(phoneNumber),
      organizationName: organizationName == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationName),
      ruleId: ruleId == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleId),
      ruleName: ruleName == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleName),
      blockedAt: Value(blockedAt),
    );
  }

  factory BlockedCallRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockedCallRecord(
      id: serializer.fromJson<String>(json['id']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      organizationName: serializer.fromJson<String?>(json['organizationName']),
      ruleId: serializer.fromJson<String?>(json['ruleId']),
      ruleName: serializer.fromJson<String?>(json['ruleName']),
      blockedAt: serializer.fromJson<DateTime>(json['blockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'organizationName': serializer.toJson<String?>(organizationName),
      'ruleId': serializer.toJson<String?>(ruleId),
      'ruleName': serializer.toJson<String?>(ruleName),
      'blockedAt': serializer.toJson<DateTime>(blockedAt),
    };
  }

  BlockedCallRecord copyWith({
    String? id,
    String? phoneNumber,
    Value<String?> organizationName = const Value.absent(),
    Value<String?> ruleId = const Value.absent(),
    Value<String?> ruleName = const Value.absent(),
    DateTime? blockedAt,
  }) => BlockedCallRecord(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    organizationName: organizationName.present
        ? organizationName.value
        : this.organizationName,
    ruleId: ruleId.present ? ruleId.value : this.ruleId,
    ruleName: ruleName.present ? ruleName.value : this.ruleName,
    blockedAt: blockedAt ?? this.blockedAt,
  );
  BlockedCallRecord copyWithCompanion(BlockedCallRowsCompanion data) {
    return BlockedCallRecord(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      organizationName: data.organizationName.present
          ? data.organizationName.value
          : this.organizationName,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      ruleName: data.ruleName.present ? data.ruleName.value : this.ruleName,
      blockedAt: data.blockedAt.present ? data.blockedAt.value : this.blockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockedCallRecord(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('organizationName: $organizationName, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleName: $ruleName, ')
          ..write('blockedAt: $blockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phoneNumber,
    organizationName,
    ruleId,
    ruleName,
    blockedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockedCallRecord &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.organizationName == this.organizationName &&
          other.ruleId == this.ruleId &&
          other.ruleName == this.ruleName &&
          other.blockedAt == this.blockedAt);
}

class BlockedCallRowsCompanion extends UpdateCompanion<BlockedCallRecord> {
  final Value<String> id;
  final Value<String> phoneNumber;
  final Value<String?> organizationName;
  final Value<String?> ruleId;
  final Value<String?> ruleName;
  final Value<DateTime> blockedAt;
  final Value<int> rowid;
  const BlockedCallRowsCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.organizationName = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleName = const Value.absent(),
    this.blockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BlockedCallRowsCompanion.insert({
    required String id,
    required String phoneNumber,
    this.organizationName = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleName = const Value.absent(),
    required DateTime blockedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phoneNumber = Value(phoneNumber),
       blockedAt = Value(blockedAt);
  static Insertable<BlockedCallRecord> custom({
    Expression<String>? id,
    Expression<String>? phoneNumber,
    Expression<String>? organizationName,
    Expression<String>? ruleId,
    Expression<String>? ruleName,
    Expression<DateTime>? blockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (organizationName != null) 'organization_name': organizationName,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleName != null) 'rule_name': ruleName,
      if (blockedAt != null) 'blocked_at': blockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BlockedCallRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? phoneNumber,
    Value<String?>? organizationName,
    Value<String?>? ruleId,
    Value<String?>? ruleName,
    Value<DateTime>? blockedAt,
    Value<int>? rowid,
  }) {
    return BlockedCallRowsCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      organizationName: organizationName ?? this.organizationName,
      ruleId: ruleId ?? this.ruleId,
      ruleName: ruleName ?? this.ruleName,
      blockedAt: blockedAt ?? this.blockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (organizationName.present) {
      map['organization_name'] = Variable<String>(organizationName.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (ruleName.present) {
      map['rule_name'] = Variable<String>(ruleName.value);
    }
    if (blockedAt.present) {
      map['blocked_at'] = Variable<DateTime>(blockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockedCallRowsCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('organizationName: $organizationName, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleName: $ruleName, ')
          ..write('blockedAt: $blockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsRowsTable extends AppSettingsRows
    with TableInfo<$AppSettingsRowsTable, AppSettingsRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _filteringEnabledMeta = const VerificationMeta(
    'filteringEnabled',
  );
  @override
  late final GeneratedColumn<bool> filteringEnabled = GeneratedColumn<bool>(
    'filtering_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("filtering_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _logBlockedCallsMeta = const VerificationMeta(
    'logBlockedCalls',
  );
  @override
  late final GeneratedColumn<bool> logBlockedCalls = GeneratedColumn<bool>(
    'log_blocked_calls',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("log_blocked_calls" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _localeCodeMeta = const VerificationMeta(
    'localeCode',
  );
  @override
  late final GeneratedColumn<String> localeCode = GeneratedColumn<String>(
    'locale_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    filteringEnabled,
    logBlockedCalls,
    themeMode,
    localeCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('filtering_enabled')) {
      context.handle(
        _filteringEnabledMeta,
        filteringEnabled.isAcceptableOrUnknown(
          data['filtering_enabled']!,
          _filteringEnabledMeta,
        ),
      );
    }
    if (data.containsKey('log_blocked_calls')) {
      context.handle(
        _logBlockedCallsMeta,
        logBlockedCalls.isAcceptableOrUnknown(
          data['log_blocked_calls']!,
          _logBlockedCallsMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('locale_code')) {
      context.handle(
        _localeCodeMeta,
        localeCode.isAcceptableOrUnknown(data['locale_code']!, _localeCodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      filteringEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}filtering_enabled'],
      )!,
      logBlockedCalls: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}log_blocked_calls'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      localeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_code'],
      ),
    );
  }

  @override
  $AppSettingsRowsTable createAlias(String alias) {
    return $AppSettingsRowsTable(attachedDatabase, alias);
  }
}

class AppSettingsRecord extends DataClass
    implements Insertable<AppSettingsRecord> {
  final int id;
  final bool filteringEnabled;
  final bool logBlockedCalls;
  final String themeMode;
  final String? localeCode;
  const AppSettingsRecord({
    required this.id,
    required this.filteringEnabled,
    required this.logBlockedCalls,
    required this.themeMode,
    this.localeCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['filtering_enabled'] = Variable<bool>(filteringEnabled);
    map['log_blocked_calls'] = Variable<bool>(logBlockedCalls);
    map['theme_mode'] = Variable<String>(themeMode);
    if (!nullToAbsent || localeCode != null) {
      map['locale_code'] = Variable<String>(localeCode);
    }
    return map;
  }

  AppSettingsRowsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsRowsCompanion(
      id: Value(id),
      filteringEnabled: Value(filteringEnabled),
      logBlockedCalls: Value(logBlockedCalls),
      themeMode: Value(themeMode),
      localeCode: localeCode == null && nullToAbsent
          ? const Value.absent()
          : Value(localeCode),
    );
  }

  factory AppSettingsRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRecord(
      id: serializer.fromJson<int>(json['id']),
      filteringEnabled: serializer.fromJson<bool>(json['filteringEnabled']),
      logBlockedCalls: serializer.fromJson<bool>(json['logBlockedCalls']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      localeCode: serializer.fromJson<String?>(json['localeCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'filteringEnabled': serializer.toJson<bool>(filteringEnabled),
      'logBlockedCalls': serializer.toJson<bool>(logBlockedCalls),
      'themeMode': serializer.toJson<String>(themeMode),
      'localeCode': serializer.toJson<String?>(localeCode),
    };
  }

  AppSettingsRecord copyWith({
    int? id,
    bool? filteringEnabled,
    bool? logBlockedCalls,
    String? themeMode,
    Value<String?> localeCode = const Value.absent(),
  }) => AppSettingsRecord(
    id: id ?? this.id,
    filteringEnabled: filteringEnabled ?? this.filteringEnabled,
    logBlockedCalls: logBlockedCalls ?? this.logBlockedCalls,
    themeMode: themeMode ?? this.themeMode,
    localeCode: localeCode.present ? localeCode.value : this.localeCode,
  );
  AppSettingsRecord copyWithCompanion(AppSettingsRowsCompanion data) {
    return AppSettingsRecord(
      id: data.id.present ? data.id.value : this.id,
      filteringEnabled: data.filteringEnabled.present
          ? data.filteringEnabled.value
          : this.filteringEnabled,
      logBlockedCalls: data.logBlockedCalls.present
          ? data.logBlockedCalls.value
          : this.logBlockedCalls,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      localeCode: data.localeCode.present
          ? data.localeCode.value
          : this.localeCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRecord(')
          ..write('id: $id, ')
          ..write('filteringEnabled: $filteringEnabled, ')
          ..write('logBlockedCalls: $logBlockedCalls, ')
          ..write('themeMode: $themeMode, ')
          ..write('localeCode: $localeCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, filteringEnabled, logBlockedCalls, themeMode, localeCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRecord &&
          other.id == this.id &&
          other.filteringEnabled == this.filteringEnabled &&
          other.logBlockedCalls == this.logBlockedCalls &&
          other.themeMode == this.themeMode &&
          other.localeCode == this.localeCode);
}

class AppSettingsRowsCompanion extends UpdateCompanion<AppSettingsRecord> {
  final Value<int> id;
  final Value<bool> filteringEnabled;
  final Value<bool> logBlockedCalls;
  final Value<String> themeMode;
  final Value<String?> localeCode;
  const AppSettingsRowsCompanion({
    this.id = const Value.absent(),
    this.filteringEnabled = const Value.absent(),
    this.logBlockedCalls = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.localeCode = const Value.absent(),
  });
  AppSettingsRowsCompanion.insert({
    this.id = const Value.absent(),
    this.filteringEnabled = const Value.absent(),
    this.logBlockedCalls = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.localeCode = const Value.absent(),
  });
  static Insertable<AppSettingsRecord> custom({
    Expression<int>? id,
    Expression<bool>? filteringEnabled,
    Expression<bool>? logBlockedCalls,
    Expression<String>? themeMode,
    Expression<String>? localeCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filteringEnabled != null) 'filtering_enabled': filteringEnabled,
      if (logBlockedCalls != null) 'log_blocked_calls': logBlockedCalls,
      if (themeMode != null) 'theme_mode': themeMode,
      if (localeCode != null) 'locale_code': localeCode,
    });
  }

  AppSettingsRowsCompanion copyWith({
    Value<int>? id,
    Value<bool>? filteringEnabled,
    Value<bool>? logBlockedCalls,
    Value<String>? themeMode,
    Value<String?>? localeCode,
  }) {
    return AppSettingsRowsCompanion(
      id: id ?? this.id,
      filteringEnabled: filteringEnabled ?? this.filteringEnabled,
      logBlockedCalls: logBlockedCalls ?? this.logBlockedCalls,
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (filteringEnabled.present) {
      map['filtering_enabled'] = Variable<bool>(filteringEnabled.value);
    }
    if (logBlockedCalls.present) {
      map['log_blocked_calls'] = Variable<bool>(logBlockedCalls.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (localeCode.present) {
      map['locale_code'] = Variable<String>(localeCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRowsCompanion(')
          ..write('id: $id, ')
          ..write('filteringEnabled: $filteringEnabled, ')
          ..write('logBlockedCalls: $logBlockedCalls, ')
          ..write('themeMode: $themeMode, ')
          ..write('localeCode: $localeCode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FilterRuleRowsTable filterRuleRows = $FilterRuleRowsTable(this);
  late final $WhitelistRowsTable whitelistRows = $WhitelistRowsTable(this);
  late final $BlockedCallRowsTable blockedCallRows = $BlockedCallRowsTable(
    this,
  );
  late final $AppSettingsRowsTable appSettingsRows = $AppSettingsRowsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    filterRuleRows,
    whitelistRows,
    blockedCallRows,
    appSettingsRows,
  ];
}

typedef $$FilterRuleRowsTableCreateCompanionBuilder =
    FilterRuleRowsCompanion Function({
      required String id,
      required String name,
      required String pattern,
      Value<bool> isEnabled,
      Value<int> priority,
      Value<String?> description,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FilterRuleRowsTableUpdateCompanionBuilder =
    FilterRuleRowsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> pattern,
      Value<bool> isEnabled,
      Value<int> priority,
      Value<String?> description,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$FilterRuleRowsTableFilterComposer
    extends Composer<_$AppDatabase, $FilterRuleRowsTable> {
  $$FilterRuleRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FilterRuleRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $FilterRuleRowsTable> {
  $$FilterRuleRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FilterRuleRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FilterRuleRowsTable> {
  $$FilterRuleRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FilterRuleRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FilterRuleRowsTable,
          FilterRuleRecord,
          $$FilterRuleRowsTableFilterComposer,
          $$FilterRuleRowsTableOrderingComposer,
          $$FilterRuleRowsTableAnnotationComposer,
          $$FilterRuleRowsTableCreateCompanionBuilder,
          $$FilterRuleRowsTableUpdateCompanionBuilder,
          (
            FilterRuleRecord,
            BaseReferences<
              _$AppDatabase,
              $FilterRuleRowsTable,
              FilterRuleRecord
            >,
          ),
          FilterRuleRecord,
          PrefetchHooks Function()
        > {
  $$FilterRuleRowsTableTableManager(
    _$AppDatabase db,
    $FilterRuleRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FilterRuleRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FilterRuleRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FilterRuleRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> pattern = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FilterRuleRowsCompanion(
                id: id,
                name: name,
                pattern: pattern,
                isEnabled: isEnabled,
                priority: priority,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String pattern,
                Value<bool> isEnabled = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FilterRuleRowsCompanion.insert(
                id: id,
                name: name,
                pattern: pattern,
                isEnabled: isEnabled,
                priority: priority,
                description: description,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FilterRuleRowsTable, FilterRuleRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FilterRuleRowsTable,
                    FilterRuleRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FilterRuleRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FilterRuleRowsTable,
      FilterRuleRecord,
      $$FilterRuleRowsTableFilterComposer,
      $$FilterRuleRowsTableOrderingComposer,
      $$FilterRuleRowsTableAnnotationComposer,
      $$FilterRuleRowsTableCreateCompanionBuilder,
      $$FilterRuleRowsTableUpdateCompanionBuilder,
      (
        FilterRuleRecord,
        BaseReferences<_$AppDatabase, $FilterRuleRowsTable, FilterRuleRecord>,
      ),
      FilterRuleRecord,
      PrefetchHooks Function()
    >;
typedef $$WhitelistRowsTableCreateCompanionBuilder =
    WhitelistRowsCompanion Function({
      required String id,
      required String phoneNumber,
      Value<String> label,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$WhitelistRowsTableUpdateCompanionBuilder =
    WhitelistRowsCompanion Function({
      Value<String> id,
      Value<String> phoneNumber,
      Value<String> label,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$WhitelistRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WhitelistRowsTable> {
  $$WhitelistRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WhitelistRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WhitelistRowsTable> {
  $$WhitelistRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WhitelistRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WhitelistRowsTable> {
  $$WhitelistRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WhitelistRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WhitelistRowsTable,
          WhitelistEntryRecord,
          $$WhitelistRowsTableFilterComposer,
          $$WhitelistRowsTableOrderingComposer,
          $$WhitelistRowsTableAnnotationComposer,
          $$WhitelistRowsTableCreateCompanionBuilder,
          $$WhitelistRowsTableUpdateCompanionBuilder,
          (
            WhitelistEntryRecord,
            BaseReferences<
              _$AppDatabase,
              $WhitelistRowsTable,
              WhitelistEntryRecord
            >,
          ),
          WhitelistEntryRecord,
          PrefetchHooks Function()
        > {
  $$WhitelistRowsTableTableManager(_$AppDatabase db, $WhitelistRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WhitelistRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WhitelistRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WhitelistRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WhitelistRowsCompanion(
                id: id,
                phoneNumber: phoneNumber,
                label: label,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phoneNumber,
                Value<String> label = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WhitelistRowsCompanion.insert(
                id: id,
                phoneNumber: phoneNumber,
                label: label,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WhitelistRowsTable, WhitelistEntryRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WhitelistRowsTable,
                    WhitelistEntryRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WhitelistRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WhitelistRowsTable,
      WhitelistEntryRecord,
      $$WhitelistRowsTableFilterComposer,
      $$WhitelistRowsTableOrderingComposer,
      $$WhitelistRowsTableAnnotationComposer,
      $$WhitelistRowsTableCreateCompanionBuilder,
      $$WhitelistRowsTableUpdateCompanionBuilder,
      (
        WhitelistEntryRecord,
        BaseReferences<
          _$AppDatabase,
          $WhitelistRowsTable,
          WhitelistEntryRecord
        >,
      ),
      WhitelistEntryRecord,
      PrefetchHooks Function()
    >;
typedef $$BlockedCallRowsTableCreateCompanionBuilder =
    BlockedCallRowsCompanion Function({
      required String id,
      required String phoneNumber,
      Value<String?> organizationName,
      Value<String?> ruleId,
      Value<String?> ruleName,
      required DateTime blockedAt,
      Value<int> rowid,
    });
typedef $$BlockedCallRowsTableUpdateCompanionBuilder =
    BlockedCallRowsCompanion Function({
      Value<String> id,
      Value<String> phoneNumber,
      Value<String?> organizationName,
      Value<String?> ruleId,
      Value<String?> ruleName,
      Value<DateTime> blockedAt,
      Value<int> rowid,
    });

class $$BlockedCallRowsTableFilterComposer
    extends Composer<_$AppDatabase, $BlockedCallRowsTable> {
  $$BlockedCallRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleName => $composableBuilder(
    column: $table.ruleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get blockedAt => $composableBuilder(
    column: $table.blockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BlockedCallRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $BlockedCallRowsTable> {
  $$BlockedCallRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleName => $composableBuilder(
    column: $table.ruleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get blockedAt => $composableBuilder(
    column: $table.blockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BlockedCallRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlockedCallRowsTable> {
  $$BlockedCallRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get organizationName => $composableBuilder(
    column: $table.organizationName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<String> get ruleName =>
      $composableBuilder(column: $table.ruleName, builder: (column) => column);

  GeneratedColumn<DateTime> get blockedAt =>
      $composableBuilder(column: $table.blockedAt, builder: (column) => column);
}

class $$BlockedCallRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockedCallRowsTable,
          BlockedCallRecord,
          $$BlockedCallRowsTableFilterComposer,
          $$BlockedCallRowsTableOrderingComposer,
          $$BlockedCallRowsTableAnnotationComposer,
          $$BlockedCallRowsTableCreateCompanionBuilder,
          $$BlockedCallRowsTableUpdateCompanionBuilder,
          (
            BlockedCallRecord,
            BaseReferences<
              _$AppDatabase,
              $BlockedCallRowsTable,
              BlockedCallRecord
            >,
          ),
          BlockedCallRecord,
          PrefetchHooks Function()
        > {
  $$BlockedCallRowsTableTableManager(
    _$AppDatabase db,
    $BlockedCallRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockedCallRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockedCallRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockedCallRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String?> organizationName = const Value.absent(),
                Value<String?> ruleId = const Value.absent(),
                Value<String?> ruleName = const Value.absent(),
                Value<DateTime> blockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BlockedCallRowsCompanion(
                id: id,
                phoneNumber: phoneNumber,
                organizationName: organizationName,
                ruleId: ruleId,
                ruleName: ruleName,
                blockedAt: blockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phoneNumber,
                Value<String?> organizationName = const Value.absent(),
                Value<String?> ruleId = const Value.absent(),
                Value<String?> ruleName = const Value.absent(),
                required DateTime blockedAt,
                Value<int> rowid = const Value.absent(),
              }) => BlockedCallRowsCompanion.insert(
                id: id,
                phoneNumber: phoneNumber,
                organizationName: organizationName,
                ruleId: ruleId,
                ruleName: ruleName,
                blockedAt: blockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BlockedCallRowsTable, BlockedCallRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BlockedCallRowsTable,
                    BlockedCallRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BlockedCallRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockedCallRowsTable,
      BlockedCallRecord,
      $$BlockedCallRowsTableFilterComposer,
      $$BlockedCallRowsTableOrderingComposer,
      $$BlockedCallRowsTableAnnotationComposer,
      $$BlockedCallRowsTableCreateCompanionBuilder,
      $$BlockedCallRowsTableUpdateCompanionBuilder,
      (
        BlockedCallRecord,
        BaseReferences<_$AppDatabase, $BlockedCallRowsTable, BlockedCallRecord>,
      ),
      BlockedCallRecord,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsRowsTableCreateCompanionBuilder =
    AppSettingsRowsCompanion Function({
      Value<int> id,
      Value<bool> filteringEnabled,
      Value<bool> logBlockedCalls,
      Value<String> themeMode,
      Value<String?> localeCode,
    });
typedef $$AppSettingsRowsTableUpdateCompanionBuilder =
    AppSettingsRowsCompanion Function({
      Value<int> id,
      Value<bool> filteringEnabled,
      Value<bool> logBlockedCalls,
      Value<String> themeMode,
      Value<String?> localeCode,
    });

class $$AppSettingsRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get filteringEnabled => $composableBuilder(
    column: $table.filteringEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get logBlockedCalls => $composableBuilder(
    column: $table.logBlockedCalls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get filteringEnabled => $composableBuilder(
    column: $table.filteringEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get logBlockedCalls => $composableBuilder(
    column: $table.logBlockedCalls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get filteringEnabled => $composableBuilder(
    column: $table.filteringEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get logBlockedCalls => $composableBuilder(
    column: $table.logBlockedCalls,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get localeCode => $composableBuilder(
    column: $table.localeCode,
    builder: (column) => column,
  );
}

class $$AppSettingsRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsRowsTable,
          AppSettingsRecord,
          $$AppSettingsRowsTableFilterComposer,
          $$AppSettingsRowsTableOrderingComposer,
          $$AppSettingsRowsTableAnnotationComposer,
          $$AppSettingsRowsTableCreateCompanionBuilder,
          $$AppSettingsRowsTableUpdateCompanionBuilder,
          (
            AppSettingsRecord,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsRowsTable,
              AppSettingsRecord
            >,
          ),
          AppSettingsRecord,
          PrefetchHooks Function()
        > {
  $$AppSettingsRowsTableTableManager(
    _$AppDatabase db,
    $AppSettingsRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> filteringEnabled = const Value.absent(),
                Value<bool> logBlockedCalls = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> localeCode = const Value.absent(),
              }) => AppSettingsRowsCompanion(
                id: id,
                filteringEnabled: filteringEnabled,
                logBlockedCalls: logBlockedCalls,
                themeMode: themeMode,
                localeCode: localeCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> filteringEnabled = const Value.absent(),
                Value<bool> logBlockedCalls = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> localeCode = const Value.absent(),
              }) => AppSettingsRowsCompanion.insert(
                id: id,
                filteringEnabled: filteringEnabled,
                logBlockedCalls: logBlockedCalls,
                themeMode: themeMode,
                localeCode: localeCode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsRowsTable, AppSettingsRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsRowsTable,
                    AppSettingsRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsRowsTable,
      AppSettingsRecord,
      $$AppSettingsRowsTableFilterComposer,
      $$AppSettingsRowsTableOrderingComposer,
      $$AppSettingsRowsTableAnnotationComposer,
      $$AppSettingsRowsTableCreateCompanionBuilder,
      $$AppSettingsRowsTableUpdateCompanionBuilder,
      (
        AppSettingsRecord,
        BaseReferences<_$AppDatabase, $AppSettingsRowsTable, AppSettingsRecord>,
      ),
      AppSettingsRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FilterRuleRowsTableTableManager get filterRuleRows =>
      $$FilterRuleRowsTableTableManager(_db, _db.filterRuleRows);
  $$WhitelistRowsTableTableManager get whitelistRows =>
      $$WhitelistRowsTableTableManager(_db, _db.whitelistRows);
  $$BlockedCallRowsTableTableManager get blockedCallRows =>
      $$BlockedCallRowsTableTableManager(_db, _db.blockedCallRows);
  $$AppSettingsRowsTableTableManager get appSettingsRows =>
      $$AppSettingsRowsTableTableManager(_db, _db.appSettingsRows);
}
