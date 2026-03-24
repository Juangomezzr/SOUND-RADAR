# Sound Radar

Sound Radar is a Flutter application that allows users to discover and share music based on their geographical location. Users can see what others are listening to on a map and share their own favorite songs. The app leverages Gemini for an enhanced experience.

## Features

- **User Authentication:** Secure login to the application.
- **Interactive Map:** View and share music on an interactive map.
- **Real-time Geolocation:** Discover music being played around you in real-time.
- **User Profiles:** Create and manage your user profile.
- **Song Sharing:** Share your favorite songs with others.
- **AI-Powered Features:** Enhanced experience with Gemini.

## Technologies Used

- **Flutter:** An open-source UI software development kit created by Google.
- **Dart:** The programming language used for Flutter development.
- **flutter_map:** A versatile and customizable map plugin for Flutter.
- **geolocator:** A Flutter plugin for easy access to platform-specific location services.
- **latlong2:** A library for geographical coordinate calculations.
- **Gemini API:** Integration with Google's Gemini for AI-powered features.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- An API key for Gemini.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your_username/sound_radar.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd sound_radar/sound_radar
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the application:**
    You need to provide your Gemini API key as a command-line argument.
    ```sh
    flutter run --dart-define=GEMINI_API_KEY=YOUR_API_KEY
    ```

## Project Structure

The `lib` folder contains the main source code of the application, organized as follows:

```
lib/
├── config/         # Configuration files
├── models/         # Data models (e.g., User, Song)
├── screens/        # UI screens (e.g., Login, Map, Profile)
├── services/       # Business logic and services (e.g., Gemini service)
├── theme/          # Application theme and styling
├── widgets/        # Reusable UI components
└── main.dart       # Main application entry point
```

## License

Distributed under the MIT License. See `LICENSE` for more information.
