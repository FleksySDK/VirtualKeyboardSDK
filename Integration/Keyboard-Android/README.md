# SDK Sample

**SDK Sample** is a sample application built to showcase Fleksy Keyboard SDK's integration and features.

This keyboard has outstanding features included, such as: being able to type or swipe in 82 languages,
autocorrection, emojis, custom views on top of the keyboard, custom themes, and much more.

Once integrated, you can see an actual custom keyboard on your device.

## Requirements

- Latest Android Studio
- Android 5.0+ (API 21)
- Fleksy license and secret keys (from [developers.fleksy.com](https://developers.fleksy.com/))

## Development

To build this project, please set both license and secret keys as `fleksy_license_key` and `fleksy_license_secret`
in your respective project properties to populate the `BuildConfig` variables at build time.

## Fleksy Apps
1. The included GIPHY app requires a GIPHY API key to run properly. You must provide your own. You may [request one here](https://support.giphy.com/hc/en-us/articles/360020283431-Request-A-GIPHY-API-Key).
2. In the file `keyboardsdk-integrations/keyboard-android/app/src/main/java/co/thingthing/sample/sdksample/SimpleKeyboardService.kt` file, replace the text "ADD_YOUR_GIPHY_KEY_HERE" for your GIPHY API key.
3. Run the project.

## Documentation

- [Quick Start](https://docs.fleksy.com/quick-start/) - Get started developing your keyboard using the FleksySDK.
- [Documentation](https://docs.fleksy.com/) - FleksySDK documentation
- [Developer portal](https://developers.fleksy.com) - Fleksy developer portal.

## Licensing

All code and materials are © 2023 ThingThing Ltd.
