#!/bin/sh -e
make DISTRO=alpine BASEOS_REGISTRY=docker.io/library BASEOS_TAG=edge FLAVORS=reef,alpine,edge IMAGES_TO_BUILD=daemon-base build
