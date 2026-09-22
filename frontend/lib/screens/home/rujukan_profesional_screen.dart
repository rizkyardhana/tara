import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';
import '../../widgets/tara_common.dart';

/// Rujukan Profesional Screen
class RujakanProfesionalScreen extends StatelessWidget {
  const RujakanProfesionalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rujukan Profesional'),
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
            // Alert card
            TaraCard(
              backgroundColor: TaraColors.error.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber, color: TaraColors.error),
                      SizedBox(width: 8),
                      Text(
                        'Hasil Skrining',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: TaraColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Berdasarkan jawaban Anda, kami merekomendasikan untuk berbicara dengan profesional kesehatan mental.',
                    style: TextStyle(
                      fontSize: 13,
                      color: TaraColors.textDeepIndigo,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Rekomendasi profesional
            const Text(
              'Daftar Profesional Ramah Tuli',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),

            // Profesional cards
            _ProfesionalCard(
              name: 'Dr. Andi Psychologist, M.Psi',
              specialization: 'Psikolog Klinis',
              phone: '+62812345678',
              availability: 'Senin-Jumat, 09:00-17:00',
              friendly: true,
            ),
            const SizedBox(height: 12),
            _ProfesionalCard(
              name: 'Ir. Budi Counselor, S.Kom',
              specialization: 'Konselor Wellbeing',
              phone: '+62812345679',
              availability: 'Selasa-Sabtu, 10:00-18:00',
              friendly: true,
            ),
            const SizedBox(height: 32),

            // Jalur darurat
            const Text(
              'Jalur Darurat (24 Jam)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            TaraCard(
              backgroundColor: TaraColors.green.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SEJIWA Crisis Center',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: TaraColors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '📞 119 ext 8',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TaraColors.textDeepIndigo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ramah Tuli - Chat, Video Relay, Teks',
                    style: TextStyle(
                      fontSize: 12,
                      color: TaraColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TaraSolidButton(
                    label: 'Hubungi Sekarang',
                    onPressed: () {},
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfesionalCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String phone;
  final String availability;
  final bool friendly;

  const _ProfesionalCard({
    required this.name,
    required this.specialization,
    required this.phone,
    required this.availability,
    required this.friendly,
  });

  @override
  Widget build(BuildContext context) {
    return TaraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialization,
                      style: const TextStyle(
                        fontSize: 12,
                        color: TaraColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (friendly)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TaraColors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '✓ Ramah Tuli',
                    style: TextStyle(
                      fontSize: 11,
                      color: TaraColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            '📞 $phone',
            style: const TextStyle(
              fontSize: 12,
              color: TaraColors.textDeepIndigo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '⏰ $availability',
            style: const TextStyle(
              fontSize: 12,
              color: TaraColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          TaraSolidButton(
            label: 'Hubungi',
            onPressed: () {},
            height: 36,
          ),
        ],
      ),
    );
  }
}
