# Fuzhou Mahjong Score Calculator (福州麻将计分器)

A modern, fast, and easy-to-use mobile application for keeping track of scores in Fuzhou Mahjong. Built with Flutter, this app streamlines the score-counting process, supporting customized game rules, complex winning conditions, and custom score distributions.

## Features

- **Player Management:** Easily configure names and icons for players in each game.
- **Round Score Calculation:** Keep track of game state including dealer (庄家), prevailing wind, etc.
- **Special Hands Support (特殊胡牌):** Built-in multiplier effects for special hands including:
  - Standard Win (平胡)
  - Self-drawn (自摸)
  - Golden Sparrow (金雀)
  - Three Golds (三金倒)
  - Robbing the Gold (抢金)
  - Golden Dragon (金龙)
- **Detailed Score Inputs:** Inputs for Flowers (花数), Golds (金数), and Kongs (槓数) directly factored into the scoring formula.
- **Draw/No-Winner Handling (流局):** Seamlessly handle rounds that end without a winner.
- **Custom Edit Score:** For nuanced situations or house rules, manually set the exact score each non-winner player lost.
- **Real-time Previews:** Preview the exact payout or loss for each participant before finalizing the round.
- **Modern UI:** Built with Material 3 design logic and the `google_fonts` package for a premium feel.

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **State Management:** [Riverpod](https://riverpod.dev/) (`flutter_riverpod`)
- **Fonts:** `google_fonts`
- **Icons:** `cupertino_icons`

## Getting Started

To run this app locally, ensure you have the Flutter SDK installed on your machine. 

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.9.0 or higher recommended)
- Android Studio / Xcode / VS Code for building to mobile devices or simulators.

### Installation

1. Clone or download the repository to your local machine:
   ```bash
   git clone <repository_url>
   cd fuzhou_majong_score
   ```

2. Install the necessary Dart dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## Usage
1. **Players Page:** Start by setting up the 4 players for your game session and selecting the starting dealer.
2. **Game Tracker:** From the main dashboard, you can track current dealer streaks, winds, and individual player scores.
3. **End Round Calculation:** When a round finishes, click to settle the round. Choose the winner, the ending style (self-drawn, special hand etc.), and input the tile elements (Flowers, Golds, and Kongs). You may also switch to custom score entry if needed.
4. **Game Rules Page:** Customize base point values and special winning condition multipliers in the settings.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
