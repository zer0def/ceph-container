#!/bin/sh
set -e

function start_tcmu_runner {
  get_config
  check_config

  if [ "${CEPH_GET_ADMIN_KEY}" -eq 1 ]; then
    # ensure we have the admin key
    get_admin_key
    check_admin_key
  fi

  ceph_health client.admin /etc/ceph/"$CLUSTER".client.admin.keyring

  # mount configfs at /sys/kernel/config
  mount -t configfs none /sys/kernel/config

  # create the log directory
  mkdir -p "${TCMU_RUNNER_LOG_DIR}"

  log "SUCCESS"
  # start tcmu-runner
  _exec tcmu-runner --tcmu-log-dir "${TCMU_RUNNER_LOG_DIR}"
}
