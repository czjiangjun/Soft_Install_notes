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
xmin=50
xmax=1000
xtics=50
##左侧y轴坐标范围
ymin=15000
ymax=30000
## 数据文件路径
dir=.
file=abresult.dat

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

set terminal png size $sizel,$sizeh font "/usr/share/fonts/kingsoft/simfang.ttf,14"
set output "$dir/ab测试结果.png"
set title "ab测试 $server"
set size 1,0.8
set grid y
set xlabel "并发数"
set xrange [$xmin:$xmax]
set xtics $xtics

set ylabel "吞吐率"
set yrange [$ymin:$ymax]
set ytics nomirror

set y2label "响应时间/y2"
# set y2tics

plot "$dir/$file" using 1:2 smooth sbezier with line axis x1y1 title "吞吐率"\
, "$dir/$file" using 1:3 smooth sbezier with linespoint pointtype 3 axis x1y2 title "相应时间/y2轴" 

set output
EOF
