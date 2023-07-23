set term pdfcairo font "Times,18"
set output 'strong512_perlmutter.pdf'
#set logscale x
#set xrange[0.15:1]
set grid
#set key outside
set key title 'Strong scaling for 512x512x512' top left
set xlabel 'Number of MPI Tasks'
set ylabel 'Speedup'
p 'perlmutter512strong.dat' u 1:($2) w lp pi -1 lt 2 lw 2 ps 1.0 pt 7 lc rgb "red" t     'Velocity',\
  'perlmutter512strong.dat' u 1:($3) w lp pi -1 lt 2 lw 2 ps 1.0 pt 8 lc rgb "#2e8b57" t 'Thermodynamics',\
  'perlmutter512strong.dat' u 1:($4) w lp pi -1 lt 2 lw 2 ps 1.0 pt 6 lc rgb "blue" t    'Particle Tracking',\
  0.002*x - 0.024 w l dashtype 2 lw 2 lc rgb "black" t    'Linear'

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

set term pdfcairo font "Times,18"
set output 'strong256_perlmutter.pdf'
#set logscale x
#set xrange[0.15:1]
set grid
#set key outside
set key title 'Strong scaling for 256x256x256' top left
set xlabel 'Number of MPI Tasks'
set ylabel 'Speedup'
p 'perlmutter256strong.dat' u 1:($2) w lp pi -1 lw 2 ps 1.0 pt 7 lc rgb "red" t     'Velocity',\
  'perlmutter256strong.dat' u 1:($3) w lp pi -1 lw 2 ps 1.0 pt 8 lc rgb "#2e8b57" t 'Thermodynamics',\
  'perlmutter256strong.dat' u 1:($4) w lp pi -1 lw 2 ps 1.0 pt 6 lc rgb "blue" t    'Particle Tracking',\
  0.016*x - 0.024 w l dashtype 2 lw 2 lc rgb "black" t    'Linear'

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #


set term pdfcairo font "Times,18"
set output 'cpu128_kspcomp.pdf'
#set logscale x
#set xrange[0.15:1]
set grid
#set key outside
set key title 'Strong scaling for 128x128x128' top left
set xlabel 'Number of MPI Tasks'
set ylabel 'Speedup'
p 'cpu128_kspcomp.dat' u 1:($3) w lp pi -1 lt 2 lw 2 ps 1.0 pt 8 lc rgb "#2e8b57" t 'Algebraic Multigrid',\
  'cpu128_kspcomp.dat' u 1:($2) w lp pi -1 lt 2 lw 2 ps 1.0 pt 7 lc rgb "red" t     'Block Jacobi',\
  'cpu128_kspcomp.dat' u 1:($4) w lp pi -1 lt 2 lw 2 ps 1.0 pt 6 lc rgb "blue" t    'Additive Schwarz',\
  x w l dashtype 2 lw 2 lc rgb "black" t    'Linear'

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

set term pdfcairo font "Times,18"
set output 'cpu128_kspcomp_hist.pdf'
#set logscale y
#set xrange[0.15:1]
set grid
#set key outside
set key title 'Timings for 128x128x128' top right

set lt 1 lc rgb 'blue'
set lt 2 lc rgb 'cyan'
set lt 3 lc rgb 'dark-green'
set lt 4 lc rgb 'light-green'
set lt 5 lc rgb 'dark-red'
set lt 6 lc rgb 'red'

# Select histogram data
#set style data histogram
# Give the bars a plain fill pattern, and draw a solid line around them.
set style fill solid border
set xlabel 'Number of MPI Tasks'
set ylabel "Time (s) [Lower is better]"

#set style histogram clustered
#set style histogram rowstack
set style fill solid border -1
##set boxwidth 0.25 relative
set xtics("1" 1, "2" 2, "4" 3, "8" 4, "16" 5, "32" 6, "64" 7, "128" 8)
num_of_ksptypes=3
set boxwidth 0.75/num_of_ksptypes
dx=0.5/num_of_ksptypes
offset=-0.12

