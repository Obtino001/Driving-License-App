import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';
import 'initial_data.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Questions, QuestionProgress, RoadSigns, ExamSessions, ExamSessionQuestions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await batch((batch) {
          batch.insertAll(questions, getInitialQuestions());
        });
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(examSessions);
          await m.createTable(examSessionQuestions);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'dmv_practice.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
