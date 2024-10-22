#!/bin/sh -e
make DISTRO=alpine BASEOS_REGISTRY=docker.io/library BASEOS_TAG=3.18 FLAVORS=pacific,alpine,3.18 IMAGES_TO_BUILD=daemon-base build
