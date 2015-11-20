#!/bin/sh

demo_fullbuild () {
  make
}

demo_build () {
  make -C nginx
}

demo_size () {
  docker run -i -t nginx du -h nginx.bin.bz2
}

mysql_run () {
  sudo ./docker-unikernel run --hostname mysql --name mysql mysql
}

mysql_show_logs () {
  docker logs mysql | more
}

mysql_connect() {
  mysql -h mysql -u rump
}

unicluster_run () {
  sudo ./docker-unikernel run --hostname php --name php php-nibbleblog
  sleep 2
  sudo ./docker-unikernel run -P --hostname nginx --name nginx nginx-nibbleblog
}

nginx_show_logs () {
  docker logs nginx | more
}

kill_all_humans() {
  sudo docker rm -f mysql            || true
  sudo docker rm -f nginx            || true
  sudo docker rm -f nginx-fastcgi    || true
  sudo docker rm -f nginx-nibbleblog || true
  sudo docker rm -f php              || true
  sudo docker rm -f php-nibbleblog   || true
}
