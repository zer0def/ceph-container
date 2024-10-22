#!/bin/sh
set -e

ceph --cluster "${CLUSTER}" mon remove "$(hostname -s)"
