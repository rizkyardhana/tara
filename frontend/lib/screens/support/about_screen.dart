import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_common.dart';

/// Tentang TARA Screen
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang TARA'),
        elevation: 0,
        backgroundColor: TaraColors.bgCoolWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    TaraColors.purple,
                    TaraColors.blue,
                    TaraColors.green,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'TARA',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App name and version
            const Text(
              'TARA',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Teman Akses Ruang Aman',
              style: TextStyle(
                fontSize: 14,
                color: TaraColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: TaraColors.bgCoolWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: TaraColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Mission
            const Text(
              'Misi Kami',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TaraColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'TARA adalah aplikasi wellbeing yang dirancang khusus untuk komunitas Tuli/DeafBlind di Indonesia. Kami berkomitmen untuk menyediakan akses kesehatan mental yang ramah, visual-first, dan accessible.',
                style: TextStyle(
                  fontSize: 13,
                  color: TaraColors.textDeepIndigo,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Three Pillars
            const Text(
              'Tiga Pilar TARA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _PillarCard(
              icon: '🧠',
              title: 'Pikiran',
              description: 'Pahami dan kelola emosi dengan tools interaktif',
            ),
            const SizedBox(height: 12),
            _PillarCard(
              icon: '💙',
              title: 'Ketenangan',
              description: 'Akses guided activities dan teknik grounding',
            ),
            const SizedBox(height: 12),
            _PillarCard(
              icon: '🌿',
              title: 'Pertumbuhan',
              description: 'Tumbuh bersama Taman Pikiran Anda setiap hari',
            ),
            const SizedBox(height: 32),

            // Features
            const Text(
              'Fitur Utama',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _FeatureItem(icon: Icons.mood, title: 'Daily Check-in'),
            const SizedBox(height: 8),
            _FeatureItem(icon: Icons.chat, title: 'TARA AI Companion'),
            const SizedBox(height: 8),
            _FeatureItem(icon: Icons.videocam, title: 'BISINDO Video Relay'),
            const SizedBox(height: 8),
            _FeatureItem(icon: Icons.spa, title: 'Guided Wellbeing Activities'),
            const SizedBox(height: 8),
            _FeatureItem(icon: Icons.favorite, title: 'Mental Health Support'),
            const SizedBox(height: 32),

            // Credits
            const Text(
              'Dikembangkan Dengan ❤️',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            TaraCard(
              child: Column(
                children: [
                  const Text(
                    'Tim TARA Indonesia',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bekerja sama dengan komunitas Tuli dan profesional kesehatan mental untuk membangun aplikasi yang inklusif dan accessible.',
                    style: TextStyle(
                      fontSize: 12,
                      color: TaraColors.textMuted,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _TagChip(label: 'Accessibility First'),
                      _TagChip(label: 'Visual First'),
                      _TagChip(label: 'Community-Driven'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Privasi'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Syarat & Ketentuan'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Kontak'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '© 2026 TARA Indonesia\nSemua hak dilindungi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: TaraColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _PillarCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TaraColors.bgCoolWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: TaraColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: TaraColors.blue, size: 20),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: TaraColors.textDeepIndigo,
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: TaraColors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: TaraColors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
