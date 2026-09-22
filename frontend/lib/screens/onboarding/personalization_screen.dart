import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';
import '../../widgets/tara_common.dart';

/// Personalisasi Screen
class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({Key? key}) : super(key: key);

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  String? _selectedAge;
  String? _selectedGoal;
  final List<String> _selectedFocusAreas = [];
  bool _isLoading = false;

  final List<String> _ageOptions = ['13-18', '19-25', '26-35', '36-50', '50+'];
  final List<String> _goalOptions = ['Manajemen Stress', 'Tidur Lebih Baik', 'Kepercayaan Diri'];
  final List<String> _focusAreaOptions = [
    'Manajemen Emosi',
    'Komunikasi',
    'Kepercayaan Diri',
    'Manajemen Stress',
    'Tidur & Istirahat',
    'Hubungan Sosial',
  ];

  void _handleContinue() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/accessibility');
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
              'Personalisasi Profil Anda 👤',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bantu kami memahami kebutuhan Anda (opsional)',
              style: TextStyle(
                fontSize: 14,
                color: TaraColors.textMuted,
              ),
            ),
            const SizedBox(height: 32),

            // Age Selection
            const Text(
              'Usia Anda',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _ageOptions
                  .map(
                    (age) => TaraPill(
                      label: age,
                      isSelected: _selectedAge == age,
                      onTap: () {
                        setState(() => _selectedAge = age);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),

            // Goal Selection
            const Text(
              'Tujuan Utama Wellbeing',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _goalOptions
                  .map(
                    (goal) => TaraPill(
                      label: goal,
                      isSelected: _selectedGoal == goal,
                      onTap: () {
                        setState(() => _selectedGoal = goal);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),

            // Focus Areas Selection
            const Text(
              'Area Fokus (Pilih Ganda)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _focusAreaOptions
                  .map(
                    (area) => TaraPill(
                      label: area,
                      isSelected: _selectedFocusAreas.contains(area),
                      onTap: () {
                        setState(() {
                          if (_selectedFocusAreas.contains(area)) {
                            _selectedFocusAreas.remove(area);
                          } else {
                            _selectedFocusAreas.add(area);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 48),

            // Buttons
            TaraGradientButton(
              label: 'Lanjutkan ke Aksesibilitas',
              isLoading: _isLoading,
              onPressed: _handleContinue,
            ),
            const SizedBox(height: 12),
            TaraGhostButton(
              label: 'Lewati',
              onPressed: () {
                context.go('/accessibility');
              },
            ),
          ],
        ),
      ),
    );
  }
}
