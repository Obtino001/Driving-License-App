import 'package:drift/drift.dart';

@DataClassName('Question')
class Questions extends Table {
  TextColumn get id => text()();
  TextColumn get state => text()();
  TextColumn get licenseType => text()();
  TextColumn get category => text()();
  IntColumn get difficulty => integer()();
  TextColumn get questionText => text()();
  TextColumn get answerA => text()();
  TextColumn get answerB => text()();
  TextColumn get answerC => text()();
  IntColumn get correctAnswerIndex => integer()();
  TextColumn get explanationShort => text()();
  TextColumn get explanationDetailed => text().nullable()();
  TextColumn get illustrationAsset => text().nullable()();
  TextColumn get sourceReference => text().nullable()();
  IntColumn get contentVersion => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('QuestionProgressItem')
class QuestionProgress extends Table {
  TextColumn get questionId => text().references(Questions, #id)();
  IntColumn get timesAnswered => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get incorrectCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAnsweredAt => dateTime().nullable()();
  BoolColumn get isBookmarked => boolean().withDefault(const Constant(false))();
  BoolColumn get isMastered => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {questionId};
}

@DataClassName('RoadSign')
class RoadSigns extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get assetPath => text()();
  TextColumn get shortMeaning => text()();
  TextColumn get detailedMeaning => text()();
  TextColumn get commonMistake => text().nullable()();
  TextColumn get sourceReference => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
