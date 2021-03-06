#!/bin/bash
email="X-Auth-Email: "$CF_EMAIL
key="X-Auth-Key: "$CF_KEY

echo "[INFO] Getting A Records from CloudFlare..."
curl -X GET "https://api.cloudflare.com/client/v4/zones/08b55de26fc282481683d62469d7ffba/dns_records?type=A&page=1&per_page=100&order=name&direction=asc&match=all" -H "$email" -H "$key" -H "Content-Type: application/json" >cloudflare-tmp.json
count=$(cat cloudflare-tmp.json | jq '.result_info.count')
echo "[INFO] Total count: "$count
for ((i = 1; i < $count; i++)); do
    get_domain="cat cloudflare-tmp.json | jq '.result["$i"].name'"
    domain=$(eval $get_domain)
    echo $domain >tmp
    sed -i "s/\"//g" tmp
    domain=$(cat tmp)
    echo $domain >>namelist
    rm -rf tmp
    echo "[INFO] "$i"/"$count
done
rm -rf cloudflare-tmp.json
echo "[INFO] Okay."

echo "[INFO] Getting AAAA Records from CloudFlare..."
curl -X GET "https://api.cloudflare.com/client/v4/zones/08b55de26fc282481683d62469d7ffba/dns_records?type=AAAA&page=1&per_page=100&order=name&direction=asc&match=all" -H "$email" -H "$key" -H "Content-Type: application/json" >cloudflare-tmp.json
count=$(cat cloudflare-tmp.json | jq '.result_info.count')
echo "[INFO] Total count: "$count
for ((i = 1; i < $count; i++)); do
    get_domain="cat cloudflare-tmp.json | jq '.result["$i"].name'"
    domain=$(eval $get_domain)
    echo $domain >tmp
    sed -i "s/\"//g" tmp
    domain=$(cat tmp)
    echo $domain >>namelist
    rm -rf tmp
    echo "[INFO] "$i"/"$count
done
rm -rf cloudflare-tmp.json
echo "[INFO] Okay."

echo "[INFO] Getting CNAME Records from CloudFlare..."
curl -X GET "https://api.cloudflare.com/client/v4/zones/08b55de26fc282481683d62469d7ffba/dns_records?type=CNAME&page=1&per_page=100&order=name&direction=asc&match=all" -H "$email" -H "$key" -H "Content-Type: application/json" >cloudflare-tmp.json
count=$(cat cloudflare-tmp.json | jq '.result_info.count')
echo "[INFO] Total count: "$count
for ((i = 1; i < $count; i++)); do
    get_domain="cat cloudflare-tmp.json | jq '.result["$i"].name'"
    domain=$(eval $get_domain)
    echo $domain >tmp
    sed -i "s/\"//g" tmp
    domain=$(cat tmp)
    echo $domain >>namelist
    rm -rf tmp
    echo "[INFO] "$i"/"$count
done
rm -rf cloudflare-tmp.json
echo "[INFO] Okay."

sort namelist -o namelist

args=" "

cat namelist | while read line; do
    args="$args $line"
    echo $args >tmp
done

rm -rf namelist

ct=$(cat tmp)

rm -rf tmp

./checker.sh "$ct"
