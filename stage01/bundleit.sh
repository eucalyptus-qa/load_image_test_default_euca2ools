#!/bin/bash

PREFIX="ec2"

KERNEL=$1
RAMDISK=$2
IMAGE=$3

DIR=`mktemp -d -p .`
BUKKIT=`echo $DIR | sed "s/\.\///" | sed "s/\.//"`
(sleep 1; echo) | $PREFIX-bundle-image --cert ${EC2_CERT} --privatekey ${EC2_PRIVATE_KEY} --ec2cert ${EUCALYPTUS_CERT} --user 000100739354 -i $KERNEL -d $DIR --kernel true
MANIFEST=`echo $DIR/*.manifest.xml`
(sleep 1; echo y) | $PREFIX-upload-bundle -a ${EC2_ACCESS_KEY} -s ${EC2_SECRET_KEY} --url ${S3_URL} --ec2cert ${EUCALYPTUS_CERT} -b $BUKKIT -m $MANIFEST
MANIFEST=`echo $DIR/*.manifest.xml | sed "s/\.\///" | sed "s/\.//"`
echo $MANIFEST
EKI=`$PREFIX-register $MANIFEST | awk '{print $2}'`
echo $EKI
rm -rf $DIR

DIR=`mktemp -d -p .`
BUKKIT=`echo $DIR | sed "s/\.\///" | sed "s/\.//"`
(sleep 1; echo) | $PREFIX-bundle-image --cert ${EC2_CERT} --privatekey ${EC2_PRIVATE_KEY} --ec2cert ${EUCALYPTUS_CERT} --user 000100739354 -i $RAMDISK -d $DIR --ramdisk true
MANIFEST=`echo $DIR/*.manifest.xml`
(sleep 1; echo y) | $PREFIX-upload-bundle -a ${EC2_ACCESS_KEY} -s ${EC2_SECRET_KEY} --url ${S3_URL} --ec2cert ${EUCALYPTUS_CERT} -b $BUKKIT -m $MANIFEST
MANIFEST=`echo $DIR/*.manifest.xml | sed "s/\.\///" | sed "s/\.//"`
echo $MANIFEST
ERI=`$PREFIX-register $MANIFEST | awk '{print $2}'`
echo $ERI
rm -rf $DIR

DIR=`mktemp -d -p .`
BUKKIT=`echo $DIR | sed "s/\.\///" | sed "s/\.//"`
(sleep 1; echo) | $PREFIX-bundle-image --cert ${EC2_CERT} --privatekey ${EC2_PRIVATE_KEY} --ec2cert ${EUCALYPTUS_CERT} --user 000100739354 -i $IMAGE -d $DIR --kernel $EKI --ramdisk $ERI
MANIFEST=`echo $DIR/*.manifest.xml`
(sleep 1; echo y) | $PREFIX-upload-bundle -a ${EC2_ACCESS_KEY} -s ${EC2_SECRET_KEY} --url ${S3_URL} --ec2cert ${EUCALYPTUS_CERT} -b $BUKKIT -m $MANIFEST
MANIFEST=`echo $DIR/*.manifest.xml | sed "s/\.\///" | sed "s/\.//"`
echo $MANIFEST
EMI=`$PREFIX-register $MANIFEST | awk '{print $2}'`
echo $EKI
rm -rf $DIR

echo $EKI $ERI $EMI
exit 0