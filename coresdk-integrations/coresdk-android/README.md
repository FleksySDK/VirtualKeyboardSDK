# Android-Fleksy-Core-Sample

## Description

This repository consists of a demo app for the Fleksy Core SDK package.

## Requirements

* Android Studio
* Android 7+

## Credentials

The FleksyCoreSample project requires setting valid Fleksy Core SDK credentials in the `build.gradle` (for the keys `fleksy_lib_license_key` and `fleksy_lib_license_secret`).

## Fleksy Core SDK integration

These are the files of the demo app where the integration of the Fleksy Core SDK occurs:

* `AppModule.kt`. This is the Hilt module where the `FleksyLib` class is instanced and configured.
* `MainFragment.kt`. The `MainFragment` class configures and uses the APIs of the `FleksyLib` object for Autocorrection and Next word prediction.
* `LoadingFragment.kt`. The `LoadingFragment` class uses the `LanguagesHelper` APIs of the Core SDK to have an up-to-date language file for the `en-US` locale.
