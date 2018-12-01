#!/bin/bash

docker stop emulator
docker rm emulator
docker build -t android-emulator .
docker run --rm -d --privileged -p5555:5555 -p5554:5554 --name emulator android-emulator
