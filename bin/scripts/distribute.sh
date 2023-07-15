#!/bin/bash

FLAVOR="dev"

while [[ "$#" -gt 0 ]]; do
  case $1 in
  -at | --android_token)
    ANDROID_APP_CENTER_TOKEN="$2"
    shift
    ;;
  -it | --ios_token)
    IOS_APP_CENTER_TOKEN="$2"
    shift
    ;;
  --flavor)
    FLAVOR="$2"
    shift
    ;;
  -a | --apk)
    ANDROID_BUNDLE_PATH="$2"
    shift
    ;;
  -i | --ipa)
    IOS_BUNDLE_PATH="$2"
    shift
    ;;
  -ap | --android_project)
    ANDROID_PROJECT_NAME="$2"
    shift
    ;;
  -ip | --ios_project)
    IOS_PROJECT_NAME="$2"
    shift
    ;;
  *)
    echo "Unknown parameter passed: $1"
    exit 1
    ;;
  esac
  shift
done

perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' pubspec.yaml
VERSION=$(grep 'version: ' pubspec.yaml | sed 's/version: //')

echo "Bump build number to $VERSION"

echo "Build Android and iOS bundles"

if [ "$FLAVOR" = "dev" ]; then
  fvm flutter build apk --release --flavor development -t lib/main_development.dart || exit 1
  fvm flutter build ipa --export-options-plist=ios/Runner/ExportOptionsDev.plist --release --flavor development -t lib/main_development.dart || exit 1
else
  fvm flutter build apk --release --flavor production -t lib/main_production.dart || exit 1
  fvm flutter build ipa --export-options-plist=ios/Runner/ExportOptionsProd.plist --release --flavor production -t lib/main_production.dart || exit 1
fi

BUILD_DATE=$(date +"%Y-%m-%dT%H:%M")
BUILD_AUTHOR=$(whoami)

function distribute() {
  echo "Publishing $1 to App Center"

  FILE=$([[ "$1" == "android" ]] && echo "$ANDROID_BUNDLE_PATH" || echo "$IOS_BUNDLE_PATH")
  PROJECT=$([[ "$1" == "android" ]] && echo "$ANDROID_PROJECT_NAME" || echo "$IOS_PROJECT_NAME")
  TOKEN=$([[ "$1" == "android" ]] && echo "$ANDROID_APP_CENTER_TOKEN" || echo "$IOS_APP_CENTER_TOKEN")

  npx appcenter-cli distribute release \
    --group "Collaborators" \
    --file "$FILE" \
    --release-notes "$FLAVOR $VERSION [$BUILD_AUTHOR | $BUILD_DATE]" \
    --app CookieDevs/"$PROJECT" \
    --token "$TOKEN" \
    --quiet
}

distribute android
distribute ios

echo "Android $VERSION [$BUILD_DATE]: https://install.appcenter.ms/orgs/CookieDevs/apps/$ANDROID_PROJECT_NAME"
echo "iOS $VERSION [$BUILD_DATE]: https://install.appcenter.ms/orgs/CookieDevs/apps/$IOS_PROJECT_NAME"
