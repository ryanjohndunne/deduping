use strict;
use warnings;
use diagnostics;
use Cwd;
use File::Find;
use File::Path qw(make_path);
use File::Find::Duplicates;
use File::Basename;
use File::DirSync;

# Get variables from argument
my $flag      = $ARGV[0];
my $outFolder = $ARGV[1];
my $inDir     = $ARGV[2];
my @fileList  = "";

# see if inDir exists
if ( -d $inDir ) {
    #Directory exists
}
else {
    print "Error: $inDir does not exist\n";
    exit(1);
}
# If outFolder and inDir are identicle, quit
if ($outFolder eq $inDir) {
    print "Error: Out File and In File have same value.";
    exit(1);
}

# check if the outfolder is going to be placed within the in directory
my $lengthOfString = length($inDir);
my $ifOutGoingIn = substr($outFolder, 0, $lengthOfString);
if ($ifOutGoingIn eq $inDir) {
    print "Error: Out file is placed within the in directory.";
    exit(1);
}

# Make the new directory to store into
# make_path returns a 1 on success
eval {
    if ( make_path($outFolder) != 1 ) {
        print "Error, cannot create: $outFolder\n";
        exit(1);
    }
};

# Sync the folder into the new directory
my $dirsync = new File::DirSync {
    verbose   => 0,
    nocache   => 1,
    localmode => 0,
};
$dirsync->src($inDir);
$dirsync->dst($outFolder);
$dirsync->ignore($outFolder);
$dirsync->rebuild();
$dirsync->dirsync();

# File::Find::Duplicates returns a list of duplicate files
my @dupes = find_duplicate_files($outFolder);
my $length = @dupes;

# find duplicates and print them to text document
open my $fh, '>', $outFolder .= "/duplicates.txt";
print {$fh} "Duplicate files\n";
if (@dupes) {
    for ( my $i = 0 ; $i < $length ; $i++ ) {
        my $innerLength = @{ $dupes[$i][0] };
        for ( my $j = 0 ; $j < $innerLength ; $j++ ) {
          my $baseOriginal = basename($dupes[$i][0][0]);
          my $baseDuplicate = basename($dupes[$i][0][$j]);
            if ( $j == 0 ) {
                #original in here
                print {$fh} "ORIGINAL:\n$dupes[$i][0][$j]\n";
                print {$fh} "DUPLICATE(S):\n";
            }
            else {
                # duplicates in here
                if ($baseOriginal eq $baseDuplicate) {
                    print {$fh} "$dupes[$i][0][$j]\n";
                }
            }
        }
    }
}
close $fh;

# won't let you unlink while the file is being written to so
# have to run this again and unlink duplicates
if (@dupes) {
    for ( my $i = 0 ; $i < $length ; $i++ ) {
        my $innerLength = @{ $dupes[$i][0] };
        for ( my $j = 0 ; $j < $innerLength ; $j++ ) {
          my $baseOriginal = basename($dupes[$i][0][0]);
          my $baseDuplicate = basename($dupes[$i][0][$j]);
            if ( $j == 0 ) {
                #original in here
            }
            else {
                # duplicates in here, we only want same named files
                if ($baseOriginal eq $baseDuplicate) {
                    unlink $dupes[$i][0][$j] or die "Error: Can't delete $dupes[$i][0][$j]: $!";
                }
            }
        }
    }
}
exit(0);
