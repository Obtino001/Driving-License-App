class StudySign {
  const StudySign({
    required this.id,
    required this.name,
    required this.category,
    required this.meaning,
    required this.commonMistake,
    required this.assetPath,
  });
  final String id;
  final String name;
  final String category;
  final String meaning;
  final String commonMistake;
  final String assetPath;
}

const studySigns = <StudySign>[
  StudySign(
    id: 'stop',
    name: 'Stop',
    category: 'Regulatory',
    meaning: 'Come to a complete stop before the limit line or crosswalk. Yield before proceeding.',
    commonMistake: 'Rolling through when the intersection appears clear.',
    assetPath: 'assets/signs/stop.svg',
  ),
  StudySign(
    id: 'yield',
    name: 'Yield',
    category: 'Regulatory',
    meaning: 'Slow down and give the right of way to traffic and people already in the intersection.',
    commonMistake: 'Treating yield as permission to enter without checking.',
    assetPath: 'assets/signs/yield.svg',
  ),
  StudySign(
    id: 'speed_25',
    name: 'Speed Limit 25',
    category: 'Regulatory',
    meaning: 'Do not exceed 25 mph where this speed limit is posted.',
    commonMistake: 'Treating the posted limit as a target in poor conditions.',
    assetPath: 'assets/signs/speed_25.svg',
  ),
  StudySign(
    id: 'merge',
    name: 'Merging Traffic',
    category: 'Warning',
    meaning: 'Traffic from another roadway joins your lane ahead. Adjust speed and leave space.',
    commonMistake: 'Waiting until the merge point to make room.',
    assetPath: 'assets/signs/merge.svg',
  ),
  StudySign(
    id: 'guide',
    name: 'Direction Guide',
    category: 'Guide',
    meaning: 'Green guide signs show routes, destinations, and directions.',
    commonMistake: 'Making a sudden lane change after reading the sign late.',
    assetPath: 'assets/signs/guide.svg',
  ),
  StudySign(
    id: 'road_work',
    name: 'Road Work Ahead',
    category: 'Construction',
    meaning: 'Expect workers, changed lanes, and slower traffic ahead.',
    commonMistake: 'Failing to slow down before reaching the work zone.',
    assetPath: 'assets/signs/road_work.svg',
  ),
  StudySign(
    id: 'railroad',
    name: 'Railroad Crossing',
    category: 'Railroad',
    meaning:
        'A railroad crossing is ahead. Look, listen, and be ready to stop.',
    commonMistake: 'Crossing when signals are active or barriers are lowering.',
    assetPath: 'assets/signs/railroad.svg',
  ),
];
