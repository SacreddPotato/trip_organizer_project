import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_organizer_project/core/providers/auth_provider.dart';
import 'package:trip_organizer_project/core/theme/app_theme_colors.dart';
import 'package:trip_organizer_project/presentation/widgets/labeled_text_field.dart';
import 'package:trip_organizer_project/presentation/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    await auth.register(email: email, password: password, fullName: fullName);
    if (!mounted) return;
    setState(() => _loading = false);

    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error!)),
      );
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: context.appColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start planning your trips',
                style: TextStyle(
                  fontSize: 16,
                  color: context.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              LabeledTextField(
                label: 'Full Name',
                hint: 'John Doe',
                icon: Icons.person_outline,
                controller: _fullNameController,
              ),
              const SizedBox(height: 20),
              LabeledTextField(
                label: 'Email',
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              LabeledTextField(
                label: 'Password',
                hint: '••••••••',
                icon: Icons.lock_outline,
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              LabeledTextField(
                label: 'Confirm Password',
                hint: '••••••••',
                icon: Icons.lock_outline,
                controller: _confirmController,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: _loading ? 'Creating account…' : 'Register',
                onPressed: _loading ? null : _register,
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: context.appColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: context.appColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
