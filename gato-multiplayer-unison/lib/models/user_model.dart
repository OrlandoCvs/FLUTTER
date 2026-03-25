class UserModel {
  final String uid;
  final String username;
  final String email;
  final int wins;
  final int games;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.wins = 0,
    this.games = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      wins: map['wins'] ?? 0,
      games: map['games'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'wins': wins,
      'games': games,
    };
  }
}