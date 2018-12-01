FROM openjdk:8-jdk-slim

LABEL maintainer "Denis Itskovich <denis.itskovich@gmail.com>"

SHELL ["/bin/bash", "-c"]

RUN apt-get --quiet update
RUN apt-get --quiet -y install git wget tar unzip qemu-system-arm libglu1-mesa

ENV ANDROID_HOME=/android-sdk
ENV ANDROID_COMPILE_SDK=28
ENV ANDROID_SDK_TOOLS=4333796
ENV ANDROID_BUILD_TOOLS=28.0.3
ENV ANDROID_VER=25
ENV ANDROID_TARGET_CPU=armeabi-v7a
ENV PATH=$ANDROID_HOME/platform-tools/:$ANDROID_HOME/emulator:${PATH}

RUN mkdir -p $ANDROID_HOME
RUN wget --quiet --output-document=./android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_TOOLS.zip
RUN wget --quiet --output-document=android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator
RUN chmod +x android-wait-for-emulator
RUN unzip -d $ANDROID_HOME android-sdk.zip
RUN rm android-sdk.zip
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "emulator"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "system-images;android-$ANDROID_VER;google_apis;$ANDROID_TARGET_CPU"

RUN set +o pipefail;yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses;set -o pipefail
RUN echo no | $ANDROID_HOME/tools/bin/avdmanager create avd --name emulator -k "system-images;android-$ANDROID_VER;google_apis;$ANDROID_TARGET_CPU"

EXPOSE 5555/tcp 5554/tcp
COPY emulator.sh /
RUN chmod +x /emulator.sh
