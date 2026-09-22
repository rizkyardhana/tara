import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';

/// Aksesibilitas Screen
class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({Key? key}) : super(key: key);

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool _enableBisindo = false;
  bool _enableLargeText = false;
  bool _enableHighContrast = false;
  bool _enableVisualNotifications = true;
  String _selectedLanguage = 'ID'; // Bahasa Indonesia
  bool _isLoading = false;

  void _handleComplete() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/home');
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
              'Aksesibilitas ♿',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sesuaikan pengalaman TARA dengan kebutuhan Anda',
              style: TextStyle(
                fontSize: 14,
                color: TaraColors.textMuted,
              ),
            ),
            const SizedBox(height: 32),

            // Bahasa
            const Text(
              'Bahasa',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: TaraColors.divider),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _selectedLanguage,
                underline: Container(),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'ID', child: Text('Bahasa Indonesia')),
                  DropdownMenuItem(value: 'EN', child: Text('English')),
                ],
                onChanged: (value) {
                  setState(() => _selectedLanguage = value ?? 'ID');
                },
              ),
            ),
            const SizedBox(height: 32),

            // BISINDO Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BISINDO (Bahasa Isyarat)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: TaraColors.textDeepIndigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tampilkan video isyarat di seluruh aplikasi',
                      style: TextStyle(
                        fontSize: 12,
                        color: TaraColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _enableBisindo,
                  onChanged: (value) {
                    setState(() => _enableBisindo = value);
                  },
                  activeColor: TaraColors.blue,
                ),
              ],
            ),
            const Divider(height: 32),

            // Large Text Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Teks Lebih Besar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: TaraColors.textDeepIndigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tingkatkan ukuran teks di seluruh aplikasi',
                      style: TextStyle(
                        fontSize: 12,
                        color: TaraColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _enableLargeText,
                  onChanged: (value) {
                    setState(() => _enableLargeText = value);
                  },
                  activeColor: TaraColors.blue,
                ),
              ],
            ),
            const Divider(height: 32),

            // High Contrast Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kontras Tinggi',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: TaraColors.textDeepIndigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gunakan warna kontras tinggi untuk keterbacaan',
                      style: TextStyle(
                        fontSize: 12,
                        color: TaraColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _enableHighContrast,
                  onChanged: (value) {
                    setState(() => _enableHighContrast = value);
                  },
                  activeColor: TaraColors.blue,
                ),
              ],
            ),
            const Divider(height: 32),

            // Visual Notifications Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifikasi Visual',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: TaraColors.textDeepIndigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aktifkan flashing dan animasi notifikasi',
                      style: TextStyle(
                        fontSize: 12,
                        color: TaraColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _enableVisualNotifications,
                  onChanged: (value) {
                    setState(() => _enableVisualNotifications = value);
                  },
                  activeColor: TaraColors.blue,
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Complete Button
            TaraGradientButton(
              label: 'Selesai & Mulai Perjalanan Anda',
              isLoading: _isLoading,
              onPressed: _handleComplete,
            ),
          ],
        ),
      ),
    );
  }
}
