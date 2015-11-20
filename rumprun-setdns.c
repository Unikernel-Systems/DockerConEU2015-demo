#include <err.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/types.h>

int main(int argc, char *argv[])
{
    char *dns_resolver;
    FILE *resolv;
    int nw;

    dns_resolver = getenv("RUMPRUN_RESOLVER");
    if (dns_resolver == NULL) {
        warnx("RUMPRUN_RESOLVER not set, not configuring DNS");
        return 0;
    }

    /* May not exist if running w/o any filesystems */
    (void)mkdir("/etc", 0755);
    
    resolv = fopen("/etc/resolv.conf", "w");
    if (resolv == NULL)
        err(1, "fopen(/etc/resolv.conf)");
    nw = fprintf(resolv, "nameserver %s\ndomain docker\n", dns_resolver);
    if (nw <= 0)
        errx(1, "fprintf() returned %d", nw);
    fclose(resolv);

    /* Test that the DNS server actually works */
    struct addrinfo *result;
    int rc;

    rc = getaddrinfo("docker.com", NULL, NULL, &result);
    if (rc != 0)
        errx(1, "getaddrinfo(\"docker.com\"): %s", gai_strerror(rc));
    freeaddrinfo(result);
    
    return 0;
}
