FROM openjdk:8-jdk

LABEL maintainer "Denis Itskovich <denis.itskovich@gmail.com>"

SHELL ["/bin/bash", "-c"]
RUN apt-get --quiet update
RUN apt-get --quiet install wget tar unzip
ENV ANDROID_HOME=/android-sdk
ENV ANDROID_COMPILE_SDK=28
ENV ANDROID_SDK_TOOLS=4333796
ENV ANDROID_BUILD_TOOLS=28.0.3
RUN mkdir $ANDROID_HOME
RUN wget --quiet --output-document=./android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_TOOLS.zip
RUN unzip -d $ANDROID_HOME android-sdk.zip
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "platform-tools"
RUN echo y | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;$ANDROID_BUILD_TOOLS"
ENV PATH=$ANDROID_HOME/platform-tools/:${PATH}
RUN set +o pipefail;yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses;set -o pipefail
