import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/sound_service.dart';
import '../../widgets/retro_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authService = AuthService();
  bool _isLogin = true;
  bool _isLoading = false;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _authService.signIn(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
      } else {
        await _authService.register(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          username: _usernameCtrl.text.trim(),
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showError("Error de autenticación. Revisa tus datos.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.lose.withOpacity(0.9),
        content: Text(msg, style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 12)),
      ),
    );
  }

  void _toggleMode() {
    SoundService.instance.playClick();
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center( // Centramos todo el contenido
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ocupa solo el espacio necesario
                children: [
                  const _UnisonLogo(),
                  const SizedBox(height: 20),
                  Text('PIXEL GATO', style: AppTextStyles.pixelTitle.copyWith(fontSize: 28))
                      .animate().fadeIn().slideY(begin: -0.2),
                  const SizedBox(height: 4),
                  Text('TIC · TAC · TOE', style: AppTextStyles.pixelDim.copyWith(letterSpacing: 2, fontSize: 12)),
                  
                  const SizedBox(height: 12),
                  
                  // Créditos reducidos para evitar overflow
                  Text(
                    'EQUIPO: Espinoza, Álvarez, Valencia, Cervantes, Hinojoza, Molina',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.pixelDim.copyWith(fontSize: 9),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 24),
                  _ModeToggle(isLogin: _isLogin, onToggle: _toggleMode),
                  const SizedBox(height: 24),

                  if (!_isLogin) ...[
                    _RetroField(
                      controller: _usernameCtrl,
                      label: 'USUARIO',
                      icon: Icons.person_outline,
                      validator: (v) => (v == null || v.length < 3) ? 'Corto' : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  _RetroField(
                    controller: _emailCtrl,
                    label: 'CORREO',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => (v == null || !v.contains('@')) ? 'Inválido' : null,
                  ),
                  const SizedBox(height: 12),

                  _RetroField(
                    controller: _passwordCtrl,
                    label: 'CONTRASEÑA',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6' : null,
                  ),

                  const SizedBox(height: 28),

                  if (_isLoading)
                    const CircularProgressIndicator(color: AppColors.primary)
                  else
                    RetroButton(
                      label: _isLogin ? 'INGRESAR' : 'CREAR CUENTA',
                      onPressed: _submit,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),

                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _toggleMode,
                    child: Text(
                      _isLogin ? '¿No tienes cuenta? REGÍSTRATE' : '¿Ya tienes cuenta? LOGIN',
                      style: AppTextStyles.pixelDim.copyWith(
                        color: AppColors.info,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnisonLogo extends StatelessWidget {
  const _UnisonLogo();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        // Efecto retro para que el logo resalte
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            blurRadius: 10,
          )
        ],
      ),
      child: Image.asset(
        'assets/images/unison.png',
        fit: BoxFit.contain,
        // Si la imagen no carga, mostramos un fallback para que no truene la app
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, color: AppColors.accent),
        ),
      ),
    );
  }
}

// ── Subwidgets ──────────────────────────────────────────────────────────────



class _ModeToggle extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;
  const _ModeToggle({required this.isLogin, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Tab(label: 'INGRESAR',   active: isLogin,  onTap: isLogin  ? null : onToggle),
        _Tab(label: 'REGISTRAR',  active: !isLogin, onTap: !isLogin ? null : onToggle),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const _Tab({required this.label, required this.active, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppColors.primary : AppColors.border,
                width: active ? 2 : 1,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: active ? AppColors.primary : AppColors.textDim,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _RetroField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _RetroField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'monospace',
        color: AppColors.textPrimary,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'monospace',
          color: AppColors.textDim,
          fontSize: 12,
          letterSpacing: 2,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lose),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lose, width: 2),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'monospace',
          color: AppColors.lose,
          fontSize: 11,
        ),
        filled: true,
        fillColor: AppColors.surfaceLight,
      ),
    );
  }
}