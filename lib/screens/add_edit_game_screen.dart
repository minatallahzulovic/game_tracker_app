import 'package:flutter/material.dart';
import '../models/game_model.dart';

class AddEditGameScreen extends StatefulWidget {
  final Game? game;

  const AddEditGameScreen({super.key, this.game});

  @override
  State<AddEditGameScreen> createState() => _AddEditGameScreenState();
}

class _AddEditGameScreenState extends State<AddEditGameScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _hoursController;
  late TextEditingController _notesController;
  late Genre _selectedGenre;
  late Platform _selectedPlatform;
  late int _selectedRating;
  late GameStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.game?.title ?? '');
    _hoursController =
        TextEditingController(text: widget.game?.hoursPlayed.toString() ?? '');
    _notesController = TextEditingController(text: widget.game?.notes ?? '');
    _selectedGenre = widget.game?.genre ?? Genre.action;
    _selectedPlatform = widget.game?.platform ?? Platform.pc;
    _selectedRating = widget.game?.rating ?? 5;
    _selectedStatus = widget.game?.status ?? GameStatus.notStarted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final game = Game.create(
        title: _titleController.text,
        genre: _selectedGenre,
        platform: _selectedPlatform,
        hoursPlayed: double.parse(_hoursController.text),
        rating: _selectedRating,
        status: _selectedStatus,
        notes: _notesController.text,
        dateCompleted:
        _selectedStatus == GameStatus.completed ? DateTime.now() : null,
      );
      Navigator.pop(context, game);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game == null ? 'Dodaj igru' : 'Uredi igru'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Naziv igre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.gamepad),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Unesite naziv igre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              DropdownButtonFormField<Genre>(
                value: _selectedGenre,
                decoration: const InputDecoration(
                  labelText: 'Žanr',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: Genre.values.map((genre) {
                  return DropdownMenuItem(
                    value: genre,
                    child: Text('${genre.icon} ${genre.displayName}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedGenre = value!),
                validator: (value) => value == null ? 'Odaberite žanr' : null,
              ),
              const SizedBox(height: 16),


              DropdownButtonFormField<Platform>(
                value: _selectedPlatform,
                decoration: const InputDecoration(
                  labelText: 'Platforma',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.devices),
                ),
                items: Platform.values.map((platform) {
                  return DropdownMenuItem(
                    value: platform,
                    child: Text('${platform.icon} ${platform.displayName}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedPlatform = value!),
                validator: (value) => value == null ? 'Odaberite platformu' : null,
              ),
              const SizedBox(height: 16),


              TextFormField(
                controller: _hoursController,
                decoration: const InputDecoration(
                  labelText: 'Sati igranja',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                  suffixText: 'sati',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Unesite sate igranja';
                  }
                  final hours = double.tryParse(value);
                  if (hours == null || hours < 0) {
                    return 'Unesite validan broj sati';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ocjena (1-10)'),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _selectedRating.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: _selectedRating.toString(),
                          activeColor: Colors.amber,
                          onChanged: (value) {
                            setState(() => _selectedRating = value.round());
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_selectedRating/10',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),


              DropdownButtonFormField<GameStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: GameStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text('${status.icon} ${status.displayName}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedStatus = value!),
              ),
              const SizedBox(height: 16),


              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Bilješke (opcionalno)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),


              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('SPREMI'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}