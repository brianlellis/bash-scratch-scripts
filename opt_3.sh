#!/bin/bash

# Create tree path
function mymv ()
{
	dir="$2"
	tmp="$2"; tmp="${tmp: -1}"
	[ "$tmp" != "/" ] && dir="$(dirname "$2")"
	[ ! -a "$dir" ] &&
	mkdir -p "$dir" &&
	mv "$@"
}

cd /Volumes/Sites/_FILE_DUMPS/BX_C

# Find the number of PNG files
find . -name "*.png" -ls | wc -l

# Displays weight PNG
find . -name "*.png" -ls | awk '{total += $7} END {print total}' | awk '{ split( "o KB MB GB" , v ); s=1; while( $1>1024 ){ $1/=1024; s++ }  printf("%.2f %s\n", $1, v[s]) }'

# Optimizes images
TMP_DIR='/Volumes/Sites/_FILE_DUMPS/BX_PDFS_THUMBNAILS_OPT'
mkdir -p "$TMP_DIR"
for file in `find . -name "*.png"`; do \
  NAME=$(echo $file | cut -c3-)
	echo "$NAME"
  # convert $NAME -resize 40% $NAME
	pngquant  -f 8 -o tmp_img_file.png $file
	pngcrush -brute -ow -reduce tmp_img_file.png > /dev/null 2>&1
	mymv tmp_img_file.png ${TMP_DIR}/${file}
done;

find "$TMP_DIR" -name "*.png" -ls | awk '{total += $7} END {print total}' | awk '{ split( "o KB MB GB" , v ); s=1; while( $1>1024 ){ $1/=1024; s++ }  printf("%.2f %s\n", $1, v[s]) }'
