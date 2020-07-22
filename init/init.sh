#!/bin/bash
awk -F'\n'  '{printf "docker exec acme --issue -d %s -d *.%s  --dns %s;\n",$1,$1,"'$dns_type'"}' ./init/domain.list|bash
awk -F'\n'  '{print "docker exec acme --deploy -d " $1 " --deploy-hook haproxy"}' ./init/domain.list |bash
sed -i -E "s/crt [a-z/\. ]+pem/$(ls /etc/cert/|grep \.pem$|awk '{print "crt \/etc\/cert\/" $1}'|paste -d" " -s)/" /usr/local/etc/haproxy/haproxy.cfg
docker restart wing_haproxy