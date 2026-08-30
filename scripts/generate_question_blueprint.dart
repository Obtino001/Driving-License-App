import 'dart:convert';
import 'dart:io';

void main() async {
  final rulesFile = File('assets/data/us/research/ca/rules.json');
  final signsFile = File('assets/data/us/research/ca/road_signs.json');
  final priorityFile = File('assets/data/us/research/ca/topic_priority.json');
  
  if (!rulesFile.existsSync() || !signsFile.existsSync() || !priorityFile.existsSync()) {
    print('Missing research files.');
    return;
  }

  final rulesJson = jsonDecode(await rulesFile.readAsString()) as List;
  final signsJson = jsonDecode(await signsFile.readAsString()) as List;
  final priorityJson = jsonDecode(await priorityFile.readAsString()) as List;

  final Map<String, String> topicPriorities = {};
  for (var p in priorityJson) {
    topicPriorities[p['topic']] = p['priority'];
  }

  final Map<String, dynamic> blueprint = {
    "stateId": "ca",
    "targetQuestions": 0,
    "rulesBlueprint": <Map<String, dynamic>>[],
    "signsBlueprint": <Map<String, dynamic>>[]
  };

  int totalQuestions = 0;

  for (var rule in rulesJson) {
    String ruleId = rule['ruleId'];
    String topic = rule['topic'];
    String ruleSummary = rule['ruleSummary'];
    String? details = rule['details'];
    String? exceptions = rule['exceptions'];
    
    String priority = topicPriorities[topic] ?? "LOW_PRIORITY";
    
    List<Map<String, String>> angles = [];
    
    // Direct angle (almost all have this)
    angles.add({
      "type": "standard_mcq",
      "difficulty": "easy",
      "description": "Directly test the core requirement of the rule."
    });

    // Exception angle
    if (exceptions != null && exceptions.isNotEmpty) {
      angles.add({
        "type": "exception",
        "difficulty": "hard",
        "description": "Test the specific exception: \$exceptions"
      });
    }

    // Numerical angle
    final numRegex = RegExp(r'\b(\d+%|mph|feet|seconds|inches|years|pounds|miles|days)\b', caseSensitive: false);
    if (numRegex.hasMatch(ruleSummary) || (details != null && numRegex.hasMatch(details))) {
      angles.add({
        "type": "numerical",
        "difficulty": "medium",
        "description": "Test numerical memory while preserving the condition."
      });
    }

    // Scenario angle
    if (['Right of Way', 'Intersections', 'Lane Changes', 'Turns', 'Safe Driving', 'Defensive Driving', 'Sharing the Road', 'Parking'].contains(topic)) {
      angles.add({
        "type": "scenario",
        "difficulty": "medium",
        "description": "Place the driver in a scenario requiring them to apply this rule."
      });
      // Maybe a harder scenario for HIGH priority
      if (priority == 'HIGH_PRIORITY') {
        angles.add({
          "type": "scenario",
          "difficulty": "hard",
          "description": "A complex scenario combining this rule with another common road condition."
        });
      }
    }

    // Determine counts based on priority
    int maxQuestions = 2;
    if (priority == 'HIGH_PRIORITY') {
      maxQuestions = angles.length > 3 ? 5 : 4;
    } else if (priority == 'MEDIUM_PRIORITY') {
      maxQuestions = angles.length > 2 ? 3 : 2;
    } else {
      maxQuestions = 2;
    }
    
    // Cap angles to maxQuestions
    if (angles.length > maxQuestions) {
      angles = angles.sublist(0, maxQuestions);
    }
    
    // Some very simple rules shouldn't have too many questions
    if (angles.length == 1) maxQuestions = 1;

    blueprint['rulesBlueprint']!.add({
      "ruleId": ruleId,
      "priority": priority,
      "recommendedCount": angles.length,
      "angles": angles
    });
    
    totalQuestions += angles.length;
  }

  for (var sign in signsJson) {
    String signId = sign['signResearchId'];
    
    List<Map<String, String>> angles = [
      {
        "type": "sign_question",
        "difficulty": "easy",
        "description": "Identify the meaning of the sign."
      },
      {
        "type": "sign_question",
        "difficulty": "medium",
        "description": "Identify the required driver action: \${sign['driverAction']}"
      }
    ];

    blueprint['signsBlueprint']!.add({
      "signResearchId": signId,
      "recommendedCount": angles.length,
      "angles": angles
    });
    
    totalQuestions += angles.length;
  }

  blueprint['targetQuestions'] = totalQuestions;

  final outDir = Directory('assets/data/us/ca');
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  final encoder = JsonEncoder.withIndent('  ');
  await File('assets/data/us/ca/question_blueprint.json').writeAsString(encoder.convert(blueprint));
  print('Generated blueprint for \$totalQuestions questions.');
}
