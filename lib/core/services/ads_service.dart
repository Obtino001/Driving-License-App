library;

import 'package:flutter/material.dart';

/// Abstract service for handling advertisements.
/// 
/// This interface allows swapping between AdMob, AppLovin, or IronSource.
abstract class AdsService {
  /// Initializes the ad SDK.
  Future<void> initialize();

  /// Attempts to show an interstitial ad (e.g., at the end of a test).
  /// If the ad isn't ready or fails, this should quietly return so the
  /// user flow is not interrupted.
  Future<void> showInterstitialAd(BuildContext context);
}

/// A mock implementation for development that just prints to the console
/// or shows a snackbar instead of a real ad.
class MockAdsService implements AdsService {
  @override
  Future<void> initialize() async {
    debugPrint('MockAdsService: Initialized');
  }

  @override
  Future<void> showInterstitialAd(BuildContext context) async {
    debugPrint('MockAdsService: Showing Interstitial Ad');
    
    // Simulate an ad display with a brief full-screen dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _MockInterstitialDialog(),
    );
  }
}

class _MockInterstitialDialog extends StatefulWidget {
  const _MockInterstitialDialog();

  @override
  State<_MockInterstitialDialog> createState() => _MockInterstitialDialogState();
}

class _MockInterstitialDialogState extends State<_MockInterstitialDialog> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    while (_countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _countdown--);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black87,
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Placeholder Interstitial Ad\n\nSupport the developer by upgrading to Premium!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          if (_countdown <= 0)
            Positioned(
              top: 48,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
              ),
            )
          else
            Positioned(
              top: 60,
              right: 24,
              child: Text(
                '$_countdown',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }
}
