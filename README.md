<h1 align="center">VirtualKeyboardSDK</h1>
<p align="center">
A SDK to create a Virtual Keyboard for iOS and Android 💁.
</p>

<p align="center">
  <a href="#about-keyboard-sdk">About</a> •
  <a href="#installation">Installation</a> •
  <a href="#supported-platforms">Supported Platforms</a> •
  <a href="#features">Features</a> •
  <a href="#integration">Integration</a> •
  <a href="#examples">Examples</a> •
  <a href="#benchmark">Benchmark</a> •
  <a href="#how-to-get-help">How to get help?</a> •
  <a href="#licensing">License</a>
  
  <br>
  <a href="https://docs.fleksy.com/" target="_blank">Documentation</a>
</p>


## About Keyboard SDK

The Virtual Keyboard SDK is a virtual keyboard for `iOS` and `Android`.

This keyboard has outstanding features included such as: being able to type or swipe in 82 languages, autocorrection, emojis, custom views on top of the keyboard, custom themes, and much more. 

Once integrated you would be able to see an actual virtual keyboard in your device.

## Installation

**iOS, iPadOS**

VirtualKeyboardSDK can be installed with the Swift Package Manager:

`https://github.com/FleksySDK/FleksySDK-iOS`

**Android**

VirtualKeyboardSDK can be installed with Maven:

`maven { url = "https://maven.fleksy.com/maven" }`

and adding the dependency:

```kotlin
dependencies {
  ...       
  // Keyboard SDK dependency
  implementation("co.thingthing.fleksycore:fleksycore-release:4.15.2")
}
```

## Supported Platforms

**Apple Platform**

`iOS 13` 

**Android Platform**

`Android API 21`

It also supports `kotlin` and `java`


## Features

* ⚡ **Custom Action**: The Virtual Keyboard SDK enables you to add custom actions directly to the keyboard layout. This might be custom buttons next to the space bar, specific images and associated actions. Check all the different options: [Custom Action iOS](https://docs.fleksy.com/sdk-ios/features/custom-action/) and [Custom Action Android](https://docs.fleksy.com/sdk-android/features/custom-action/).
* 🙋‍♀️ **Emojis**: Emojis are already configured by categories, and they are automatically updated to the latest supported version. Configure and check all the different options: [Emojis iOS](https://docs.fleksy.com/sdk-ios/features/emojis/) and [Emojis Android](https://docs.fleksy.com/sdk-android/features/emojis/).
* 📱 **In-App Keyboard**: The Virtual Keyboard SDK allows you to integrate the virtual keyboard as an in-app keyboard without needing a system-wide keyboard. This is specific for App developers in the cybersecurity space. Further details: [In-App Keyboard iOS](https://docs.fleksy.com/sdk-ios/features/in-app-keyboard/) and [In-App Keyboard Android](https://docs.fleksy.com/sdk-android/features/in-app-keyboard/).
* 🌍 **Languages**: The Virtual Keyboard SDK supports up to 82 different languages. 
* 🎨 **Theming**: The Virtual Keyboard SDK allows you to configure the appearance of the keyboard by changing colors, font, background and more for a different parts of the keyboard. For further details and comprehensive documentation: [Theming iOS](https://docs.fleksy.com/sdk-ios/features/theming/) and [Theming Android](https://docs.fleksy.com/sdk-android/features/theming/).
* 💅 **Topbar Icon**: The Virtual keyboard SDK empowers you to customize icons within the top bar, ranging from a basic image to a view positioned on either the right or left side of the topbar. Further details:  [Topbar iOS](https://docs.fleksy.com/sdk-ios/features/topbar-icon/) and [Topbar Android](https://docs.fleksy.com/sdk-android/features/topbar-icon/).


## Integration

Using the Fleksy Keyboard SDK you are able to create an App for iOS or Android which has a keyboard.

| Folder | Description |
| --- | --- |
| [/Integration/Keyboard-iOS](/Integration/Keyboard-iOS) | iOS project for an App which holds a keyboard built using the FleksySDK. |
| [/Integration/Keyboard-Android](/Integration/Keyboard-Android) | Android project for an App which has a keyboard built using the FleksySDK. |
| [/Integration/Keyboard-Flutter](/Integration/Keyboard-Flutter) | Flutter project for an App which holds a keyboard built using the FleksySDK. |

## Examples

1. Customise look&feel of the keyboard 🎨 -> [Examples/Style](/Examples/Style)
2. Download and Install Languages 🌍 -> [Examples/Languages](/Examples/Languages)
3. Add your own custom buttons on the keyboard layout 🔡 -> [Examples/CustomAction](/Examples/CustomAction)



## Benchmark

Want to test how KeyboardSDK works on your phone ?

Join our community to test how the VirtualKeyboardSDK performs.

| Public Link | Description |
| --- | --- |
| [iOS Testflight](https://testflight.apple.com/join/zOZEBpQ9) | iOS sample App for testing right away our last development on the KeyboardSDK.|
| [Android Firebase](https://appdistribution.firebase.dev/i/f9ae23f7f30c9045) | Android sample App for testing right away our last development on the KeyboardSDK.|


**Keyboard Performance Comparison**

Compare the perfomance of any keyboard against that of any other keyboard, use our open source tool: [Kebbie](https://github.com/FleksySDK/kebbie)

## Documentation

- [Quick Start](https://docs.fleksy.com/quick-start/) - Get started on developing your keyboard using the KeyboardSDK.
- [Documentation](https://docs.fleksy.com/) - FleksySDK documentation
- [Developer portal](https://developers.fleksy.com) - Fleksy developer portal.


## How to get help?

Any question that you might have, please post it directly into the [Github Discussion Forum](https://github.com/FleksySDK/fleksysdk/discussions).

Business related questions, please, go to our [developers portal](https://developers.fleksy.com/), we will assist you as soon as possible.


## Licensing

The Fleksy test SDK is proprietary binary code and licensed under the Fleksy Binary Trial License in the License folder.

The remaining source code available in this repository are licensed under the MIT license, a copy of which is also in the License folder
 
Documentation is distributed under the CC-BY-ND-4.0 license, available at https://creativecommons.org/licenses/by-nd/4.0/,
 
All code and materials are © 2024 ThingThing Ltd.

