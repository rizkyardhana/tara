import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';

/// TARA Space - Wellbeing Activities
class TaraSpaceScreen extends StatelessWidget {
  const TaraSpaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TARA Space'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aktivitas Wellbeing Terpandu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 24),
            _ActivityCard(
              title: 'Latihan Pernapasan 4-4-4',
              description: 'Penenang cepat untuk mengurangi kecemasan',
              duration: '5 menit',
              icon: Icons.air,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _ActivityCard(
              title: 'Grounding 5-4-3-2-1',
              description: 'Teknik awareness melalui indera',
              duration: '10 menit',
              icon: Icons.eco,
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _ActivityCard(
              title: 'Meditasi Guided',
              description: 'Meditasi ketenangan 10 menit',
              duration: '10 menit',
              icon: Icons.self_improvement,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final IconData icon;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.title,
    required this.description,
    required this.duration,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: TaraColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: TaraColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: TaraColors.blue),
            ),
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
                      color: TaraColors.textDeepIndigo,
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
                  const SizedBox(height: 4),
                  Text(
                    '⏱️ $duration',
                    style: const TextStyle(
                      fontSize: 11,
                      color: TaraColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: TaraColors.textMuted),
          ],
        ),
      ),
    );
  }
}
