aa="X-Auth-Email: "$CF_EMAIL
bb="X-Auth-Key: "$CF_KEY
curl -X GET "https://api.cloudflare.com/client/v4/zones/08b55de26fc282481683d62469d7ffba/dns_records?type=A&page=1&per_page=100&order=name&direction=asc&match=all"  -H "$aa" -H "$bb"  -H "Content-Type: application/json" > cloudflare-tmp.json
count=`cat cloudflare-tmp.json | jq '.result_info.count'`
#echo $count
for ((i=1; i<$count; i++))
do
#domain=`cat cloudflare-tmp.json | jq '.result_info.count'`
get_domain="cat cloudflare-tmp.json | jq '.result["$i"].name'"
domain=`eval $get_domain`
echo $domain > tmp
sed -i "s/\"//g" tmp
domain=`cat tmp`
echo $domain >> namelist
rm -rf tmp
done
rm -rf cloudflare-tmp.json
curl -X GET "https://api.cloudflare.com/client/v4/zones/08b55de26fc282481683d62469d7ffba/dns_records?type=AAAA&page=1&per_page=100&order=name&direction=asc&match=all"  -H "$aa" -H "$bb" -H "Content-Type: application/json" > cloudflare-tmp.json
count=`cat cloudflare-tmp.json | jq '.result_info.count'`
#echo $count
for ((i=1; i<$count; i++))
do
#domain=`cat cloudflare-tmp.json | jq '.result_info.count'`
get_domain="cat cloudflare-tmp.json | jq '.result["$i"].name'"
domain=`eval $get_domain`
echo $domain > tmp
sed -i "s/\"//g" tmp
domain=`cat tmp`
echo $domain >> namelist
rm -rf tmp
done
rm -rf cloudflare-tmp.json
curl -X GET "https://api.cloudflare.com/client/v4/zones/08b55de26fc282481683d62469d7ffba/dns_records?type=CNAME&page=1&per_page=100&order=name&direction=asc&match=all"  -H "$aa" -H "$bb"  -H "Content-Type: application/json" > cloudflare-tmp.json
count=`cat cloudflare-tmp.json | jq '.result_info.count'`
#echo $count
for ((i=1; i<$count; i++))
do
#domain=`cat cloudflare-tmp.json | jq '.result_info.count'`
get_domain="cat cloudflare-tmp.json | jq '.result["$i"].name'"
domain=`eval $get_domain`
echo $domain > tmp
sed -i "s/\"//g" tmp
domain=`cat tmp`
echo $domain >> namelist
rm -rf tmp
done
rm -rf cloudflare-tmp.json
sort namelist -o namelist
args=" "
cat namelist | while read line
do
#echo $line
args="$args $line"
echo $args > tmp
done
rm -rf namelist
cc=`cat tmp`
./checker.sh "$cc"
