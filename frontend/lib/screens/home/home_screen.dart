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
      body: TaraPastelBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/WhatsApp Image 2026-09-06 at 01.43.08.jpeg',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: TaraColors.textDeepIndigo,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Apa yang kamu rasakan hari ini?',
                            style: TextStyle(
                              fontSize: 14,
                              color: TaraColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Buka profil',
                      onPressed: () => context.go('/profile'),
                      icon: const Icon(Icons.account_circle_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

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
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFFF0EBFC),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.spa_outlined,
                                color: TaraColors.authAccent,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Check-in harian',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: TaraColors.textDeepIndigo,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: TaraColors.authAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kenali suasana hati dan kebutuhanmu saat ini.',
                        style: TextStyle(
                          fontSize: 13,
                          color: TaraColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Text(
                            'Mulai check-in',
                            style: TextStyle(
                              color: TaraColors.authAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: TaraColors.authAccent,
                          ),
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
                        'Taman Pikiran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: TaraColors.textDeepIndigo,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bangun kebiasaan kecil untuk merawat dirimu.',
                        style: TextStyle(
                          fontSize: 13,
                          color: TaraColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                const Text(
                  'Layanan lainnya',
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
                      color: TaraColors.authAccent,
                      onTap: () {
                        context.go('/chat');
                      },
                    ),
                    _QuickActionCard(
                      icon: Icons.book_outlined,
                      label: 'Jurnal',
                      color: TaraColors.authAccent,
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
                      color: TaraColors.authAccent,
                      onTap: () {
                        context.go('/bisindo');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Tip Harian
                TaraCard(
                  backgroundColor: const Color(0xFFEAF6EF),
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
                const SizedBox(height: 16),
                TaraCard(
                  onTap: () => context.push('/rujukan-profesional'),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.support_agent_rounded,
                        color: TaraColors.authAccent,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Butuh dukungan lebih lanjut?',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: TaraColors.textDeepIndigo,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Lihat pilihan bantuan profesional',
                              style: TextStyle(
                                fontSize: 13,
                                color: TaraColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: TaraColors.authAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
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
