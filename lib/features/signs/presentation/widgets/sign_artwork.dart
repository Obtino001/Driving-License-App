import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/study_sign.dart';

class SignArtwork extends StatelessWidget {
  const SignArtwork({super.key, required this.sign, this.size = 118});
  final StudySign sign;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          children: [
            SvgPicture.asset(sign.assetPath, width: 160, height: 160),
            if (sign.id == 'stop')
              const Positioned(
                top: 59,
                left: 19,
                right: 19,
                child: Text(
                  'STOP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 39,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            if (sign.id == 'yield')
              const Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Text(
                  'YIELD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFA9272A),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            if (sign.id == 'speed_25') ...[
              const Positioned(
                top: 28,
                left: 30,
                right: 30,
                child: Text(
                  'SPEED\nLIMIT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF212723),
                    fontSize: 17,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Positioned(
                top: 79,
                left: 30,
                right: 30,
                child: Text(
                  '25',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF212723),
                    fontSize: 48,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
            if (sign.id == 'guide')
              const Positioned(
                top: 51,
                left: 16,
                right: 16,
                child: Text(
                  'EXIT 24',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
          if (sign.id == 'road_work')
            const Positioned(
              top: 49,
              left: 24,
              right: 24,
              child: Text(
                'ROAD\nWORK\nAHEAD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF272924),
                  fontSize: 17,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          if (sign.id == 'railroad') ...[
            const Positioned(
              top: 67,
              left: 28,
              child: Text('R', style: TextStyle(
                color: Color(0xFF252823), fontSize: 24, fontWeight: FontWeight.w900)),
            ),
            const Positioned(
              top: 67,
              right: 28,
              child: Text('R', style: TextStyle(
                color: Color(0xFF252823), fontSize: 24, fontWeight: FontWeight.w900)),
            ),
          ],
              ),
          ],
        ),
      ),
    ),
  );
}
