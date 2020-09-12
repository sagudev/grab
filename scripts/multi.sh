#!/bin/bash

## Firstly get master data
# Build my xmltv
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
git clone https://github.com/sagudev/xmltv.git
cd xmltv
perl Makefile.PL --yes
make
sudo make install
cd ..
rm xmltv -rf
echo "all" | tv_grab_si --configure
tv_grab_si --output "epg_grab.xmltv"
## Download data from ITAK (if failed do not merge)
# todo merge with old
wget -q http://freeweb.t-2.net/itak/epg_b.xml.gz || mv "epg_grab.xmltv" "epg_v2.xmltv" && exit 0

# tar files are sometimes corrupted so we are using 7z to extract
#sudo apt install p7zip-full p7zip-rar
# tar -zxvf ./epg_b.xml.gz
7z e epg_b.xml.gz

#Itak id|siol_id|siol name  empty if no
# set the Internal Field Separator to |
IFS='|'
while read -r itak_ch siol_id siol_name; do
    if [ ! -z "$siol_id" ]; then # not empty, so do replace
        id='id="'$itak_ch'"'
        id_r='id="'$siol_id'"'
        cn='channel="'$itak_ch'"'
        cn_r='channel="'$siol_id'"'
        n='>'$itak_ch'</display-name>'
        n_r='>'$siol_name'</display-name>'
        # replace channel id
        sed -i -e "s,${id},${id_r},g" -e "s,${cn},${cn_r},g" -e "s,${n},${n_r},g" "epg_b.xml"
    fi
done < ./itak.conf
tv_sort --by-channel --output "epg_grab_s.xmltv"  "epg_grab.xmltv"
tv_sort --by-channel --output "epg_b_s.xml"  "epg_b.xml"
/usr/bin/tv_merge -i "epg_grab_s.xmltv" -m "epg_b_s.xml" -o "epg_v2.xmltv"
rm epg_grab* epg_b*