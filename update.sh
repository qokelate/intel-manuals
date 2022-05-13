#!/bin/zsh

set -x
mkdir -pv intel
cd intel
alias 'curl=curl -LORk'
alias "aria2c=aria2c '--split=10' '--max-concurrent-downloads=10' '--max-connection-per-server=10' '--min-split-size=1M' '--allow-overwrite=false' '--auto-file-renaming=false' '--continue=true'"
curl 'https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html'
grep -oE 'href\s*=\s*"[^"]+' intel-sdm.html | grep -oE '[^"]+$' > url.txt
grep -oE "href\\s*=\\s*'[^']+" intel-sdm.html | grep -oE "[^']+" >> url.txt
grep '/getContent/' url.txt > url2.txt
grep '/download/' url.txt >> url2.txt
cat url2.txt | while read line; do
    newurl="$line"
    [ '/' = "${line:0:1}" ] && newurl="https://www.intel.com$line"
    aria2c "$newurl" && continue
    newurl="https://software.intel.com$line"
	aria2c "$newurl"
done
exit

