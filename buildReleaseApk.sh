#!/bin/bash
sudo docker run --rm -v $(pwd):/workspace -w /workspace lets-test-me /bin/bash -c "source \"\$HOME/.sdkman/bin/sdkman-init.sh\" \
&& (cordova platform remove android || true) \
&& (cordova platform add android || true) \
&& cordova requirements android \
&& cordova-check-plugins --update=auto \
&& cordova plugin save \
&& cordova prepare \
&& cordova build android --release \
&& (rm keystore.PKCS12 || true) \
&& keytool -genkey -alias aliasKeystore -keyalg RSA -keystore ./keystore.PKCS12 -dname \"CN=Luca Guzzon, OU=Mobilez, O=SolonSoft, L=Siena, S=Toscana, C=IT\" -storepass storepass1qaz2wsX  -keysize 4096  -validity 10000 -deststoretype pkcs12 \
&& jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore keystore.PKCS12 -storepass storepass1qaz2wsX /workspace/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk aliasKeystore \
&& (rm release.apk || true) \
&& zipalign -v 4 /workspace/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk release.apk" \
&& sudo chown -R $(whoami):$(whoami) . \
&& sudo chown -R $(whoami):$(whoami) * \
&& ffsend u release.apk -p p 
