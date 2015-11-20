#!/bin/sh
#
# docker-unikernel: Container side, using a rumprun unikernel as an example.
#

# Wait for host to configure network
echo "INFO: Waiting for network..."
inotifywait -e create -t 60 /dev
if [ $? -ne 0 -o ! -c /dev/tap0 ]; then
    echo "ERROR: timed out waiting for network or no /dev/tap0 found" 1>&2
    exit 1
fi

# Check configuration. Verifies that the interface is in sync with that of
# docker-unikernel.
VTAPDEV=$(echo /sys/devices/virtual/net/vtap*)
if [ \( ! -d "${VTAPDEV}" \) -o \( ! -f "${VTAPDEV}/address" \) ]; then
    echo "ERROR: macvtap device not found on container side" 1>&2
    exit 1
fi
if [ \( ! -f /ip \) -o \( ! -f /mask \) -o \( ! -f /gw \) ]; then
    echo "ERROR: interface mismatch (missing network config)" 1>&2
    exit 1
fi

# Rumprun unikernel configuration using host-provided ip, mask and gw.
# If we have a resolv.conf, use its resolver via rumprun-setdns.
NAMESERVER=
[ -f /etc/resolv.conf ] && \
    NAMESERVER=$(grep nameserver /etc/resolv.conf | cut -d ' ' -f2 | head -1)
if [ -n "${NAMESERVER}" ]; then
    RUMPENV="\"env\": \"RUMPRUN_RESOLVER=${NAMESERVER}\","
else
    RUMPENV=
fi
RUMPCONFIG=$(cat <<EOM
{
    ${RUMPENV}
    "rc": [
        { "bin": "rumprun-setdns", "argv": [ ] },
        { "bin": "nginx", "argv": [ "-c", "/data/conf/nginx.conf" ] }
    ],
    "net": {
        "if": "vioif0",
        "type": "inet",
        "method": "static",
        "addr": "$(cat /ip)",
        "mask": "$(cat /mask)",
        "gw": "$(cat /gw)"
    },
    "blk": {
        "source": "dev",
        "path": "/dev/ld0a",
        "fstype": "blk",
        "mountpoint": "/etc",
    },
    "blk": {
        "source": "dev",
        "path": "/dev/ld1a",
        "fstype": "blk",
        "mountpoint": "/data",
    }
}
EOM
)
RUMPCONFIG=$(echo "${RUMPCONFIG}" | sed -e 's/,/,,/g' | tr '\n' ' ')
MAC=$(cat ${VTAPDEV}/address)

# Run the unikernel.
exec qemu-system-x86_64 \
    -enable-kvm \
    -cpu host,migratable=no,+invtsc \
    -vga none -nographic \
    -kernel ./nginx.bin \
    -net nic,model=virtio,macaddr=${MAC} \
    -net tap,fd=3 \
    -drive if=virtio,file=etc.iso,format=raw \
    -drive if=virtio,file=data.iso,format=raw \
    -append "${RUMPCONFIG}" \
    3<>/dev/tap0
