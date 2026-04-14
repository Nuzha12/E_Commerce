import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
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
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: saving
                    ? null
                    : () async {
                  if (!formKey.currentState!.validate()) return;
                  setState(() => saving = true);
                  final user = await ProfileLocalDataSource().updateProfile(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                  );
                  if (!mounted) return;
                  context.read<AuthBloc>().add(AuthProfileUpdated(user));
                  Navigator.pop(context);
                },
                child: saving
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Save Changes'),
              )
            ],
          ),
        ),
      ),
    );
  }
}