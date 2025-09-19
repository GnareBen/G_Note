# G Note

Une application moderne et puissante de gestion de tâches construite avec Flutter, offrant une architecture offline-first et une synchronisation transparente.

## Fonctionnalités

### Fonctionnalités Principales
- **Gestion des Tâches** - Créez, modifiez, supprimez et organisez vos tâches efficacement
- **Mode Hors-ligne** - Fonctionne parfaitement sans internet, synchronise une fois connecté
- **Synchronisation Temps Réel** - Synchronisation automatique en arrière-plan pour garder vos données à jour
- **Architecture Clean** - Code robuste et maintenable suivant les meilleures pratiques
- **Material Design 3** - Interface moderne et intuitive avec des animations fluides

### Points Techniques
- **Gestion d'État BLoC** - Gestion d'état prévisible avec flutter_bloc
- **Stockage Local SQLite** - Base de données locale rapide et fiable avec sqflite
- **Traitement en Arrière-plan** - Synchronisation automatique toutes les heures via WorkManager
- **Injection de Dépendances** - Gestion propre des dépendances avec GetIt
- **Gestion des Erreurs** - Gestion complète des erreurs avec messages conviviaux

## Démarrage

### Prérequis
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code avec les extensions Flutter
- Le développement iOS nécessite macOS avec Xcode

### Installation

1. Cloner le dépôt
```bash
git clone https://github.com/yourusername/g_task.git
cd g_task
```

2. Installer les dépendances
```bash
flutter pub get
```

3. Lancer l'application
```bash
flutter run
```

### Compilation pour Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## Architecture

G Note suit les principes de **Clean Architecture** avec trois couches distinctes :

- **Couche Domaine** - Logique métier et entités
- **Couche Données** - Implémentations des dépôts, sources de données et modèles
- **Couche Présentation** - Composants UI, pages et gestion d'état

### Stack Technique
- **Flutter** - Framework UI multi-plateforme
- **BLoC** - Pattern Business Logic Component
- **SQLite** - Base de données locale
- **Dio** - Client HTTP
- **GetIt** - Service locator pour l'injection de dépendances
- **WorkManager** - Planification de tâches en arrière-plan
- **Dartz** - Utilitaires de programmation fonctionnelle

## Configuration API

L'application se connecte à une API backend pour la synchronisation :
- URL de base : `http://192.168.1.64:8000/api`
- Points de terminaison : `/tasks`
- Timeout : 30 secondes

## Développement

### Lancer les Tests
```bash
flutter test
```

### Analyse du Code
```bash
flutter analyze
```

### Nettoyage et Reconstruction
```bash
flutter clean
flutter pub get
```

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à soumettre une Pull Request.

## Licence

Ce projet est sous licence MIT - voir le fichier LICENSE pour plus de détails.
