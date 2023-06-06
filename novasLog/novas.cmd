verdiWindowResize -win $_Verdi_1 "2950" "83" "900" "828"
debImport "/home/eda/2023-IC-Design-Contest/LASER.v" -path \
          {/home/eda/2023-IC-Design-Contest}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "temp_1" -line 39 -pos 1 -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
wvCreateWindow
debExit
