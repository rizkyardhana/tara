import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/api_service.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_common.dart';

class BisindoScreen extends StatefulWidget {
  const BisindoScreen({super.key});
  @override
  State<BisindoScreen> createState() => _BisindoScreenState();
}

class _BisindoScreenState extends State<BisindoScreen> {
  final _api = ApiService();
  late Future<List<dynamic>> _videos;
  String _category = 'Semua';
  String? _selectedId;
  VideoPlayerController? _controller;
  bool _autoStarted = false;
  String? _playerError;

  @override
  void initState() {
    super.initState();
    _videos = _api.getBisindoVideos();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _play(dynamic video) async {
    final url = '${video['videoUrl'] ?? ''}';
    if (url.isEmpty) return;
    await _controller?.dispose();
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    setState(() {
      _selectedId = '${video['id']}';
      _controller = controller;
      _playerError = null;
    });
    try {
      await controller.initialize();
      await controller.play();
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) {
        setState(() => _playerError = url);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Player langsung gagal memuat video Drive. Gunakan tombol Buka Drive.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BISINDO 🤟'), elevation: 0, backgroundColor: TaraColors.bgCoolWhite),
      body: FutureBuilder<List<dynamic>>(
        future: _videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Video belum dapat dimuat: ${snapshot.error}'));
          final videos = snapshot.data ?? [];
          final categories = ['Semua', ...videos.map((video) => '${video['category']}').toSet()];
          final filtered = _category == 'Semua' ? videos : videos.where((video) => video['category'] == _category).toList();
          if (!_autoStarted && filtered.isNotEmpty) {
            _autoStarted = true;
            Future.microtask(() => _play(filtered.first));
          }
          return RefreshIndicator(
            onRefresh: () async => setState(() => _videos = _api.getBisindoVideos()),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text('Bahasa Isyarat Indonesia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TaraColors.textDeepIndigo)),
                const SizedBox(height: 6),
                const Text('Perpustakaan visual dari Google Drive TARA.', style: TextStyle(color: TaraColors.textMuted)),
                const SizedBox(height: 18),
                SizedBox(height: 40, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: categories.length, separatorBuilder: (_, index) => const SizedBox(width: 8), itemBuilder: (context, index) {
                  final category = categories[index];
                  return ChoiceChip(label: Text(category), selected: category == _category, onSelected: (_) => setState(() => _category = category), selectedColor: TaraColors.blue, labelStyle: TextStyle(color: category == _category ? Colors.white : TaraColors.textDeepIndigo));
                })),
                const SizedBox(height: 20),
                if (_controller != null && _controller!.value.isInitialized) _Player(controller: _controller!),
                if (_playerError != null) _DriveFallback(url: _playerError!),
                if ((_controller != null && _controller!.value.isInitialized) || _playerError != null) const SizedBox(height: 18),
                ...filtered.map((video) => _VideoCard(video: video, selected: _selectedId == '${video['id']}', onPlay: () => _play(video))),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({required this.controller});
  final VideoPlayerController controller;
  @override
  Widget build(BuildContext context) => TaraCard(padding: EdgeInsets.zero, child: ClipRRect(borderRadius: BorderRadius.circular(24), child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: Stack(alignment: Alignment.bottomCenter, children: [VideoPlayer(controller), VideoProgressIndicator(controller, allowScrubbing: true, colors: const VideoProgressColors(playedColor: TaraColors.blue, bufferedColor: Colors.white54, backgroundColor: Colors.white24))]))));
}

class _DriveFallback extends StatelessWidget {
  const _DriveFallback({required this.url});
  final String url;
  @override
  Widget build(BuildContext context) => TaraCard(backgroundColor: TaraColors.blue.withValues(alpha: 0.1), child: Row(children: [const Expanded(child: Text('Video tersedia di Google Drive. Buka untuk mulai menonton.', style: TextStyle(color: TaraColors.textDeepIndigo))), const SizedBox(width: 12), ElevatedButton(onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication), child: const Text('Buka Drive'))]));
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video, required this.selected, required this.onPlay});
  final dynamic video;
  final bool selected;
  final VoidCallback onPlay;
  @override
  Widget build(BuildContext context) {
    final title = '${video['title'] ?? 'Video BISINDO'}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TaraCard(
        onTap: onPlay,
        border: selected ? Border.all(color: TaraColors.blue, width: 2) : null,
        child: Row(
          children: [
            Container(
              width: 76,
              height: 64,
              decoration: BoxDecoration(
                color: TaraColors.blue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(selected ? Icons.pause_circle_filled : Icons.play_circle_fill, color: TaraColors.blue, size: 38),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 5),
                  Text('${video['category'] ?? 'Umum'}', style: const TextStyle(fontSize: 12, color: TaraColors.textMuted)),
                  const SizedBox(height: 5),
                  Text('${video['description'] ?? 'Materi video BISINDO'}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: TaraColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.play_arrow, color: TaraColors.blue),
          ],
        ),
      ),
    );
  }
}
