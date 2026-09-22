import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_common.dart';

/// Home Screen (Beranda)
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan greeting
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Pagi 🌅',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: TaraColors.textDeepIndigo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Semoga hari Anda penuh ketenangan',
                    style: TextStyle(
                      fontSize: 14,
                      color: TaraColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Daily Check-in Card
              TaraCard(
                padding: const EdgeInsets.all(20),
                onTap: () {
                  context.push('/check-in');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Check-in Harian',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: TaraColors.textDeepIndigo,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: TaraColors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Pilih mood Anda hari ini',
                      style: TextStyle(
                        fontSize: 13,
                        color: TaraColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _MoodEmoji('😢'),
                        _MoodEmoji('😔'),
                        _MoodEmoji('😐'),
                        _MoodEmoji('😊'),
                        _MoodEmoji('😄'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Taman Pikiran Card
              TaraCard(
                padding: const EdgeInsets.all(20),
                onTap: () {
                  context.push('/taman-pikiran');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🌱 Taman Pikiran Anda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: TaraColors.textDeepIndigo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tanaman Anda sedang berkembang',
                      style: TextStyle(
                        fontSize: 13,
                        color: TaraColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Simple progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: 0.6,
                        minHeight: 8,
                        backgroundColor: TaraColors.divider,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          TaraColors.green.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '6 aktivitas - Tahap Bertumbuh',
                      style: TextStyle(
                        fontSize: 12,
                        color: TaraColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              const Text(
                'Aksi Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: TaraColors.textDeepIndigo,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _QuickActionCard(
                    icon: Icons.chat_outlined,
                    label: 'Cerita ke TARA',
                    color: TaraColors.blue,
                    onTap: () {
                      context.go('/chat');
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.book_outlined,
                    label: 'Jurnal',
                    color: TaraColors.purple,
                    onTap: () {
                      context.go('/journal');
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.spa_outlined,
                    label: 'TARA Space',
                    color: TaraColors.green,
                    onTap: () {
                      context.push('/tara-space');
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.videocam_outlined,
                    label: 'BISINDO',
                    color: TaraColors.blue,
                    onTap: () {
                      context.go('/bisindo');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tip Harian
              TaraCard(
                backgroundColor: TaraColors.green.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: TaraColors.green,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tip Harian',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: TaraColors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Luangkan 5 menit untuk bernapas dalam-dalam. Tarik napas selama 4 detik, tahan selama 4 detik, dan hembuskan selama 4 detik.',
                      style: TextStyle(
                        fontSize: 13,
                        color: TaraColors.textDeepIndigo,
                        height: 1.5,
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
}

class _MoodEmoji extends StatelessWidget {
  final String emoji;

  const _MoodEmoji(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: TaraColors.bgCoolWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
