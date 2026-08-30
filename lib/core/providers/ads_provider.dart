library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ads_service.dart';

/// Provides the singleton instance of the Ads service.
final adsServiceProvider = Provider<AdsService>((ref) {
  return MockAdsService()..initialize();
});
