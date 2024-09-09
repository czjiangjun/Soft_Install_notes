#!/bin/bash

echo "本脚本基于绘图软件 gnuplot, 使用前确保 gnuplot 正确安装"
echo -e "以 CentOS 为例: \n\t yum install -y gnuplot"
echo -e "脚本使用帮助: \n\t sh abdraw.sh -h"

# 默认参数
## 服务器类型
server=

## 图片大小
sizel=1400
sizeh=700
## x轴设置
xmin=0
xmax=11.5
xtics=1
##左侧y轴坐标范围
ymin=-1034.5
ymax=-1026
## 数据文件路径
dir=.
#file=abresult.dat
file=N-O_H-E
file1=C-N_H-E
file2=C-O_H-E_2

function usage(){
    echo -e "命令格式: \n sh abdraw.sh < commands..>"
    echo "   -S --server         目标服务器名，用途title携带，可选"
    echo "   -d --dir            数据文件夹，必传"
    echo "   -f --file           数据文件，默认adresult.dat,可选"
    exit
}   

ARGS=`getopt -a -o S:d:f:h -l server:,dir:,file:,help -- "$@"`
eval set -- "${ARGS}"

while true
do
	case "$1" in
		-S|--server)
			server="$2"
			shift
			;;
		-d|--dir)
			dir="$2"
			shift
			;;
		-f|--file)
			file="$2"
			shift
			;;
		-h|--help)
			usage
			;;
		--)
			shift
			break
			;;
	esac
	shift
done

if [ ! -d $dir ]; then
	echo "文件夹 $dir 不存在"
elif [ ! -f $dir/$file ]; then
	echo "数据文件 $dir/$file 不存在"
fi

gnuplot -persist <<EOF

# set terminal png size $sizel,$sizeh font "/usr/share/fonts/kingsoft/simfang.ttf,14"

set terminal postscript eps color enhanced # size $sizel,$sizeh ## eps 格式不要设置 size

# set term pngcairo lw 2 font "AR PL UKai CN, 14" # 设置中文字体为 AR PL UKai CN (问鼎简中楷)
# set terminal pdfcairo size $sizel,$sizeh lw2 font "Times New Roman, 8"   # postscript terminal 下很难使用中文字体, pdf则容易得多

set font "/usr/share/fonts/kingsoft/simfang.ttf,14"
set key font "/usr/share/fonts/kingsoft/simfang.ttf,8"
set output "$dir/$file-3.eps"
set title "Energy vs Distance $server"
set size 1,0.8
#set style line 1 \
#    linecolor "red" \
#    dashtype "-._" \
#    linetype 1 linewidth 1 \
#    pointtype 7 pointsize 1.5
#

set grid y
set xlabel "C-H/N-H/O-H Distance"
set xrange [$xmin:$xmax]
set xtics $xtics

set ylabel "Energy"
set yrange [$ymin:$ymax]
set ytics nomirror

#set y2label "响应时间/y2"
# set y2tics

#plot "$dir/$file" using 1:2 smooth sbezier with line axis x1y1 title "吞吐率" \
#, "$dir/$file" using 3:4 smooth  with linespoint pointtype 3 axis x2y1 title "相应时间/y2轴" 

plot  "$dir/$file1" using 1:2  with linespoints linetype 1 pointtype 3 title "E_{vs}C-H (CN)" \
, "$dir/$file1" using 3:4  with linespoints linetype 1 dashtype "-._" pointtype 4  title "E_{vs}N-H (CN)"  \
, "$dir/$file2" using 1:2  with linespoints linetype 7 pointtype 5 title "E_{vs}C-H (CO)"  \
, "$dir/$file2" using 3:4  with linespoints linetype 7 dashtype "-._" pointtype 6 title "E_{vs}O-H (CO)" \
, "$dir/$file" using 1:2 with linespoints linetype 3 pointtype 7 title "E_{vs}N-H (NO)"   \
, "$dir/$file" using 3:4  with linespoints linetype 3 dashtype "-._" pointtype 8 title "E_{vs}O-H (NO)" 

set output
EOF

# mv $dir/$file-3.png X-H_E.png
mv $dir/$file-3.eps X-H_E.eps
