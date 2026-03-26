import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/game_service.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/retro_button.dart';
import '../game/game_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../auth/auth_screen.dart'; // Importamos AuthScreen por si acaso

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final _authService = AuthService();
  final _gameService = GameService();
  final _codeCtrl    = TextEditingController();
  
  StreamSubscription? _gameSubscription;
  UserModel? _user;
  bool _isLoading = false;
  String? _createdRoomCode;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _gameSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final user = await _authService.getUserProfile(uid);
    if (mounted) setState(() => _user = user);
  }

  Future<void> _createGame() async {
    if (_user == null) return;
    setState(() => _isLoading = true);

    try {
      final game = await _gameService.createGame(_user!);
      if (!mounted) return;
      setState(() {
        _createdRoomCode = game.roomCode;
        _isLoading       = false;
      });

      _gameSubscription = _gameService.watchGame(game.gameId).listen((updatedGame) {
        if (updatedGame?.isPlaying == true && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => GameScreen(
                gameId: game.gameId,
                currentUserId: _user!.uid,
              ),
            ),
          );
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Error al crear sala: $e');
      }
    }
  }

  Future<void> _joinGame() async {
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.length != 6 || _user == null) {
      _showError('Ingresa un código de 6 caracteres');
      return;
    }
    setState(() => _isLoading = true);

    try {
      final game = await _gameService.joinGame(code, _user!);
      if (game == null) {
        _showError('Sala no encontrada o ya está en juego');
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(
            gameId: game.gameId,
            currentUserId: _user!.uid,
          ),
        ),
      );
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.lose.withOpacity(0.9),
        content: Text(msg, style: const TextStyle(fontFamily: 'monospace')),
      ),
    );
  }

  // ── Lógica de Cierre de Sesión MODIFICADA ───────────────────────────────────

  Future<void> _handleSignOut() async {
    try {
      // 1. Cancelamos el stream de juego
      await _gameSubscription?.cancel();
      
      // 2. Cerramos sesión en Firebase
      await _authService.signOut();

      // 3. Limpiamos TODA la pila de navegación. 
      // Si '/' te está fallando, usamos MaterialPageRoute directamente a AuthScreen
      // para asegurar que no quede nada "encima".
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      _showError('Error al cerrar sesión: $e');
    }
  }

  // ── UI ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PIXEL GATO', style: AppTextStyles.pixelTitle.copyWith(fontSize: 24)),
                      if (_user != null)
                        Text(
                          'HOLA, ${_user!.username.toUpperCase()}',
                          style: AppTextStyles.pixelDim.copyWith(color: AppColors.accent),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.info),
                        boxShadow: [BoxShadow(color: AppColors.info.withOpacity(0.3), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.leaderboard, color: AppColors.info, size: 22),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              if (_user != null) _StatsBar(user: _user!),
              const SizedBox(height: 40),

              Text('── CREAR SALA ──', style: AppTextStyles.pixelSubtitle)
                  .animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 16),

              Center(
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : RetroButton(
                        label: '+ NUEVA PARTIDA',
                        onPressed: _createGame,
                        color: AppColors.primary,
                        fontSize: 15,
                      ),
              ),

              if (_createdRoomCode != null) ...[
                const SizedBox(height: 20),
                _RoomCodeDisplay(code: _createdRoomCode!),
              ],

              const SizedBox(height: 40),

              Text('── UNIRSE ──', style: AppTextStyles.pixelSubtitle)
                  .animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeCtrl,
                      maxLength: 6,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        letterSpacing: 6,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        hintText: 'ABC123',
                        hintStyle: TextStyle(
                          fontFamily: 'monospace',
                          color: AppColors.textDim,
                          letterSpacing: 4,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.secondary, width: 2),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  RetroButton(
                    label: 'ENTRAR',
                    onPressed: _joinGame,
                    color: AppColors.secondary,
                  ),
                ],
              ),

              const SizedBox(height: 60),

              Center(
                child: RetroButton(
                  label: 'CERRAR SESIÓN',
                  onPressed: _handleSignOut,
                  color: AppColors.textDim,
                  isOutlined: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (Subwidgets _StatsBar, _Stat, _RoomCodeDisplay iguales)
class _StatsBar extends StatelessWidget {
  final UserModel user;
  const _StatsBar({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        color: AppColors.surfaceLight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'WINS',   value: '${user.wins}',       color: AppColors.win),
          _Stat(label: 'LOSSES', value: '${user.losses}',     color: AppColors.lose),
          _Stat(label: 'DRAWS',  value: '${user.draws}',      color: AppColors.draw),
          _Stat(label: 'GAMES',  value: '${user.totalGames}', color: AppColors.info),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: color,
          shadows: [Shadow(color: color, blurRadius: 8)],
        )),
        Text(label, style: AppTextStyles.pixelDim.copyWith(fontSize: 10)),
      ],
    );
  }
}

class _RoomCodeDisplay extends StatelessWidget {
  final String code;
  const _RoomCodeDisplay({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent, width: 2),
        color: AppColors.accent.withOpacity(0.05),
        boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 16)],
      ),
      child: Column(
        children: [
          Text('CÓDIGO DE SALA', style: AppTextStyles.pixelDim),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                code,
                style: AppTextStyles.pixelTitle.copyWith(
                  color: AppColors.accent,
                  fontSize: 36,
                  letterSpacing: 10,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Código copiado')),
                  );
                },
                child: const Icon(Icons.copy, color: AppColors.accent, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Esperando oponente...',
            style: AppTextStyles.pixelDim.copyWith(color: AppColors.info),
          ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 1500.ms,
            color: AppColors.info,
          ),
        ],
      ),
    );
  }
}