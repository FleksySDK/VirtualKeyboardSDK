# iOS-Predictive-SDK-Sample

## Description

This repository consists of a demo app for the Fleksy Predictive SDK package.

## Requirements

* Xcode 13
* iOS 15+

## Credentials

The PredictiveSDKSample project requires setting valid Fleksy Predictive SDK credentials in the `info.plist` (for the keys `SDKLicenseKey` and `SDKLicenseSecret`).

## Architecture

The project uses Model-View-ViewModel (MVVM) pattern with SwiftUI.

## Predictive SDK integration

These are the files of the demo app where the integration of the Predictive SDK occurs:

* `PredictiveServiceManager.swift`. The `PredictiveServiceManager` class configures and uses the APIs of the `PredictiveService` object for Autocorrection and Next word prediction.
* `LanguagesManager.swift`. The `LanguagesManager` class uses the `LanguagesHelper` APIs of the Predictive SDK to have an up-to-date language file for the `en-US` locale.
* `Candidate.swift`. This file contains an extension to the Predictive SDK `Candidate` type to showcase how to apply a `Candidate` object to a string.
