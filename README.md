# Shopping store mobile app

## Installation
Shopping store requires [Flutter](https://docs.flutter.dev/get-started/install) v3.13.4 and Dart v3.1.2 to run.

Install the dependencies and devDependencies and start the server.

```sh
flutter pub get
flutter run
```

To build production android build...

- add the file ~/android/key.properties.
- add ~/key/*.jks file and configure it's credentials in above file.
- run below commands.
```sh
flutter build apk --release
flutter build appbundle
```

To build production ios build...
```sh
flutter build ipa
```


