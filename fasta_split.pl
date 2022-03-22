#! /usr/bin/perl
############################################################
#      Copyright (C) Hangzhou
#      作    者: 葛文龙
#      通讯邮件: gwl9505@163.com
#      脚本名称: fasta_split.pl
#      版    本: 1.0
#      创建日期: 2022年03月21日
############################################################
use feature ':all';
use Cwd qw(abs_path getcwd);
my $abs = abs_path(getcwd());
use Getopt::Long;
use vars qw($in_raw_file $out_file $one_lines $help);
GetOptions(
	"i:s" => \$in_raw_file,
	"o:s" => \$out_file,
	"one" => \$one_lines,
	"h" => \$help
);
&HELP if ($help);

sub HELP{
	say STDOUT "要求fasta文件的开头必须是\">\"符号";
	say STDOUT "用法: $0 -i (需要拆分的fasta文件名)\n";
	print STDOUT "选项\n";
	say STDOUT "\t-o   : 输出目录，默认out+fasta文件名";
	say STDOUT "\t-one : 无需参数，开启则将序列由多行转换为一行\n";
	exit;
}

my $out1=$1 if($in_raw_file=~/(.*)\./);
$out_file||=$abs."/out_".$out1;

if(!-s $in_raw_file){say "输入的fasta文件不存在，请重新输入";}

open IN,'<',$in_raw_file;
$/=">";
my @raw_file=<IN>;
chomp @raw_file;
close IN;
if(!-e $out_file){
	`mkdir $out_file`;
}

for(@raw_file){
	chomp;
	next unless(defined $_);
	my $name=$1 if(/(.*?)\s/);
	my $path=$out_file."/$name";
	open OUT,'>',$path;
	s/\s+\z//;
	if(defined $one_lines){
		s/[ATCG]{4}\K\n//g;
	}
	say OUT ">",$_;
	close OUT;
}

say "完成，输出目录至 $out_file";