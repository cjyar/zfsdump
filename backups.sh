#!/bin/sh -e
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Script to back up all the filesystems in a zfs pool.

SRC=maxwell-root
DST=/backup

LEVEL=$1
if ! [ "$LEVEL" -ge 0 ] ; then
    echo "First arg must be dump level >=0"
    exit 1
fi

mount $DST
zfs list -r -H -t filesystem $SRC | awk '{print $1}' | while read FS ; do
    THISLEVEL=$LEVEL
    DATE=`date +%F-%H-%M-%S`
    SHORTFS=`echo $FS | sed -e 's,/,-,g' -e 's,^$,_,'`
    LOWLEVEL=`expr $THISLEVEL - 1`
    while [ $LOWLEVEL -ge 0 ] &&
	! ls $DST/*-${SHORTFS}-${LOWLEVEL}.zfs.gz > /dev/null 2> /dev/null ; do
	echo "No level $THISLEVEL dump of $FS; promoting to $LOWLEVEL"
	THISLEVEL=$LOWLEVEL
	LOWLEVEL=`expr $LOWLEVEL - 1` || true
    done
    OUT="${DATE}-${SHORTFS}-${THISLEVEL}"
    zfsdump $FS $THISLEVEL | gzip -c > $DST/$OUT.zfs.gz
done
umount $DST
