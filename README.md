# Deduping
Bundles files together and compresses them, allowing for different functionality when duplicates are detected: 

•-d: delete duplicate files

•-l: unarchive duplicate files as soft links to the original (usingln -s)

•-c: unarchive duplicate files as copies of the origina

## install File::Find::Duplicates & File::DirSync
run cpan in terminal
type 'sudo' if required
type 'install File::Find::Duplicates'
type 'install File::DirSync'
Enter password for sudo if asked

## Run program
chmod +x the dear and undear files
./dear flag outPath inDir
e.g: ./dear -g outFile inFolder
./undear flag inFile
e.g: ./undear -d outFile.tar.gz

The options that dear supports are:

•-g: compress result with gzip

•-b: compress result with bzip2

•-c: compress result with compress

The options that undear supports are:

•-d: delete duplicate files

•-l: unarchive duplicate files as soft links to the original (usingln -s)

•-c: unarchive duplicate files as copies of the original

## Assumptions
I've assumed that undear is only used on files that were compressed
with dear.
Undear unzips into the A3 directory that holds the scripts.

## References
Documentation for modules used:

file::find::duplicates:
http://search.cpan.org/~tmtm/File-Find-Duplicates-1.00/lib/File/Find/Duplicates.pm

file::DirSync
http://search.cpan.org/~bbb/File-DirSync-1.12/lib/File/DirSync.pm
