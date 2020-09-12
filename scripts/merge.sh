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
mv "epg_grab_0.xml" "epg_grab.xml"
tv_merge -i "epg_grab_1.xml" -m "epg_grab.xml" -o "epg_grab.xml"
tv_merge -i "epg_grab_2.xml" -m "epg_grab.xml" -o "epg_grab.xml"
tv_merge -i "epg_grab_3.xml" -m "epg_grab.xml" -o "epg_grab.xml"