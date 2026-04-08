// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GameHub';

  @override
  String get addGame => 'Add Game';

  @override
  String get editGame => 'Edit Game';

  @override
  String get gameTitle => 'Game Title';

  @override
  String get genre => 'Genre';

  @override
  String get platform => 'Platform';

  @override
  String get hoursPlayed => 'Hours Played';

  @override
  String get rating => 'Rating (1-10)';

  @override
  String get status => 'Status';

  @override
  String get notes => 'Notes';

  @override
  String get save => 'SAVE';

  @override
  String get deleteConfirmation => 'Delete game?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get gameDeleted => 'Game deleted';

  @override
  String get totalHours => 'Total Hours';

  @override
  String get averageRating => 'Avg Rating';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get favorite => 'Favorite';

  @override
  String get search => 'Search games...';

  @override
  String get noGames => 'No games';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get allGenres => 'All genres';

  @override
  String get sortByDate => 'By date';

  @override
  String get sortByHours => 'By hours';

  @override
  String get sortByRating => 'By rating';

  @override
  String get titleRequired => 'Game title is required';

  @override
  String get hoursRequired => 'Hours played is required';

  @override
  String get hoursInvalid => 'Enter valid hours';

  @override
  String get genreRequired => 'Select a genre';

  @override
  String get platformRequired => 'Select a platform';
}
