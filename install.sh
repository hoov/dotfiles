#!/bin/bash

case $(uname -s) in
  Darwin)
    ./osx.sh
    ;;
  Linux)
    . /etc/os-release
    case $ID in
      debian)
        ./debian.sh
        ;;
      *)
        echo "Unknown Linux OS"
        ;;
    esac
    ;;
  *)
    echo "Unknown OS"
    ;;
esac
