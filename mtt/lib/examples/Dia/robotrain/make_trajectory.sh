#! /bin/sh
mtt -cc -no-reduce robotrain odeso ps
cd MTT_work
#set data style lines
cat <<EOF | gnuplot
set timestamp
set key left
set xlabel 'x'
set ylabel 'y'
set grid 
set title 'MTT model "robotrain": trajectory of trailer links'
plot   'robotrain_odes.dat2' using 4:5   title 'front'
replot 'robotrain_odes.dat2' using 8:9   title 'middle'
replot 'robotrain_odes.dat2' using 12:13 title 'rear'
set terminal postscript eps
set output "trajectory.ps"
replot
EOF
cd ..
cp MTT_work/trajectory.ps .
gv trajectory.ps