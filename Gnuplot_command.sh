set terminal pngcairo size 800,600
# set terminal pngcairo size $sizel,$sizeh font "/usr/share/fonts/kingsoft/simfang.ttf,14"
# set term pngcairo lw 2 font "AR PL UKai CN, 14" # 设置中文字体为 AR PL UKai CN (问鼎简中楷)
# set terminal pdfcairo size $sizel,$sizeh lw2 font "Times New Roman, 8"   # postscript terminal 下很难使用中文字体, pdf则容易得多
# set terminal postscript eps color enhanced # size $sizel,$sizeh ## eps 格式不要设置 size

set font "/usr/share/fonts/kingsoft/simfang.ttf,14"
set key font "/usr/share/fonts/kingsoft/simfang.ttf,8"
set output 'demo.png'
# set output "$dir/$file-3.eps"
# set title "Energy vs Distance $server"
set size 1,0.8
#set style line 1 \
#    linecolor "red" \
#    dashtype "-._" \
#    linetype 1 linewidth 1 \
#    pointtype 7 pointsize 1.5
#

set grid y
set xlabel "C-H/N-H/O-H Distance"
# set xrange [$xmin:$xmax]
# set xtics $xtics

set ylabel "Energy"
# set yrange [$ymin:$ymax]
set ytics nomirror

##set y2label "响应时间/y2"
## set y2tics

##plot "$dir/$file" using 1:2 smooth sbezier with line axis x1y1 title "吞吐率" \
##, "$dir/$file" using 3:4 smooth  with linespoint pointtype 3 axis x2y1 title "相应时间/y2轴" 
# plot "C-O_H-E_1" using 1:2 with linespoints lc rgb "blue" pt 7 ps 0.5
# replot "C-O_H-E_1" using 3:4 with linespoints lc rgb "red" pt 7 ps 0.5
plot "C-O_H-E_1" using 1:2 with linespoints dashtype "--" linecolor rgb "blue" title "E_{vs}C-H", "C-O_H-E_1" using 3:4 with linespoints lc rgb "red" title "E_{vs}O-H"

#plot  "$dir/$file1" using 1:2  with linespoints linetype 1 pointtype 3 title "E_{vs}C-H (CN)" \
#, "$dir/$file1" using 3:4  with linespoints linetype 1 dashtype "-._" pointtype 4  title "E_{vs}N-H (CN)"  \
#, "$dir/$file2" using 1:2  with linespoints linetype 7 pointtype 5 title "E_{vs}C-H (CO)"  \
#, "$dir/$file2" using 3:4  with linespoints linetype 7 dashtype "-._" pointtype 6 title "E_{vs}O-H (CO)" \
#, "$dir/$file" using 1:2 with linespoints linetype 3 pointtype 7 title "E_{vs}N-H (NO)"   \
#, "$dir/$file" using 3:4  with linespoints linetype 3 dashtype "-._" pointtype 8 title "E_{vs}O-H (NO)" 

set output
