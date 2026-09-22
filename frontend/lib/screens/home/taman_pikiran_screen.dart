import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_common.dart';

/// Taman Pikiran - Virtual Garden/Plant
class TamanPikiranScreen extends StatelessWidget {
  const TamanPikiranScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taman Pikiran'),
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
            // Plant visualization (placeholder)
            Center(
              child: Container(
                width: 200,
                height: 250,
                decoration: BoxDecoration(
                  color: TaraColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '🌱',
                      style: TextStyle(fontSize: 80),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Berkembang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: TaraColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Growth stage info
            const Text(
              'Tahap Pertumbuhan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            TaraCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tahap Berkembang',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tanaman Anda tumbuh seiring dengan aktivitas wellbeing Anda.',
                    style: TextStyle(
                      fontSize: 12,
                      color: TaraColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            const Text(
              'Statistik',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            TaraCard(
              child: Column(
                children: [
                  _StatRow(label: 'Total Check-in', value: '12'),
                  const Divider(height: 16),
                  _StatRow(label: 'Hari Berturut-turut', value: '5'),
                  const Divider(height: 16),
                  _StatRow(label: 'Aktivitas Wellbeing', value: '8'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Three Roots
            const Text(
              'Tiga Akar TARA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            _RootCard(
              icon: '🧠',
              title: 'Pikiran',
              value: 30,
            ),
            const SizedBox(height: 12),
            _RootCard(
              icon: '💙',
              title: 'Ketenangan',
              value: 60,
            ),
            const SizedBox(height: 12),
            _RootCard(
              icon: '🌿',
              title: 'Pertumbuhan',
              value: 45,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: TaraColors.textMuted,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: TaraColors.blue,
          ),
        ),
      ],
    );
  }
}

class _RootCard extends StatelessWidget {
  final String icon;
  final String title;
  final int value;

  const _RootCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TaraColors.bgCoolWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$icon $title',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              backgroundColor: TaraColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(
                TaraColors.blue.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value%',
            style: const TextStyle(
              fontSize: 11,
              color: TaraColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
