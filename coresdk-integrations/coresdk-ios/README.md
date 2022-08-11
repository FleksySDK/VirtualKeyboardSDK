# iOS-Fleksy-Core-Sample

## Description

This repository consists of a demo app for the Fleksy Core SDK package.

## Requirements

* Xcode 13
* iOS 15+

## Credentials

The FleksyCoreSample project requires setting valid Fleksy Core SDK credentials in the `info.plist` (for the keys `SDKLicenseKey` and `SDKLicenseSecret`).

## Architecture

The project uses Model-View-ViewModel (MVVM) pattern with SwiftUI.

## Fleksy Core SDK integration

These are the files of the demo app where the integration of the Fleksy Core SDK occurs:

* `FleksyLibManager.swift`. The `FleksyLibManager` class configures and uses the APIs of the `FleksyLib` object for Autocorrection and Next word prediction.
* `LanguagesManager.swift`. The `LanguagesManager` class uses the `LanguagesHelper` APIs of the Core SDK to have an up-to-date language file for the `en-US` locale.
* `Candidate.swift`. This file contains an extension to the Fleksy Core SDK `Candidate` type to showcase how to apply a `Candidate` object to a string.
