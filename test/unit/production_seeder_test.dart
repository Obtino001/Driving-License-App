import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:driving_license_app/core/data/local_database.dart';
import 'package:driving_license_app/core/content/production_seeder.dart';

class FakeLocalDatabase implements LocalDatabase {
  final Database _fakeDb;
  FakeLocalDatabase(this._fakeDb);
  
  @override
  Future<Database> get database async => _fakeDb;
  
  @override
  Future<void> clearUserData() async {}
}

class FakeDatabase implements Database {
  int inserts = 0;
  int updates = 0;
  bool shouldInsertFail = false;

  @override
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action, {bool? exclusive}) async {
    return await action(FakeTransaction(this) as Transaction);
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTransaction implements Transaction {
  final FakeDatabase db;
  FakeTransaction(this.db);

  @override
  Future<int> insert(String table, Map<String, Object?> values, {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) async {
    if (db.shouldInsertFail) return 0;
    db.inserts++;
    return 1;
  }

  @override
  Future<int> update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm}) async {
    db.updates++;
    return 1;
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductionSeeder Tests', () {
    late FakeDatabase fakeDb;
    late FakeLocalDatabase localDb;
    late ProductionSeeder seeder;

    setUp(() {
      fakeDb = FakeDatabase();
      localDb = FakeLocalDatabase(fakeDb);
      seeder = ProductionSeeder(localDb);
    });

    test('Should ONLY import VERIFIED questions and use INSERT IGNORE', () async {
      final jsonList = [
        {
          "id": "q1",
          "text": "Review question",
          "options": ["A", "B", "C", "D"],
          "correctIndex": 0,
          "explanation": "Because.",
          "category": "Speed Limits",
          "verificationStatus": "REVIEW"
        },
        {
          "id": "q2",
          "text": "Verified question",
          "options": ["A", "B", "C", "D"],
          "correctIndex": 0,
          "explanation": "Because.",
          "category": "Speed Limits",
          "verificationStatus": "VERIFIED"
        }
      ];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return const StringCodec().encodeMessage(jsonEncode(jsonList));
      });

      fakeDb.shouldInsertFail = false; // insert succeeds

      final imported = await seeder.importVerifiedQuestions('mock_path.json');
      expect(imported, 1);
      expect(fakeDb.inserts, 1);
      expect(fakeDb.updates, 0); // shouldn't update if insert succeeds
    });

    test('Should UPDATE existing questions (idempotency)', () async {
      final jsonList = [
        {
          "id": "q2",
          "text": "Verified question updated",
          "options": ["A", "B", "C", "D"],
          "correctIndex": 0,
          "explanation": "Because.",
          "category": "Speed Limits",
          "verificationStatus": "VERIFIED"
        }
      ];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return const StringCodec().encodeMessage(jsonEncode(jsonList));
      });

      fakeDb.shouldInsertFail = true; // insert returns 0 (existing)

      final imported = await seeder.importVerifiedQuestions('mock_path.json');
      expect(imported, 1);
      
      expect(fakeDb.inserts, 0);
      expect(fakeDb.updates, 1); // should fallback to update
    });
  });
}
