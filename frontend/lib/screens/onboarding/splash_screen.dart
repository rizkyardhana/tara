import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';

/// Splash Screen - TARA logo + tagline
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _brandOpacity;
  late Animation<Offset> _brandSlide;
  late Animation<double> _quoteOpacity;
  late Animation<Offset> _quoteSlide;
  late Animation<double> _actionOpacity;
  late Animation<Offset> _actionSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    final logoCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.48, curve: Curves.easeOutCubic),
    );
    _logoScale = Tween<double>(begin: 0.88, end: 1).animate(logoCurve);
    _logoOpacity = logoCurve;

    final brandCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.58, curve: Curves.easeOutCubic),
    );
    _brandOpacity = brandCurve;
    _brandSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(brandCurve);

    final quoteCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.38, 0.74, curve: Curves.easeOutCubic),
    );
    _quoteOpacity = quoteCurve;
    _quoteSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(quoteCurve);

    final actionCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.58, 0.92, curve: Curves.easeOutCubic),
    );
    _actionOpacity = actionCurve;
    _actionSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(actionCurve);

    _controller.forward();

    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: TaraColors.authBackgroundGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              const IgnorePointer(
                child: CustomPaint(painter: _SplashPainter()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
                child: Column(
                  children: [
                    const Spacer(flex: 3),
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: _buildLogo(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeTransition(
                      opacity: _brandOpacity,
                      child: SlideTransition(
                        position: _brandSlide,
                        child: Column(
                          children: [
                            const Text(
                              'TARA',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: TaraColors.authInk,
                                height: 0.95,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'TULI AKSES RUANG AMAN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: TaraColors.authAccent,
                              ),
                            ),
                            const SizedBox(height: 28),
                            _buildPageIndicator(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 42),
                    FadeTransition(
                      opacity: _quoteOpacity,
                      child: SlideTransition(
                        position: _quoteSlide,
                        child: const Text(
                          '"Ruang aman untuk didengar, dipahami, dan\nditemani."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.55,
                            fontStyle: FontStyle.italic,
                            color: TaraColors.authMuted,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 4),
                    FadeTransition(
                      opacity: _actionOpacity,
                      child: SlideTransition(
                        position: _actionSlide,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/onboarding'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TaraColors.authAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'AI Wellbeing · Komunitas Tuli',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 176,
      height: 176,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: TaraColors.authBorder),
        boxShadow: [
          BoxShadow(
            color: TaraColors.authAccent.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: ClipOval(
        child: Image.asset(
          'assets/images/WhatsApp Image 2026-09-06 at 01.43.08.jpeg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 2,
          color: TaraColors.authAccent.withValues(alpha: 0.24),
        ),
        const SizedBox(width: 12),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: TaraColors.authAccent,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 56,
          height: 2,
          color: TaraColors.authAccent.withValues(alpha: 0.24),
        ),
      ],
    );
  }
}

class _SplashPainter extends CustomPainter {
  const _SplashPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.39);
    final ringPaint = Paint()
      ..color = TaraColors.authAccent.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, size.width * 0.29, ringPaint);
    canvas.drawCircle(
      center,
      size.width * 0.20,
      ringPaint..color = TaraColors.authAccent.withValues(alpha: 0.08),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
