import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/theme/app_colors.dart';

class ContentInspectorScreen extends ConsumerWidget {
  const ContentInspectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbRepo = ref.watch(databaseRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Content Inspector'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder(
        future: dbRepo.getQuestionsByCategory(
          'Road Rules',
        ), // Get some sample questions
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          final questions = snapshot.data as List;
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              return ListTile(
                title: Text(q.id),
                subtitle: Text('\${q.category} - \${q.reviewStatus}'),
                trailing: Text(q.assetPath ?? 'no asset'),
              );
            },
          );
        },
      ),
    );
  }
}
