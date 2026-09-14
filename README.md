# 🍽️ Meal Explorer

A Flutter meal discovery application that allows users to explore meals, search for recipes, browse categories, view detailed recipe information, save favorites, share recipes, and interact with an AI-powered meal assistant.

## ✨ Features

* 🔎 Search for meals by name
* 🗂️ Browse meals by categories
* 📖 View detailed recipes, ingredients, measurements, and cooking instructions
* ❤️ Add and remove meals from favorites
* 📤 Share recipes with others
* ▶️ Open recipe videos on YouTube
* 🤖 AI Meal Assistant for cooking and recipe-related questions
* 🌙 Dark mode
* 🎨 Clean and responsive Flutter UI
* 🌐 Fetch real-time meal data from TheMealDB API
* 💾 Store favorite meals locally

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

The application uses TheMealDB API to retrieve meal information, categories, recipes, ingredients, measurements, cooking instructions, meal images, and YouTube recipe links.

### OpenRouter

OpenRouter is used to power the AI Meal Assistant, which provides help with cooking, recipes, ingredients, meal ideas, and application-related questions.

> The OpenRouter API key is stored locally in a `.env` file and is excluded from Git using `.gitignore`.

## 📱 Screenshots

<p align="center">
  <img src="screenshots/Screenshot%202026-09-08%20184850.png" width="180">
  <img src="screenshots/Screenshot%202026-09-08%20185543.png" width="180">
  <img src="screenshots/Screenshot%202026-09-08%20185817.png" width="180">
</p>

<p align="center">
  <img src="screenshots/Screenshot%202026-09-08%20185137.png" width="180">
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
cd meal-explorer-flutter
