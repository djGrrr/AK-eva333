#!/bin/bash

clear

BASE_AK_VER="AK"
VER=".122.JS"
AK_VER=$BASE_AK_VER$VER

export LOCALVERSION="~"`echo $AK_VER`
#export CROSS_COMPILE=${HOME}/android/AK-linaro/4.7.3-2013.04.20130415/bin/arm-linux-gnueabihf-
export CROSS_COMPILE=${HOME}/android/AK-linaro/4.8.2-2013.07.20130729/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=ak
export KBUILD_BUILD_HOST="kernel"

echo 
echo "Making Mako Defconfig"
echo

DATE_START=$(date +"%s")

make "mako_ak_defconfig"

INIT_DIR=${HOME}/android/AK-mako-ramdisk/ramdisk-4.2.2
MODULES_DIR=${HOME}/android/AK-mako-ramdisk/cwm/system/lib/modules
KERNEL_DIR=`pwd`
OUTPUT_DIR=${HOME}/android/AK-mako-ramdisk/zip
CWM_DIR=${HOME}/android/AK-mako-ramdisk/cwm
ZIMAGE_DIR=${HOME}/android/AK-eva333/arch/arm/boot
CWM_MOVE=/home/anarkia1976/Desktop/AK-Kernel
RAM_DIR=${HOME}/android/AK-mako-ramdisk

echo
echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
echo "INIT_DIR="$INIT_DIR
echo "MODULES_DIR="$MODULES_DIR
echo "KERNEL_DIR="$KERNEL_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo "CWM_DIR="$CWM_DIR
echo "ZIMAGE_DIR="$ZIMAGE_DIR
echo "CWM_MOVE="$CWM_MOVE
echo "RAM_DIR="$RAM_DIR
echo

make -j3 > /dev/null
#make -j3

rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
cd $INIT_DIR
#find . | cpio -o -H newc | gzip -9 > ../initrd.img
find . | cpio -o -H newc | xz --check=crc32 --lzma2=dict=8MiB > ../initrd.img

cd ../
cp -vr $ZIMAGE_DIR/zImage .
./mkbootimg --kernel zImage --ramdisk initrd.img --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=mako lpj=67677' --base 0x80200000 --pagesize 2048 --ramdiskaddr 0x81800000 -o boot.img

cp -vr boot.img $CWM_DIR
cd $CWM_DIR
zip -r `echo $AK_VER`.zip *
mv  `echo $AK_VER`.zip $OUTPUT_DIR
cp -vr $OUTPUT_DIR/`echo $AK_VER`.zip $CWM_MOVE

rm -rf $RAM_DIR/zImage
rm -rf $RAM_DIR/initrd.img
rm -rf $RAM_DIR/boot.img

cd $KERNEL_DIR

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
