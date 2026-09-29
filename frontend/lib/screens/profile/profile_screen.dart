import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../services/api_service.dart';
import '../../widgets/tara_common.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _api = ApiService();
  String _name = 'Muhammad Rizky';
  String _email = 'rizkiardhana@email.com';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _api.getProfile();
      if (!mounted) return;
      setState(() {
        _name = profile['name'] as String? ?? _name;
        _email = profile['email'] as String? ?? _email;
      });
    } catch (_) {
      // Keep the local fallback when the API is unavailable.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TaraColors.authBackgroundGradient[1],
      appBar: AppBar(
        title: const Text('Profil'),
        elevation: 0,
        backgroundColor: TaraColors.authBackgroundGradient.first,
      ),
      body: TaraPastelBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: TaraColors.authButtonGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: TaraColors.textDeepIndigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: TaraColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Menu
              const Text(
                'Akun dan preferensi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: TaraColors.textDeepIndigo,
                ),
              ),
              const SizedBox(height: 12),
              _ProfileMenuItem(
                icon: Icons.person_outline,
                label: 'Edit Profil',
                onTap: () {
                  context.push('/edit-profile');
                },
              ),
              _ProfileMenuItem(
                icon: Icons.accessibility,
                label: 'Aksesibilitas',
                onTap: () => context.push('/accessibility'),
              ),
              _ProfileMenuItem(
                icon: Icons.shield_outlined,
                label: 'Privasi & Keamanan',
                onTap: () => context.push('/privacy'),
              ),
              _ProfileMenuItem(
                icon: Icons.notifications_outlined,
                label: 'Notifikasi',
                onTap: () => context.push('/notifications'),
              ),
              _ProfileMenuItem(
                icon: Icons.support_agent_rounded,
                label: 'Dukungan krisis',
                onTap: () => context.push('/security-crisis'),
              ),
              _ProfileMenuItem(
                icon: Icons.help_outline,
                label: 'Pusat Bantuan',
                onTap: () => context.push('/help-center'),
              ),
              _ProfileMenuItem(
                icon: Icons.info_outline,
                label: 'Tentang TARA',
                onTap: () => context.push('/about'),
              ),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: TaraColors.error),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(color: TaraColors.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari TARA?'),
        content: const Text('Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ApiService.sessionToken = null;
              context.go('/login');
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: TaraColors.authAccent),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, color: TaraColors.textDeepIndigo),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: TaraColors.textMuted,
      ),
    );
  }
}
