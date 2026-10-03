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

  Future<double?> getCategoryAccuracy(String category) async {
    final rows = await (_db.select(_db.questionProgress).join([
      innerJoin(
        _db.questions,
        _db.questions.id.equalsExp(_db.questionProgress.questionId),
      ),
    ])..where(_db.questions.category.equals(category))).get();
    var correct = 0;
    var answered = 0;
    for (final row in rows) {
      final progress = row.readTable(_db.questionProgress);
      correct += progress.correctCount;
      answered += progress.timesAnswered;
    }
    return answered == 0 ? null : correct / answered;
  }

  Future<void> resetProgress() async {
    await _db.delete(_db.questionProgress).go();
  }

  // MOCK EXAM METHODS

  Future<ExamSession> createExamSession({
    required String profileId,
    required String state,
    required String licenseType,
    required int passingRequirement,
    required List<Question> questions,
  }) async {
    final sessionId = 'exam_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    return await _db.transaction(() async {
      final session = ExamSession(
        id: sessionId,
        profileId: profileId,
        state: state,
        licenseType: licenseType,
        startedAt: now,
        completedAt: null,
        status: 'in_progress',
        score: null,
        passingRequirement: passingRequirement,
        questionCount: questions.length,
      );

      await _db.into(_db.examSessions).insert(session);

      var index = 0;
      for (final q in questions) {
        await _db.into(_db.examSessionQuestions).insert(
          ExamSessionQuestion(
            sessionId: sessionId,
            questionId: q.id,
            questionIndex: index,
            selectedAnswerIndex: null,
            correctAnswerIndex: q.correctAnswerIndex,
            isFlagged: false,
            isCorrect: null,
          ),
        );
        index++;
      }
      return session;
    });
  }

  Future<void> updateExamSessionAnswer(
      String sessionId, String questionId, int? selectedAnswerIndex) async {
    await (_db.update(_db.examSessionQuestions)
          ..where((q) =>
              q.sessionId.equals(sessionId) & q.questionId.equals(questionId)))
        .write(
      ExamSessionQuestionsCompanion(
        selectedAnswerIndex: Value(selectedAnswerIndex),
      ),
    );
  }

  Future<void> updateExamSessionFlag(
      String sessionId, String questionId, bool isFlagged) async {
    await (_db.update(_db.examSessionQuestions)
          ..where((q) =>
              q.sessionId.equals(sessionId) & q.questionId.equals(questionId)))
        .write(
      ExamSessionQuestionsCompanion(
        isFlagged: Value(isFlagged),
      ),
    );
  }

  Future<List<ExamSessionQuestion>> getExamSessionQuestions(String sessionId) async {
    final query = _db.select(_db.examSessionQuestions)
      ..where((q) => q.sessionId.equals(sessionId))
      ..orderBy([(q) => OrderingTerm(expression: q.questionIndex, mode: OrderingMode.asc)]);
    return query.get();
  }

  Future<List<Question>> getQuestionsForSession(String sessionId) async {
    final query = _db.select(_db.questions).join([
      innerJoin(
        _db.examSessionQuestions,
        _db.examSessionQuestions.questionId.equalsExp(_db.questions.id),
      ),
    ])
      ..where(_db.examSessionQuestions.sessionId.equals(sessionId))
      ..orderBy([OrderingTerm(expression: _db.examSessionQuestions.questionIndex, mode: OrderingMode.asc)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(_db.questions)).toList();
  }

  Future<ExamSession?> getInProgressSession() async {
    return (_db.select(_db.examSessions)
          ..where((s) => s.status.equals('in_progress'))
          ..orderBy([
            (s) => OrderingTerm(expression: s.startedAt, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> finishExamSession(String sessionId, int score) async {
    await _db.transaction(() async {
      // 1. Update session status and score
      await (_db.update(_db.examSessions)..where((s) => s.id.equals(sessionId)))
          .write(
        ExamSessionsCompanion(
          status: const Value('completed'),
          completedAt: Value(DateTime.now()),
          score: Value(score),
        ),
      );

      // 2. Evaluate each question and update Mistake Bank idempotently
      final questions = await getExamSessionQuestions(sessionId);
      for (final q in questions) {
        final isCorrect = q.selectedAnswerIndex == q.correctAnswerIndex;
        // Update snapshot
        await (_db.update(_db.examSessionQuestions)
              ..where((esq) =>
                  esq.sessionId.equals(sessionId) & esq.questionId.equals(q.questionId)))
            .write(
          ExamSessionQuestionsCompanion(
            isCorrect: Value(isCorrect),
          ),
        );
        // Only record if answered
        if (q.selectedAnswerIndex != null) {
          await recordAnswer(q.questionId, isCorrect);
        }
      }
    });
  }

  Future<int> getMockExamsCount() async {
    final countExp = _db.examSessions.id.count();
    final query = _db.selectOnly(_db.examSessions)
      ..addColumns([countExp])
      ..where(_db.examSessions.status.equals('completed'));
    return (await query.getSingle()).read(countExp) ?? 0;
  }

  Future<int?> getLatestMockScore() async {
    final row = await (_db.select(_db.examSessions)
          ..where((s) => s.status.equals('completed'))
          ..orderBy([(s) => OrderingTerm(expression: s.completedAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    return row?.score;
  }

  Future<int?> getBestMockScore() async {
    final row = await (_db.select(_db.examSessions)
          ..where((s) => s.status.equals('completed'))
          ..orderBy([(s) => OrderingTerm(expression: s.score, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
    return row?.score;
  }
}
