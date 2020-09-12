#!/bin/bash
# comments are nested as in GitHub MD
# Main
## Sub
### sub sub

# Firstly get master data
## Build my xmltv
### Download deps
sudo apt install -y git libxml2-utils xmlstarlet xmltv dos2unix zip libarchive-zip-perl \
    libcgi-pm-perl \
    libdata-dump-perl \
    libdate-calc-perl \
    libdate-manip-perl \
    libdatetime-format-iso8601-perl \
    libdatetime-format-sqlite-perl \
    libdatetime-format-strptime-perl \
    libdatetime-perl \
    libdatetime-timezone-perl \
    libdbd-sqlite3-perl \
    libdbi-perl \
    libfile-chdir-perl \
    libfile-homedir-perl \
    libfile-slurp-perl \
    libfile-which-perl \
    libhtml-parser-perl \
    libhtml-tree-perl \
    libhttp-cache-transparent-perl \
    libhttp-cookies-perl \
    libhttp-message-perl \
    libio-stringy-perl \
    libjson-perl \
    libjson-xs-perl \
    liblingua-preferred-perl \
    liblinux-dvb-perl \
    liblist-moreutils-perl \
    liblog-tracemessages-perl \
    liblwp-protocol-https-perl \
    liblwp-useragent-determined-perl \
    libperlio-gzip-perl \
    libsoap-lite-perl \
    libterm-progressbar-perl \
    libterm-readkey-perl \
    libtimedate-perl \
    libtk-tablematrix-perl \
    libtry-tiny-perl \
    libunicode-string-perl \
    liburi-encode-perl \
    liburi-perl \
    libwww-perl \
    libxml-dom-perl \
    libxml-libxml-perl \
    libxml-libxslt-perl \
    libxml-parser-perl \
    libxml-simple-perl \
    libxml-treepp-perl \
    libxml-twig-perl \
    libxml-writer-perl \
    make \
    perl \
    perl-tk
### download src
git clone https://github.com/sagudev/xmltv.git
cd xmltv
### build
perl Makefile.PL --yes
make
### install
sudo make install
cd ..
rm xmltv -rf

## Grab using tv_grab_si
echo "all" | tv_grab_si --configure
tv_grab_si --output "epg_grab.xml"

# Get ITAK data
## Download data from ITAK (if failed use old data)
wget -q http://freeweb.t-2.net/itak/epg_b.xml.gz -O /tmp/epg_b.xml.gz && mv /tmp/epg_b.xml.gz epg_b.xml.gz || echo "Itak not working, using old"

## Extract data
### tar files are sometimes corrupted so we are using 7z to extract
sudo apt install p7zip-full p7zip-rar -y
7z e epg_b.xml.gz

## Eq. data
### Itak id|siol_id|siol name
### set the Internal Field Separator to |
IFS='|'
while read -r itak_ch siol_id siol_name; do
    if [ ! -z "$siol_id" ]; then ### not empty, so do replace
        id='id="'$itak_ch'"'
        id_r='id="'$siol_id'"'
        cn='channel="'$itak_ch'"'
        cn_r='channel="'$siol_id'"'
        n='>'$itak_ch'</display-name>'
        n_r='>'$siol_name'</display-name>'
        ### do replace
        sed -i -e "s,${id},${id_r},g" -e "s,${cn},${cn_r},g" -e "s,${n},${n_r},g" "epg_b.xml"
    fi
done < ./itak.conf

# Sort and merge
tv_sort --by-channel --output "epg_grab_s.xml"  "epg_grab.xml"
tv_sort --by-channel --output "epg_b_s.xml"  "epg_b.xml"
/usr/bin/tv_merge -i "epg_grab_s.xml" -m "epg_b_s.xml" -o "epg_v2.xmltv"
rm epg_grab* epg_b*.xml