import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/api_service.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_common.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _api = ApiService();
  late Future<Map<String, dynamic>> _overview;
  late Future<List<dynamic>> _users;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _overview = _api.getAdminOverview();
    _users = _api.getAdminUsers();
  }

  Future<void> _changeUser(dynamic user) async {
    final role = user['role'] == 'admin' ? 'user' : 'admin';
    try {
      await _api.updateAdminUser('${user['id']}', role: role, status: '${user['status']}');
      setState(_reload);
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  Future<void> _toggleStatus(dynamic user) async {
    final status = user['status'] == 'active' ? 'suspended' : 'active';
    try {
      await _api.updateAdminUser('${user['id']}', role: '${user['role']}', status: status);
      setState(_reload);
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TARA Admin'), backgroundColor: TaraColors.blue, foregroundColor: Colors.white, actions: [IconButton(onPressed: () => context.go('/login'), icon: const Icon(Icons.logout))]),
      body: RefreshIndicator(
        onRefresh: () async => setState(_reload),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          const Text('Pusat kendali', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: TaraColors.textDeepIndigo)),
          const SizedBox(height: 5),
          const Text('Kelola akun, konten, dan kesehatan data TARA.', style: TextStyle(color: TaraColors.textMuted)),
          const SizedBox(height: 20),
          FutureBuilder<Map<String, dynamic>>(future: _overview, builder: (context, snapshot) {
            final data = snapshot.data ?? {};
            final users = Map<String, dynamic>.from(data['users'] ?? {});
            final moods = Map<String, dynamic>.from(data['moods'] ?? {});
            final content = Map<String, dynamic>.from(data['content'] ?? {});
            return GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.65, mainAxisSpacing: 12, crossAxisSpacing: 12, children: [
              _StatCard('Pengguna', '${users['totalUsers'] ?? '-'}', Icons.people, TaraColors.blue),
              _StatCard('Admin', '${users['totalAdmins'] ?? '-'}', Icons.admin_panel_settings, TaraColors.purple),
              _StatCard('Check-in', '${moods['totalCheckIns'] ?? '-'}', Icons.insights, TaraColors.green),
              _StatCard('Publikasi', '${content['totalVideos'] ?? '-'} video', Icons.video_library, TaraColors.warning),
            ]);
          }),
          const SizedBox(height: 28),
          const Text('Kelola akun pengguna', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: TaraColors.textDeepIndigo)),
          const SizedBox(height: 12),
          FutureBuilder<List<dynamic>>(future: _users, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Text('Gagal memuat akun: ${snapshot.error}');
            final users = snapshot.data ?? [];
            if (users.isEmpty) return const TaraCard(child: Text('Belum ada akun pengguna.'));
            return Column(children: users.map((user) => Padding(padding: const EdgeInsets.only(bottom: 10), child: TaraCard(child: ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(backgroundColor: user['role'] == 'admin' ? TaraColors.purple : TaraColors.blue, child: Icon(user['role'] == 'admin' ? Icons.shield : Icons.person, color: Colors.white)), title: Text('${user['name']}', style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('${user['email']}\n${user['role']} • ${user['status']}'), isThreeLine: true, trailing: PopupMenuButton<String>(onSelected: (value) => value == 'role' ? _changeUser(user) : _toggleStatus(user), itemBuilder: (_) => [PopupMenuItem(value: 'role', child: Text(user['role'] == 'admin' ? 'Jadikan user' : 'Jadikan admin')), PopupMenuItem(value: 'status', child: Text(user['status'] == 'active' ? 'Suspend akun' : 'Aktifkan akun'))]))))).toList());
          }),
          const SizedBox(height: 20),
          TaraCard(backgroundColor: TaraColors.blue.withValues(alpha: 0.1), child: const Row(children: [Icon(Icons.info_outline, color: TaraColors.blue), SizedBox(width: 10), Expanded(child: Text('Akun admin hanya dapat dibuat dari domain resmi atau oleh admin yang sudah berwenang.', style: TextStyle(color: TaraColors.textDeepIndigo)))])),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.label, this.value, this.icon, this.color);
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => TaraCard(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TaraColors.textDeepIndigo)), Text(label, style: const TextStyle(fontSize: 12, color: TaraColors.textMuted))]));
}
