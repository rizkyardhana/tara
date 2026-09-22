import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../widgets/tara_buttons.dart';

/// Verifikasi OTP Screen
class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({Key? key}) : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 60;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (_) => FocusNode());
    _controllers = List.generate(4, (_) => TextEditingController());
    
    // Start resend timer
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) {
        setState(() => _canResend = true);
      }
    });
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleVerify() {
    final otp = _controllers.map((c) => c.text).join();
    
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 4 digit kode OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to safety agreement
        context.go('/safety-agreement');
      }
    });
  }

  void _handleResend() {
    if (!_canResend) return;
    
    // Reset OTP fields
    for (var controller in _controllers) {
      controller.clear();
    }
    
    setState(() {
      _canResend = false;
      _resendTimer = 60;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode OTP telah dikirim ulang')),
    );

    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) {
        setState(() => _canResend = true);
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
              'Verifikasi Email Anda 📧',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: TaraColors.textDeepIndigo,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan kode OTP yang telah kami kirimkan',
              style: TextStyle(
                fontSize: 14,
                color: TaraColors.textMuted,
              ),
            ),
            const SizedBox(height: 40),

            // OTP Input Boxes
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 60,
                    height: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: TaraColors.divider),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          if (index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Verifikasi
            TaraGradientButton(
              label: 'Verifikasi',
              isLoading: _isLoading,
              onPressed: _handleVerify,
            ),
            const SizedBox(height: 20),

            // Resend OTP
            Center(
              child: Column(
                children: [
                  const Text(
                    'Tidak menerima kode?',
                    style: TextStyle(
                      color: TaraColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _canResend ? _handleResend : null,
                    child: Text(
                      _canResend
                          ? 'Kirim ulang kode'
                          : 'Kirim ulang dalam $_resendTimer detik',
                      style: TextStyle(
                        color: _canResend
                            ? TaraColors.blue
                            : TaraColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
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
