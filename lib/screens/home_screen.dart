import 'package:flutter/material.dart';
import '../models/game_model.dart';
import 'add_edit_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Game> _games = [];
  String _searchQuery = '';
  GameStatus? _filterStatus;
  Genre? _filterGenre;
  String _sortBy = 'date'; // date, hours, rating

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    _games = [
      Game.create(
        title: 'The Witcher 3',
        genre: Genre.rpg,
        platform: Platform.pc,
        hoursPlayed: 120,
        rating: 10,
        status: GameStatus.completed,
        notes: 'Odlična priča!',
        dateCompleted: DateTime(2025, 12, 1),
      ),
      Game.create(
        title: 'Elden Ring',
        genre: Genre.rpg,
        platform: Platform.playstation,
        hoursPlayed: 85,
        rating: 9,
        status: GameStatus.completed,
        notes: 'Teško ali zabavno',
        dateCompleted: DateTime(2026, 1, 15),
      ),
      Game.create(
        title: 'Counter-Strike 2',
        genre: Genre.shooter,
        platform: Platform.pc,
        hoursPlayed: 250,
        rating: 8,
        status: GameStatus.inProgress,
        notes: 'Competitive ranked',
      ),
      Game.create(
        title: 'Stardew Valley',
        genre: Genre.simulation,
        platform: Platform.pc,
        hoursPlayed: 45,
        rating: 9,
        status: GameStatus.inProgress,
        notes: 'Relaksirajuće',
      ),
      Game.create(
        title: 'Mario Kart 8',
        genre: Genre.racing,
        platform: Platform.nintendo,
        hoursPlayed: 30,
        rating: 8,
        status: GameStatus.completed,
        notes: 'Zabavno sa društvom',
        dateCompleted: DateTime(2026, 2, 10),
      ),
      Game.create(
        title: 'Silent Hill 2',
        genre: Genre.horror,
        platform: Platform.playstation,
        hoursPlayed: 12,
        rating: 9,
        status: GameStatus.abandoned,
        notes: 'Previše strašno!',
      ),
    ];
  }

  List<Game> get _filteredAndSortedGames {
    var filtered = _games;


    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((g) => g.matchesSearch(_searchQuery)).toList();
    }


    if (_filterStatus != null) {
      filtered = GameStatisticsHelper.filterByStatus(filtered, _filterStatus);
    }


    if (_filterGenre != null) {
      filtered = GameStatisticsHelper.filterByGenre(filtered, _filterGenre);
    }


    switch (_sortBy) {
      case 'hours':
        filtered = GameStatisticsHelper.sortByHours(filtered, true);
        break;
      case 'rating':
        filtered = GameStatisticsHelper.sortByRating(filtered, true);
        break;
      default:
        filtered = GameStatisticsHelper.sortByDateAdded(filtered, true);
    }

    return filtered;
  }

  void _addGame(Game game) {
    setState(() => _games.add(game));
  }

  void _updateGame(Game updatedGame) {
    setState(() {
      final index = _games.indexWhere((g) => g.id == updatedGame.id);
      if (index != -1) {
        _games[index] = updatedGame;
      }
    });
  }

  void _deleteGame(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Potvrda brisanja'),
        content: const Text('Da li ste sigurni da želite obrisati ovu igru?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Obriši'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _games.removeWhere((g) => g.id == id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Igra obrisana')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalHours = GameStatisticsHelper.getTotalHoursPlayed(_games);
    final avgRating = GameStatisticsHelper.getAverageRating(_games);
    final completedCount = GameStatisticsHelper.getCompletedGamesCount(_games);
    final inProgressCount = GameStatisticsHelper.getInProgressGamesCount(_games);
    final mostPlayed = GameStatisticsHelper.getMostPlayedGame(_games);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('GameHub 🎮'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          // Filter po statusu
          PopupMenuButton<GameStatus?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => setState(() => _filterStatus = value),
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: null, child: Text('Svi statusi')),
              ...GameStatus.values.map((s) => PopupMenuItem(
                value: s,
                child: Text('${s.icon} ${s.displayName}'),
              )),
            ],
          ),
          const SizedBox(width: 4),

          // Filter po žanru
          PopupMenuButton<Genre?>(
            icon: const Icon(Icons.category),
            onSelected: (value) => setState(() => _filterGenre = value),
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: null, child: Text('Svi žanrovi')),
              ...Genre.values.map((g) => PopupMenuItem(
                value: g,
                child: Text('${g.icon} ${g.displayName}'),
              )),
            ],
          ),
          const SizedBox(width: 4),

          // Sortiranje
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'date', child: Text('Po datumu')),
              const PopupMenuItem(value: 'hours', child: Text('Po satima')),
              const PopupMenuItem(value: 'rating', child: Text('Po ocjeni')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Statistika
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade700, Colors.deepPurple.shade400],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCard(
                      title: 'Ukupno sati',
                      value: '${totalHours.toStringAsFixed(0)}h',
                      icon: Icons.timer,
                      color: Colors.orange,
                    ),
                    _StatCard(
                      title: 'Prosj. ocjena',
                      value: avgRating.toStringAsFixed(1),
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                    _StatCard(
                      title: 'Završeno',
                      value: completedCount.toString(),
                      icon: Icons.emoji_events,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCard(
                      title: 'U toku',
                      value: inProgressCount.toString(),
                      icon: Icons.play_circle,
                      color: Colors.blue,
                    ),
                    _StatCard(
                      title: 'Omiljena',
                      value: mostPlayed?.title.split(' ').first ?? '-',
                      icon: Icons.favorite,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pretraga
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '🔍 Pretraži igre...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 8),

          // Lista igara
          Expanded(
            child: _filteredAndSortedGames.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.games, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nema igara', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredAndSortedGames.length,
              itemBuilder: (ctx, index) {
                final game = _filteredAndSortedGames[index];
                return Dismissible(
                  key: Key(game.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Potvrda'),
                        content: Text('Obriši igru "${game.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Odustani'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Obriši'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) => _deleteGame(game.id),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            game.genre.icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              game.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(game.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              game.status.displayName,
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '${game.genre.displayName} • ${game.platform.displayName}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.timer, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(game.formattedHours, style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 12),
                              Text(game.ratingStars, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          if (game.notes.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              game.notes,
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.purple),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => AddEditGameScreen(game: game),
                            ),
                          );
                          if (result != null) {
                            _updateGame(result);
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const AddEditGameScreen()),
          );
          if (result != null) {
            _addGame(result);
          }
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(GameStatus status) {
    switch (status) {
      case GameStatus.completed:
        return Colors.green;
      case GameStatus.inProgress:
        return Colors.blue;
      case GameStatus.notStarted:
        return Colors.grey;
      case GameStatus.abandoned:
        return Colors.red;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}