import 'dart:math' as math;
import 'package:flutter/material.dart';

class NeonAppIcon extends StatelessWidget {
  const NeonAppIcon({super.key, this.size = 1024});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _NeonAppIconPainter()),
    );
  }
}

class _NeonAppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment.center,
          radius: 0.85,
          colors: [Color(0xFF241044), Color(0xFF0D0618), Color(0xFF020207)],
        ).createShader(Offset.zero & size),
    );

    // Subtle neon grid
    final gridPaint = Paint()
      ..color = const Color(0xFF9C4DFF).withValues(alpha: .10)
      ..strokeWidth = size.width * .002;

    for (double x = 0; x <= size.width; x += size.width / 8) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += size.height / 8) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Neon border
    final border = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .035,
        size.height * .035,
        size.width * .93,
        size.height * .93,
      ),
      Radius.circular(size.width * .15),
    );

    canvas.drawRRect(
      border,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .018
        ..color = const Color(0xFF8A2BFF).withValues(alpha: .30)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
    );

    canvas.drawRRect(
      border,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .009
        ..color = const Color(0xFF42E8FF),
    );

    // Bricks
    _brick(canvas, size, .22, .19, const Color(0xFF42E8FF));
    _brick(canvas, size, .40, .19, const Color(0xFFB83CFF));
    _brick(canvas, size, .58, .19, const Color(0xFFFF3EA5));
    _brick(canvas, size, .76, .19, const Color(0xFFFFD447));

    _brick(canvas, size, .31, .29, const Color(0xFFB83CFF));
    _brick(canvas, size, .49, .29, const Color(0xFF42E8FF));
    _brick(canvas, size, .67, .29, const Color(0xFFFF3EA5));

    // Explosive brick
    _explosiveBrick(canvas, size, .76, .29);

    // Ball trail
    final ballX = size.width * .50;
    final ballY = size.height * .53;

    final trailPaint = Paint()
      ..color = const Color(0xFF42E8FF).withValues(alpha: .28)
      ..strokeWidth = size.width * .035
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawLine(
      Offset(ballX - size.width * .16, ballY + size.height * .13),
      Offset(ballX, ballY),
      trailPaint,
    );

    // Ball outer glow
    canvas.drawCircle(
      Offset(ballX, ballY),
      size.width * .115,
      Paint()
        ..color = const Color(0xFF42E8FF).withValues(alpha: .25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28),
    );

    // Ball
    canvas.drawCircle(
      Offset(ballX, ballY),
      size.width * .075,
      Paint()
        ..shader =
            const RadialGradient(
              colors: [Colors.white, Color(0xFFB9F9FF), Color(0xFF42E8FF)],
            ).createShader(
              Rect.fromCircle(
                center: Offset(ballX, ballY),
                radius: size.width * .075,
              ),
            ),
    );

    // Ball highlight
    canvas.drawCircle(
      Offset(ballX - size.width * .022, ballY - size.height * .025),
      size.width * .018,
      Paint()..color = Colors.white,
    );

    // Paddle
    final paddleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * .50, size.height * .76),
        width: size.width * .48,
        height: size.height * .075,
      ),
      Radius.circular(size.width * .035),
    );

    canvas.drawRRect(
      paddleRect,
      Paint()
        ..color = const Color(0xFF42E8FF).withValues(alpha: .35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28),
    );

    canvas.drawRRect(
      paddleRect,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF42E8FF), Color(0xFFB83CFF), Color(0xFFFF3EA5)],
        ).createShader(paddleRect.outerRect),
    );

    // Paddle inner highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        paddleRect.outerRect.deflate(size.width * .012),
        Radius.circular(size.width * .025),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .008
        ..color = Colors.white.withValues(alpha: .8),
    );

    // Small impact sparks
    for (int i = 0; i < 12; i++) {
      final angle = i * math.pi * 2 / 12;
      final start = Offset(
        ballX + math.cos(angle) * size.width * .10,
        ballY + math.sin(angle) * size.height * .10,
      );

      final end = Offset(
        ballX + math.cos(angle) * size.width * .135,
        ballY + math.sin(angle) * size.height * .135,
      );

      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = const Color(0xFF42E8FF)
          ..strokeWidth = size.width * .006
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _brick(Canvas canvas, Size size, double x, double y, Color color) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * x, size.height * y),
        width: size.width * .14,
        height: size.height * .065,
      ),
      Radius.circular(size.width * .018),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..color = color.withValues(alpha: .30)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    canvas.drawRRect(rect, Paint()..color = color);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect.outerRect.deflate(size.width * .008),
        Radius.circular(size.width * .012),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * .006
        ..color = Colors.white.withValues(alpha: .65),
    );
  }

  void _explosiveBrick(Canvas canvas, Size size, double x, double y) {
    _brick(canvas, size, x, y, const Color(0xFFFF6B2C));

    final center = Offset(size.width * x, size.height * y);

    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * .006
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center + Offset(-10, -10), center + Offset(10, 10), p);

    canvas.drawLine(center + Offset(10, -10), center + Offset(-10, 10), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
