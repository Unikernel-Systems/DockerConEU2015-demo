# DockerCon EU 2015: Unikernels, meet Docker!

This repository contains the source code for the unikernel demo presented at
DockerCon EU 2015.

## Requirements

* A Linux machine with KVM and Docker installed.
* As part of the build process, `genisoimage` and `makefs` need to be installed
  on the host in order to generate the filesystems used by the unikernels. On
  Debian, `apt-get install genisoimage makefs` is sufficient.
* `docker-unikernel` requires root access in order to be able to plumb
  networking into the unikernel/KVM container.
* Optional: A kernel patched with `macvtap.patch` from this repository. (See
  _Known issues_ below)

## Minimal quick start

1. `make pull`. This pulls `mato/rumprun-packages-hw-x86_64` which will take a
   while. This image contains the prebuilt rumprun unikernels for mysql, nginx
   and php.
2. `make`. This builds the unikernel containers.
3. `make rundns`. Runs a DNS server on docker0, using `mgood/resolvable`.
4. `sudo ./docker-unikernel run -P --hostname nginx unikernel/nginx`.
5. Browse to `http://nginx/`.

This will start a container with an Nginx unikernel, serving static files.

## Demo unikernels

The following unikernels were shown in the demo:

* `mysql`: The MySQL unikernel shown in the demo.
* `nginx-nibbleblog`, `php-nibbleblog`: The Nginx+PHP unikernel cluster running
  Nibbleblog shown in the demo.

To replicate the demo, see `demo.sh`.

Note that the docker image names are different from the live demo, notably all
images have been namespaced under `unikernel/` to avoid conflicts, and the
Nginx image used for Nibbleblog has been renamed to `nginx-nibbleblog`.

In addition to the unikernels shown in the demo, the following additional
unikernels are also part of this repository:

* `nginx`: A Nginx unikernel serving only static files.
* `nginx-fastcgi`, `php`: A barebones Nginx+PHP unikernel cluster using read
  only filesystems and showing just `phpinfo()`.

## Known issues

* Due to a kernel bug in the macvtap driver you will not be able to run more
than one instance of `docker-unikernel` on a single host. There is a tentative
workaround in `macvtap.patch`, refer there if feeling brave.
