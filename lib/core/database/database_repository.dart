import 'package:drift/drift.dart';

import 'app_database.dart';

class DatabaseRepository {
  final AppDatabase _db;

  DatabaseRepository(this._db);

  Future<List<Question>> getQuestionsByCategory(String category) {
    return (_db.select(
      _db.questions,
    )..where((q) => q.category.equals(category))).get();
  }

  Future<QuestionProgressItem?> getProgress(String questionId) {
    return (_db.select(
      _db.questionProgress,
    )..where((p) => p.questionId.equals(questionId))).getSingleOrNull();
  }

  Future<void> recordAnswer(String questionId, bool isCorrect) async {
    return _db.transaction(() async {
      final progress = await getProgress(questionId);
      final now = DateTime.now();

      if (progress == null) {
        await _db
            .into(_db.questionProgress)
            .insert(
              QuestionProgressCompanion.insert(
                questionId: questionId,
                timesAnswered: const Value(1),
                correctCount: Value(isCorrect ? 1 : 0),
                incorrectCount: Value(isCorrect ? 0 : 1),
                lastAnsweredAt: Value(now),
              ),
            );
      } else {
        final newCorrect = progress.correctCount + (isCorrect ? 1 : 0);
        final newIncorrect = progress.incorrectCount + (isCorrect ? 0 : 1);

        // Lightweight mastery logic: if they answered correctly more than they got it wrong
        // and have answered it correctly recently, they might be mastering it.
        // For simplicity: mastered if correctCount > incorrectCount and correctCount >= 2.
        final isMastered = newCorrect > newIncorrect && newCorrect >= 2;

        await (_db.update(
          _db.questionProgress,
        )..where((p) => p.questionId.equals(questionId))).write(
          QuestionProgressCompanion(
            timesAnswered: Value(progress.timesAnswered + 1),
            correctCount: Value(newCorrect),
            incorrectCount: Value(newIncorrect),
            lastAnsweredAt: Value(now),
            isMastered: Value(isMastered),
          ),
        );
      }
    });
  }

  Future<List<Question>> getMistakeBank() async {
    // Return questions where incorrectCount > 0 and not mastered
    final query =
        _db.select(_db.questions).join([
          innerJoin(
            _db.questionProgress,
            _db.questionProgress.questionId.equalsExp(_db.questions.id),
          ),
        ])..where(
          _db.questionProgress.incorrectCount.isBiggerThanValue(0) &
              _db.questionProgress.isMastered.equals(false),
        );

    final rows = await query.get();
    return rows.map((row) => row.readTable(_db.questions)).toList();
  }

  Future<int> getMistakeBankCount() async {
    final countExp = _db.questionProgress.questionId.count();
    final query = _db.selectOnly(_db.questionProgress)
      ..addColumns([countExp])
      ..where(
        _db.questionProgress.incorrectCount.isBiggerThanValue(0) &
            _db.questionProgress.isMastered.equals(false),
      );

    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  /// Distinct questions whose most recent answer happened today.
  Future<int> getTodayQuestionCount() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final count = _db.questionProgress.questionId.count();
    final query = _db.selectOnly(_db.questionProgress)
      ..addColumns([count])
      ..where(
        _db.questionProgress.lastAnsweredAt.isBiggerOrEqualValue(start) &
            _db.questionProgress.lastAnsweredAt.isSmallerThanValue(end),
      );
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<Map<String, int>> getCategoryProgress(String category) async {
    final allQuestionsQuery = _db.selectOnly(_db.questions)
      ..addColumns([_db.questions.id.count()])
      ..where(_db.questions.category.equals(category));
    final allCount =
        (await allQuestionsQuery.getSingle()).read(_db.questions.id.count()) ??
        0;

    final completedQuery =
        _db.selectOnly(_db.questions).join([
            innerJoin(
              _db.questionProgress,
              _db.questionProgress.questionId.equalsExp(_db.questions.id),
            ),
          ])
          ..addColumns([_db.questions.id.count()])
          ..where(
            _db.questions.category.equals(category) &
                _db.questionProgress.timesAnswered.isBiggerThanValue(0),
          );
    final completedCount =
        (await completedQuery.getSingle()).read(_db.questions.id.count()) ?? 0;

    return {'total': allCount, 'completed': completedCount};
  }
}
