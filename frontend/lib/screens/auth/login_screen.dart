import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';
import '../../widgets/tara_common.dart';
import '../../services/api_service.dart';

/// Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _api = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        final result = await _api.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (mounted) {
          final user = Map<String, dynamic>.from(result['user'] as Map);
          context.go(user['role'] == 'admin' ? '/admin' : '/home');
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString().replaceFirst('Exception: ', '')),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: TaraColors.bgCoolWhite),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Selamat Datang Kembali 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masuk ke akun Anda untuk melanjutkan',
              style: TextStyle(fontSize: 14, color: TaraColors.textMuted),
            ),
            const SizedBox(height: 32),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TaraInputField(
                    label: 'Email atau Nomor HP',
                    hintText: 'Masukkan email atau nomor HP',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.mail_outline),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email atau nomor HP tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TaraInputField(
                    label: 'Kata Sandi',
                    hintText: 'Masukkan kata sandi',
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Kata sandi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lupa Sandi
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.push('/forgot-password');
                },
                child: const Text(
                  'Lupa Kata Sandi?',
                  style: TextStyle(
                    color: TaraColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Masuk
            TaraGradientButton(
              label: 'Masuk',
              isLoading: _isLoading,
              onPressed: _handleLogin,
            ),
            const SizedBox(height: 24),

            // Divider
            const TaraDivider(text: 'atau'),
            const SizedBox(height: 24),

            // Google Sign In
            TaraGhostButton(
              label: '🔵 Masuk dengan Google',
              onPressed: () {
                // TODO: Implement Google Sign In
              },
            ),
            const SizedBox(height: 32),

            // Sign Up Link
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Belum punya akun? ',
                  style: const TextStyle(
                    color: TaraColors.textMuted,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'Daftar di sini',
                      style: const TextStyle(
                        color: TaraColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go('/register');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
