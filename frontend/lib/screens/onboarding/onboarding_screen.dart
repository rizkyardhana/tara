import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';

/// Onboarding Screen - 3 slides
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Kenali Perasaanmu',
      description:
          'Mulai dengan memahami perasaan Anda setiap hari melalui check-in harian yang sederhana dan mendukung.',
      icon: Icons.sentiment_satisfied_alt,
      color: TaraColors.purple,
    ),
    OnboardingPage(
      title: 'Cerita ke TARA',
      description:
          'Berbagi cerita dan pikiran Anda dengan TARA, AI companion yang selalu siap mendengarkan tanpa menghakimi.',
      icon: Icons.chat_bubble_outline,
      color: TaraColors.blue,
    ),
    OnboardingPage(
      title: 'Dukungan Aksesibel BISINDO',
      description:
          'Akses perpustakaan BISINDO untuk pembelajaran bahasa isyarat dan dukungan visual yang inklusif.',
      icon: Icons.videocam_outlined,
      color: TaraColors.green,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: _pages
                  .map((page) => _OnboardingPageWidget(page: page))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      width: _currentPage == index ? 32 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? TaraColors.blue
                            : TaraColors.divider,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Buttons
                if (_currentPage == _pages.length - 1)
                  TaraGradientButton(
                    label: 'Mulai Sekarang',
                    onPressed: () {
                      context.go('/login');
                    },
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TaraGhostButton(
                          label: 'Lewati',
                          onPressed: () {
                            context.go('/login');
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TaraSolidButton(
                          label: 'Lanjut',
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: page.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Icon(
            page.icon,
            size: 60,
            color: page.color,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: TaraColors.textDeepIndigo,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                page.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: TaraColors.textMuted,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
