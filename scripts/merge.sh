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
   /usr/bin/tv_merge -i $filename -m $second -o "epg.xmltv"
   i=$((i+1))

done;
