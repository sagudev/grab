#!/bin/bash

i=0

for filename in slo*.xml
do

  if [[ $i -eq 0 ]]; then
    second=$filename
    i=$((i+1))
    continue
  fi

  if [[ $i -gt 1 ]]; then
    second="epg_wg.xmltv"
  fi

   echo -e "merge ${filename} $second"
   tv_merge -i $filename -m $second -o "epg_wg.xmltv"
   i=$((i+1))

done;

echo "wg merge done!"
#v2
for filename in grab_*.xml
do
  # Move firs one
  if [[ "$filename" = "grab_1.xml" ]]; then
    mv -f "grab_1.xml" "epg_grab.xmltv"
    continue
  fi
  echo -e "merge ${filename}"
  tv_merge -i "${filename}" -m "epg_grab.xmltv" -o "epg_grab.xmltv"

done;

# after merge same data is wrong
echo "Normalize"
xmlstarlet tr normalize.xsl epg_grab.xmltv > epg_grab_n.xmltv
mv -f epg_grab_n.xmltv epg_grab.xmltv
