#!/bin/bash
while true
do
  zone=${ZONE}
  dnsrecord=${RECORD}
  cloudflare_auth_email=${EMAIL}
  cloudflare_auth_key=${KEY}
  ip=$(curl -s -X GET https://checkip.amazonaws.com)
  echo "Current IP is $ip"

  zoneid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone&status=active" \
    -H "X-Auth-Email: $cloudflare_auth_email" \
    -H "Authorization: Bearer $cloudflare_auth_key" \
    -H "Content-Type: application/json"| jq -r '{"result"}[] | .[0] | .id' )

  dnsrecordid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?type=A&name=$dnsrecord" \
    -H "X-Auth-Email: $cloudflare_auth_email" \
    -H "Authorization: Bearer $cloudflare_auth_key" \
    -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsrecordid" \
    -H "X-Auth-Email: $cloudflare_auth_email" \
    -H "Authorization: Bearer $cloudflare_auth_key" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$ip\",\"ttl\":1,\"proxied\":true}" | jq
  sleep 60
done