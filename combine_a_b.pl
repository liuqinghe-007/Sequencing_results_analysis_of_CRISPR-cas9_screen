#!/usr/bin/perl -w
# ����ʱ��������������ļ�����·������Ļ����������밲װ
use POSIX qw(strftime);
use Getopt::Long;
use File::Basename;
use Cwd;
###############################################################################
#Scripts usage and about.
# ����İ����ĵ������õ������ǳ������ú͹���Ļ�����Ҳ�ǳ��������͸��µ�ǰ��
###############################################################################
sub usage {
    die(
        qq!
Usage:    perl combine_a_b.pl -i1 input_path1 -o1 output_path1
Function: combine a&b lib result
Command:  -i1 input path1 (Must)
          -o1 output_path1 (Must)     
Author:   Grace Shen, shenenhui\@westlake.edu.cn
Version:  v1.0
Update:   
Notes:    
\n!
    )
}
###############################################################################
#�����в����ݵĶ���ͻ�ȡ����¼�����ʼʱ�䣬���ò���Ĭ��ֵ
#Get the parameter and provide the usage.
###############################################################################
my %opts;
GetOptions(\%opts,"i1:s","o1:s");
&usage unless ( exists $opts{i1} & exists $opts{o1});
my $start_time=time;
print strftime("Start time is %Y-%m-%d %H:%M:%S\n", localtime(time));
print "Input path1 is $opts{i1}\nOutput path is $opts{o1}\n";
#print "Database file is $opts{d}\n" if defined($opts{d});
# ���ò����ĳ�ʼֵ��������Ӹ��������Ĭ��ֵ
#$opts{thread}=1 unless defined($opts{thread}); 
#$opts{paralle}=1 unless defined($opts{paralle});
###############################################################################
###############################################################################
#Main text.
###############################################################################
# ���Ĳ��֣���ȡ�����ļ����г�����������ļ���������Ϊʾ���������̴�������
opendir DIR, "$opts{i1}";
my $path=$opts{i1};
my $outpath=$opts{o1};

foreach $file (readdir DIR){
	if($file=~/^A\-/ || $file=~/^GPI\-A/){
		my $path1=$path.'/'.$file;
		my $file1=$file;
		$file1=~s/A\-/B\-/;
		my $path2=$path.'/'.$file1;
		my $out=$file;
		$out=~s/A\-//;
		my $outfile=$outpath.'/'."$out";
		my %hash_read;
		my %hash_sgRNA;
		my %hash_A;
		my %hash_B;
		open IN1, "$path1";
		while(<IN1>){
			chomp;
			@ss=split(/\t/,$_);
			if(!exists $hash_read{$ss[2]}){
				$hash_read{$ss[2]}=$ss[1];
				$hash_sgRNA{$ss[2]}=1;
				$hash_A{$ss[2]}=$ss[3];
			}
			else{
				$hash_read{$ss[2]}+=$ss[1];
				$hash_sgRNA{$ss[2]}+=1;
				$hash_A{$ss[2]}.=','.$ss[3];
			}
			
		}
		close IN1;
		open IN2, "$path2";
		while(<IN2>){
			chomp;
			@ss=split(/\t/,$_);
			if(!exists $hash_read{$ss[2]}){
				$hash_read{$ss[2]}=$ss[1];
				$hash_sgRNA{$ss[2]}=1;
				$hash_B{$ss[2]}=$ss[3];
			}
			else{
				if(exists $hash_B{$ss[2]}){
				$hash_read{$ss[2]}+=$ss[1];
				$hash_sgRNA{$ss[2]}+=1;
				$hash_B{$ss[2]}.=','.$ss[3];
				}
				else{
					$hash_read{$ss[2]}+=$ss[1];
					$hash_sgRNA{$ss[2]}+=1;
					$hash_B{$ss[2]}=$ss[3];
				}
			}
			
		}
		close IN2;
		open OUT, ">$outfile";
		print OUT "gene_id\treads_number\tsgRNA_number\tsgRNA_Alib\tsgRNA_Blib\n";
		foreach $key (sort {$hash_read{$b}<=>$hash_read{$a}} keys %hash_read){
			print OUT "$key\t$hash_read{$key}\t$hash_sgRNA{$key}\t";
			if(exists $hash_A{$key}){
				print OUT "$hash_A{$key}\t";
			}
			else{
				print OUT "NotDetect\t";
			}
			if(exists $hash_B{$key}){
				print OUT "$hash_B{$key}\n";
			}
			else{
				print OUT "NotDetect\n";
			}
		}
		close OUT;
	}
}
###############################################################################
my $duration_time=time-$start_time;
print strftime("End time is %Y-%m-%d %H:%M:%S\n", localtime(time));
print "This compute totally consumed $duration_time s\.\n";
