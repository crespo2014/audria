#!/bin/bash

if [ -z "$1" ]; then
 echo "Missing input file"
 exit
fi

#use this to plot a audria output
#first parameter is input file.
# output file are _mem_cpu.png _io.png

gnuplot <<EOF
set terminal pngcairo enhanced rounded color size 3000,500
set output "$1-cpu.png"
set key left top box

set border 3 back ls -1
set tics nomirror
set grid front lt 0 lw 1

set style fill transparent solid 0.5 border

set xlabel "run time [s]"
set xrange[0:]
set xtics 2

set ylabel "CPU [%]"
set ytics
set yrange[0:300]

set y2label "CPU [%]"
set y2tics
set y2range[0:300]

set datafile separator ","

plot "$1" using (column("RunTimeSecs")):(column("AvgCPUPerc"))  axes x1y1 title "Average CPU" smooth csplines linewidth 1.5 linecolor 8, \
     "$1" using (column("RunTimeSecs")):(column("CurCPUPerc"))  axes x1y1 title "Current CPU" smooth csplines linewidth 1.5 linecolor 1
EOF

gnuplot <<EOF
set terminal pngcairo enhanced rounded color size 1000,500
set output "$1-mem.png"
set key left top box

set border 3 back ls -1
set tics nomirror
set grid front lt 0 lw 1

set style fill transparent solid 0.5 border

set xlabel "run time [s]"
set xrange[0:]
set xtics 4


set ylabel "memory [MB]"
set ytics
set yrange[0:]

set y2label "memory [MB]"
set y2tics
set y2range[0:]

set datafile separator ","

plot "$1" using (column("RunTimeSecs")):((column("VmPeakkB"))/1024) axes x1y2 title "VirtMem" with filledcurves x1 linecolor 5,\
     "$1" using (column("RunTimeSecs")):((column("VmHWMkB"))/1024) axes x1y2 title "VMemRSS" with filledcurves x1 linecolor 3
   
EOF

gnuplot <<EOF
quit
set terminal pngcairo enhanced rounded color size 3000,500
set output "$1-io.png"

set key left top box

set border 3 back ls -1
set tics nomirror
set grid front lt 0 lw 1

set style fill transparent solid 0.5 border

set xlabel "run time [s]"
set xrange[0:]
set xtics 2

set ylabel "read/write [MB/s]"
set ytics
set yrange[0:]

set datafile separator ","
plot "$1" using (column("RunTimeSecs")):((column("CurReadBytesStoragePerSec"))/1024/1024) axes x1y1 title "read" with filledcurves x1 linecolor 1,\
     "$1" using (column("RunTimeSecs")):((column("CurWrittenBytesStoragePerSec"))/1024/1024) axes x1y1 title "write" with filledcurves x1 linecolor 3,\
     "$1" using (column("RunTimeSecs")):(column("CurReadCalls")) axes x1y2 title "read calls" with filledcurves x1 linecolor 4,\
     "$1" using (column("RunTimeSecs")):(column("CurWriteCalls")) axes x1y2 title "write calls" with filledcurves x1 linecolor 5
EOF



gnuplot <<EOF
set terminal pngcairo enhanced rounded color size 3000,500
set output "$1-time.png"

set key left top box

set border 3 back ls -1
set tics nomirror
set grid front lt 0 lw 1

set style fill transparent solid 0.5 border

set xlabel "run time [s]"
set xrange[0:]
set xtics 2

set ylabel "time [%]"
set ytics
set yrange[0:]

set y2label "threads"
set y2tics
set y2range[0:]

set datafile separator ","
plot "$1" using (column("RunTimeSecs")):(column("UserTimePerc")) axes x1y1 title "user mode" with filledcurves x1 linecolor 2,\
     "$1" using (column("RunTimeSecs")):(column("SystemTimePerc")) axes x1y1 title "kernel mode" with filledcurves x1 linecolor 1,\
     "$1" using (column("RunTimeSecs")):(column("Threads")) axes x1y2 title "threads" with lines linecolor 3
EOF