zfsdump
=======

Shell scripts to mimic BSD dump with zfs

Copy zfsdump to someplace on your path (I use /usr/local/sbin) and
make it executable.

I use backups.sh to perform backups: Once a month cron calls
"backups.sh 0" to do a level 0 dump. Other days it does level 1 or 2.
