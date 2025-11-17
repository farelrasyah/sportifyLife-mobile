import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cubits/verifyCubit.dart';
import '../../app/routes.dart';
import '../../utils/storageHelper.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  Future<void> _startCountdown() async {
    final expiry = await StorageHelper().getVerificationExpiry();
    if (expiry != null && mounted) {
      context.read<VerifyCubit>().startPendingCountdown(widget.email, expiry);
    } else {
      // If no expiry, set new one
      final newExpiry = DateTime.now().add(const Duration(minutes: 1));
      await StorageHelper().saveVerificationExpiry(newExpiry);
      if (mounted) {
        context.read<VerifyCubit>().startPendingCountdown(
          widget.email,
          newExpiry,
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _openEmailApp() async {
    final Uri emailUri = Uri(scheme: 'mailto');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _resendVerification() async {
    context.read<VerifyCubit>().resendVerification(widget.email);
    final newExpiry = DateTime.now().add(const Duration(minutes: 1));
    await StorageHelper().saveVerificationExpiry(newExpiry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<VerifyCubit, VerifyState>(
        listener: (context, state) {
          if (state is VerifySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to complete profile after 2 seconds
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(
                  context,
                ).pushReplacementNamed(Routes.completeProfileScreen);
              }
            });
          } else if (state is VerifyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  // Email Icon
                  Icon(
                    Icons.email_outlined,
                    size: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 32),
                  // Title
                  const Text(
                    'Verify Your Email',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'We sent a verification link to',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Timer or Status
                  if (state is VerifyPending) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Expires in',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDuration(state.remainingTime),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (state is VerifyExpired) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Verification link expired',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else if (state is VerifyLoading) ...[
                    const Center(child: CircularProgressIndicator()),
                  ],
                  const SizedBox(height: 24),
                  // Instructions
                  Text(
                    'Please check your email and click the verification link within the time limit.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Don't see the email? Check your spam folder.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Open Email Button
                  ElevatedButton.icon(
                    onPressed: _openEmailApp,
                    icon: const Icon(Icons.email),
                    label: const Text('Open Email App'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Resend Button
                  OutlinedButton.icon(
                    onPressed: state is VerifyLoading
                        ? null
                        : _resendVerification,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Resend Verification'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
