# 🎮 Tank Battle Game - Multiplayer

> **Initial version developed during 2024–2025**  
> **Developer:** Taimur Tariq

A real-time multiplayer tank game built with Flutter, Flame, and Firebase.

## Features
- **Multiplayer**: Real-time position syncing and chat using Cloud Firestore.
- **Combat**: Joystick movement, shooting mechanics, and power-ups.
- **Effects**: Particle explosions, improved lighting, and sound effects.
- **Cross-Platform**: Android and iOS support.

## Setup Instructions

### 1. Firebase Configuration
This game requires Firebase for multiplayer functionality.
1. Go to [Firebase Console](https://console.firebase.google.com/).
2. Create a new project.
3. Enable **Authentication** and turn on **Anonymous** sign-in.
4. Enable **Cloud Firestore** and start in Test Mode (or set proper security rules).
5. Add an Android App:
   - Package name: `com.example.tank_game` (or your updated package name)
   - Download `google-services.json`
   - Place it in `android/app/google-services.json`
6. (Optional) Add an iOS App:
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/GoogleService-Info.plist`

### 2. Assets
Ensure you have the following assets in `assets/images/`:
- `tank.png`
- `bullet.png`
- `obstacle.png`

And in `assets/audio/`:
- `shoot.mp3`
- `explosion.mp3`
- `hit.mp3`
- `bgm.mp3`

### 3. Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Credits
Built with Flutter & Flame Engine.
