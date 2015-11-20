FROM alpine:latest
MAINTAINER Martin Lucina <mato@unikernel.com>
RUN apk add --update \
    inotify-tools \
    qemu-system-x86_64 \
    && rm -rf /var/cache/apk/*
COPY php.bin run.sh fs/etc.iso fs/data.iso /unikernel/
WORKDIR /unikernel
CMD ["/unikernel/run.sh"]
