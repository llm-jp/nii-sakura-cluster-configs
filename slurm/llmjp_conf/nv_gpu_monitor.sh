#!/bin/bash

# Check for GPU and NIC errors in the last 4 hours
# If error found, return 1. NHC will then mark the node as down
# If no error found, return 0. NHC will then mark the node as up
DMESG_OUT=$(dmesg -T --since "5 minutes ago")
ERR_XID13=$(echo "$DMESG_OUT" | grep -E "NVRM: Xid.*: 13, pid=")
ERR_XID48=$(echo "$DMESG_OUT" | grep -E "NVRM: Xid.*: 48, pid=")
ERR_XID63=$(echo "$DMESG_OUT" | grep -E "NVRM: Xid.*: 63, pid=")
ERR_XID79=$(echo "$DMESG_OUT" | grep -E "NVRM: Xid.*: 79, pid=")
ERR_XID94=$(echo "$DMESG_OUT" | grep -E "NVRM: Xid.*: 94, pid=")
ERR_NIC=$(echo "$DMESG_OUT" | grep -E "mlx5_core .* Link down")

SLACK_WEBHOOK="https://hooks.slack.com/services/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"


function log_and_send_to_slack {
    MSG=$1
    echo $MSG >> /var/log/slurm/nhc_xid.log
    curl -X POST -H 'Content-type: application/json' --data '{"text":"'"${MSG}"'"}' $SLACK_WEBHOOK
}


if [ -n "$ERR_XID13" ]; then
    MSG="$(hostname) $(date): GPU error: Graphics Engine Exception"
    log_and_send_to_slack "${MSG}"
    exit 1
fi


if [ -n "$ERR_XID48" ]; then
    MSG="$(hostname) $(date): GPU error: Video Engine Error"
    log_and_send_to_slack "${MSG}"
    exit 1
fi

if [ -n "$ERR_XID63" ]; then
    MSG="$(hostname) $(date): GPU error: ECC page retirement or row remapping recording event"
    log_and_send_to_slack "${MSG}"
    exit 1
fi

if [ -n "$ERR_XID79" ]; then
    MSG="$(hostname) $(date): GPU error: GPU has fallen off the bus"
    log_and_send_to_slack "${MSG}"
    exit 1
fi

if [ -n "$ERR_XID94" ]; then
    MSG="$(hostname) $(date): GPU error: Volatile SRAM ECC Error"
    log_and_send_to_slack "${MSG}"
    exit 1
fi

if [ -n "$ERR_NIC" ]; then
    MSG="$(hostname) $(date): NetIF down event found"
    log_and_send_to_slack "${MSG}"
    exit 1
fi

echo "$(date) No error found" >> /var/log/slurm/nhc_gpu_monitor.log

exit 0
