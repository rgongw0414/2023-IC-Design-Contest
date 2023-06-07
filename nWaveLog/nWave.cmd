wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 {/home/eda/2023-IC-Design-Contest/LASER_SYN.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/testfixture"
wvSetPosition -win $_nWave1 {("G1" 24)}
wvSetPosition -win $_nWave1 {("G1" 24)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/testfixture/CLK} \
{/testfixture/DONE} \
{/testfixture/RST} \
{/testfixture/X\[3:0\]} \
{/testfixture/Y\[3:0\]} \
{/testfixture/charcount\[31:0\]} \
{/testfixture/cover_sum\[31:0\]} \
{/testfixture/cycle_pat\[30:0\]} \
{/testfixture/cycle_total\[30:0\]} \
{/testfixture/d1\[31:0\]} \
{/testfixture/d2\[31:0\]} \
{/testfixture/fd\[31:0\]} \
{/testfixture/freturn\[31:0\]} \
{/testfixture/i\[31:0\]} \
{/testfixture/j\[31:0\]} \
{/testfixture/optimum_sum\[31:0\]} \
{/testfixture/pat_n\[31:0\]} \
{/testfixture/patnum\[31:0\]} \
{/testfixture/pixel_count\[5:0\]} \
{/testfixture/rst_count\[1:0\]} \
{/testfixture/state\[1:0\]} \
{/testfixture/tg_sum\[31:0\]} \
{/testfixture/total_cover_sum\[31:0\]} \
{/testfixture/wait_done\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 )} 
wvSetPosition -win $_nWave1 {("G1" 24)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 7644.734859 -snap {("G2" 0)}
wvSetCursor -win $_nWave1 5863.437416 -snap {("G1" 10)}
wvSetCursor -win $_nWave1 6209.800808 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 4948.048452 -snap {("G1" 7)}
wvSetCursor -win $_nWave1 5145.970390 -snap {("G1" 5)}
wvSetCursor -win $_nWave1 5616.034993 -snap {("G1" 7)}
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectSignal -win $_nWave1 {( "G1" 6 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 7 )} 
wvSelectSignal -win $_nWave1 {( "G1" 8 )} 
wvSelectSignal -win $_nWave1 {( "G1" 21 )} 
wvSelectSignal -win $_nWave1 {( "G1" 20 )} 
wvSelectSignal -win $_nWave1 {( "G1" 18 )} 
wvSelectSignal -win $_nWave1 {( "G1" 17 )} 
wvSelectSignal -win $_nWave1 {( "G1" 16 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 5 )} 
wvSelectGroup -win $_nWave1 {G1}
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 0)}
wvOpenFile -win $_nWave1 {/home/eda/2023-IC-Design-Contest/LASER.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/testfixture"
wvGetSignalSetScope -win $_nWave1 "/testfixture/READ_PATTERN"
wvGetSignalSetScope -win $_nWave1 "/testfixture/u_LASER"
wvSetPosition -win $_nWave1 {("G2" 30)}
wvSetPosition -win $_nWave1 {("G2" 30)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G2" \
{/testfixture/u_LASER/C1X\[3:0\]} \
{/testfixture/u_LASER/C1Y\[3:0\]} \
{/testfixture/u_LASER/C2X\[3:0\]} \
{/testfixture/u_LASER/C2Y\[3:0\]} \
{/testfixture/u_LASER/CLK} \
{/testfixture/u_LASER/DONE} \
{/testfixture/u_LASER/RST} \
{/testfixture/u_LASER/X\[3:0\]} \
{/testfixture/u_LASER/Y\[3:0\]} \
{/testfixture/u_LASER/cnt\[5:0\]} \
{/testfixture/u_LASER/cover_current\[5:0\]} \
{/testfixture/u_LASER/cover_max\[5:0\]} \
{/testfixture/u_LASER/cover_prev\[5:0\]} \
{/testfixture/u_LASER/current_state\[1:0\]} \
{/testfixture/u_LASER/dx1\[3:0\]} \
{/testfixture/u_LASER/dx2\[3:0\]} \
{/testfixture/u_LASER/dy1\[3:0\]} \
{/testfixture/u_LASER/dy2\[3:0\]} \
{/testfixture/u_LASER/next_state\[1:0\]} \
{/testfixture/u_LASER/q\[4:0\]} \
{/testfixture/u_LASER/round\[7:0\]} \
{/testfixture/u_LASER/step\[3:0\]} \
{/testfixture/u_LASER/tmpX1\[3:0\]} \
{/testfixture/u_LASER/tmpX2\[3:0\]} \
{/testfixture/u_LASER/tmpY1\[3:0\]} \
{/testfixture/u_LASER/tmpY2\[3:0\]} \
{/testfixture/u_LASER/x1\[3:0\]} \
{/testfixture/u_LASER/x2\[3:0\]} \
{/testfixture/u_LASER/y1\[3:0\]} \
{/testfixture/u_LASER/y2\[3:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 27 28 29 30 )} 
wvSetPosition -win $_nWave1 {("G2" 30)}
wvGetSignalClose -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
