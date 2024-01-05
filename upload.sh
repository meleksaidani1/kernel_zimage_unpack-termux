#!/bin/bash

# Upload 1_kernel_header.bin
curl --upload-file 1_kernel_header.bin https://free.keep.sh

# Create a zip file containing the three kernel files
zip kernel_files.zip 1_kernel_header.bin 2_kernel_gzip.gz 3_kernel_footer.bin

# Upload the zip file
curl --upload-file kernel_files.zip https://free.keep.sh
