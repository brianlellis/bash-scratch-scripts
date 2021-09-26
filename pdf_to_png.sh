#!/bin/bash


FILES=/Volumes/Sites/_FILE_DUMPS/BX_PDFS/*

for f in $FILES
do
  FILENAME=$(basename "${f%.*}")
  echo "Processing $FILENAME"
  pdftoppm -png $f > /Volumes/Sites/_FILE_DUMPS/BX_PDFS_THUMBNAILS/$FILENAME.png
done

#pdftoppm -png ID-001.pdf > test.png
