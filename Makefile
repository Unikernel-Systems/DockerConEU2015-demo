.PHONY: all pull clean realclean rundns

all:
	make -C mysql
	make -C nginx
	make -C nginx-fastcgi
	make -C nginx-nibbleblog
	make -C php
	make -C php-nibbleblog

pull:
	docker pull mato/rumprun-packages-hw-x86_64:dceu2015-demo

clean:
	make -C mysql clean
	make -C nginx clean
	make -C nginx-fastcgi clean
	make -C nginx-nibbleblog clean
	make -C php clean
	make -C php-nibbleblog clean

realclean: clean
	-docker rmi -f unikernel/mysql unikernel/nginx unikernel/nginx-fastcgi \
	    unikernel/nginx-nibbleblog unikernel/php unikernel/php-nibbleblog

rundns:
	docker run -d --hostname resolvable \
	    -v /var/run/docker.sock:/tmp/docker.sock \
	    -v /etc/resolv.conf:/tmp/resolv.conf mgood/resolvable
