// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseTypeMeta = const VerificationMeta(
    'licenseType',
  );
  @override
  late final GeneratedColumn<String> licenseType = GeneratedColumn<String>(
    'license_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerAMeta = const VerificationMeta(
    'answerA',
  );
  @override
  late final GeneratedColumn<String> answerA = GeneratedColumn<String>(
    'answer_a',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerBMeta = const VerificationMeta(
    'answerB',
  );
  @override
  late final GeneratedColumn<String> answerB = GeneratedColumn<String>(
    'answer_b',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerCMeta = const VerificationMeta(
    'answerC',
  );
  @override
  late final GeneratedColumn<String> answerC = GeneratedColumn<String>(
    'answer_c',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswerIndexMeta =
      const VerificationMeta('correctAnswerIndex');
  @override
  late final GeneratedColumn<int> correctAnswerIndex = GeneratedColumn<int>(
    'correct_answer_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationShortMeta = const VerificationMeta(
    'explanationShort',
  );
  @override
  late final GeneratedColumn<String> explanationShort = GeneratedColumn<String>(
    'explanation_short',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationDetailedMeta =
      const VerificationMeta('explanationDetailed');
  @override
  late final GeneratedColumn<String> explanationDetailed =
      GeneratedColumn<String>(
        'explanation_detailed',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _illustrationAssetMeta = const VerificationMeta(
    'illustrationAsset',
  );
  @override
  late final GeneratedColumn<String> illustrationAsset =
      GeneratedColumn<String>(
        'illustration_asset',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentVersionMeta = const VerificationMeta(
    'contentVersion',
  );
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
    'content_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    state,
    licenseType,
    category,
    difficulty,
    questionText,
    answerA,
    answerB,
    answerC,
    correctAnswerIndex,
    explanationShort,
    explanationDetailed,
    illustrationAsset,
    sourceReference,
    contentVersion,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('license_type')) {
      context.handle(
        _licenseTypeMeta,
        licenseType.isAcceptableOrUnknown(
          data['license_type']!,
          _licenseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_licenseTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('answer_a')) {
      context.handle(
        _answerAMeta,
        answerA.isAcceptableOrUnknown(data['answer_a']!, _answerAMeta),
      );
    } else if (isInserting) {
      context.missing(_answerAMeta);
    }
    if (data.containsKey('answer_b')) {
      context.handle(
        _answerBMeta,
        answerB.isAcceptableOrUnknown(data['answer_b']!, _answerBMeta),
      );
    } else if (isInserting) {
      context.missing(_answerBMeta);
    }
    if (data.containsKey('answer_c')) {
      context.handle(
        _answerCMeta,
        answerC.isAcceptableOrUnknown(data['answer_c']!, _answerCMeta),
      );
    } else if (isInserting) {
      context.missing(_answerCMeta);
    }
    if (data.containsKey('correct_answer_index')) {
      context.handle(
        _correctAnswerIndexMeta,
        correctAnswerIndex.isAcceptableOrUnknown(
          data['correct_answer_index']!,
          _correctAnswerIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerIndexMeta);
    }
    if (data.containsKey('explanation_short')) {
      context.handle(
        _explanationShortMeta,
        explanationShort.isAcceptableOrUnknown(
          data['explanation_short']!,
          _explanationShortMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationShortMeta);
    }
    if (data.containsKey('explanation_detailed')) {
      context.handle(
        _explanationDetailedMeta,
        explanationDetailed.isAcceptableOrUnknown(
          data['explanation_detailed']!,
          _explanationDetailedMeta,
        ),
      );
    }
    if (data.containsKey('illustration_asset')) {
      context.handle(
        _illustrationAssetMeta,
        illustrationAsset.isAcceptableOrUnknown(
          data['illustration_asset']!,
          _illustrationAssetMeta,
        ),
      );
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    if (data.containsKey('content_version')) {
      context.handle(
        _contentVersionMeta,
        contentVersion.isAcceptableOrUnknown(
          data['content_version']!,
          _contentVersionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      licenseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      answerA: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_a'],
      )!,
      answerB: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_b'],
      )!,
      answerC: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_c'],
      )!,
      correctAnswerIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answer_index'],
      )!,
      explanationShort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_short'],
      )!,
      explanationDetailed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_detailed'],
      ),
      illustrationAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}illustration_asset'],
      ),
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
      contentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_version'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
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
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final String id;
  final String state;
  final String licenseType;
  final String category;
  final int difficulty;
  final String questionText;
  final String answerA;
  final String answerB;
  final String answerC;
  final int correctAnswerIndex;
  final String explanationShort;
  final String? explanationDetailed;
  final String? illustrationAsset;
  final String? sourceReference;
  final int contentVersion;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Question({
    required this.id,
    required this.state,
    required this.licenseType,
    required this.category,
    required this.difficulty,
    required this.questionText,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.correctAnswerIndex,
    required this.explanationShort,
    this.explanationDetailed,
    this.illustrationAsset,
    this.sourceReference,
    required this.contentVersion,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['state'] = Variable<String>(state);
    map['license_type'] = Variable<String>(licenseType);
    map['category'] = Variable<String>(category);
    map['difficulty'] = Variable<int>(difficulty);
    map['question_text'] = Variable<String>(questionText);
    map['answer_a'] = Variable<String>(answerA);
    map['answer_b'] = Variable<String>(answerB);
    map['answer_c'] = Variable<String>(answerC);
    map['correct_answer_index'] = Variable<int>(correctAnswerIndex);
    map['explanation_short'] = Variable<String>(explanationShort);
    if (!nullToAbsent || explanationDetailed != null) {
      map['explanation_detailed'] = Variable<String>(explanationDetailed);
    }
    if (!nullToAbsent || illustrationAsset != null) {
      map['illustration_asset'] = Variable<String>(illustrationAsset);
    }
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    map['content_version'] = Variable<int>(contentVersion);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      state: Value(state),
      licenseType: Value(licenseType),
      category: Value(category),
      difficulty: Value(difficulty),
      questionText: Value(questionText),
      answerA: Value(answerA),
      answerB: Value(answerB),
      answerC: Value(answerC),
      correctAnswerIndex: Value(correctAnswerIndex),
      explanationShort: Value(explanationShort),
      explanationDetailed: explanationDetailed == null && nullToAbsent
          ? const Value.absent()
          : Value(explanationDetailed),
      illustrationAsset: illustrationAsset == null && nullToAbsent
          ? const Value.absent()
          : Value(illustrationAsset),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
      contentVersion: Value(contentVersion),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<String>(json['id']),
      state: serializer.fromJson<String>(json['state']),
      licenseType: serializer.fromJson<String>(json['licenseType']),
      category: serializer.fromJson<String>(json['category']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      questionText: serializer.fromJson<String>(json['questionText']),
      answerA: serializer.fromJson<String>(json['answerA']),
      answerB: serializer.fromJson<String>(json['answerB']),
      answerC: serializer.fromJson<String>(json['answerC']),
      correctAnswerIndex: serializer.fromJson<int>(json['correctAnswerIndex']),
      explanationShort: serializer.fromJson<String>(json['explanationShort']),
      explanationDetailed: serializer.fromJson<String?>(
        json['explanationDetailed'],
      ),
      illustrationAsset: serializer.fromJson<String?>(
        json['illustrationAsset'],
      ),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'state': serializer.toJson<String>(state),
      'licenseType': serializer.toJson<String>(licenseType),
      'category': serializer.toJson<String>(category),
      'difficulty': serializer.toJson<int>(difficulty),
      'questionText': serializer.toJson<String>(questionText),
      'answerA': serializer.toJson<String>(answerA),
      'answerB': serializer.toJson<String>(answerB),
      'answerC': serializer.toJson<String>(answerC),
      'correctAnswerIndex': serializer.toJson<int>(correctAnswerIndex),
      'explanationShort': serializer.toJson<String>(explanationShort),
      'explanationDetailed': serializer.toJson<String?>(explanationDetailed),
      'illustrationAsset': serializer.toJson<String?>(illustrationAsset),
      'sourceReference': serializer.toJson<String?>(sourceReference),
      'contentVersion': serializer.toJson<int>(contentVersion),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Question copyWith({
    String? id,
    String? state,
    String? licenseType,
    String? category,
    int? difficulty,
    String? questionText,
    String? answerA,
    String? answerB,
    String? answerC,
    int? correctAnswerIndex,
    String? explanationShort,
    Value<String?> explanationDetailed = const Value.absent(),
    Value<String?> illustrationAsset = const Value.absent(),
    Value<String?> sourceReference = const Value.absent(),
    int? contentVersion,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Question(
    id: id ?? this.id,
    state: state ?? this.state,
    licenseType: licenseType ?? this.licenseType,
    category: category ?? this.category,
    difficulty: difficulty ?? this.difficulty,
    questionText: questionText ?? this.questionText,
    answerA: answerA ?? this.answerA,
    answerB: answerB ?? this.answerB,
    answerC: answerC ?? this.answerC,
    correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
    explanationShort: explanationShort ?? this.explanationShort,
    explanationDetailed: explanationDetailed.present
        ? explanationDetailed.value
        : this.explanationDetailed,
    illustrationAsset: illustrationAsset.present
        ? illustrationAsset.value
        : this.illustrationAsset,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
    contentVersion: contentVersion ?? this.contentVersion,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      state: data.state.present ? data.state.value : this.state,
      licenseType: data.licenseType.present
          ? data.licenseType.value
          : this.licenseType,
      category: data.category.present ? data.category.value : this.category,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      answerA: data.answerA.present ? data.answerA.value : this.answerA,
      answerB: data.answerB.present ? data.answerB.value : this.answerB,
      answerC: data.answerC.present ? data.answerC.value : this.answerC,
      correctAnswerIndex: data.correctAnswerIndex.present
          ? data.correctAnswerIndex.value
          : this.correctAnswerIndex,
      explanationShort: data.explanationShort.present
          ? data.explanationShort.value
          : this.explanationShort,
      explanationDetailed: data.explanationDetailed.present
          ? data.explanationDetailed.value
          : this.explanationDetailed,
      illustrationAsset: data.illustrationAsset.present
          ? data.illustrationAsset.value
          : this.illustrationAsset,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('state: $state, ')
          ..write('licenseType: $licenseType, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('questionText: $questionText, ')
          ..write('answerA: $answerA, ')
          ..write('answerB: $answerB, ')
          ..write('answerC: $answerC, ')
          ..write('correctAnswerIndex: $correctAnswerIndex, ')
          ..write('explanationShort: $explanationShort, ')
          ..write('explanationDetailed: $explanationDetailed, ')
          ..write('illustrationAsset: $illustrationAsset, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    state,
    licenseType,
    category,
    difficulty,
    questionText,
    answerA,
    answerB,
    answerC,
    correctAnswerIndex,
    explanationShort,
    explanationDetailed,
    illustrationAsset,
    sourceReference,
    contentVersion,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.state == this.state &&
          other.licenseType == this.licenseType &&
          other.category == this.category &&
          other.difficulty == this.difficulty &&
          other.questionText == this.questionText &&
          other.answerA == this.answerA &&
          other.answerB == this.answerB &&
          other.answerC == this.answerC &&
          other.correctAnswerIndex == this.correctAnswerIndex &&
          other.explanationShort == this.explanationShort &&
          other.explanationDetailed == this.explanationDetailed &&
          other.illustrationAsset == this.illustrationAsset &&
          other.sourceReference == this.sourceReference &&
          other.contentVersion == this.contentVersion &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<String> id;
  final Value<String> state;
  final Value<String> licenseType;
  final Value<String> category;
  final Value<int> difficulty;
  final Value<String> questionText;
  final Value<String> answerA;
  final Value<String> answerB;
  final Value<String> answerC;
  final Value<int> correctAnswerIndex;
  final Value<String> explanationShort;
  final Value<String?> explanationDetailed;
  final Value<String?> illustrationAsset;
  final Value<String?> sourceReference;
  final Value<int> contentVersion;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.state = const Value.absent(),
    this.licenseType = const Value.absent(),
    this.category = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.questionText = const Value.absent(),
    this.answerA = const Value.absent(),
    this.answerB = const Value.absent(),
    this.answerC = const Value.absent(),
    this.correctAnswerIndex = const Value.absent(),
    this.explanationShort = const Value.absent(),
    this.explanationDetailed = const Value.absent(),
    this.illustrationAsset = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required String state,
    required String licenseType,
    required String category,
    required int difficulty,
    required String questionText,
    required String answerA,
    required String answerB,
    required String answerC,
    required int correctAnswerIndex,
    required String explanationShort,
    this.explanationDetailed = const Value.absent(),
    this.illustrationAsset = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       state = Value(state),
       licenseType = Value(licenseType),
       category = Value(category),
       difficulty = Value(difficulty),
       questionText = Value(questionText),
       answerA = Value(answerA),
       answerB = Value(answerB),
       answerC = Value(answerC),
       correctAnswerIndex = Value(correctAnswerIndex),
       explanationShort = Value(explanationShort);
  static Insertable<Question> custom({
    Expression<String>? id,
    Expression<String>? state,
    Expression<String>? licenseType,
    Expression<String>? category,
    Expression<int>? difficulty,
    Expression<String>? questionText,
    Expression<String>? answerA,
    Expression<String>? answerB,
    Expression<String>? answerC,
    Expression<int>? correctAnswerIndex,
    Expression<String>? explanationShort,
    Expression<String>? explanationDetailed,
    Expression<String>? illustrationAsset,
    Expression<String>? sourceReference,
    Expression<int>? contentVersion,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (state != null) 'state': state,
      if (licenseType != null) 'license_type': licenseType,
      if (category != null) 'category': category,
      if (difficulty != null) 'difficulty': difficulty,
      if (questionText != null) 'question_text': questionText,
      if (answerA != null) 'answer_a': answerA,
      if (answerB != null) 'answer_b': answerB,
      if (answerC != null) 'answer_c': answerC,
      if (correctAnswerIndex != null)
        'correct_answer_index': correctAnswerIndex,
      if (explanationShort != null) 'explanation_short': explanationShort,
      if (explanationDetailed != null)
        'explanation_detailed': explanationDetailed,
      if (illustrationAsset != null) 'illustration_asset': illustrationAsset,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (contentVersion != null) 'content_version': contentVersion,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? state,
    Value<String>? licenseType,
    Value<String>? category,
    Value<int>? difficulty,
    Value<String>? questionText,
    Value<String>? answerA,
    Value<String>? answerB,
    Value<String>? answerC,
    Value<int>? correctAnswerIndex,
    Value<String>? explanationShort,
    Value<String?>? explanationDetailed,
    Value<String?>? illustrationAsset,
    Value<String?>? sourceReference,
    Value<int>? contentVersion,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      state: state ?? this.state,
      licenseType: licenseType ?? this.licenseType,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      questionText: questionText ?? this.questionText,
      answerA: answerA ?? this.answerA,
      answerB: answerB ?? this.answerB,
      answerC: answerC ?? this.answerC,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanationShort: explanationShort ?? this.explanationShort,
      explanationDetailed: explanationDetailed ?? this.explanationDetailed,
      illustrationAsset: illustrationAsset ?? this.illustrationAsset,
      sourceReference: sourceReference ?? this.sourceReference,
      contentVersion: contentVersion ?? this.contentVersion,
      isActive: isActive ?? this.isActive,
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
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (licenseType.present) {
      map['license_type'] = Variable<String>(licenseType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (answerA.present) {
      map['answer_a'] = Variable<String>(answerA.value);
    }
    if (answerB.present) {
      map['answer_b'] = Variable<String>(answerB.value);
    }
    if (answerC.present) {
      map['answer_c'] = Variable<String>(answerC.value);
    }
    if (correctAnswerIndex.present) {
      map['correct_answer_index'] = Variable<int>(correctAnswerIndex.value);
    }
    if (explanationShort.present) {
      map['explanation_short'] = Variable<String>(explanationShort.value);
    }
    if (explanationDetailed.present) {
      map['explanation_detailed'] = Variable<String>(explanationDetailed.value);
    }
    if (illustrationAsset.present) {
      map['illustration_asset'] = Variable<String>(illustrationAsset.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
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
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('state: $state, ')
          ..write('licenseType: $licenseType, ')
          ..write('category: $category, ')
          ..write('difficulty: $difficulty, ')
          ..write('questionText: $questionText, ')
          ..write('answerA: $answerA, ')
          ..write('answerB: $answerB, ')
          ..write('answerC: $answerC, ')
          ..write('correctAnswerIndex: $correctAnswerIndex, ')
          ..write('explanationShort: $explanationShort, ')
          ..write('explanationDetailed: $explanationDetailed, ')
          ..write('illustrationAsset: $illustrationAsset, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionProgressTable extends QuestionProgress
    with TableInfo<$QuestionProgressTable, QuestionProgressItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES questions (id)',
    ),
  );
  static const VerificationMeta _timesAnsweredMeta = const VerificationMeta(
    'timesAnswered',
  );
  @override
  late final GeneratedColumn<int> timesAnswered = GeneratedColumn<int>(
    'times_answered',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _incorrectCountMeta = const VerificationMeta(
    'incorrectCount',
  );
  @override
  late final GeneratedColumn<int> incorrectCount = GeneratedColumn<int>(
    'incorrect_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAnsweredAtMeta = const VerificationMeta(
    'lastAnsweredAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAnsweredAt =
      GeneratedColumn<DateTime>(
        'last_answered_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isBookmarkedMeta = const VerificationMeta(
    'isBookmarked',
  );
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
    'is_bookmarked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_bookmarked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isMasteredMeta = const VerificationMeta(
    'isMastered',
  );
  @override
  late final GeneratedColumn<bool> isMastered = GeneratedColumn<bool>(
    'is_mastered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mastered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    questionId,
    timesAnswered,
    correctCount,
    incorrectCount,
    lastAnsweredAt,
    isBookmarked,
    isMastered,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionProgressItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('times_answered')) {
      context.handle(
        _timesAnsweredMeta,
        timesAnswered.isAcceptableOrUnknown(
          data['times_answered']!,
          _timesAnsweredMeta,
        ),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('incorrect_count')) {
      context.handle(
        _incorrectCountMeta,
        incorrectCount.isAcceptableOrUnknown(
          data['incorrect_count']!,
          _incorrectCountMeta,
        ),
      );
    }
    if (data.containsKey('last_answered_at')) {
      context.handle(
        _lastAnsweredAtMeta,
        lastAnsweredAt.isAcceptableOrUnknown(
          data['last_answered_at']!,
          _lastAnsweredAtMeta,
        ),
      );
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
        _isBookmarkedMeta,
        isBookmarked.isAcceptableOrUnknown(
          data['is_bookmarked']!,
          _isBookmarkedMeta,
        ),
      );
    }
    if (data.containsKey('is_mastered')) {
      context.handle(
        _isMasteredMeta,
        isMastered.isAcceptableOrUnknown(data['is_mastered']!, _isMasteredMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId};
  @override
  QuestionProgressItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionProgressItem(
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      timesAnswered: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_answered'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      incorrectCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incorrect_count'],
      )!,
      lastAnsweredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_answered_at'],
      ),
      isBookmarked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_bookmarked'],
      )!,
      isMastered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_mastered'],
      )!,
    );
  }

  @override
  $QuestionProgressTable createAlias(String alias) {
    return $QuestionProgressTable(attachedDatabase, alias);
  }
}

class QuestionProgressItem extends DataClass
    implements Insertable<QuestionProgressItem> {
  final String questionId;
  final int timesAnswered;
  final int correctCount;
  final int incorrectCount;
  final DateTime? lastAnsweredAt;
  final bool isBookmarked;
  final bool isMastered;
  const QuestionProgressItem({
    required this.questionId,
    required this.timesAnswered,
    required this.correctCount,
    required this.incorrectCount,
    this.lastAnsweredAt,
    required this.isBookmarked,
    required this.isMastered,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<String>(questionId);
    map['times_answered'] = Variable<int>(timesAnswered);
    map['correct_count'] = Variable<int>(correctCount);
    map['incorrect_count'] = Variable<int>(incorrectCount);
    if (!nullToAbsent || lastAnsweredAt != null) {
      map['last_answered_at'] = Variable<DateTime>(lastAnsweredAt);
    }
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    map['is_mastered'] = Variable<bool>(isMastered);
    return map;
  }

  QuestionProgressCompanion toCompanion(bool nullToAbsent) {
    return QuestionProgressCompanion(
      questionId: Value(questionId),
      timesAnswered: Value(timesAnswered),
      correctCount: Value(correctCount),
      incorrectCount: Value(incorrectCount),
      lastAnsweredAt: lastAnsweredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAnsweredAt),
      isBookmarked: Value(isBookmarked),
      isMastered: Value(isMastered),
    );
  }

  factory QuestionProgressItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionProgressItem(
      questionId: serializer.fromJson<String>(json['questionId']),
      timesAnswered: serializer.fromJson<int>(json['timesAnswered']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      incorrectCount: serializer.fromJson<int>(json['incorrectCount']),
      lastAnsweredAt: serializer.fromJson<DateTime?>(json['lastAnsweredAt']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
      isMastered: serializer.fromJson<bool>(json['isMastered']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<String>(questionId),
      'timesAnswered': serializer.toJson<int>(timesAnswered),
      'correctCount': serializer.toJson<int>(correctCount),
      'incorrectCount': serializer.toJson<int>(incorrectCount),
      'lastAnsweredAt': serializer.toJson<DateTime?>(lastAnsweredAt),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
      'isMastered': serializer.toJson<bool>(isMastered),
    };
  }

  QuestionProgressItem copyWith({
    String? questionId,
    int? timesAnswered,
    int? correctCount,
    int? incorrectCount,
    Value<DateTime?> lastAnsweredAt = const Value.absent(),
    bool? isBookmarked,
    bool? isMastered,
  }) => QuestionProgressItem(
    questionId: questionId ?? this.questionId,
    timesAnswered: timesAnswered ?? this.timesAnswered,
    correctCount: correctCount ?? this.correctCount,
    incorrectCount: incorrectCount ?? this.incorrectCount,
    lastAnsweredAt: lastAnsweredAt.present
        ? lastAnsweredAt.value
        : this.lastAnsweredAt,
    isBookmarked: isBookmarked ?? this.isBookmarked,
    isMastered: isMastered ?? this.isMastered,
  );
  QuestionProgressItem copyWithCompanion(QuestionProgressCompanion data) {
    return QuestionProgressItem(
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      timesAnswered: data.timesAnswered.present
          ? data.timesAnswered.value
          : this.timesAnswered,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      incorrectCount: data.incorrectCount.present
          ? data.incorrectCount.value
          : this.incorrectCount,
      lastAnsweredAt: data.lastAnsweredAt.present
          ? data.lastAnsweredAt.value
          : this.lastAnsweredAt,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
      isMastered: data.isMastered.present
          ? data.isMastered.value
          : this.isMastered,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionProgressItem(')
          ..write('questionId: $questionId, ')
          ..write('timesAnswered: $timesAnswered, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('lastAnsweredAt: $lastAnsweredAt, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('isMastered: $isMastered')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    questionId,
    timesAnswered,
    correctCount,
    incorrectCount,
    lastAnsweredAt,
    isBookmarked,
    isMastered,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionProgressItem &&
          other.questionId == this.questionId &&
          other.timesAnswered == this.timesAnswered &&
          other.correctCount == this.correctCount &&
          other.incorrectCount == this.incorrectCount &&
          other.lastAnsweredAt == this.lastAnsweredAt &&
          other.isBookmarked == this.isBookmarked &&
          other.isMastered == this.isMastered);
}

class QuestionProgressCompanion extends UpdateCompanion<QuestionProgressItem> {
  final Value<String> questionId;
  final Value<int> timesAnswered;
  final Value<int> correctCount;
  final Value<int> incorrectCount;
  final Value<DateTime?> lastAnsweredAt;
  final Value<bool> isBookmarked;
  final Value<bool> isMastered;
  final Value<int> rowid;
  const QuestionProgressCompanion({
    this.questionId = const Value.absent(),
    this.timesAnswered = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.lastAnsweredAt = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.isMastered = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionProgressCompanion.insert({
    required String questionId,
    this.timesAnswered = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.incorrectCount = const Value.absent(),
    this.lastAnsweredAt = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.isMastered = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : questionId = Value(questionId);
  static Insertable<QuestionProgressItem> custom({
    Expression<String>? questionId,
    Expression<int>? timesAnswered,
    Expression<int>? correctCount,
    Expression<int>? incorrectCount,
    Expression<DateTime>? lastAnsweredAt,
    Expression<bool>? isBookmarked,
    Expression<bool>? isMastered,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (timesAnswered != null) 'times_answered': timesAnswered,
      if (correctCount != null) 'correct_count': correctCount,
      if (incorrectCount != null) 'incorrect_count': incorrectCount,
      if (lastAnsweredAt != null) 'last_answered_at': lastAnsweredAt,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
      if (isMastered != null) 'is_mastered': isMastered,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionProgressCompanion copyWith({
    Value<String>? questionId,
    Value<int>? timesAnswered,
    Value<int>? correctCount,
    Value<int>? incorrectCount,
    Value<DateTime?>? lastAnsweredAt,
    Value<bool>? isBookmarked,
    Value<bool>? isMastered,
    Value<int>? rowid,
  }) {
    return QuestionProgressCompanion(
      questionId: questionId ?? this.questionId,
      timesAnswered: timesAnswered ?? this.timesAnswered,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      lastAnsweredAt: lastAnsweredAt ?? this.lastAnsweredAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isMastered: isMastered ?? this.isMastered,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (timesAnswered.present) {
      map['times_answered'] = Variable<int>(timesAnswered.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (incorrectCount.present) {
      map['incorrect_count'] = Variable<int>(incorrectCount.value);
    }
    if (lastAnsweredAt.present) {
      map['last_answered_at'] = Variable<DateTime>(lastAnsweredAt.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    if (isMastered.present) {
      map['is_mastered'] = Variable<bool>(isMastered.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionProgressCompanion(')
          ..write('questionId: $questionId, ')
          ..write('timesAnswered: $timesAnswered, ')
          ..write('correctCount: $correctCount, ')
          ..write('incorrectCount: $incorrectCount, ')
          ..write('lastAnsweredAt: $lastAnsweredAt, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('isMastered: $isMastered, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoadSignsTable extends RoadSigns
    with TableInfo<$RoadSignsTable, RoadSign> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoadSignsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetPathMeta = const VerificationMeta(
    'assetPath',
  );
  @override
  late final GeneratedColumn<String> assetPath = GeneratedColumn<String>(
    'asset_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortMeaningMeta = const VerificationMeta(
    'shortMeaning',
  );
  @override
  late final GeneratedColumn<String> shortMeaning = GeneratedColumn<String>(
    'short_meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailedMeaningMeta = const VerificationMeta(
    'detailedMeaning',
  );
  @override
  late final GeneratedColumn<String> detailedMeaning = GeneratedColumn<String>(
    'detailed_meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commonMistakeMeta = const VerificationMeta(
    'commonMistake',
  );
  @override
  late final GeneratedColumn<String> commonMistake = GeneratedColumn<String>(
    'common_mistake',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    assetPath,
    shortMeaning,
    detailedMeaning,
    commonMistake,
    sourceReference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'road_signs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoadSign> instance, {
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('asset_path')) {
      context.handle(
        _assetPathMeta,
        assetPath.isAcceptableOrUnknown(data['asset_path']!, _assetPathMeta),
      );
    } else if (isInserting) {
      context.missing(_assetPathMeta);
    }
    if (data.containsKey('short_meaning')) {
      context.handle(
        _shortMeaningMeta,
        shortMeaning.isAcceptableOrUnknown(
          data['short_meaning']!,
          _shortMeaningMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shortMeaningMeta);
    }
    if (data.containsKey('detailed_meaning')) {
      context.handle(
        _detailedMeaningMeta,
        detailedMeaning.isAcceptableOrUnknown(
          data['detailed_meaning']!,
          _detailedMeaningMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detailedMeaningMeta);
    }
    if (data.containsKey('common_mistake')) {
      context.handle(
        _commonMistakeMeta,
        commonMistake.isAcceptableOrUnknown(
          data['common_mistake']!,
          _commonMistakeMeta,
        ),
      );
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoadSign map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoadSign(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      assetPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_path'],
      )!,
      shortMeaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_meaning'],
      )!,
      detailedMeaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detailed_meaning'],
      )!,
      commonMistake: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}common_mistake'],
      ),
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
    );
  }

  @override
  $RoadSignsTable createAlias(String alias) {
    return $RoadSignsTable(attachedDatabase, alias);
  }
}

class RoadSign extends DataClass implements Insertable<RoadSign> {
  final String id;
  final String name;
  final String category;
  final String assetPath;
  final String shortMeaning;
  final String detailedMeaning;
  final String? commonMistake;
  final String? sourceReference;
  const RoadSign({
    required this.id,
    required this.name,
    required this.category,
    required this.assetPath,
    required this.shortMeaning,
    required this.detailedMeaning,
    this.commonMistake,
    this.sourceReference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['asset_path'] = Variable<String>(assetPath);
    map['short_meaning'] = Variable<String>(shortMeaning);
    map['detailed_meaning'] = Variable<String>(detailedMeaning);
    if (!nullToAbsent || commonMistake != null) {
      map['common_mistake'] = Variable<String>(commonMistake);
    }
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    return map;
  }

  RoadSignsCompanion toCompanion(bool nullToAbsent) {
    return RoadSignsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      assetPath: Value(assetPath),
      shortMeaning: Value(shortMeaning),
      detailedMeaning: Value(detailedMeaning),
      commonMistake: commonMistake == null && nullToAbsent
          ? const Value.absent()
          : Value(commonMistake),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
    );
  }

  factory RoadSign.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoadSign(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      assetPath: serializer.fromJson<String>(json['assetPath']),
      shortMeaning: serializer.fromJson<String>(json['shortMeaning']),
      detailedMeaning: serializer.fromJson<String>(json['detailedMeaning']),
      commonMistake: serializer.fromJson<String?>(json['commonMistake']),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'assetPath': serializer.toJson<String>(assetPath),
      'shortMeaning': serializer.toJson<String>(shortMeaning),
      'detailedMeaning': serializer.toJson<String>(detailedMeaning),
      'commonMistake': serializer.toJson<String?>(commonMistake),
      'sourceReference': serializer.toJson<String?>(sourceReference),
    };
  }

  RoadSign copyWith({
    String? id,
    String? name,
    String? category,
    String? assetPath,
    String? shortMeaning,
    String? detailedMeaning,
    Value<String?> commonMistake = const Value.absent(),
    Value<String?> sourceReference = const Value.absent(),
  }) => RoadSign(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    assetPath: assetPath ?? this.assetPath,
    shortMeaning: shortMeaning ?? this.shortMeaning,
    detailedMeaning: detailedMeaning ?? this.detailedMeaning,
    commonMistake: commonMistake.present
        ? commonMistake.value
        : this.commonMistake,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
  );
  RoadSign copyWithCompanion(RoadSignsCompanion data) {
    return RoadSign(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      assetPath: data.assetPath.present ? data.assetPath.value : this.assetPath,
      shortMeaning: data.shortMeaning.present
          ? data.shortMeaning.value
          : this.shortMeaning,
      detailedMeaning: data.detailedMeaning.present
          ? data.detailedMeaning.value
          : this.detailedMeaning,
      commonMistake: data.commonMistake.present
          ? data.commonMistake.value
          : this.commonMistake,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoadSign(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('assetPath: $assetPath, ')
          ..write('shortMeaning: $shortMeaning, ')
          ..write('detailedMeaning: $detailedMeaning, ')
          ..write('commonMistake: $commonMistake, ')
          ..write('sourceReference: $sourceReference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    assetPath,
    shortMeaning,
    detailedMeaning,
    commonMistake,
    sourceReference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoadSign &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.assetPath == this.assetPath &&
          other.shortMeaning == this.shortMeaning &&
          other.detailedMeaning == this.detailedMeaning &&
          other.commonMistake == this.commonMistake &&
          other.sourceReference == this.sourceReference);
}

class RoadSignsCompanion extends UpdateCompanion<RoadSign> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> assetPath;
  final Value<String> shortMeaning;
  final Value<String> detailedMeaning;
  final Value<String?> commonMistake;
  final Value<String?> sourceReference;
  final Value<int> rowid;
  const RoadSignsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.assetPath = const Value.absent(),
    this.shortMeaning = const Value.absent(),
    this.detailedMeaning = const Value.absent(),
    this.commonMistake = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoadSignsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required String assetPath,
    required String shortMeaning,
    required String detailedMeaning,
    this.commonMistake = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       assetPath = Value(assetPath),
       shortMeaning = Value(shortMeaning),
       detailedMeaning = Value(detailedMeaning);
  static Insertable<RoadSign> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? assetPath,
    Expression<String>? shortMeaning,
    Expression<String>? detailedMeaning,
    Expression<String>? commonMistake,
    Expression<String>? sourceReference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (assetPath != null) 'asset_path': assetPath,
      if (shortMeaning != null) 'short_meaning': shortMeaning,
      if (detailedMeaning != null) 'detailed_meaning': detailedMeaning,
      if (commonMistake != null) 'common_mistake': commonMistake,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoadSignsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String>? assetPath,
    Value<String>? shortMeaning,
    Value<String>? detailedMeaning,
    Value<String?>? commonMistake,
    Value<String?>? sourceReference,
    Value<int>? rowid,
  }) {
    return RoadSignsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      assetPath: assetPath ?? this.assetPath,
      shortMeaning: shortMeaning ?? this.shortMeaning,
      detailedMeaning: detailedMeaning ?? this.detailedMeaning,
      commonMistake: commonMistake ?? this.commonMistake,
      sourceReference: sourceReference ?? this.sourceReference,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (assetPath.present) {
      map['asset_path'] = Variable<String>(assetPath.value);
    }
    if (shortMeaning.present) {
      map['short_meaning'] = Variable<String>(shortMeaning.value);
    }
    if (detailedMeaning.present) {
      map['detailed_meaning'] = Variable<String>(detailedMeaning.value);
    }
    if (commonMistake.present) {
      map['common_mistake'] = Variable<String>(commonMistake.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoadSignsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('assetPath: $assetPath, ')
          ..write('shortMeaning: $shortMeaning, ')
          ..write('detailedMeaning: $detailedMeaning, ')
          ..write('commonMistake: $commonMistake, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $QuestionProgressTable questionProgress = $QuestionProgressTable(
    this,
  );
  late final $RoadSignsTable roadSigns = $RoadSignsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    questions,
    questionProgress,
    roadSigns,
  ];
}

typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  required String id,
  required String state,
  required String licenseType,
  required String category,
  required int difficulty,
  required String questionText,
  required String answerA,
  required String answerB,
  required String answerC,
  required int correctAnswerIndex,
  required String explanationShort,
  Value<String?> explanationDetailed,
  Value<String?> illustrationAsset,
  Value<String?> sourceReference,
  Value<int> contentVersion,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<String> id,
  Value<String> state,
  Value<String> licenseType,
  Value<String> category,
  Value<int> difficulty,
  Value<String> questionText,
  Value<String> answerA,
  Value<String> answerB,
  Value<String> answerC,
  Value<int> correctAnswerIndex,
  Value<String> explanationShort,
  Value<String?> explanationDetailed,
  Value<String?> illustrationAsset,
  Value<String?> sourceReference,
  Value<int> contentVersion,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$QuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestionsTable, Question> {
  $$QuestionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuestionProgressTable, List<QuestionProgressItem>>
  _questionProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.questionProgress,
    aliasName: 'questions__id__question_progress__question_id',
  );

  $$QuestionProgressTableProcessedTableManager get questionProgressRefs {
    final manager = $$QuestionProgressTableTableManager(
      $_db,
      $_db.questionProgress,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _questionProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
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

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerA => $composableBuilder(
    column: $table.answerA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerB => $composableBuilder(
    column: $table.answerB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerC => $composableBuilder(
    column: $table.answerC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationShort => $composableBuilder(
    column: $table.explanationShort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationDetailed => $composableBuilder(
    column: $table.explanationDetailed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get illustrationAsset => $composableBuilder(
    column: $table.illustrationAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  Expression<bool> questionProgressRefs(
    Expression<bool> Function($$QuestionProgressTableFilterComposer f) f,
  ) {
    final $$QuestionProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questionProgress,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionProgressTableFilterComposer(
            $db: $db,
            $table: $db.questionProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
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

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerA => $composableBuilder(
    column: $table.answerA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerB => $composableBuilder(
    column: $table.answerB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerC => $composableBuilder(
    column: $table.answerC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationShort => $composableBuilder(
    column: $table.explanationShort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationDetailed => $composableBuilder(
    column: $table.explanationDetailed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get illustrationAsset => $composableBuilder(
    column: $table.illustrationAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get answerA =>
      $composableBuilder(column: $table.answerA, builder: (column) => column);

  GeneratedColumn<String> get answerB =>
      $composableBuilder(column: $table.answerB, builder: (column) => column);

  GeneratedColumn<String> get answerC =>
      $composableBuilder(column: $table.answerC, builder: (column) => column);

  GeneratedColumn<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationShort => $composableBuilder(
    column: $table.explanationShort,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationDetailed => $composableBuilder(
    column: $table.explanationDetailed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get illustrationAsset => $composableBuilder(
    column: $table.illustrationAsset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> questionProgressRefs<T extends Object>(
    Expression<T> Function($$QuestionProgressTableAnnotationComposer a) f,
  ) {
    final $$QuestionProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questionProgress,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.questionProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, $$QuestionsTableReferences),
          Question,
          PrefetchHooks Function({bool questionProgressRefs})
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> licenseType = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String> answerA = const Value.absent(),
                Value<String> answerB = const Value.absent(),
                Value<String> answerC = const Value.absent(),
                Value<int> correctAnswerIndex = const Value.absent(),
                Value<String> explanationShort = const Value.absent(),
                Value<String?> explanationDetailed = const Value.absent(),
                Value<String?> illustrationAsset = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                state: state,
                licenseType: licenseType,
                category: category,
                difficulty: difficulty,
                questionText: questionText,
                answerA: answerA,
                answerB: answerB,
                answerC: answerC,
                correctAnswerIndex: correctAnswerIndex,
                explanationShort: explanationShort,
                explanationDetailed: explanationDetailed,
                illustrationAsset: illustrationAsset,
                sourceReference: sourceReference,
                contentVersion: contentVersion,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String state,
                required String licenseType,
                required String category,
                required int difficulty,
                required String questionText,
                required String answerA,
                required String answerB,
                required String answerC,
                required int correctAnswerIndex,
                required String explanationShort,
                Value<String?> explanationDetailed = const Value.absent(),
                Value<String?> illustrationAsset = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                state: state,
                licenseType: licenseType,
                category: category,
                difficulty: difficulty,
                questionText: questionText,
                answerA: answerA,
                answerB: answerB,
                answerC: answerC,
                correctAnswerIndex: correctAnswerIndex,
                explanationShort: explanationShort,
                explanationDetailed: explanationDetailed,
                illustrationAsset: illustrationAsset,
                sourceReference: sourceReference,
                contentVersion: contentVersion,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuestionsTable, Question>(table),
                  $$QuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({questionProgressRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (questionProgressRefs) db.questionProgress,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (questionProgressRefs)
                    await $_getPrefetchedData<
                      Question,
                      $QuestionsTable,
                      QuestionProgressItem
                    >(
                      currentTable: table,
                      referencedTable: $$QuestionsTableReferences
                          ._questionProgressRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$QuestionsTableReferences(
                            db,
                            table,
                            p0,
                          ).questionProgressRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.questionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, $$QuestionsTableReferences),
      Question,
      PrefetchHooks Function({bool questionProgressRefs})
    >;
typedef $$QuestionProgressTableCreateCompanionBuilder =
    QuestionProgressCompanion Function({
      required String questionId,
      Value<int> timesAnswered,
      Value<int> correctCount,
      Value<int> incorrectCount,
      Value<DateTime?> lastAnsweredAt,
      Value<bool> isBookmarked,
      Value<bool> isMastered,
      Value<int> rowid,
    });
typedef $$QuestionProgressTableUpdateCompanionBuilder =
    QuestionProgressCompanion Function({
      Value<String> questionId,
      Value<int> timesAnswered,
      Value<int> correctCount,
      Value<int> incorrectCount,
      Value<DateTime?> lastAnsweredAt,
      Value<bool> isBookmarked,
      Value<bool> isMastered,
      Value<int> rowid,
    });

final class $$QuestionProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $QuestionProgressTable,
          QuestionProgressItem
        > {
  $$QuestionProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias('question_progress__question_id__questions__id');

  $$QuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<String>('question_id')!;

    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuestionProgressTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionProgressTable> {
  $$QuestionProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get timesAnswered => $composableBuilder(
    column: $table.timesAnswered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAnsweredAt => $composableBuilder(
    column: $table.lastAnsweredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => ColumnFilters(column),
  );

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionProgressTable> {
  $$QuestionProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get timesAnswered => $composableBuilder(
    column: $table.timesAnswered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAnsweredAt => $composableBuilder(
    column: $table.lastAnsweredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionProgressTable> {
  $$QuestionProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get timesAnswered => $composableBuilder(
    column: $table.timesAnswered,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incorrectCount => $composableBuilder(
    column: $table.incorrectCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAnsweredAt => $composableBuilder(
    column: $table.lastAnsweredAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBookmarked => $composableBuilder(
    column: $table.isBookmarked,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMastered => $composableBuilder(
    column: $table.isMastered,
    builder: (column) => column,
  );

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionProgressTable,
          QuestionProgressItem,
          $$QuestionProgressTableFilterComposer,
          $$QuestionProgressTableOrderingComposer,
          $$QuestionProgressTableAnnotationComposer,
          $$QuestionProgressTableCreateCompanionBuilder,
          $$QuestionProgressTableUpdateCompanionBuilder,
          (QuestionProgressItem, $$QuestionProgressTableReferences),
          QuestionProgressItem,
          PrefetchHooks Function({bool questionId})
        > {
  $$QuestionProgressTableTableManager(
    _$AppDatabase db,
    $QuestionProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> questionId = const Value.absent(),
                Value<int> timesAnswered = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> incorrectCount = const Value.absent(),
                Value<DateTime?> lastAnsweredAt = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
                Value<bool> isMastered = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionProgressCompanion(
                questionId: questionId,
                timesAnswered: timesAnswered,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                lastAnsweredAt: lastAnsweredAt,
                isBookmarked: isBookmarked,
                isMastered: isMastered,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questionId,
                Value<int> timesAnswered = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> incorrectCount = const Value.absent(),
                Value<DateTime?> lastAnsweredAt = const Value.absent(),
                Value<bool> isBookmarked = const Value.absent(),
                Value<bool> isMastered = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionProgressCompanion.insert(
                questionId: questionId,
                timesAnswered: timesAnswered,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                lastAnsweredAt: lastAnsweredAt,
                isBookmarked: isBookmarked,
                isMastered: isMastered,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuestionProgressTable, QuestionProgressItem>(
                    table,
                  ),
                  $$QuestionProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (questionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.questionId,
                        referencedTable: $$QuestionProgressTableReferences
                            ._questionIdTable(db),
                        referencedColumn: $$QuestionProgressTableReferences
                            ._questionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuestionProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionProgressTable,
      QuestionProgressItem,
      $$QuestionProgressTableFilterComposer,
      $$QuestionProgressTableOrderingComposer,
      $$QuestionProgressTableAnnotationComposer,
      $$QuestionProgressTableCreateCompanionBuilder,
      $$QuestionProgressTableUpdateCompanionBuilder,
      (QuestionProgressItem, $$QuestionProgressTableReferences),
      QuestionProgressItem,
      PrefetchHooks Function({bool questionId})
    >;
typedef $$RoadSignsTableCreateCompanionBuilder = RoadSignsCompanion Function({
  required String id,
  required String name,
  required String category,
  required String assetPath,
  required String shortMeaning,
  required String detailedMeaning,
  Value<String?> commonMistake,
  Value<String?> sourceReference,
  Value<int> rowid,
});
typedef $$RoadSignsTableUpdateCompanionBuilder = RoadSignsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> category,
  Value<String> assetPath,
  Value<String> shortMeaning,
  Value<String> detailedMeaning,
  Value<String?> commonMistake,
  Value<String?> sourceReference,
  Value<int> rowid,
});

class $$RoadSignsTableFilterComposer
    extends Composer<_$AppDatabase, $RoadSignsTable> {
  $$RoadSignsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetPath => $composableBuilder(
    column: $table.assetPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortMeaning => $composableBuilder(
    column: $table.shortMeaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailedMeaning => $composableBuilder(
    column: $table.detailedMeaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commonMistake => $composableBuilder(
    column: $table.commonMistake,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoadSignsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoadSignsTable> {
  $$RoadSignsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetPath => $composableBuilder(
    column: $table.assetPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortMeaning => $composableBuilder(
    column: $table.shortMeaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailedMeaning => $composableBuilder(
    column: $table.detailedMeaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commonMistake => $composableBuilder(
    column: $table.commonMistake,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoadSignsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoadSignsTable> {
  $$RoadSignsTableAnnotationComposer({
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get assetPath =>
      $composableBuilder(column: $table.assetPath, builder: (column) => column);

  GeneratedColumn<String> get shortMeaning => $composableBuilder(
    column: $table.shortMeaning,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detailedMeaning => $composableBuilder(
    column: $table.detailedMeaning,
    builder: (column) => column,
  );

  GeneratedColumn<String> get commonMistake => $composableBuilder(
    column: $table.commonMistake,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );
}

class $$RoadSignsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoadSignsTable,
          RoadSign,
          $$RoadSignsTableFilterComposer,
          $$RoadSignsTableOrderingComposer,
          $$RoadSignsTableAnnotationComposer,
          $$RoadSignsTableCreateCompanionBuilder,
          $$RoadSignsTableUpdateCompanionBuilder,
          (RoadSign, BaseReferences<_$AppDatabase, $RoadSignsTable, RoadSign>),
          RoadSign,
          PrefetchHooks Function()
        > {
  $$RoadSignsTableTableManager(_$AppDatabase db, $RoadSignsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoadSignsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoadSignsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoadSignsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> assetPath = const Value.absent(),
                Value<String> shortMeaning = const Value.absent(),
                Value<String> detailedMeaning = const Value.absent(),
                Value<String?> commonMistake = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoadSignsCompanion(
                id: id,
                name: name,
                category: category,
                assetPath: assetPath,
                shortMeaning: shortMeaning,
                detailedMeaning: detailedMeaning,
                commonMistake: commonMistake,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required String assetPath,
                required String shortMeaning,
                required String detailedMeaning,
                Value<String?> commonMistake = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoadSignsCompanion.insert(
                id: id,
                name: name,
                category: category,
                assetPath: assetPath,
                shortMeaning: shortMeaning,
                detailedMeaning: detailedMeaning,
                commonMistake: commonMistake,
                sourceReference: sourceReference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoadSignsTable, RoadSign>(table),
                  BaseReferences<_$AppDatabase, $RoadSignsTable, RoadSign>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoadSignsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoadSignsTable,
      RoadSign,
      $$RoadSignsTableFilterComposer,
      $$RoadSignsTableOrderingComposer,
      $$RoadSignsTableAnnotationComposer,
      $$RoadSignsTableCreateCompanionBuilder,
      $$RoadSignsTableUpdateCompanionBuilder,
      (RoadSign, BaseReferences<_$AppDatabase, $RoadSignsTable, RoadSign>),
      RoadSign,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$QuestionProgressTableTableManager get questionProgress =>
      $$QuestionProgressTableTableManager(_db, _db.questionProgress);
  $$RoadSignsTableTableManager get roadSigns =>
      $$RoadSignsTableTableManager(_db, _db.roadSigns);
}
