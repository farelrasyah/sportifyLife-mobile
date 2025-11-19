import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../cubits/verify_cubit.dart';
import '../../cubits/auth_cubit.dart';
import '../../app/routes.dart';
import '../../utils/storage_helper.dart';
import '../../data/models/user_model.dart';

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
    _initializeVerification();
  }

  /// Initialize verification flow
  Future<void> _initializeVerification() async {
    final expiry = await StorageHelper().getVerificationExpiry();
    final expiryTime = expiry ?? DateTime.now().add(const Duration(minutes: 1));

    // Save expiry if it doesn't exist
    if (expiry == null) {
      await StorageHelper().saveVerificationExpiry(expiryTime);
    }

    // Start verification flow with auto-check
    if (mounted) {
      context.read<VerifyCubit>().startVerificationFlow(
        widget.email,
        expiryTime,
      );
    }
  }

  /// Format duration as MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Open email app
  Future<void> _openEmailApp() async {
    final Uri emailUri = Uri(scheme: 'mailto');
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showSnackBar('Could not open email app', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error opening email app', isError: true);
    }
  }

  /// Resend verification email
  Future<void> _resendVerification() async {
    context.read<VerifyCubit>().resendVerification(widget.email);

    // Save new expiry time
    final newExpiry = DateTime.now().add(const Duration(minutes: 1));
    await StorageHelper().saveVerificationExpiry(newExpiry);
  }

  /// Manually check verification status
  void _checkStatus() {
    context.read<VerifyCubit>().checkVerificationStatus();
  }

  /// Show snackbar message
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle successful verification - auto-login
  void _handleVerificationSuccess(UserModel user) async {
    _showSnackBar('Email verified! Logging you in...', isError: false);

    // Update auth state
    context.read<AuthCubit>().updateUserAfterVerification(user);

    // Wait a moment for user to see the message
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Navigate to complete profile or home
      // Check if user details are complete
      // For now, navigate to complete profile
      Navigator.of(context).pushReplacementNamed(Routes.completeProfileScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
          },
          tooltip: 'Back to Login',
        ),
        actions: [
          // Help button
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelpDialog();
            },
            tooltip: 'Help',
          ),
        ],
      ),
      body: BlocConsumer<VerifyCubit, VerifyState>(
        listener: (context, state) {
          if (state is VerifySuccess) {
            _handleVerificationSuccess(state.user);
          } else if (state is VerifyError) {
            _showSnackBar(state.error, isError: true);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // Email Icon with status indicator
                  _buildStatusIcon(state),

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

                  // Email address
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Status card
                  _buildStatusCard(state),

                  const SizedBox(height: 24),

                  // Instructions
                  _buildInstructions(state),

                  const SizedBox(height: 32),

                  // Action buttons
                  _buildActionButtons(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build status icon with animation
  Widget _buildStatusIcon(VerifyState state) {
    IconData iconData;
    Color iconColor;

    if (state is VerifySuccess) {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
    } else if (state is VerifyError) {
      iconData = Icons.error;
      iconColor = Colors.red;
    } else if (state is VerifyExpired) {
      iconData = Icons.access_time;
      iconColor = Colors.orange;
    } else if (state is VerifyLoading) {
      iconData = Icons.hourglass_empty;
      iconColor = Colors.blue;
    } else if (state is VerifyPending && state.isChecking) {
      iconData = Icons.sync;
      iconColor = Colors.blue;
    } else {
      iconData = Icons.email_outlined;
      iconColor = Theme.of(context).primaryColor;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(iconData, size: 100, color: iconColor),
        if (state is VerifyPending && state.isChecking)
          const Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }

  /// Build status card showing timer or status message
  Widget _buildStatusCard(VerifyState state) {
    if (state is VerifyPending) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.blue.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Verification expires in',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _formatDuration(state.remainingTime),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            if (state.isChecking) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Checking verification status...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    } else if (state is VerifyExpired) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(Icons.access_time, color: Colors.orange.shade700, size: 32),
            const SizedBox(height: 12),
            Text(
              'Verification Link Expired',
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please request a new verification email',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else if (state is VerifyLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing...', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Build instructions text
  Widget _buildInstructions(VerifyState state) {
    if (state is VerifyExpired) {
      return Column(
        children: [
          Text(
            '⚠️ Your verification link has expired',
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Click the button below to receive a new verification email',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.check_circle_outline, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Check your email inbox',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.check_circle_outline, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Click the verification link',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.check_circle_outline, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Return here - we\'ll log you in automatically',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Don't see the email? Check your spam folder",
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(VerifyState state) {
    final isLoading = state is VerifyLoading;
    final isExpired = state is VerifyExpired;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Check Status Button (only show if pending)
        if (state is VerifyPending) ...[
          ElevatedButton.icon(
            onPressed: isLoading ? null : _checkStatus,
            icon: const Icon(Icons.refresh),
            label: const Text('Check Verification Status'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Open Email Button
        OutlinedButton.icon(
          onPressed: isLoading ? null : _openEmailApp,
          icon: const Icon(Icons.email),
          label: const Text('Open Email App'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Resend Button
        OutlinedButton.icon(
          onPressed: isLoading ? null : _resendVerification,
          icon: const Icon(Icons.send),
          label: Text(isExpired ? 'Send New Email' : 'Resend Verification'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: isExpired ? Colors.orange : Colors.blue,
              width: isExpired ? 2 : 1,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Back to Login
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(Routes.loginScreen);
                },
          child: const Text('Back to Login'),
        ),
      ],
    );
  }

  /// Show help dialog
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Help'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Why do I need to verify my email?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Email verification ensures the security of your account and allows us to send you important notifications.',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              const Text(
                'I haven\'t received the email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '1. Check your spam/junk folder\n2. Make sure you entered the correct email\n3. Wait a few minutes for delivery\n4. Click "Resend Verification" to get a new email',
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              const Text(
                'The link expired',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Verification links expire after 1 minute for security. Simply click "Resend Verification" to get a new link.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
