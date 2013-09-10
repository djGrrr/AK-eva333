#!/bin/bash

# Add Colors to unhappiness
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# AK Kernel Version
BASE_AK_VER="AK"
VER=".666.JSS.08+.PURGATORY"
AK_VER=$BASE_AK_VER$VER

# AK Variables
export LOCALVERSION="~"`echo $AK_VER`
export CROSS_COMPILE=${HOME}/android/AK-linaro/4.8.2-2013.08.20130820/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=ak
export KBUILD_BUILD_HOST="kernel"

DATE_START=$(date +"%s")

echo
echo -e "${green}"
echo "AK Kernel Creation Script:"
echo "    _____                         "
echo "   (, /  |              /)   ,    "
echo "     /---| __   _   __ (/_     __ "
echo "  ) /    |_/ (_(_(_/ (_/(___(_(_(_"
echo " ( /                              "
echo " _/                               "
echo -e "${restore}"
echo

echo -e "${green}"
echo "------------------------"
echo "Show: AK Mako Settings"
echo "------------------------"
echo -e "${restore}"

INIT_DIR=${HOME}/android/AK-eva333-ramdisk/ramdisk-4.3.x
MODULES_DIR=${HOME}/android/AK-eva333-ramdisk/cwm/system/lib/modules
KERNEL_DIR=`pwd`
OUTPUT_DIR=${HOME}/android/AK-eva333-ramdisk/zip
CWM_DIR=${HOME}/android/AK-eva333-ramdisk/cwm
ZIMAGE_DIR=${HOME}/android/AK-eva333/arch/arm/boot
CWM_MOVE=/home/anarkia1976/Desktop/AK-Kernel
RAM_DIR=${HOME}/android/AK-eva333-ramdisk

echo -e "${red}"; echo "COMPILING VERSION:"; echo -e "${blink_red}"; echo "$LOCALVERSION"; echo -e "${restore}"
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

echo -e "${green}"
echo "-------------------------"
echo "Making: AK Mako Defconfig"
echo "-------------------------"
echo -e "${restore}"

make "mako_ak_defconfig"
make -j3 > /dev/null

echo -e "${green}"
echo "-------------------------"
echo "Create: AK Kernel and Zip"
echo "-------------------------"
echo -e "${restore}"

rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
echo

cd $INIT_DIR
#find . | cpio -o -H newc | gzip -9 > ../initrd.img
find . \( ! -regex '.*/\..*' \) | cpio -o -H newc -R root:root | xz --check=crc32 --lzma2=dict=8MiB > ../initrd.img

cd ../
cp -vr $ZIMAGE_DIR/zImage .
./mkbootimg --kernel zImage --ramdisk initrd.img --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=mako lpj=67677' --base 0x80200000 --pagesize 2048 --ramdiskaddr 0x81800000 -o boot.img

cp -vr boot.img $CWM_DIR
echo

cd $CWM_DIR
zip -r `echo $AK_VER`.zip *
mv  `echo $AK_VER`.zip $OUTPUT_DIR

echo -e "${green}"
echo "-------------------------"
echo "The End: AK is Born"
echo "-------------------------"
echo -e "${restore}"

cp -vr $OUTPUT_DIR/`echo $AK_VER`.zip $CWM_MOVE
echo

rm -rf $RAM_DIR/zImage
rm -rf $RAM_DIR/initrd.img
rm -rf $RAM_DIR/boot.img

cd $INIT_DIR
git reset --hard

cd $KERNEL_DIR

echo -e "${green}"
echo "-------------------------"
echo "Build Completed in:"
echo "-------------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
