#!/usr/bin/env perl
#use warnings;

if (@ARGV < 1) {
	print STDERR "<fastq file>\n";
	print STDERR "Will output a FASTA file\n";
	exit;
}

$infilename=$ARGV[0];
$libinfo=&judgelib($infilename);
print $libinfo;
open(IN, "gzip -dc $infilename|") or die ("cannot open $infilename\n");
#open(IN, "$infilename") or die ("cannot open $infilename\n");
my $good = 0;
my $numLines = 0;
my %hash;
while (<IN>) {
	$numLines++;
	chomp;
	if (/^\@/) {
		next if ($good == 0 && $numLines==1);
		$good = 1;
		s/^\@//;
		s/ /_/g;
		#print ">$_\n";
	} elsif (/^\+/) {
		$good = 0;
		$numLines = 0;
	} else {
		if ($good) {
			#print "$_\n";
		if(length $_ < 30){
			if(!exists $hash{$_}){
			$hash{$_}=1;
			}
			else{
			$hash{$_}+=1;
			}
		}
	}
	}
}
close IN;
open(INN, "gzip -dc $ARGV[1]|") or die ("cannot open $ARGV[1]\n");
#open(INN, "$ARGV[1]") or die ("cannot open $ARGV[1]\n");
 $good = 0;
 $numLines = 0;
while (<INN>) {
	$numLines++;
	chomp;
	if (/^\@/) {
                next if ($good == 0 && $numLines==1);
		$good = 1;
                s/^\@//;
                s/ /_/g;
               # print ">$_\n";
        } elsif (/^\+/) {
                $good = 0;
                $numLines = 0;
        } else {
                if ($good) {
                       # print "$_\n";
											if(length $_ < 30){
                        if(!exists $hash{$_}){
                        $hash{$_}=1;
                        }
                        else{
                        $hash{$_}+=1;
                        }
											}
                }
        }
}
close INN;

##build hash for a & b lib
open ALIB, "./human_geckov2_library_a.csv";
while(<ALIB>){
	chomp;
	unless(/^gene_id/){
		@ss=split(/\,/,$_);
		$hash_a{$ss[2]}=$ss[0]."\t".$ss[1];
	}
}
close ALIB;
open BLIB, "./human_geckov2_library_b.csv";
while(<BLIB>){
	chomp;
	unless(/^gene_id/){
		@ss=split(/\,/,$_);
		$hash_b{$ss[2]}=$ss[0]."\t".$ss[1];
	}
}
close BLIB;
##get ordered number & gene information
my @paths=split(/\//,$infilename);
my @tit=split(/\_/,$paths[-1]);
my $outname="$ARGV[2]".'/'.$tit[0].'.xls';
open OUT, ">$outname";
foreach my $key (sort {$hash{$b} <=> $hash{$a}} keys %hash){
	if($libinfo eq 'A'){
		if(exists $hash_a{$key}){
		print OUT "$key\t$hash{$key}\t$hash_a{$key}\n";
		}
	}
	if($libinfo eq 'B'){
		if(exists $hash_b{$key}){
		print OUT "$key\t$hash{$key}\t$hash_b{$key}\n";
		}
	}
}
##
sub judgelib{
	my $name=$infilename;
	my $r='';
	if($name=~/Geno_A/ || $name=~/A\-/){
		$r='A';
	}
	else{
		$r='B';
	}
	return $r;
}
