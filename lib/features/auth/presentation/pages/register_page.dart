import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/');
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF7675), Color(0xFFFDCB6E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Create account',
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Register and start exploring',
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: nameController,
                                validator: (value) => Validators.name(value ?? ''),
                                decoration: const InputDecoration(
                                  hintText: 'Full name',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: emailController,
                                validator: (value) => Validators.email(value ?? ''),
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                validator: (value) => Validators.password(value ?? ''),
                                decoration: const InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                              ),
                              const SizedBox(height: 18),
                              CustomButton(
                                text: 'Register',
                                loading: state.status == AuthStatus.loading,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      AuthRegisterRequested(
                                        nameController.text.trim(),
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: TextButton(
                                  onPressed: () => context.go('/login'),
                                  child: const Text('Back to login'),
                                ),
                              ),
                              if (state.error != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  state.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ]
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}