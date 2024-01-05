#!/bin/bash
BOLD="$(tput bold)"
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"
echo Kernel Z-Image Unpack ${BOLD}[${GREEN}Decker${RESET}${BOLD}]${RESET}

if [ $# -eq 0 ] ; then
    echo "Usage: $0 <Linux kernel zImage>"
    exit 1
fi

echo -n -e '\x1F\x8B\x08' > gzip-signature-start.tmp
GZIP_OFFSET_START=`grep -F -b -a -o -f gzip-signature-start.tmp "$1" | cut -d: -f1`
printf 'GZip Offset Start           : 0x%08X\n' "$GZIP_OFFSET_START"
rm gzip-signature-start.tmp
dd if="$1" of=image.tmp bs=1 skip="$GZIP_OFFSET_START" 2>/dev/null
GZIP_ARCHIVE_SIZE=`gzip -dc image.tmp 2>/dev/null | gzip -9 | wc -c`
rm image.tmp
printf 'GZip Compressed Data Size   : %d\n' "$GZIP_ARCHIVE_SIZE"
dd if="$1" of=1_kernel_header.bin bs=1 count="$GZIP_OFFSET_START" 2>/dev/null
dd if="$1" of=2_kernel_gzip.gz bs=1 skip="$GZIP_OFFSET_START" count="$GZIP_ARCHIVE_SIZE" 2>/dev/null
dd if="$1" of=3_kernel_footer.bin bs=1 skip=$((GZIP_OFFSET_START+GZIP_ARCHIVE_SIZE)) 2>/dev/null
