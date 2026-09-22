import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';

/// Pusat Bantuan (FAQ) Screen
class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _searchController = TextEditingController();
  int? _expandedIndex;

  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'Apakah TARA aman untuk privasi saya?',
      answer:
          'Ya, semua data Anda dienkripsi dan disimpan dengan aman. Kami tidak membagikan data dengan pihak ketiga tanpa persetujuan Anda.',
      category: 'Privasi',
    ),
    FAQItem(
      question: 'Bagaimana cara menggunakan Check-in Harian?',
      answer:
          'Buka halaman Beranda, pilih mood Anda dari 5 emoji, pilih faktor yang mempengaruhi, dan tambahkan catatan (opsional).',
      category: 'Fitur',
    ),
    FAQItem(
      question: 'Apa itu Taman Pikiran?',
      answer:
          'Taman Pikiran adalah visualisasi pertumbuhan pribadi Anda. Setiap aktivitas wellbeing membantu tanaman Anda tumbuh dari tunas menjadi taman yang rimbun.',
      category: 'Fitur',
    ),
    FAQItem(
      question: 'Bagaimana jika saya dalam krisis?',
      answer:
          'Jika Anda dalam krisis, segera hubungi SEJIWA 119 ext 8. TARA bukan pengganti layanan profesional untuk situasi darurat.',
      category: 'Keamanan',
    ),
    FAQItem(
      question: 'Bagaimana cara mengaktifkan BISINDO?',
      answer:
          'Buka Pengaturan > Aksesibilitas > toggle BISINDO. Setelah diaktifkan, video isyarat akan tersedia di seluruh aplikasi.',
      category: 'Aksesibilitas',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan'),
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
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari topik bantuan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: TaraColors.divider),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // FAQ Categories
            const Text(
              'Kategori Umum',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Fitur', 'Privasi', 'Aksesibilitas', 'Keamanan']
                  .map(
                    (category) => Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: TaraColors.bgCoolWhite,
                        border: Border.all(color: TaraColors.divider),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: TaraColors.textDeepIndigo,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),

            // FAQ List
            const Text(
              'Pertanyaan Umum',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _faqs.length,
              itemBuilder: (context, index) {
                final faq = _faqs[index];

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
                        faq.question,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: TaraColors.textDeepIndigo,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Chip(
                          label: Text(
                            faq.category,
                            style: const TextStyle(fontSize: 11),
                          ),
                          backgroundColor: TaraColors.blue.withOpacity(0.2),
                          labelStyle: const TextStyle(
                            color: TaraColors.blue,
                            fontSize: 11,
                          ),
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
                            faq.answer,
                            style: const TextStyle(
                              fontSize: 13,
                              color: TaraColors.textMuted,
                              height: 1.6,
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

            // Contact support
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
                    'Masih butuh bantuan?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: TaraColors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hubungi tim support kami di support@tara.id atau gunakan form kontak di bawah.',
                    style: TextStyle(
                      fontSize: 12,
                      color: TaraColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TaraColors.blue,
                      ),
                      child: const Text('Hubungi Kami'),
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

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
