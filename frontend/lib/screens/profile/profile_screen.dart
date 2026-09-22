import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../services/api_service.dart';

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
      appBar: AppBar(
        title: const Text('Profil'),
        elevation: 0,
        backgroundColor: TaraColors.bgCoolWhite,
      ),
      body: SingleChildScrollView(
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
                        colors: TaraColors.taraGradient,
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

            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCard(label: 'Check-in', value: '23'),
                _StatCard(label: 'Hari Berturut-turut', value: '7'),
                _StatCard(label: 'Aktivitas', value: '12'),
              ],
            ),
            const SizedBox(height: 32),

            // Menu
            const Text(
              'Pengaturan & Lainnya',
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
              onTap: () {
                // TODO: Navigate to accessibility settings
              },
            ),
            _ProfileMenuItem(
              icon: Icons.shield_outlined,
              label: 'Privasi & Keamanan',
              onTap: () {
                // TODO: Navigate to privacy settings
              },
            ),
            _ProfileMenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifikasi',
              onTap: () {
                // TODO: Navigate to notification settings
              },
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline,
              label: 'Pusat Bantuan',
              onTap: () {
                // TODO: Navigate to help center
              },
            ),
            _ProfileMenuItem(
              icon: Icons.info_outline,
              label: 'Tentang TARA',
              onTap: () {
                // TODO: Navigate to about
              },
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
              context.go('/login');
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: TaraColors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: TaraColors.textMuted),
        ),
      ],
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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: TaraColors.textDeepIndigo),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: TaraColors.textDeepIndigo,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: TaraColors.textMuted),
          ],
        ),
      ),
    );
  }
}
