FROM docker.io/library/alpine:edge AS builddeps
COPY py3-cryptography /py3-cryptography
RUN set -e; apk update; apk upgrade --no-cache; apk add --no-cache alpine-sdk ccache git; \
  addgroup bin abuild; mkdir -p /var/cache/distfiles; chgrp abuild /var/cache/distfiles; chmod g+w /var/cache/distfiles; chown -R bin:abuild /py3-cryptography; \
  su -s /bin/sh -c 'export HOME=/var/tmp; abuild-keygen -a -n; git config --global user.name zer0def; git config --global user.email zer0def@zer0def.0;' bin; cp /var/tmp/.abuild/*.pub /etc/apk/keys/; \
  su -s /bin/sh -c 'export HOME=/var/tmp; for i in /py3-cryptography; do cd ${i}; JOBS=$(nproc) abuild -Kmr; done  #-F' bin;

FROM builddeps AS build
COPY APKBUILD /build
RUN set -e; apk update; apk add --allow-untrusted --no-cache /var/tmp/packages/*/*.apk; chown -R bin:abuild /build; \
  su -s /bin/sh -c 'export HOME=/var/tmp; cd /build; JOBS=$(nproc) abuild -Kmr  #-F' bin; \
  rm /var/tmp/packages/*/ceph*-bash-completion-*.apk \
     /var/tmp/packages/*/ceph*-dev-*.apk \
     /var/tmp/packages/*/ceph*-diskprediction-*.apk \
     /var/tmp/packages/*/ceph*-doc-*.apk \
     /var/tmp/packages/*/ceph*-openrc-*.apk \
     /var/tmp/packages/*/cephfs*-mirror-*.apk \
     /var/tmp/packages/*/cephfs*-top-*.apk \
     /var/tmp/packages/*/rbd-fuse*-*.apk \
     /var/tmp/packages/*/cephfs*-shell-*.apk \
     /var/tmp/packages/*/ceph-dev-*.apk ||:;

FROM docker.io/library/alpine:edge AS install
COPY --from=build /var/tmp/packages /var/tmp/packages

#======================================================
# Install ceph and dependencies, and clean up
#======================================================

__DOCKERFILE_PREINSTALL__

__EXPOSE_PORTS__

# Escape char after immediately after RUN allows comment in first line
RUN \
    # Install all components for the image, whether from packages or web downloads.
    # Typical workflow: add new repos; refresh repos; install packages; package-manager clean;
    #   download and install packages from web, cleaning any files as you go.
    # Installs should support install of ganesha for luminous
    __DOCKERFILE_INSTALL__ && \
    __QAT_ACCELERATION__
    # Clean container, starting with record of current size (strip / from end)
    INITIAL_SIZE="$(sh -c 'sz="$(du -smx /)" ; echo "${sz%*/}"')" && \
    #
    #
    # Perform any final cleanup actions like package manager cleaning, etc.
    __DOCKERFILE_POSTINSTALL_CLEANUP__ && \
    # Tweak some configuration files on the container system
    __DOCKERFILE_POSTINSTALL_TWEAKS__ && \
    # Clean common files like /tmp, /var/lib, etc.
    __DOCKERFILE_CLEAN_COMMON__

FROM scratch

ENV I_AM_IN_A_CONTAINER 1

__DOCKERFILE_TRACEABILITY_LABELS__

ENV CEPH_VERSION __ENV_[CEPH_VERSION]__
ENV CEPH_POINT_RELEASE "__ENV_[CEPH_POINT_RELEASE]__"
ENV CEPH_DEVEL __ENV_[CEPH_DEVEL]__
ENV CEPH_REF __ENV_[CEPH_REF]__
ENV OSD_FLAVOR __ENV_[OSD_FLAVOR]__

COPY --from=install / /
