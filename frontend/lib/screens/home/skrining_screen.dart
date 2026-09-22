import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';

/// Skrining Terpandu Screen - Safety Detection
class SkriningSertaScreen extends StatefulWidget {
  const SkriningSertaScreen({Key? key}) : super(key: key);

  @override
  State<SkriningSertaScreen> createState() => _SkriningSertaScreenState();
}

class _SkriningSertaScreenState extends State<SkriningSertaScreen> {
  int _currentStep = 0;

  final List<SkriningQuestion> _questions = [
    SkriningQuestion(
      question: 'Dalam seminggu terakhir, seberapa sering Anda merasa sedih atau putus asa?',
      options: ['Tidak pernah', 'Beberapa hari', 'Setengah hari', 'Hampir setiap hari'],
    ),
    SkriningQuestion(
      question: 'Apakah Anda mengalami kesulitan tidur atau terlalu banyak tidur?',
      options: ['Tidak', 'Kadang-kadang', 'Sering', 'Setiap hari'],
    ),
    SkriningQuestion(
      question: 'Apakah Anda merasa kehilangan minat pada hal-hal yang biasanya Anda nikmati?',
      options: ['Tidak', 'Sedikit', 'Cukup banyak', 'Sangat banyak'],
    ),
  ];

  void _handleNext() {
    if (_currentStep < _questions.length - 1) {
      setState(() => _currentStep++);
    } else {
      // Navigate to rujukan profesional
      context.push('/rujukan-profesional');
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skrining Terpandu'),
        elevation: 0,
        backgroundColor: TaraColors.bgCoolWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / _questions.length,
              minHeight: 6,
              backgroundColor: TaraColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(TaraColors.blue),
            ),
            const SizedBox(height: 24),

            // Step counter
            Text(
              'Pertanyaan ${_currentStep + 1} dari ${_questions.length}',
              style: const TextStyle(
                fontSize: 12,
                color: TaraColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Question
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Options
            Column(
              children: List.generate(
                question.options.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: TaraColors.divider),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: TaraColors.blue,
                                    width: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: TaraColors.textDeepIndigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Navigation buttons
            TaraGradientButton(
              label: _currentStep == _questions.length - 1
                  ? 'Lihat Hasil Skrining'
                  : 'Lanjut',
              onPressed: _handleNext,
            ),
          ],
        ),
      ),
    );
  }
}

class SkriningQuestion {
  final String question;
  final List<String> options;

  SkriningQuestion({
    required this.question,
    required this.options,
  });
}
