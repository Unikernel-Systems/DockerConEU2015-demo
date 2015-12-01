all: fs php

.PHONY: fs php

php.bin:
	docker run -ti -d --name=php-build mato/rumprun-packages-hw-x86_64:dceu2015-demo cat
	docker cp ../rumprun-setdns.c php-build:/build/rumprun-setdns.c
	docker exec php-build x86_64-rumprun-netbsd-gcc -O2 -Wall -o rumprun-setdns rumprun-setdns.c
	docker exec php-build rumprun-bake hw_virtio /build/php.bin /build/rumprun-setdns /build/rumprun-packages/php/bin/php-cgi
	docker cp php-build:/build/php.bin .
	strip php.bin
	docker rm -f php-build

php: php.bin fs
	docker build -t unikernel/php-nibbleblog .

fs:
	genisoimage -l -r -o fs/etc.iso fs/etc
	./rumprun-makefs.sh -u 1 -g 1 fs/data.ffs fs/data

clean:
	rm -f fs/*.iso fs/*.ffs *.bin
	-docker rm -f php-build
