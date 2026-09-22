import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';
import '../../widgets/tara_common.dart';

/// Keamanan & Krisis Screen
class SecurityCrisisScreen extends StatefulWidget {
  const SecurityCrisisScreen({Key? key}) : super(key: key);

  @override
  State<SecurityCrisisScreen> createState() => _SecurityCrisisScreenState();
}

class _SecurityCrisisScreenState extends State<SecurityCrisisScreen> {
  final _emergencyContactController = TextEditingController();
  String? _selectedRiskLevel;

  @override
  void dispose() {
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan & Krisis'),
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
            // Risk Level Assessment
            const Text(
              'Tingkat Risiko Kesehatan Mental',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _RiskLevelCard(
              level: 'Rendah',
              description: 'Merasa baik-baik saja, tantangan normal',
              color: TaraColors.green,
              isSelected: _selectedRiskLevel == 'low',
              onTap: () => setState(() => _selectedRiskLevel = 'low'),
            ),
            const SizedBox(height: 12),
            _RiskLevelCard(
              level: 'Sedang',
              description: 'Merasa cemas atau sedih, butuh dukungan',
              color: TaraColors.warning,
              isSelected: _selectedRiskLevel == 'medium',
              onTap: () => setState(() => _selectedRiskLevel = 'medium'),
            ),
            const SizedBox(height: 12),
            _RiskLevelCard(
              level: 'Tinggi',
              description: 'Pikiran berbahaya, butuh bantuan profesional sekarang',
              color: TaraColors.error,
              isSelected: _selectedRiskLevel == 'high',
              onTap: () => setState(() => _selectedRiskLevel = 'high'),
            ),
            const SizedBox(height: 32),

            // Emergency Contact
            const Text(
              'Kontak Darurat (Orang Terpercaya)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            TaraInputField(
              label: 'Nama & Nomor HP',
              hintText: 'Nama orang terpercaya',
              controller: _emergencyContactController,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 24),

            // Emergency Routes
            const Text(
              'Jalur Bantuan Krisis (Ramah Tuli)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _EmergencyRouteCard(
              icon: Icons.message_outlined,
              title: 'Chat Krisis',
              description: 'Hubungi konselor via chat 24 jam',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _EmergencyRouteCard(
              icon: Icons.videocam_outlined,
              title: 'Video Relay',
              description: 'Bicara dengan interpreter video',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _EmergencyRouteCard(
              icon: Icons.phone_outlined,
              title: 'SEJIWA 119 ext 8',
              description: 'Hotline ramah Tuli 24 jam',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Safety Plan
            TaraCard(
              backgroundColor: TaraColors.blue.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.shield, color: TaraColors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Rencana Keamanan Pribadi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: TaraColors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Buat rencana pribadi untuk saat-saat sulit. Catat tanda-tanda peringatan Anda dan strategi yang membantu.',
                    style: TextStyle(
                      fontSize: 12,
                      color: TaraColors.textDeepIndigo,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TaraSolidButton(
                    label: 'Buat Rencana Keamanan',
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

class _RiskLevelCard extends StatelessWidget {
  final String level;
  final String description;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _RiskLevelCard({
    required this.level,
    required this.description,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          border: Border.all(
            color: isSelected ? color : TaraColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
                color: isSelected ? color : Colors.white,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
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
      ),
    );
  }
}

class _EmergencyRouteCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _EmergencyRouteCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TaraColors.green.withOpacity(0.1),
          border: Border.all(color: TaraColors.green.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: TaraColors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: TaraColors.green),
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
