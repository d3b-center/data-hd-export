#!/bin/sh
manfiest=$1; encryptionkey=$2; outputdir=$3
if [[ ! -r $manfiest ]]; then
	echo "file $manfiest is not readable"
	invalid_credentials=1
fi
if [[ ! -r $encryptionkey ]]; then
	echo "file $encryptionkey is not readable"
	invalid_credentials=1
fi
if [[ ! -w $outputdir ]]; then
	echo "dir $outputdir is not writable"
	invalid_credentials=1
fi
if [ "$invalid_credentials" == "1" ]; then
	echo "usages: dec <input.manifest> <encryption.key> <path/to/output/dir>"
	exit 1
fi
cat $manfiest | while read f
	do
		if [[ ! -r $f ]]; then
			echo "file $f is not readable"
			exit 1
		fi
		mkdir -p $outputdir/`dirname $f`
		openssl aes-256-cbc -d -in $f -out $outputdir/$f -pass file:$encryptionkey
	done