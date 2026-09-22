import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_common.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _api = ApiService();
  late Future<Map<String, dynamic>> _statistics;

  @override
  void initState() {
    super.initState();
    _statistics = _api.getJournalStatistics();
  }

  void _reload() => setState(() => _statistics = _api.getJournalStatistics());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal'),
        elevation: 0,
        backgroundColor: TaraColors.bgCoolWhite,
        actions: [IconButton(onPressed: _reload, icon: const Icon(Icons.refresh))],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _statistics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Data belum dapat dimuat: ${snapshot.error}'));
          }
          final data = snapshot.data ?? {};
          final summary = Map<String, dynamic>.from(data['summary'] ?? {});
          final trend = List<Map<String, dynamic>>.from((data['trend'] as List? ?? []).map((item) => Map<String, dynamic>.from(item)));
          final factors = List<Map<String, dynamic>>.from((data['factors'] as List? ?? []).map((item) => Map<String, dynamic>.from(item)));
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text('Riwayat wellbeing-mu', style: TextStyle(fontSize: 16, color: TaraColors.textMuted)),
                const SizedBox(height: 20),
                Row(children: [
                  _MetricCard(label: 'Rata-rata', value: '${summary['averageMood'] ?? 0}/5', icon: Icons.sentiment_satisfied_alt, color: TaraColors.blue),
                  const SizedBox(width: 12),
                  _MetricCard(label: 'Check-in', value: '${summary['totalCheckIns'] ?? 0}', icon: Icons.insights, color: TaraColors.green),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  _MetricCard(label: 'Hari aktif', value: '${summary['activeDays'] ?? 0}', icon: Icons.calendar_month, color: TaraColors.purple),
                  const SizedBox(width: 12),
                  _MetricCard(label: 'Terbaik', value: '${summary['bestMood'] ?? 0}/5', icon: Icons.emoji_emotions, color: TaraColors.warning),
                ]),
                const SizedBox(height: 28),
                const _SectionTitle('Minggu ini'),
                const SizedBox(height: 12),
                TaraCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [const Icon(Icons.trending_up, color: TaraColors.green), const SizedBox(width: 4), Text('+12%', style: const TextStyle(color: TaraColors.green, fontWeight: FontWeight.w800))]),
                  SizedBox(height: 170, child: _TrendChart(trend: trend)),
                  const Divider(),
                  Text('Rata-rata: ${summary['averageMood'] ?? 0}/5  ${_moodLabel(summary)}', style: const TextStyle(fontSize: 16, color: TaraColors.textMuted)),
                ])),
                const SizedBox(height: 28),
                const _SectionTitle('Faktor yang paling sering muncul'),
                const SizedBox(height: 12),
                TaraCard(child: factors.isEmpty ? const Text('Belum ada faktor yang tercatat.') : Column(children: factors.map((factor) => _FactorRow(name: '${factor['factor']}', count: factor['count'] as num? ?? 0, max: factors.first['count'] as num? ?? 1)).toList())),
                const SizedBox(height: 28),
                const _SectionTitle('Catatan analisis'),
                const SizedBox(height: 12),
                TaraCard(backgroundColor: TaraColors.blue.withOpacity(0.08), child: Text(_insight(summary, factors), style: const TextStyle(color: TaraColors.textDeepIndigo, height: 1.5))),
              ],
            ),
          );
        },
      ),
    );
  }

  String _insight(Map<String, dynamic> summary, List<Map<String, dynamic>> factors) {
    final average = double.tryParse('${summary['averageMood'] ?? 0}') ?? 0;
    if (summary['totalCheckIns'] == 0) return 'Mulai dengan check-in pertama agar TARA dapat membaca pola kebahagiaan Anda.';
    final leadingFactor = factors.isEmpty ? 'belum ada faktor dominan' : factors.first['factor'];
    return average >= 4 ? 'Rata-rata mood Anda positif. Faktor yang paling sering tercatat adalah $leadingFactor. Pertahankan aktivitas yang membantu Anda merasa baik.' : 'Rata-rata mood Anda masih perlu perhatian. Faktor yang paling sering tercatat adalah $leadingFactor. Coba ceritakan lebih detail pada TARA atau lakukan check-in rutin.';
  }

  String _moodLabel(Map<String, dynamic> summary) {
    final average = double.tryParse('${summary['averageMood'] ?? 0}') ?? 0;
    return average >= 4 ? 'Cukup baik 😊' : average >= 3 ? 'Biasa saja 😐' : 'Perlu perhatian';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.icon, required this.color});
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Expanded(child: TaraCard(child: Row(children: [Icon(icon, color: color, size: 28), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TaraColors.textDeepIndigo)), Text(label, style: const TextStyle(fontSize: 12, color: TaraColors.textMuted))]))])));
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: TaraColors.textDeepIndigo));
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.trend});
  final List<Map<String, dynamic>> trend;
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _TrendPainter(trend.map((item) => double.tryParse('${item['score']}') ?? 0).toList()), child: const SizedBox.expand());
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.values);
  final List<double> values;
  @override
  void paint(Canvas canvas, Size size) {
    final chartValues = values.isEmpty ? [3.0, 4.0, 2.0, 3.0, 5.0, 4.0, 5.0] : values.take(7).toList();
    final labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final barWidth = (size.width - 24) / chartValues.length;
    for (var index = 0; index < chartValues.length; index++) {
      final barHeight = (chartValues[index] / 5 * (size.height - 28)).clamp(14.0, size.height - 28).toDouble();
      final rect = RRect.fromRectAndCorners(Rect.fromLTWH(index * barWidth + 4, size.height - barHeight - 24, barWidth - 10, barHeight), topLeft: const Radius.circular(14), topRight: const Radius.circular(14));
      canvas.drawRRect(rect, Paint()..color = index == chartValues.length - 1 ? TaraColors.blue : TaraColors.blue.withOpacity(0.18));
      final textPainter = TextPainter(text: TextSpan(text: labels[index], style: const TextStyle(color: TaraColors.textMuted, fontSize: 12, fontWeight: FontWeight.w700)), textDirection: TextDirection.ltr)..layout();
      textPainter.paint(canvas, Offset(index * barWidth + (barWidth - textPainter.width) / 2, size.height - 18));
    }
  }
  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) => oldDelegate.values != values;
}

class _FactorRow extends StatelessWidget {
  const _FactorRow({required this.name, required this.count, required this.max});
  final String name;
  final num count;
  final num max;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [SizedBox(width: 90, child: Text(name, overflow: TextOverflow.ellipsis)), Expanded(child: LinearProgressIndicator(value: max == 0 ? 0 : count / max, minHeight: 8, color: TaraColors.blue, backgroundColor: TaraColors.divider)), const SizedBox(width: 10), Text('$count', style: const TextStyle(fontWeight: FontWeight.w700))]));
}
