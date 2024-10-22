# Copyright 2016 The Rook Authors. All rights reserved.
# Copyright (c) 2017 SUSE LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Environment variables required to be set for this Makefile:
#   DAEMON_BASE_IMAGE - the tag to be applied to the build of the daemon-base image
#                       (e.g., ceph/daemon-base:testbuild1)
#   BUILD_ARGS (optional) - additional arguments to the container build

.PHONY: build push clean

build:
	@echo === docker build $(DAEMON_BASE_IMAGE)
	@cp -vr /$(shell pwd)/../../../APKBUILDs/py3-cryptography py3-cryptography
	@cp -vr /$(shell pwd)/../../../APKBUILDs/ceph19 APKBUILD
	@buildah build --pull $(BUILD_ARGS) --layers --jobs 1 --platform linux/amd64,linux/arm64/v8,linux/riscv64,linux/ppc64le --manifest docker.io/zer0def/ceph:$$CEPH_VERSION-x64v1-alpine .  # $$HOST_ARCH  # ,linux/loongarch64  # ,linux/s390x is slow/single-threaded for some reason

push: ; @buildah manifest push --all $(DAEMON_BASE_IMAGE) docker://$(DAEMON_BASE_IMAGE)
clean:
# Don't fail if can't clean; user may have removed the image
	@buildah rmi $(DAEMON_BASE_IMAGE) || true
