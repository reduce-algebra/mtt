#! /bin/sh

mv ImplicitRC_simpar.txt SAVE
Delta="0.01 0.2 1.0"
for delta in $Delta; do
    echo Doing with sample interval = $delta

    cp SAVE ImplicitRC_simpar.txt 
cat <<EOF >>ImplicitRC_simpar.txt 
DT=$delta
EOF
    mtt -q ImplicitRC odeso dat
    cp ImplicitRC_odeso.dat ImplicitRC_odeso.$delta
done

gnuplot <<EOF 
set term postscript
set output "ImplicitRC.ps"
set grid
plot "ImplicitRC_odeso.0.01" with lines, \
     "ImplicitRC_odeso.0.2" with linespoints, \
     "ImplicitRC_odeso.1.0" with linespoints
EOF
mv SAVE ImplicitRC_simpar.txt 

ghostview ImplicitRC.ps

mv ImplicitRC.ps ../../Figs
