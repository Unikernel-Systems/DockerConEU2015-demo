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

### MySQL, Nginx + PHP with Nibbleblog

* `mysql`: The MySQL unikernel shown in the demo.
* `nginx-nibbleblog`, `php-nibbleblog`: The Nginx+PHP unikernel cluster running
  Nibbleblog shown in the demo.

To run these, see `demo.sh`. After running `unicluster_run`, if you browse to
`http://blog/` you will get the Nibbleblog install page.

The MySQL, Nginx and PHP with Nibbleblog unikernels were shown in the DockerCon
demo. In addition, this repository also includes some extra unikernels which we
did not have time to show:

### Nginx serving static files

Run with `sudo ./docker-unikernel run -P --hostname nginx unikernel/nginx` and
browse to `http://nginx/`. This shows a standalone Nginx unikernel serving
static files. Browse to `http://nginx/root/` for extra fun!

### Nginx + PHP "barebones" example

Run with:

````
sudo ./docker-unikernel run --hostname php unikernel/php
sudo ./docker-unikernel run -P --hostname nginx-fastcgi unikernel/nginx-fastcgi
````
Browse to `http://nginx-fastcgi/`. This shows a simplest possible PHP example,
with phpinfo().

## Known issues

* Due to a kernel bug in the macvtap driver you will not be able to run more
than one instance of `docker-unikernel` on a single host. There is a tentative
workaround in `macvtap.patch`, refer there if feeling brave.
