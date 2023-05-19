# Drops Technology info Box

## Overview

All related information as regards configuration and packages used for the app will go here.

## Important Packages

- Firebase Auth
- Firebase Messaging (For push notifications)
- Firebase Cloud firestore (For cloud storage)
- Firebase core (For instantiating and initializing google firebase package)

## Before using

Before using this package ensure you have created a project and enabled these firebase features.

For authentication this project uses the **Google SignIn** and **Facebook SignIn** Authentication.

Once these have been enabled, You can use the **firebase cli** tool from **npm** to install the Command Line Interface tool for flutter configuration into the project.

## Commands

***Installing firebase CLI***

To install the firebase cli, run the following command:

```bash
//i firebase cli install command
npm install -g firebase-tools
```

***login to firebase CLI***

```bash
// firebase login
firebase login
```

***Install and Configuring the flutterfire***

```bash
// Flutter fire install
dart pub global activate flutterfire

// flutter fire configuration
flutterfire configure
```

*While this is running, choose the platforms you wish to enable the firebase support for in the command prompt*.

***Add Firebase core***

```bash
// add firebase core
flutter pub add firebase_core

// Then re run flutterfire configure to rebind the necessary packages enabled
// In your firebase project to your flutter project
flutterfire configure
```

******

## **FLUTTER APP CONFIGURES**

These configurations enable flutter to accept certain features from third party packages.

***MinimumSDK Version***

this will be found in the **android/app/main/AndroidManifest.xml** file.

***MultiDex Support***

For flutter tool to run successfully you need to add multiDex support.

```bash
// This can be achieved by running the flutter app in debug mode
flutter run --debug
```
