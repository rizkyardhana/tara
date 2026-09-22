import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';
import '../../widgets/tara_common.dart';

/// Persetujuan & Keamanan Screen
class SafetyAgreementScreen extends StatefulWidget {
  const SafetyAgreementScreen({Key? key}) : super(key: key);

  @override
  State<SafetyAgreementScreen> createState() => _SafetyAgreementScreenState();
}

class _SafetyAgreementScreenState extends State<SafetyAgreementScreen> {
  bool _agreeDisclamer = false;
  bool _agreeEmergency = false;
  bool _isLoading = false;

  void _handleContinue() {
    if (!_agreeDisclamer || !_agreeEmergency) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui semua pernyataan'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/personalization');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            // Header
            const Text(
              'Keamanan & Dukungan ❤️',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Informasi penting sebelum melanjutkan',
              style: TextStyle(
                fontSize: 14,
                color: TaraColors.textMuted,
              ),
            ),
            const SizedBox(height: 32),

            // Disclaimer Card
            TaraCard(
              backgroundColor: TaraColors.purple.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: TaraColors.purple,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Disclaimer Penting',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: TaraColors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'TARA adalah AI companion untuk dukungan awal wellbeing, BUKAN psikolog atau terapis profesional. Jika Anda mengalami krisis, segera hubungi layanan darurat.',
                    style: TextStyle(
                      fontSize: 13,
                      color: TaraColors.textDeepIndigo,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _agreeDisclamer,
                          onChanged: (value) {
                            setState(
                              () => _agreeDisclamer = value ?? false,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Saya memahami bahwa TARA bukan pengganti layanan profesional',
                          style: TextStyle(
                            fontSize: 12,
                            color: TaraColors.textDeepIndigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Emergency Contact Card
            TaraCard(
              backgroundColor: TaraColors.green.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: TaraColors.green,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Jalur Darurat Ramah Tuli',
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
                    'Anda dapat berbicara dengan orang terpercaya atau menghubungi:',
                    style: TextStyle(
                      fontSize: 13,
                      color: TaraColors.textDeepIndigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📞 SEJIWA 119 ext 8',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: TaraColors.textDeepIndigo,
                          ),
                        ),
                        Text(
                          'Ramah Tuli - Text/Chat/Video Relay',
                          style: TextStyle(
                            fontSize: 11,
                            color: TaraColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _agreeEmergency,
                          onChanged: (value) {
                            setState(
                              () => _agreeEmergency = value ?? false,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Saya memahami dan siap menggunakan jalur darurat jika diperlukan',
                          style: TextStyle(
                            fontSize: 12,
                            color: TaraColors.textDeepIndigo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            TaraGradientButton(
              label: 'Lanjutkan',
              isLoading: _isLoading,
              onPressed: _handleContinue,
            ),
            const SizedBox(height: 12),
            TaraGhostButton(
              label: 'Kembali',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
