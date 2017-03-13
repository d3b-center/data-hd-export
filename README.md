# Export data to hard drive

## key steps:

generate key
```
openssl rand -base64 256 > $outputdir/encryption.key
chmod 400 $outputdir/encryption.key
```

aes encryption
```
openssl aes-256-cbc -salt -in $input -out $output -pass file:$encryption.key
```

decryption
```
openssl aes-256-cbc -d -in $input -out $output -pass file:$encryption.key
```

## shell script

usage:
```
command.sh enc manifest_file output_dir # encryption
command.sh dec manifest_file encryption_key output_dir #decryption
```

`manifest_file` is a list of files with relative dir path, something like the output from `ls`
```
folder1/file1.fq
folder1/file2.fq
folder2/file3.fq
folder2/file4.fq
```

The script will auto-md5sum original files and encrypted files at the same time. 

The `tree` will be like:
```
.
├── folder1
│   ├── file1.fq
│   └── file2.fq
├── folder2
│   ├── file3.fq
│   └── file4.fq
├── manifest
└── output_folder
    ├── folder1
    │   ├── file1.fq
    │   └── file2.fq
    ├── folder2
    │   ├── file3.fq
    │   └── file4.fq
    ├── encryption.key
    ├── manifest
    ├── md5sum.encrypted.txt
    └── md5sum.original.txt
```