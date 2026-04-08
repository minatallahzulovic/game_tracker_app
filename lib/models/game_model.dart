import 'package:uuid/uuid.dart';

enum GameStatus {
  notStarted('Nije započeto', '⭕'),
  inProgress('U toku', '🔄'),
  completed('Završeno', '✅'),
  abandoned('Napušteno', '❌');

  final String displayName;
  final String icon;
  const GameStatus(this.displayName, this.icon);
}

enum Genre {
  action('Akcija', '🎯'),
  rpg('RPG', '⚔️'),
  strategy('Strategija', '♟️'),
  racing('Trkaće', '🏎️'),
  sports('Sport', '⚽'),
  shooter('Pucačina', '🔫'),
  adventure('Avantura', '🗺️'),
  simulation('Simulacija', '🏭'),
  horror('Horror', '👻'),
  puzzle('Puzzle', '🧩');

  final String displayName;
  final String icon;
  const Genre(this.displayName, this.icon);
}

enum Platform {
  pc('PC', '💻'),
  playstation('PlayStation', '🎮'),
  xbox('Xbox', '🎮'),
  nintendo('Nintendo', '🎮'),
  mobile('Mobilni', '📱'),
  other('Ostalo', '🎮');

  final String displayName;
  final String icon;
  const Platform(this.displayName, this.icon);
}

class Game {
  final String id;
  final String title;
  final Genre genre;
  final Platform platform;
  final double hoursPlayed;
  final int rating; // 1-10
  final GameStatus status;
  final String notes;
  final DateTime dateAdded;
  final DateTime? dateCompleted;

  Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.platform,
    required this.hoursPlayed,
    required this.rating,
    required this.status,
    required this.notes,
    required this.dateAdded,
    this.dateCompleted,
  });


  String get ratingStars {
    final fullStars = rating ~/ 2;
    return '⭐' * fullStars + (rating % 2 == 1 ? '½' : '');
  }

  String get formattedHours => '${hoursPlayed.toStringAsFixed(1)}h';

  String get formattedRating => '$rating/10';

  bool get isCompleted => status == GameStatus.completed;


  Game copyWith({
    String? id,
    String? title,
    Genre? genre,
    Platform? platform,
    double? hoursPlayed,
    int? rating,
    GameStatus? status,
    String? notes,
    DateTime? dateAdded,
    DateTime? dateCompleted,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      platform: platform ?? this.platform,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      dateAdded: dateAdded ?? this.dateAdded,
      dateCompleted: dateCompleted ?? this.dateCompleted,
    );
  }


  static Game create({
    required String title,
    required Genre genre,
    required Platform platform,
    required double hoursPlayed,
    required int rating,
    required GameStatus status,
    String notes = '',
    DateTime? dateCompleted,
  }) {
    return Game(
      id: const Uuid().v4(),
      title: title,
      genre: genre,
      platform: platform,
      hoursPlayed: hoursPlayed,
      rating: rating,
      status: status,
      notes: notes,
      dateAdded: DateTime.now(),
      dateCompleted: status == GameStatus.completed
          ? (dateCompleted ?? DateTime.now())
          : null,
    );
  }


  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        genre.displayName.toLowerCase().contains(lowerQuery) ||
        platform.displayName.toLowerCase().contains(lowerQuery) ||
        notes.toLowerCase().contains(lowerQuery);
  }

  String toCSV() {
    return '"$id","$title","${genre.name}","${platform.name}",$hoursPlayed,$rating,"${status.name}","$notes","${dateAdded.toIso8601String()}","${dateCompleted?.toIso8601String() ?? ""}"';
  }
}

class GameStatisticsHelper {
  static double getTotalHoursPlayed(List<Game> games) {
    return games.fold(0, (sum, game) => sum + game.hoursPlayed);
  }

  static double getAverageRating(List<Game> games) {
    if (games.isEmpty) return 0;
    final sum = games.fold(0, (sum, game) => sum + game.rating);
    return sum / games.length;
  }

  static int getCompletedGamesCount(List<Game> games) {
    return games.where((g) => g.status == GameStatus.completed).length;
  }

  static int getInProgressGamesCount(List<Game> games) {
    return games.where((g) => g.status == GameStatus.inProgress).length;
  }

  static Map<Genre, double> getHoursByGenre(List<Game> games) {
    final Map<Genre, double> result = {};
    for (final game in games) {
      result[game.genre] = (result[game.genre] ?? 0) + game.hoursPlayed;
    }
    return result;
  }

  static Map<Platform, double> getHoursByPlatform(List<Game> games) {
    final Map<Platform, double> result = {};
    for (final game in games) {
      result[game.platform] = (result[game.platform] ?? 0) + game.hoursPlayed;
    }
    return result;
  }

  static Game? getMostPlayedGame(List<Game> games) {
    if (games.isEmpty) return null;
    return games.reduce((a, b) => a.hoursPlayed > b.hoursPlayed ? a : b);
  }

  static Game? getHighestRatedGame(List<Game> games) {
    if (games.isEmpty) return null;
    return games.reduce((a, b) => a.rating > b.rating ? a : b);
  }

  static List<Game> sortByHours(List<Game> games, bool descending) {
    final list = List<Game>.from(games);
    list.sort((a, b) => descending
        ? b.hoursPlayed.compareTo(a.hoursPlayed)
        : a.hoursPlayed.compareTo(b.hoursPlayed));
    return list;
  }

  static List<Game> sortByRating(List<Game> games, bool descending) {
    final list = List<Game>.from(games);
    list.sort((a, b) => descending
        ? b.rating.compareTo(a.rating)
        : a.rating.compareTo(b.rating));
    return list;
  }

  static List<Game> sortByDateAdded(List<Game> games, bool descending) {
    final list = List<Game>.from(games);
    list.sort((a, b) => descending
        ? b.dateAdded.compareTo(a.dateAdded)
        : a.dateAdded.compareTo(b.dateAdded));
    return list;
  }

  static List<Game> filterByStatus(List<Game> games, GameStatus? status) {
    if (status == null) return games;
    return games.where((g) => g.status == status).toList();
  }

  static List<Game> filterByGenre(List<Game> games, Genre? genre) {
    if (genre == null) return games;
    return games.where((g) => g.genre == genre).toList();
  }

  static List<Game> filterByPlatform(List<Game> games, Platform? platform) {
    if (platform == null) return games;
    return games.where((g) => g.platform == platform).toList();
  }
}