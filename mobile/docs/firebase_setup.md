# Firebase Setup Guide

ForenShield uses Firebase exclusively for Push Notifications (FCM). It does **NOT** use Firebase Authentication or Firestore.

## Prerequisites
- A Firebase project created at [console.firebase.google.com](https://console.firebase.google.com).
- Flutter CLI and Firebase CLI (`curl -sL https://firebase.tools | bash`).

## Configuration Steps
1. Run `dart pub global activate flutterfire_cli`.
2. Navigate to `mobile/` and run `flutterfire configure`.
3. Select your Firebase project and enable Android/iOS support.
4. This will automatically generate `lib/firebase_options.dart` and `google-services.json` / `GoogleService-Info.plist`.

## Android Requirements
Ensure your `android/build.gradle` has the Google Services classpath:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

Ensure `android/app/build.gradle` applies the plugin:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Push Notifications Testing
The backend automatically stores the user's FCM token upon login. To test:
1. Log into the app on a physical device or emulator with Google Play Services.
2. Send a test push notification via the Firebase Console to the generated FCM token printed in the IDE console.
