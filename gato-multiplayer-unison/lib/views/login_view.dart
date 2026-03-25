import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import 'lobby_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo UAS
                Image.asset(
                  'assets/images/uas_logo.png',
                  height: 120,
                  errorBuilder: (_,_, _) => const Icon(
                    Icons.school,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Gato Unison',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Equipo: [Tus Nombres Aquí]',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 40),
                if (!_isLogin)
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de usuario',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => v!.isEmpty ? 'Requerido' : null,
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return 'Requerido';
                    if (!v.contains('@')) return 'Correo inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return 'Requerido';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => CustomButton(
                    text: _isLogin ? 'Iniciar Sesión' : 'Registrarse',
                    isLoading: auth.isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool success;
                        if (_isLogin) {
                          success = await auth.signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        } else {
                          success = await auth.signUp(
                            username: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                        if (success && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LobbyView()),
                          );
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error en autenticación')),
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() => _isLogin = !_isLogin);
                  },
                  child: Text(
                    _isLogin 
                        ? '¿No tienes cuenta? Regístrate' 
                        : '¿Ya tienes cuenta? Inicia sesión',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}