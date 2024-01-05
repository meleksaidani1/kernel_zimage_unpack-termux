### What is this?

**unpack.sh** is a simple script that allows you to work with Linux Kernel zImage (ARM, Little Endian) from MTK (Mediatek). Let's assume that you extracted the Linux Kernel image from boot.img or recovery.img. In the general case, it consists of the kernel binary itself, compressed with gzip, dtb, loader, and possibly some service information.

Several options are possible, for example:

* The file recovery.img-kernel command determines the contents as Linux kernel ARM boot executable zImage (little-endian).
* Content defined as gzip compressed data, max compression, from Unix.

In the first case, the file structure is as follows, first there is the boot executable code, then GZip of the kernel itself, then the offset table and then DTB, starting with the signature DTB_MAGIC - D0 0D FE ED (0xEDFE0DD0). What is an offset table?

* DWORD (0x0)
* DWORD (0x0)
* DWORD (0x0)
* Pointer to DTB_MAGIC
* Pointer to the offset table (i.e. the first DWORD from the given list)
* ... (and so on.)

In the second case, the structure is simpler, there are no boot executables, the GZip kernel goes straight away, and then DTB, starting with dtb-magic.

The script correctly processes (at least in test examples) both options.

The launch is carried out as follows:

* 0_ chmod +x unpack.sh
* 1_ bash unpack.sh recovery.img-kernel


* if you dont have root for check files in data just use upload scrpit

*chmod +x upload.sh
*./upload.sh


As a result of the script, three files will be generated:

* 1_kernel_header.bin
* 2_kernel_gzip.gz
* 3_kernel_footer.bin

With the names, I think everything is clear - the first contains the boot executable code (if there is one), the second contains directly pure kernel.gz, and the third contains the offset table (if available) + DTB. The total size of these three files should be equal to the size of the original recovery.img-kernel. If this condition is met, then the kernel is unpacked correctly.

Now you can unzip 2_kernel_gzip.gz and study (or modify) the kernel binary. When modifying, it is important that the size of the resulting gz is equal to the size of the original gzip. You can put everything back together like this:

cat 1_kernel_header.bin 2_kernel_gzip.gz 3_kernel_footer.bin > recovery.img-kernel-new

The script was written thanks to questions that arose when communicating with **jemmini** and **hyperion70**. In no case does it pretend to be perfect, it’s just a convenient “useful tool” so as not to run that HIEW from under Wine and not to cut recovery.img-kernel manually.
		
