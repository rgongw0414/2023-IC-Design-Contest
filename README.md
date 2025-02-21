# 2023-IC-Design-Contest Cell-Based Digital Circuit Design  \ (Graduate-Level)
### [Problem：2023 IC Design Contest: Cell-Based IC Design Graduate Level](https://drive.google.com/file/d/1L6U6q_DS8KO-ufoZQarjWGYi9X9bYYlh/view)
  * Find the maximum covering points of two fixed-size circle
#### Method
* Simulated Annealing (SA) algorithm
  * For searching the optimal center points of the two circles
 * 5-bit LFSR (a pseudo-random number generator)
   * For the control of possibility used in SA algorithm
   * For example, we can simulate the possibility of 50% by dividing the number (0 to 31) into two group. If the number generated is greater than 15, then it is considered passed, otherwise failed.

#### Results
* Synthesis result:
  * Cell library: Cell-Based Design Kit for IC Contest (Artisan TSMC 0.13µm Process)
  * Area:
```bash
****************************************
Report : area
Design : LASER
Version: R-2020.09
Date   : Wed Jun  7 22:38:48 2023
****************************************

Library(s) Used:

    slow (File: /home/eda/CBDK_IC_Contest_v2.1/SynopsysDC/db/slow.db)

Number of ports:                           27
Number of nets:                          1563
Number of cells:                         1549
Number of combinational cells:           1147
Number of sequential cells:               402
Number of macros/black boxes:               0
Number of buf/inv:                        179
Number of references:                      90

Combinational area:              10225.137453
Buf/Inv area:                     1118.586604
Noncombinational area:           10313.402578
Macro/Black Box area:                0.000000
Net Interconnect area:          203701.042175

Total cell area:                 20538.540031
Total area:                     224239.582206
```
<br> <br> 
  * Timing:
``` txt
****************************************
Report : timing
        -path full
        -delay max
        -max_paths 1
Design : LASER
Version: R-2020.09
Date   : Wed Jun  7 22:38:48 2023
****************************************

Operating Conditions: slow   Library: slow
Wire Load Model Mode: top

  Startpoint: cnt_reg[1] (rising edge-triggered flip-flop clocked by CLK)
  Endpoint: cover_current_reg[5]
            (rising edge-triggered flip-flop clocked by CLK)
  Path Group: CLK
  Path Type: max

  Des/Clust/Port     Wire Load Model       Library
  ------------------------------------------------
  LASER              tsmc13_wl10           slow

  Point                                    Incr       Path
  -----------------------------------------------------------
  clock CLK (rise edge)                    0.00       0.00
  clock network delay (ideal)              0.50       0.50
  cnt_reg[1]/CK (DFFQX4)                   0.00       0.50 r
  cnt_reg[1]/Q (DFFQX4)                    0.26       0.76 f
  U1105/Y (INVX4)                          0.13       0.89 r
  U1525/Y (BUFX4)                          0.21       1.11 r
  U1104/Y (NAND3X1)                        0.19       1.30 f
  U1634/Y (CLKBUFX8)                       0.28       1.58 f
  U1320/Y (NOR2X2)                         0.62       2.20 r
  U1739/Y (AO22X1)                         0.40       2.60 r
  U1740/Y (NOR4X1)                         0.16       2.76 f
  U1314/Y (NAND3XL)                        0.32       3.08 r
  U1181/Y (AOI211X1)                       0.22       3.29 f
  U1244/Y (NAND4X2)                        0.29       3.58 r
  U1173/Y (INVX3)                          0.16       3.75 f
  U1755/Y (NOR2X1)                         0.36       4.11 r
  U1084/Y (CLKINVX1)                       0.31       4.42 f
  U1164/Y (OAI21X2)                        0.24       4.66 r
  U1777/Y (AO21X4)                         0.30       4.96 r
  U1162/Y (AOI2BB2X2)                      0.27       5.23 r
  U1161/Y (OAI2BB2X2)                      0.33       5.56 r
  U1242/Y (OAI22X2)                        0.19       5.75 f
  U1241/Y (AOI221X2)                       0.30       6.05 r
  U1789/Y (OAI211X1)                       0.25       6.30 f
  U1248/Y (NAND2X2)                        0.17       6.47 r
  U1156/Y (AOI221X2)                       0.18       6.65 f
  U1369/Y (NOR2X4)                         0.23       6.89 r
  U1155/Y (NAND2X4)                        0.14       7.03 f
  U1073/Y (NOR2X2)                         0.35       7.38 r
  U1070/Y (NAND2X4)                        0.20       7.58 f
  U1067/Y (NOR2X4)                         0.20       7.79 r
  U1154/Y (NOR2X2)                         0.13       7.92 f
  U1240/Y (AOI211X1)                       0.31       8.23 r
  cover_current_reg[5]/D (DFFQX1)          0.00       8.23 r
  data arrival time                                   8.23

  clock CLK (rise edge)                    8.00       8.00
  clock network delay (ideal)              0.50       8.50
  clock uncertainty                       -0.10       8.40
  cover_current_reg[5]/CK (DFFQX1)         0.00       8.40 r
  library setup time                      -0.16       8.24
  data required time                                  8.24
  -----------------------------------------------------------
  data required time                                  8.24
  data arrival time                                  -8.23
  -----------------------------------------------------------
  slack (MET)                                         0.01
```
* Post-sim simulatino result: \
![image](https://github.com/user-attachments/assets/f16e3f50-c2f3-4b7c-ae11-ce93479087c6)


