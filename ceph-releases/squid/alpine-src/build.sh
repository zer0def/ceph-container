#!/bin/sh -e
make DISTRO=alpine BASEOS_REGISTRY=docker.io/library BASEOS_TAG=edge FLAVORS=squid,alpine-src,edge IMAGES_TO_BUILD=daemon-base build