import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';
import '../../widgets/tara_common.dart';
import '../../services/api_service.dart';

/// Check-in Harian Screen
class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  String? _selectedMood;
  final List<String> _selectedFactors = [];
  final _notesController = TextEditingController();
  bool _isLoading = false;
  final _api = ApiService();

  final List<String> _moods = ['😢', '😔', '😐', '😊', '😄'];
  final List<String> _factors = [
    'Tidur',
    'Pekerjaan',
    'Hubungan',
    'Kesehatan',
    'Cuaca',
    'Aktivitas',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mood terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _api.saveMood({
        'moodScore': _moods.indexOf(_selectedMood!) + 1,
        'moodEmoji': _selectedMood,
        'factors': _selectedFactors,
        'notes': _notesController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-in berhasil disimpan')),
        );
        context.pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Harian'),
        elevation: 0,
        backgroundColor: TaraColors.bgCoolWhite,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bagaimana perasaan Anda?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((mood) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedMood = mood);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _selectedMood == mood
                          ? TaraColors.blue.withOpacity(0.2)
                          : TaraColors.bgCoolWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: _selectedMood == mood
                          ? Border.all(color: TaraColors.blue, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(mood, style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            const Text(
              'Apa yang mempengaruhi?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _factors.map((factor) {
                return TaraPill(
                  label: factor,
                  isSelected: _selectedFactors.contains(factor),
                  onTap: () {
                    setState(() {
                      if (_selectedFactors.contains(factor)) {
                        _selectedFactors.remove(factor);
                      } else {
                        _selectedFactors.add(factor);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            const Text(
              'Catatan (Opsional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Apa yang ingin Anda bagikan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: TaraColors.divider),
                ),
              ),
            ),
            const SizedBox(height: 32),

            TaraGradientButton(
              label: 'Simpan Check-in',
              isLoading: _isLoading,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
