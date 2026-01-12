# Space Invaders – Flame Prototype

This project is a small Space Invaders–inspired prototype built with the Flame
game engine and Flutter Web. The goal of this project is to demonstrate
adaptability to a new engine, clean architecture, and the use of Flame features.

## 🎮 Controls
- Left / Right Arrow: Move
- Space: Shoot
- R: Replay

## 🏆 Win & Lose Conditions
- Win: Destroy all invaders
- Lose: Player loses all lives or invaders reach the bottom

## 🧠 Architecture Overview
- Flame used for rendering and gameplay
- BLoC used for game state management
- Components follow a scalable entity-based structure
- Design patterns applied: State, Strategy, Object Pool


## 🚀 Run Locally
flutter pub get
flutter run -d chrome
