# zkmf2024_app

## Build and Release
### Android
* Make sure you have to `upload-keystore.jks` available
* Add file `[project]/android/key.properties`
  ```
  storePassword=<see ZKMF2024 Upload Keystore>
  keyPassword=<see ZKMF2024 Upload Keystore>
  keyAlias=upload
  storeFile=../upload-keystore.jks
  ```
* `flutter build appbundle`
* Upload `build/app/outputs/bundle/release/app-release.aab` to Google Play Console
* Increase version in [pubspec.yaml](pubspec.yaml)

## Icons
* See [flutter_launcher_icons.yaml](flutter_launcher_icons.yaml)
* Run `dart run flutter_launcher_icons`
