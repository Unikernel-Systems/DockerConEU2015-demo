all: fs nginx

.PHONY: fs nginx

nginx.bin:
	docker run -ti -d --name=nginx-build mato/rumprun-packages-hw-x86_64:dceu2015-demo cat
	docker cp ../rumprun-setdns.c nginx-build:/build/rumprun-setdns.c
	docker exec nginx-build x86_64-rumprun-netbsd-gcc -O2 -Wall -o rumprun-setdns rumprun-setdns.c
	docker exec nginx-build rumprun-bake hw_virtio /build/nginx.bin /build/rumprun-setdns /build/rumprun-packages/nginx/bin/nginx
	docker cp nginx-build:/build/nginx.bin .
	strip nginx.bin
	docker rm -f nginx-build

nginx: nginx.bin fs
	docker build -t unikernel/nginx-fastcgi .

fs:
	genisoimage -l -r -o fs/etc.iso fs/etc
	genisoimage -l -r -o fs/data.iso fs/data

clean:
	rm -f fs/*.iso fs/*.img *.bin
	-docker rm -f nginx-build
