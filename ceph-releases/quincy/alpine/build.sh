#!/bin/sh -e
make DISTRO=alpine BASEOS_REGISTRY=docker.io/library BASEOS_TAG=3.20 FLAVORS=quincy,alpine,3.20 IMAGES_TO_BUILD=daemon-base build
