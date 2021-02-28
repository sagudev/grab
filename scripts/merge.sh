#!/bin/bash

i=0

for filename in slo*.xmltv
do
  # this will not happend
  if [[ "$filename" = "epg.xmltv" ]]; then
    continue
  fi

  if [[ $i -eq 0 ]]; then
    second=$filename
    i=$((i+1))
    continue
  fi

  if [[ $i -gt 1 ]]; then
    second="epg.xmltv"
  fi

   echo -e "merge ${filename} $second"
   tv_merge -i $filename -m $second -o "epg.xmltv"
   i=$((i+1))

done;

#v2
for filename in epg_grab_*.xml
do
  # Move firs one
  if [[ "$filename" = "epg_grab_0.xml" ]]; then
    mv -f "epg_grab_0.xml" "epg_grab.xml"
    continue
  fi
  echo -e "merge ${filename}"
  tv_merge -i "${filename}" -m "epg_grab.xml" -o "epg_grab.xml"

done;

# after merge same data is wrong
echo "Normalize"
xmlstarlet tr normalize.xsl epg_grab.xml > epg_grab_n.xml
mv -f epg_grab_n.xml epg_grab.xml
