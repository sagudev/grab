#!/bin/bash

[ -d "ch" ] && rm -Rf ch
mkdir ch
cd ch
# only base
xmllint --encode utf8 --xpath '//channel' "../kanali.xml" >> "tmp.xml"
# new lines
sed -i 's/channel>/channel>\n/g' tmp.xml
# do split
split -l 38 tmp.xml -d "slo"
# remove old
rm tmp.xml
# now insert start and end of file
FILES=.
for f in ./*
do
  echo "Editing file $f"
  echo '<?xml version="1.0" encoding="UTF-8"?>
    <settings>
    <filename>/data/'"$f"'_wg.xml</filename>
    <mode>m</mode>
    <proxy>automatic</proxy>
    <user-agent>Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0; yie9)</user-agent>
    <logging>on</logging>
    <retry time-out="15">1</retry>
    <timespan>7</timespan>
  <update>i</update>' | cat - "$f" > temp && mv temp "$f.xml"
  rm "$f"
  echo '</settings>' >> "$f.xml"
  xmllint "$f.xml" --format --output "$f.xml"
done

# v2
echo "all" | tv_grab_si --configure
sort -o ~/.xmltv/tv_grab_si.conf ~/.xmltv/tv_grab_si.conf
cp  ~/.xmltv/tv_grab_si.conf set1.conf
cp  ~/.xmltv/tv_grab_si.conf set2.conf
cp  ~/.xmltv/tv_grab_si.conf set3.conf
cp  ~/.xmltv/tv_grab_si.conf set4.conf
cp  ~/.xmltv/tv_grab_si.conf set5.conf
cp  ~/.xmltv/tv_grab_si.conf set6.conf
cp  ~/.xmltv/tv_grab_si.conf set7.conf
cp  ~/.xmltv/tv_grab_si.conf set8.conf
cp  ~/.xmltv/tv_grab_si.conf set9.conf
cp  ~/.xmltv/tv_grab_si.conf set10.conf
sed -i -e '1,25{s/!/=/}' set1.conf
sed -i -e '26,50{s/!/=/}' set2.conf
sed -i -e '51,75{s/!/=/}' set3.conf
sed -i -e '76,100{s/!/=/}' set4.conf
sed -i -e '101,125{s/!/=/}' set5.conf
sed -i -e '126,150{s/!/=/}' set6.conf
sed -i -e '151,175{s/!/=/}' set7.conf
sed -i -e '176,200{s/!/=/}' set8.conf
sed -i -e '201,225{s/!/=/}' set9.conf
sed -i -e '226,300{s/!/=/}' set10.conf
