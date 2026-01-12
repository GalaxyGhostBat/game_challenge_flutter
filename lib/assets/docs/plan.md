# 8-Hour Development Plan

This plan outlines a focused approach to building a small Flame-based
prototype within a strict 8-hour time constraint.

---

## Planning & Scoping (15 minutes)
- Review challenge requirements
- Choose Space Invaders–style concept
- Identify required Flame features and design patterns
- Define strict scope limits

---

## Project Setup (30 minutes)
- Create Flutter Web project
- Add Flame and audio dependencies
- Set up basic Flame game loop
- Initialize Git repository

---

## Core Gameplay (2 hours)
- Player movement (left/right)
- Player shooting
- Enemy grid spawning and movement
- Basic projectile collision
- Win and lose conditions

---

## Architecture & Required Patterns (2 hours)
- Implement BLoC for game phase, score, and lives
- Apply State pattern to player behavior
- Apply Strategy pattern to enemy shooting
- Implement Object Pool pattern for projectiles

---

## Visual Feedback & Required Flame Features (2 hours)
- Sprite sheet animation (player or enemies)
- Flame effects for hits and deaths
- Particle effects for enemy destruction
- Apply at least one decorator
- Implement a simple custom camera transformation

---

## UI, Audio & Replay (45 minutes)
- HUD for lives and score
- Background music
- Sound effects
- Replay functionality

---

## Final Review & Deployment (30 minutes)
- Verify all challenge requirements are met
- Fix obvious bugs
- Build for web and deploy to GitHub Pages
