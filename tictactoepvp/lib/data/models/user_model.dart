/// Modelo de usuario almacenado en Firestore -> colección "users"
class UserModel {
  final String uid;
  final String username;
  final String email;
  final int wins;
  final int losses;
  final int draws;
  final int totalGames;

  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.totalGames = 0,
  });

  int get totalGamesPlayed => wins + losses + draws;

  /// Crea un UserModel desde un documento de Firestore
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      username: map['username'] as String? ?? 'Player',
      email: map['email'] as String? ?? '',
      wins: map['wins'] as int? ?? 0,
      losses: map['losses'] as int? ?? 0,
      draws: map['draws'] as int? ?? 0,
      totalGames: map['totalGames'] as int? ?? 0,
    );
  }

  /// Convierte el modelo a un Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'totalGames': totalGames,
    };
  }

  UserModel copyWith({
    int? wins,
    int? losses,
    int? draws,
    int? totalGames,
  }) {
    return UserModel(
      uid: uid,
      username: username,
      email: email,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      draws: draws ?? this.draws,
      totalGames: totalGames ?? this.totalGames,
    );
  }
}