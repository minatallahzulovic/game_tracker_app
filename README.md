# 🎮 GameHub - Gaming Tracker

![Flutter](https://img.shields.io/badge/Flutter-3.29.3-blue)
![Dart](https://img.shields.io/badge/Dart-3.7.0-blue)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Windows-lightgrey)

## 📱 O aplikaciji

**GameHub** je mobilna web aplikacija razvijena u **Flutter** framework-u koja omogućava korisnicima da prate svoje video igre. Aplikacija pomaže gejmerima da zabilježe vrijeme provedeno u igrama, ocijene naslove i prate napredak kroz različite statuse.

### ✨ Glavne funkcionalnosti

- ✅ **Dodavanje, uređivanje i brisanje igara**
- ✅ **Praćenje sati igranja** (sa tačnošću na jednu decimalu)
- ✅ **Ocjenjivanje igara** (1-10 sa zvjezdicama)
- ✅ **Statistički pregled** (ukupno sati, prosječna ocjena, završene igre)
- ✅ **Pretraga igara** (po naslovu, žanru, platformi, bilješkama)
- ✅ **Filtriranje** (po statusu i žanru)
- ✅ **Sortiranje** (po datumu, satima, ocjeni)
- ✅ **Lokalizacija** (bosanski i engleski jezik)

### 🎯 Podržani žanrovi

| Žanr | Ikona |
|------|-------|
| Akcija | 🎯 |
| RPG | ⚔️ |
| Strategija | ♟️ |
| Trkaće | 🏎️ |
| Sport | ⚽ |
| Pucačina | 🔫 |
| Avantura | 🗺️ |
| Simulacija | 🏭 |
| Horror | 👻 |
| Puzzle | 🧩 |

### 🖥️ Podržane platforme

| Platforma | Ikona |
|-----------|-------|
| PC | 💻 |
| PlayStation | 🎮 |
| Xbox | 🎮 |
| Nintendo | 🎮 |
| Mobilni | 📱 |
| Ostalo | 🎮 |

### 📊 Statusi igara

| Status | Ikona | Opis |
|--------|-------|------|
| Nije započeto | ⭕ | Planirano za igranje |
| U toku | 🔄 | Trenutno se igra |
| Završeno | ✅ | Glavna priča završena |
| Napušteno | ❌ | Odustalo od igre |

---

## 🚀 Pokretanje aplikacije

### Preduslovi

- **Flutter SDK** 3.0.0 ili noviji
- **Chrome** ili neki drugi web preglednik
- **Git** (opciono, za kloniranje)

### Koraci za pokretanje

# 1. Kloniraj repozitorij
git clone https://github.com/minatallahzulovic/game_tracker_app.git

# 2. Uđi u folder projekta
cd game_tracker_app

# 3. Instaliraj dependencyje
flutter pub get

# 4. Generiši lokalizaciju
flutter gen-l10n

# 5. Pokreni aplikaciju na Chrome-u
flutter run -d chrome

## 📂 Struktura projekta

game_tracker_app/
├── lib/
│   ├── main.dart                 # Ulazna tačka aplikacije
│   ├── models/
│   │   └── game_model.dart       # Model podataka (Game klasa, enum-i, helperi)
│   ├── screens/
│   │   ├── home_screen.dart      # Glavni ekran (lista, statistika)
│   │   └── add_edit_game_screen.dart # Ekran za unos/uređivanje
│   └── l10n/                     # Lokalizacijski fajlovi
│       ├── app_en.arb            # Engleski prijevodi
│       └── app_bs.arb            # Bosanski prijevodi
├── pubspec.yaml                  # Dependencyji i konfiguracija
├── l10n.yaml                     # Konfiguracija za lokalizaciju
└── README.md                     # Ova dokumentacija

## 🛠️ Korištene tehnologije

Tehnologija	Verzija	Namjena
Flutter	3.29.3	Framework za izradu aplikacije
Dart	3.7.0	Programski jezik
intl	0.20.2	Internacionalizacija
uuid	4.5.1	Generisanje jedinstvenih ID-eva

## 🌐 Lokalizacija

Aplikacija podržava dva jezika:

🇧🇦 Bosanski (default)

🇬🇧 English

Promjena jezika: Klik na ikonicu 🌐 u gornjem desnom uglu AppBar-a.

## Autor

Minatallah Zulović









