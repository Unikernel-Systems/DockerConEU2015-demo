all: fs mysql

.PHONY: fs mysql

mysql.bin:
	docker run -ti -d --name=mysql-build mato/rumprun-packages-hw-x86_64 cat
	docker cp ../rumprun-setdns.c mysql-build:/build/rumprun-setdns.c
	docker exec mysql-build x86_64-rumprun-netbsd-gcc -O2 -Wall -o rumprun-setdns rumprun-setdns.c
	docker exec mysql-build rumprun-bake hw_virtio /build/mysqld.bin /build/rumprun-setdns /build/rumprun-packages/mysql/bin/mysqld
	docker cp mysql-build:/build/mysqld.bin .
	strip mysqld.bin
	docker rm -f mysql-build

mysql: mysql.bin fs
	docker build -t unikernel/mysql .

# XXX copies mysql data FFS straight out of rumprun-packages for now
fs:
	genisoimage -l -r -o fs/etc.iso fs/etc
	docker run -ti -d --name=mysql-build mato/rumprun-packages-hw-x86_64 cat
	docker cp mysql-build:/build/rumprun-packages/mysql/images/data.ffs ./fs/data.ffs
	docker rm -f mysql-build

clean:
	rm -f fs/*.iso fs/*.ffs *.bin
	-docker rm -f mysql-build
