import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_common.dart';

class JournalEntriesScreen extends StatefulWidget {
  const JournalEntriesScreen({super.key});

  @override
  State<JournalEntriesScreen> createState() => _JournalEntriesScreenState();
}

class _JournalEntriesScreenState extends State<JournalEntriesScreen> {
  final _api = ApiService();
  late Future<List<dynamic>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = _api.getJournals();
  }

  Future<void> _refresh() async {
    final entries = _api.getJournals();
    setState(() => _entries = entries);
    await entries;
  }

  Future<void> _createEntry() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _JournalComposer(),
    );
    if (result == null || !mounted) return;

    try {
      await _api.saveJournal(result);
      await _refresh();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Catatan tersimpan.')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan belum tersimpan. Coba lagi sebentar.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TaraColors.authBackgroundGradient[1],
      appBar: AppBar(
        title: const Text('Catatan jurnal'),
        backgroundColor: TaraColors.authBackgroundGradient.first,
        actions: [
          IconButton(
            tooltip: 'Muat ulang catatan',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createEntry,
        backgroundColor: TaraColors.authAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('Tulis catatan'),
      ),
      body: TaraPastelBackground(
        child: FutureBuilder<List<dynamic>>(
          future: _entries,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _MessageState(
                icon: Icons.cloud_off_outlined,
                title: 'Catatan belum dapat dimuat',
                detail: 'Periksa koneksi lalu coba muat ulang.',
                actionLabel: 'Coba lagi',
                onAction: _refresh,
              );
            }

            final entries = snapshot.data ?? [];
            if (entries.isEmpty) {
              return _MessageState(
                icon: Icons.edit_note_rounded,
                title: 'Ruang refleksimu dimulai di sini',
                detail:
                    'Tuliskan pikiran atau perasaanmu. Catatan ini bersifat pribadi.',
                actionLabel: 'Tulis catatan pertama',
                onAction: _createEntry,
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                itemCount: entries.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = Map<String, dynamic>.from(entries[index]);
                  final title = '${entry['title'] ?? ''}'.trim();
                  final content = '${entry['content'] ?? entry['notes'] ?? ''}'
                      .trim();
                  final date = DateTime.tryParse('${entry['createdAt'] ?? ''}');
                  return TaraCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (date != null)
                          Text(
                            MaterialLocalizations.of(
                              context,
                            ).formatMediumDate(date),
                            style: const TextStyle(
                              color: TaraColors.authAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (title.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              color: TaraColors.textDeepIndigo,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        if (content.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            content,
                            style: const TextStyle(
                              color: TaraColors.textMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.detail,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: TaraColors.authAccent),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: TaraColors.textDeepIndigo,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(color: TaraColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalComposer extends StatefulWidget {
  const _JournalComposer();

  @override
  State<_JournalComposer> createState() => _JournalComposerState();
}

class _JournalComposerState extends State<_JournalComposer> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;
    Navigator.of(context).pop({
      'title': _titleController.text.trim(),
      'content': content,
      'tags': <String>[],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: TaraColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Catatan baru',
                  style: TextStyle(
                    color: TaraColors.textDeepIndigo,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Judul (opsional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  autofocus: true,
                  minLines: 4,
                  maxLines: 7,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Apa yang ingin kamu catat?',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Simpan catatan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
