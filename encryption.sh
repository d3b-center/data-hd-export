#!/bin/sh
manfiest=$1
outputdir=$2
if [[ ! -r $manfiest ]]; then
	echo "file $manfiest is not readable"
	invalid_credentials=1
fi
if [[ ! -w $outputdir ]]; then
	echo "dir $outputdir is not writable"
	invalid_credentials=1
fi
if [ "$invalid_credentials" == "1" ]; then
	echo "usages: sh $0 enc <input.manifest> <path/to/output/dir>"
	exit 1
fi
openssl rand -base64 256 > $outputdir/encryption.key
chmod 400 $outputdir/encryption.key
cp $manfiest $outputdir
cat $manfiest | while read f
	do
		if [[ ! -r $f ]]; then
			echo "file $f is not readable"
			exit 1
		fi
		mkdir -p $outputdir/`dirname $f`
		openssl aes-256-cbc -salt -in $f -out $outputdir/$f -pass file:$outputdir/
encryption.key
	done
md5 $manfiest > $outputdir/md5sum.original.txt
cd $outputdir; md5 $manfiest > md5sum.encrypted.txt; cd -