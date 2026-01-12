# Sound Radar

Sound Radar is an Android app built with Flutter. It shows nearby users on a map and provides a profile screen with a short AI-generated music taste description based on the last 20 songs.

## Final delivery links

- Application files (ZIP): <[Google Drive Folder](https://drive.google.com/drive/folders/1euSzAt5f_N9daEFpduoHE2ZlUVm-ndTq?usp=sharing)>


## Install

1. Download the APK from the link above.
2. On your Android device, enable “Install unknown apps” for your browser or file manager.
3. Open the APK and install.

## Use

1. Launch the app.
2. Log in with:
   - Username: `purple`
   - Password: `group1`
3. Allow location access when prompted to load the map.
4. Tap the profile button to view the profile.

## Build release APK (local)

From the project root:

```bash
flutter build apk --release
```

The APK will be at:

```
build/app/outputs/flutter-apk/app-release.apk
```

## Android SDK requirements

- Uses Flutter tool defaults for `compileSdkVersion`, `targetSdkVersion`, and `minSdkVersion` (defined in `android/app/build.gradle.kts`).
- No Google API services required. The map uses `flutter_map` with Carto tiles.
- Requires location permission to show your position.

## Diferences with the figma demo

- Main diferences are related to the aspect of the UI to get a more profesional and stilized look.
- Changes in the login screen, and in the bar of the map screen.