# 🍽️ Meal Explorer

A Flutter meal discovery application that allows users to explore meals, search for recipes, browse categories, view detailed recipes, save favorites, share recipes, and interact with an AI meal assistant.

## ✨ Features

* 🔎 Search for meals by name
* 🗂️ Browse meals by categories
* 📖 View detailed recipes, ingredients, measurements, and instructions
* ❤️ Save and remove favorite meals
* 📤 Share recipes
* ▶️ Open recipe videos on YouTube
* 🤖 AI Meal Assistant for cooking and recipe-related questions
* 🎨 Clean and responsive Flutter UI
* 🌐 Real-time meal data using TheMealDB API

## 🛠️ Technologies

* Flutter
* Dart
* TheMealDB API
* OpenRouter API
* HTTP
* SharedPreferences
* flutter_dotenv
* share_plus
* url_launcher

## 🔌 APIs

### TheMealDB

The application uses TheMealDB API to retrieve meal information, categories, recipes, ingredients, instructions, and meal images.

### OpenRouter

OpenRouter is used to power the AI Meal Assistant, which provides help with cooking, recipes, ingredients, meals, and the application itself.

> The OpenRouter API key is stored locally in a `.env` file and is excluded from Git using `.gitignore`.

## 📱 Screenshots

<p align="center">
  <img src="screenshots/Screenshot%202026-09-07%20114138.png" width="180">
  <img src="screenshots/Screenshot%202026-09-08%20184850.png" width="180">
  <img src="screenshots/Screenshot%202026-09-08%20185137.png" width="180">
</p>

<p align="center">
  <img src="screenshots/Screenshot%202026-09-08%20185543.png" width="180">
  <img src="screenshots/Screenshot%202026-09-08%20185817.png" width="180">
  <img src="screenshots/Screenshot%202026-09-08%20185851.png" width="180">
</p>
## 🚀 Getting Started

### Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio or another Flutter-compatible IDE

### Installation

Clone the repository:

```bash
git clone https://github.com/ohoodjammal/meal-explorer-flutter.git
```

Navigate to the project:

```bash
cd meal-explorer-flutter
```

Install dependencies:

```bash
flutter pub get
```

Create a `.env` file in the project root:

```env
OPENROUTER_API_KEY=your_api_key_here
```
