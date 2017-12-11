# Apple Provisioning Overview

Before doing any work with Apple's Provisioning system, please watch the first two sections of this Pluralsight course.
This process is very confusing and complicated. The course provides both background and explicit steps on how to get started.

https://app.pluralsight.com/library/courses/deploying-ios-apps/table-of-contents


## Apple Terminology

### Certificates


### Application ids:

Uniquely identify each application. Uniquely associated with a single iOS developer team.

Example: `com.drivetime.publicmobile`

**Bundle Identifiers:*

AppIds are related to bundle identifiers. ApplicationId can match one or several Bundle Identifiers. Are the reverse-DNS style identifiers configured in the XCode project

Can use a WildcardId to match your applications, BUT cannot use if your app uses Push Notification.

### Device Ids

UDID - uniquiely identifies a device

### Provisioning Profiles

Tie together:
* Certificates - who is installing the software, are they are registered iOS developer
* Application Identifiers - what software is allowed to be installed
* Device Identifiers - what devices the software can be installed on

Provisioning profiles **do expire** and need to be renewed through the portal

### Team Provisioning Profiles

Profiles managed exclusively by XCode, cannot be edited in portal.

### Apple Web Sites

* Dev Center - Documentation, Downloads, Beta Software
https://developer.apple.com/develop/

* Member Center - Manage Apple Developer Membership
https://developer.apple.com/account

* Provisioning Portal - Manage Cryptographic Information
https://developer.apple.com/account/ios/certificate/


## Provisioning Steps

### Create 'Development' Certificate

Overview:
* Create 'Certificate Signing Request' (CSR)
* Submit the CSR to Apple to generate a certificate
* Download and install certificate

Steps:

**IMPORTANT: Lock your Keychain before running the Certificate Signing Assistant**
* Go to https://developer.apple.com/account/ios/certificate/development/create
* Go to Certificates > Development, select the "iOS App Development" option
* NOTE: on the Certificates page, if your Mac is new you may need to download the 'Worldwide Developer Relations Certificate Authority" cert, so that the cert you create is based off theirs
* Follow directions on how to create a 'Certificate Signing Request'
    * In the Applications folder on your Mac, open the Utilities folder and launch Keychain Access.
    * Within the Keychain Access drop down menu, select Keychain Access > Certificate Assistant > Request a Certificate from a Certificate Authority.
    * In the Certificate Information window, enter the following information:
    * In the User Email Address field, enter your email address.
    * In the Common Name field, create a name for your private key (e.g., John Doe Dev Key).
    * The CA Email Address field should be left empty.
    * In the "Request is" group, select the "Saved to disk" option.
    * Click Continue within Keychain Access to complete the CSR generating process.
    * Download 'CertificateSigningRequest.certSigningRequest' file (This is a temporary file you won't need to hand onto)
* In "Generate your certificate", upload signing request
* Certificate is created. Download 'ios_development.cer' file

#### Generating a .p12 File (Optional)

A .p12 file may be helpful when other systems are building your app, or you need to use your cert on another machine.

* In 'Keychain Access', right click the cert
* Select 'Export...'
* Provide a name for the file
* Provide a password to protect the p12 file

### Register Devices

#### Get Device UDID

Need to get the UDID, there are several ways to do this. (Follow these directions: http://whatsmyudid.com/)

#### XCode

* Connect your device
* Go to XCode > Window > Devices and Simulators
* Select device from the list
* Find "Identifier" and copy the value

#### iTunes

* Plug iPhone into computer with iTunes
* Open iTunes
* In top left find iPhone symbol, click
* In the summary, find "Serial Number", click on it
* "Serial Number" will change to "UDID", right click on the number and click copy

### Register Development Device

* Go to https://developer.apple.com/account/ios/device/iphone
* Register the device, add Name and UDID
* Confirm

### Create Application Ids

This is used if you are creating a new application.

* Go to Identifiers > App IDs
* Add an App ID Description - This is the 'english' name so others understand what this App is
* The App ID Prefix will match your 'Team Prefix Id' (No change needed)
* In "Explicit App Id", put in the full Bundle ID you want to match - which is the AppId you use in your app
* Add any other capabilities like Push Notifications


### Create Development Provisioning Profile

This will tie a certificate, to an app, to a physical device.

* Go to 'Provisoning Profiles' https://developer.apple.com/account/ios/profile/limited
* Click the '+' to add a new profile
* Under 'Development' select 'iOS App Development'
* In 'App Id', select the specific Application ID created earlier
* Select certificate previously created
* Select devices
* Provide a name for the profile
* Download the Provisioning Profile file 'Greg_Berns_Dev_Profile.mobileprovision'


## Project Setup in VSTS

### iOS

To configure a project to build a Cordova app involve the follwoing steps:

* Upload p12 and provisioning profile
* Install Apple Certificate
* Install Apple provisioning Profile
* Cordova Build iOS
* Deploy to HockeyApp

**Upload p12 and provisioning profile**

* In VSTS, go to 'Build and Release' > Library > Secure Files
* Add a new Secure file
* Upload the .p12 file
* Upload the provisioning profile

**'Install Apple Certificate' Step**

* Add new Task to a build agent
* Search for "Apple", select the "Install Apple Certificate" task
* In the 'Certificate (P12)' field, select the P12 file uploaded previously
* Go to the 'Variables' tab, add a secure build variable, example: `P12_PASSWORD`
* Go back to the 'Tasks' tab, in the 'Certificate (P12) Password' field, add the build variable just created example: `$(P12_PASSWORD)`

**'Install Apple provisioning profile' Step**

* Add new Task to a build agent
* Search for "Apple", select the "Install Apple provisioning profile" task
* In the 'Provisioning Profile Location' field, select 'Secure Files'
* In the 'Provisioning Profile' field, select the provisioning profile file uploaded previously

**'Cordova Build iOS' Step**

* Get the UUID for the Mobile Provisioning Profile uploaded previously (Do a Google Search to find out how. Hints: open the file and look for the GUID, or the files are stored here with the GUID/UUID in the file name `./Library/MobileDevice/Provisioning Profiles/`)
* Add new Task to a build agent
* Search for "Apple", select the "Install Apple provisioning profile" task
* Open the iOS section
* In the 'Default Keychain Password' field, add a password, the p12 password should work fine: `$(P12_PASSWORD)`
* In the 'Provisioning Profile UUID' field, add the UUID found in the first step

**'HockeyApp' Step**

* Go to HockeyApp, and open the project for this app, find the App Id
* In Account settings, open the API Tokens and create or get a token
* Add new Task to a build agent
* Search for "HockeyApp", select the "HockeyApp" task
* In the 'HockeyApp Connection' field, use the token found above
* In the 'App ID' field, add the App Id found above
* In the 'Binary File Path' field, add path to the built `.ipa` file, example: `platforms/ios/build/device/*.ipa`
