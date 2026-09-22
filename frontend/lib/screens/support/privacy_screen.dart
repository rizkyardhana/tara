import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';

/// Privasi & Keamanan Screen
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  int? _expandedIndex;

  final List<PrivacySection> _sections = [
    PrivacySection(
      title: 'Apa data yang kami kumpulkan?',
      content:
          'TARA mengumpulkan:\n\n• Informasi akun: nama, email, nomor HP\n• Data mood: check-in harian, jurnal, faktor-faktor\n• Riwayat chat: percakapan dengan TARA AI\n• Pengaturan aksesibilitas: preferensi Anda\n• Metadata: waktu akses, perangkat yang digunakan\n\nSemua data disimpan secara terenkripsi.',
    ),
    PrivacySection(
      title: 'Bagaimana kami menggunakan data Anda?',
      content:
          'Data Anda digunakan untuk:\n\n• Memberikan layanan personal yang relevan\n• Meningkatkan fitur dan pengalaman pengguna\n• Analisis anonim untuk riset kesehatan mental\n• Keamanan dan pencegahan fraud\n• Mematuhi hukum dan regulasi yang berlaku\n\nKami TIDAK menjual atau membagikan data pribadi Anda.',
    ),
    PrivacySection(
      title: 'Siapa yang dapat mengakses data saya?',
      content:
          'Data Anda hanya dapat diakses oleh:\n\n• Tim TARA yang memerlukan untuk memberikan layanan\n• Layanan cloud yang terekripsi end-to-end\n• Profesional kesehatan mental jika Anda memberikan persetujuan eksplisit\n• Pihak ketiga hanya jika disyaratkan oleh hukum\n\nProfesor dan pihak ketiga lainnya TIDAK dapat mengakses tanpa izin Anda.',
    ),
    PrivacySection(
      title: 'Berapa lama data disimpan?',
      content:
          'Kebijakan retensi data:\n\n• Data akun: disimpan selama akun aktif\n• Data mood & jurnal: disimpan sesuai preferensi Anda\n• Chat history: dapat dihapus kapan saja\n• Backup: disimpan hingga 30 hari setelah penghapusan\n\nAnda dapat meminta penghapusan semua data kapan saja.',
    ),
    PrivacySection(
      title: 'Bagaimana data dilindungi?',
      content:
          'Kami menggunakan:\n\n• Enkripsi TLS/SSL untuk data dalam transit\n• Enkripsi AES-256 untuk data yang tersimpan\n• Authentication dua faktor opsional\n• Regular security audits dari pihak ketiga\n• Compliance dengan standar GDPR dan regulasi lokal\n\nJika ada pelanggaran keamanan, kami akan memberi tahu Anda dalam 24 jam.',
    ),
    PrivacySection(
      title: 'Hak-hak privasi Anda',
      content:
          'Anda memiliki hak untuk:\n\n• Mengakses data pribadi Anda kapan saja\n• Memperbaiki atau memperbarui data Anda\n• Menghapus akun dan semua data terkait\n• Menonaktifkan izin (lokasi, kamera, mikrofon)\n• Membatalkan newsletter atau notifikasi\n• Mengekspor data dalam format yang dapat dibaca\n\nHubungi privacy@tara.id untuk meminta hak Anda.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privasi & Keamanan'),
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
            // Privacy statement
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TaraColors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.security, color: TaraColors.green),
                      SizedBox(width: 8),
                      Text(
                        'Komitmen Privasi Kami',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: TaraColors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Privasi Anda adalah prioritas utama kami. TARA berkomitmen untuk melindungi data pribadi Anda dengan standar keamanan tertinggi dan transparansi penuh.',
                    style: TextStyle(
                      fontSize: 13,
                      color: TaraColors.textDeepIndigo,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Privacy sections
            const Text(
              'Kebijakan Privasi Lengkap',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: TaraColors.divider),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: _expandedIndex == index,
                      title: Text(
                        section.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: TaraColors.textDeepIndigo,
                        ),
                      ),
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _expandedIndex = expanded ? index : null;
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            section.content,
                            style: const TextStyle(
                              fontSize: 13,
                              color: TaraColors.textMuted,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Privacy controls
            const Text(
              'Kontrol Privasi Anda',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _PrivacyControlTile(
              icon: Icons.download,
              title: 'Unduh Data Anda',
              description: 'Ekspor semua data pribadi dalam format JSON',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _PrivacyControlTile(
              icon: Icons.delete_forever,
              title: 'Hapus Akun Selamanya',
              description:
                  'Hapus akun dan semua data terkait secara permanen',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Hapus Akun?'),
                    content: const Text(
                      'Tindakan ini tidak dapat dibatalkan. Semua data Anda akan dihapus selamanya.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Delete account
                          Navigator.pop(context);
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Document section
            const Text(
              'Dokumen Resmi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 16),
            _DocumentLink(
              icon: Icons.description,
              title: 'Kebijakan Privasi Lengkap',
              subtitle: 'Versi 1.0, Efektif 1 Januari 2026',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _DocumentLink(
              icon: Icons.article,
              title: 'Syarat & Ketentuan Penggunaan',
              subtitle: 'Versi 1.0, Efektif 1 Januari 2026',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _DocumentLink(
              icon: Icons.info,
              title: 'Cookie Policy',
              subtitle: 'Informasi tentang cookies yang kami gunakan',
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Contact privacy
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TaraColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pertanyaan Privasi?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: TaraColors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hubungi Data Protection Officer kami:',
                    style: TextStyle(
                      fontSize: 12,
                      color: TaraColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'privacy@tara.id\n📞 +62-800-TARA-HELP',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TaraColors.textDeepIndigo,
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

class _PrivacyControlTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _PrivacyControlTile({
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
          color: TaraColors.bgCoolWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TaraColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: TaraColors.textDeepIndigo),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

class _DocumentLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DocumentLink({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TaraColors.bgCoolWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TaraColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: TaraColors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: TaraColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, color: TaraColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class PrivacySection {
  final String title;
  final String content;

  PrivacySection({
    required this.title,
    required this.content,
  });
}
