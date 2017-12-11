# Cordova POC

Simple project used to document and validate the creation of a Cordova app.

Check out the [Getting Started - iOS](GettingStarted-iOS.md) guide to understand iOS provisioning/signing if you're not already familiar with it.

# Configuring a New Environment

If you're on Mac and don't have Homebew installed, you should, get it together already!

```bash
# Android
brew cask install java
brew cask install android-sdk
sdkmanager "platform-tools" "platforms;android-27"
# iOS
xcode-select --install
npm install -g ios-deploy ios-sim
# Cordova
npm install -g cordova
```

## Android

Accept SDK licenses

```
sdkmanager --licenses
```

**Run**

```
cordova run android
```

## iOS

Follow the directions in this article:

https://cordova.apache.org/docs/en/latest/guide/platforms/ios/index.html

**Run**

```
cordova run ios
```

## Files to Update

* build.json - Update the `developmentTeam` and `provisioningProfile` fields
* config.xml - Update `widget id="<AppId>"` with your App Id
* circle.yml - This file is incomplete, may not fully work


## Android Helpful Functions

**See plugged in devices**

```
adb devices
```

**Manually install an APK file**

```
adb install C:\repos\MotionMobile\App\android
```