plot 'cpu128_kspcomp_all.dat' using ($1+offset):($3+$2) title "Block Jacobi - KSP Setup"  with boxes, \
     ''                       using ($1+offset):($2) title "Block Jacobi - Solver"  with boxes, \
     ''                       using ($1+offset+1.5*dx):($5+$6) title "Algebraic Multigrid - KSP Setup"  with boxes, \
     ''                       using ($1+offset+1.5*dx):($5) title "Algebraic Multigrid - Solver"  with boxes, \
     ''                       using ($1+offset+3*dx):($8+$9) title "Additive Schwarz - KSP Setup"  with boxes, \
     ''                       using ($1+offset+3*dx):($8) title "Additive Schwarz - Solver"  with boxes, \

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

set term pdfcairo font "Times,16"
set output 'gpu128_kspcomp_hist.pdf'
#set logscale y
#set xrange[0.15:1]
set grid
set xlabel "Number of MPI Tasks sharing a GPU"
set ylabel "Time (s) [Lower is better]"

set lt 1 lc rgb 'blue'
set lt 2 lc rgb 'cyan'
set lt 3 lc rgb 'dark-green'
set lt 4 lc rgb 'light-green'
set lt 5 lc rgb 'dark-red'
set lt 6 lc rgb 'red'
set lt 7 lc rgb 'coral'
set lt 8 lc rgb 'orange'
set lt 9 lc rgb 'grey20'
set lt 10 lc rgb 'grey70'
set lt 11 lc rgb 'khaki'
set lt 12 lc rgb 'dark-goldenrod'

# Select histogram data
#set style data histogram
# Give the bars a plain fill pattern, and draw a solid line around them.
set style fill solid border

#set style histogram clustered
#set style histogram rowstack
set style fill solid border -1
##set boxwidth 0.25 relative
set xtics("1" 1, "2" 2, "4" 3, "8" 4, "16" 5)
num_of_ksptypes=6
set boxwidth 0.75/num_of_ksptypes
dx=0.5/num_of_ksptypes
offset=-0.12

set key title 'Timings for 128x128x128' top left

plot 'gpu128_kspcomp_all.dat' using ($1+offset):($3+$2) notitle  with boxes, \
     ''                       using ($1+offset):($2) title "Block Jacobi - 1 Node"  with boxes, \
     ''                       using ($1+offset+1.5*dx):($4+$5) title ""  with boxes, \
     ''                       using ($1+offset+1.5*dx):($4) title "Block Jacobi - 2 Nodes"  with boxes, \
     ''                       using ($1+offset+3*dx):($6+$7) title ""  with boxes, \
     ''                       using ($1+offset+3*dx):($6) title "Block Jacobi - 4 Nodes"  with boxes, \
     ''                       using ($1+offset+4.5*dx):($8+$9) title ""  with boxes, \
     ''                       using ($1+offset+4.5*dx):($8) title "Additive Schwarz - 1 Node"  with boxes, \
     ''                       using ($1+offset+6*dx):($10+$11) title ""  with boxes, \
     ''                       using ($1+offset+6*dx):($10) title "Additive Schwarz - 2 Nodes"  with boxes, \
     ''                       using ($1+offset+7.5*dx):($12+$13) title ""  with boxes, \
     ''                       using ($1+offset+7.5*dx):($12) title "Additive Schwarz - 4 Nodes"  with boxes, \


# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

set term pdfcairo font "Times,18"
set output 'gpu128_kspcomp.pdf'
#set logscale x
set yrange[0.95:4.2]
set grid
#set key outside
set key title 'Strong scaling for 128x128x128' top left
set xlabel 'Number of MPI Tasks'
set ylabel 'Speedup'
p 'gpu128_kspcomp.dat' u 1:($2) w lp pi -1 lt 2 lw 2 ps 1.0 pt 7 lc rgb "red" t     'Block Jacobi',\
  'gpu128_kspcomp.dat' u 1:($3) w lp pi -1 lt 2 lw 2 ps 1.0 pt 6 lc rgb "blue" t    'Additive Schwarz',\
  x w l dashtype 2 lw 2 lc rgb "black" t    'Linear'


