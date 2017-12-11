#!/bin/sh
echo "Start Cert Install"

P12_PASSWORD=$1

## ENCRIPT
# openssl des3 -in ./signing/GregBernsCert.cer -out ./signing/GregBernsCert.cer.enc
# openssl des3 -in ./signing/GregBernsPem.p12 -out ./signing/GregBernsPem.p12.enc
# openssl des3 -in ./signing/profile/Greg_Berns_DriveTime_Public_Mobile_Development.mobileprovision -out ./signing/profile/Greg_Berns_DriveTime_Public_Mobile_Development.mobileprovision.enc

# Decript Certs
openssl des3 -d -in ./signing/GregBernsCert.cer.enc -out ./signing/GregBernsCert.cer -k "$P12_PASSWORD"
openssl des3 -d -in ./signing/GregBernsPem.p12.enc -out ./signing/GregBernsPem.p12 -k "$P12_PASSWORD"
openssl des3 -d -in ./signing/profile/Greg_Berns_DriveTime_Public_Mobile_Development.mobileprovision.enc -out ./signing/profile/Greg_Berns_DriveTime_Public_Mobile_Development.mobileprovision -k "$P12_PASSWORD"

security create-keychain -p 'tempPassword' ios-build.keychain
security import ./signing/AppleWWDRCA.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./signing/GregBernsCert.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./signing/GregBernsPem.p12 -k ~/Library/Keychains/ios-build.keychain -P "$P12_PASSWORD" -T /usr/bin/codesign
security list-keychain -s ~/Library/Keychains/ios-build.keychain
security unlock-keychain -p 'tempPassword' ~/Library/Keychains/ios-build.keychain

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./signing/profile/* ~/Library/MobileDevice/Provisioning\ Profiles/

#sudo mkdir -p ./platforms/ios/cordova/
#sudo cp ./signing/build-release.xcconfig ./platforms/ios/cordova/build-release.xcconfig

echo "End Cert Install"
