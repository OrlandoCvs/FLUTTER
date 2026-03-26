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

  // Controladores
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  // ── Acciones ──────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _authService.signIn(
          email:    _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
      } else {
        await _authService.register(
          email:    _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          username: _usernameCtrl.text.trim(),
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.lose.withOpacity(0.9),
        content: Text(
          msg,
          style: const TextStyle(
            fontFamily: 'monospace',
            color: Colors.white,
          ),
        ),
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

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Logo Universidad de Sonora (coloca tu imagen en assets/images/unison.png)
                _UnisonLogo(),

                const SizedBox(height: 24),

                // Título del juego
                Text('TICTACTOE PVP', style: AppTextStyles.pixelTitle)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.3),

                const SizedBox(height: 6),
                Text(
                  'TIC · TAC · TOE',
                  style: AppTextStyles.pixelDim.copyWith(letterSpacing: 4),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 8),
                // Créditos del equipo
                Text(
                  'Saul Filiberto Espinoza Rivera & Lilian Yeitnaletzi Álvarez portillo & María Yamile Valencia Loroña & Orlando Cervantes Sousa & Hugo Alan Hinojoza Lopez & Sebastián Molina Pérez',
                  style: AppTextStyles.pixelDim,
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 40),

                // Selector Login / Registro
                _ModeToggle(isLogin: _isLogin, onToggle: _toggleMode),

                const SizedBox(height: 32),

                // Campos del formulario
                if (!_isLogin) ...[
                  _RetroField(
                    controller: _usernameCtrl,
                    label: 'USUARIO',
                    icon: Icons.person_outline,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingresa tu usuario';
                      if (v.length < 3) return 'Mínimo 3 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                _RetroField(
                  controller: _emailCtrl,
                  label: 'CORREO',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa tu correo';
                    if (!v.contains('@')) return 'Correo no válido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _RetroField(
                  controller: _passwordCtrl,
                  label: 'CONTRASEÑA',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 36),

                if (_isLoading)
                  const CircularProgressIndicator(color: AppColors.primary)
                else
                  RetroButton(
                    label: _isLogin ? 'INICIAR SESIÓN' : 'REGISTRARSE',
                    onPressed: _submit,
                    color: AppColors.primary,
                    fontSize: 15,
                  ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: _toggleMode,
                  child: Text(
                    _isLogin
                        ? '¿No tienes cuenta? REGÍSTRATE'
                        : '¿Ya tienes cuenta? INICIA SESIÓN',
                    style: AppTextStyles.pixelDim.copyWith(
                      color: AppColors.info,
                      decoration: TextDecoration.underline,
                    ),
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

// ── Subwidgets ──────────────────────────────────────────────────────────────

class _UnisonLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Intenta cargar el logo; si no existe muestra un placeholder
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12)],
      ),
      child: ClipRect(
        child: Image.asset(
          'assets/images/unison.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Text(
              'UNISON',
              style: AppTextStyles.pixelDim.copyWith(
                color: AppColors.accent,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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