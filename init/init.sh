#!/bin/bash
base_path='./'
nginx_path='../nginx/'
nginx_passwd_path=${nginx_path}conf.d/passwd
nginx_conf_path=${nginx_path}conf.d/default.conf
out_path='../html/info/'
domain_path="${base_path}domain.list"
v2ray_path="../v2ray/config.json"
v2ray_client_path="${out_path}config.json"
v2ray_qr_path="${out_path}qrcode.png"
domain=$(head -1 $domain_path);

#初始化配置页面密码
./command.sh set_passwd $nginx_passwd_path;
uuid=$(./command.sh uuid)
(printf "sed -i -E 's/\"id\": \"[0-9a-z\-]+\"/\"id\": \"%s\"/' %s" "$uuid" $v2ray_path)|bash;
(printf "sed -i -E 's/\"id\": \"[0-9a-z\-]+\"/\"id\": \"%s\"/' %s" "$uuid" "$v2ray_client_path")|bash;
(printf "sed -i -E 's/\"address\": \".+\"/\"address\": \"%s\"/' %s" "$domain" "$v2ray_client_path")|bash;
(printf "sed -i -E 's/server_name .+/server_name %s;/\' %s" "$domain" "$nginx_conf_path")|bash;
#

v2conf='{"add":"'$domain'","aid":"0","host":"","id":"'${uuid}'","net":"tcp","path":"","port":"443","ps":"wing","tls":"tls","type":"none","v":"2"}'
v2_b64=$(echo "${v2conf}"| base64 -w0 )
v2ray_vmess="vmess://${v2_b64}"
echo -n "$v2ray_vmess"  | qrencode -o "$v2ray_qr_path"

#awk -F'\n'  '{printf "docker exec acme --issue -d %s -d *.%s  --dns %s;\n",$1,$1,"'"$dns_type"'"}' ./init/domain.list|bash
#awk -F'\n'  '{print "docker exec acme --deploy -d " $1 " --deploy-hook haproxy"}' ./init/domain.list |bash
#if [ -d '/etc/cert' ]; then
#  sed -i -E "s/crt [a-z/\. ]+pem/$(ls /etc/cert/|grep \.pem$|awk '{print "crt \/etc\/cert\/" $1}'|paste -d" " -s)/" /usr/local/etc/haproxy/haproxy.cfg;
#fi;
#docker restart wing_haproxy
#docker restart wing_nginx