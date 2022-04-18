#!/usr/bin/perl -w
# 加载时间管理，参数管理，文件名和路径处理的基础包，无须安装
use POSIX qw(strftime);
use Getopt::Long;
use File::Basename;
use Cwd;
###############################################################################
#Scripts usage and about.
# 程序的帮助文档，良好的描述是程序重用和共享的基础，也是程序升级和更新的前提
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
#命令行参数据的定义和获取，记录程序初始时间，设置参数默认值
#Get the parameter and provide the usage.
###############################################################################
my %opts;
GetOptions(\%opts,"i1:s","o1:s");
&usage unless ( exists $opts{i1} & exists $opts{o1});
my $start_time=time;
print strftime("Start time is %Y-%m-%d %H:%M:%S\n", localtime(time));
print "Input path1 is $opts{i1}\nOutput path is $opts{o1}\n";
#print "Database file is $opts{d}\n" if defined($opts{d});
# 调置参数的初始值，可以添加更多参数的默认值
#$opts{thread}=1 unless defined($opts{thread}); 
#$opts{paralle}=1 unless defined($opts{paralle});
###############################################################################
###############################################################################
#Main text.
###############################################################################
# 正文部分，读取输入文件，列出输入和输入文件的三行作为示例，方便编程处理数据
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
