FROM openjdk:8-jdk-slim

LABEL maintainer "Denis Itskovich <denis.itskovich@gmail.com>"

SHELL ["/bin/bash", "-c"]

RUN apt-get --quiet update
RUN apt-get --quiet -y install wget tar unzip qemu-kvm libglu1-mesa

ENV ANDROID_HOME=/android-sdk
ENV ANDROID_COMPILE_SDK=28
ENV ANDROID_SDK_TOOLS=4333796
ENV ANDROID_BUILD_TOOLS=28.0.3
ENV AVD=28
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
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "system-images;android-$AVD;google_apis;x86"

RUN set +o pipefail;yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses;set -o pipefail
RUN echo no | $ANDROID_HOME/tools/bin/avdmanager create avd --name android-$AVD -k "system-images;android-$AVD;google_apis;x86"

EXPOSE 5555/tcp
COPY emulator.sh /
RUN chmod +x /emulator.sh

ENTRYPOINT ["/bin/bash", "-c", "/emulator.sh"]
