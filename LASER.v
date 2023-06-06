module LASER (
input CLK,
input RST,
input [3:0] X,
input [3:0] Y,
output reg [3:0] C1X,
output reg [3:0] C1Y,
output reg [3:0] C2X,
output reg [3:0] C2Y,
output reg DONE);

// For LFSR
reg [4:0] q // random value from 1 to 31 

// FSM
reg [3:0]current_state;
reg [3:0]next_state;
parameter  INIT = 0;
parameter READ = 1;
parameter STEP_ONE = 2;
parameter STEP_TWO = 3;
parameter STEP_THREE = 4;
// parameter OPTIMIZE = 8;
parameter OUTPUT = 5;

// caculate max cover
reg [5:0] cover_current; // num of current covered points
reg [5:0] cover_max;
reg [5:0] cnt;
reg [3:0] corX [39:0]; // coordinates array of all input points
reg [3:0] corY [39:0];
reg [3:0] tmpX1, tmpY1, tmpX2, tmpY2; // current x and y
wire [4:0] dx1, dy1, dx2, dy2;

// ***
// compute abs value of dist. b/t tmpX/Y and corXY
assign  dx1 = (tmpX1 > corX[cnt])? tmpX1 - corX[cnt] : corX[cnt] - tmpX1;
assign  dy1 = (tmpY1 > corY[cnt])? tmpY1 - corY[cnt] : corY[cnt] - tmpY1;
assign  dx2 = (tmpX2 > corX[cnt])? tmpX2 - corX[cnt] : corX[cnt] - tmpX2;
assign  dy2 = (tmpY2 > corY[cnt])? tmpY2 - corY[cnt] : corY[cnt] - tmpY2;
// ***
/*
cover_current <= cover_current +
        ((dx1 + dy1 <= 4) || (dx1 == 3 && dy1 == 2) || (dx1 == 2 && dy1 == 3) ||
        (dx2 + dy2 <= 4) || (dx2 == 3 && dy2 == 2) || (dx2 == 2 && dy2 == 3));
*/


/// vvvvvvvvvvv  FSM  vvvvvvvvvvv ///
always @(posedge CLK or posedge RST) begin
  if(RST)
    current_state <= INIT;
  else
    current_state <= next_state;
end

// State transition
always @(*) begin
  case (current_state)
    INIT:
      next_state =(RST)?INIT:READ;
    READ:
      next_state =  (cnt == 6'd39)?STEP_ONE:READ;
    STEP_ONE: // how to stop STEP_ONE?
      next_state =  (cnt == 6'd20)?STEP_TWO:STEP_ONE;
    STEP_TWO:
      next_state =  (cnt == 6'd20)?STEP_THREE:STEP_TWO;
    STEP_THREE:
      next_state =  (cnt ==Z 6'd20)?STEP_TWO:STEP_THREE;
    // OPTIMIZE:
    //     next_state =(dir1 == 0 && dir2 == 0 && change ==0 && interval == 3'd7)?OUTPUT:CAL_DOWN;
    OUTPUT:
      next_state = READ;
    default:
      next_state = INIT;
  endcase
end
/// ^^^^^^^^^^^  FSM  ^^^^^^^^^^^ ///

// cover_current
always @(posedge CLK) begin
if(RST)
    cover_current <= 6'd0;
else if(current_state == CAL_COVER_RATE)
begin
    if(cnt >0)
    begin
        if(mul1 <=16)
            cover_current <= cover_current + 1;
    end
end
else if(current_state == CAL_UP || current_state == CAL_DOWN || current_state == CAL_LEFT ||current_state == CAL_RIGHT)
begin
    if(cnt >0)
    begin
        if(mul1 <=16 || mul2 <= 16)
            cover_current <= cover_current + 1;
    end
    else
        cover_current <= 0;
end
else if(current_state == OUTPUT)
    cover_current <= 0;
end

// cover_max
always @(posedge CLK) begin
if(RST)
    cover_max <= 6'd0;
else if(current_state == CAL_COVER_RATE || current_state == CAL_UP || current_state == CAL_DOWN || current_state == CAL_LEFT || current_state == CAL_RIGHT)
begin
    if(cnt == 6'd40)
    begin
        if(cover_current >cover_max)
            cover_max <= cover_current;
    end
end
else if(current_state == OUTPUT)
    cover_max <= 0;
end

// dir
always @(posedge CLK)
begin
if(RST)
begin
    dir1 <= 0;
    dir2 <= 0;
    change <= 0;
end
else if(current_state == OPTIMIZE && next_state == CAL_DOWN)
begin
    if(!circle && dir2!=0)
        change <= 1;
    else if(circle && dir1!=0)
        change <= 1;
    else
        change <=0;
    dir1 <= 0;
    dir2 <= 0;
end
else if(cnt == 6'd40 && cover_current >cover_max)
begin
    if(circle)
    begin
        change <= 1;
        case(current_state)
            CAL_UP:
                dir2 <= 1;
            CAL_DOWN:
                dir2 <= 2;
            CAL_LEFT:
                dir2 <= 3;
            CAL_RIGHT:
                dir2 <= 4;
        endcase
    end
    else
    begin
        change <= 1;
        case(current_state)
            CAL_UP:
                dir1 <= 1;
            CAL_DOWN:
                dir1 <= 2;
            CAL_LEFT:
                dir1 <= 3;
            CAL_RIGHT:
                dir1 <= 4;
        endcase
    end
end
else if(current_state == OUTPUT)
begin
    dir1 <= 0;
    dir2 <= 0;
end

end

// cnt, or Temperature for 15 ~ 25 round
always @(posedge CLK) begin
  if(RST)
    cnt <= 0;
  else if(current_state == OUTPUT)
    cnt <= 0;
  else if(next_state == READ) // read input patterns
    cnt <= cnt + 1;
  else if(current_state == STEP_ONE)
    cnt <= 0;
  else if(current_state == STEP_TWO) // start SA
    cnt = (cnt == 6'd20)? cnt <= 0: cnt;
  else if(current_state == STEP_THTREE)
    cnt = (cnt == 6'd20)? cnt <= 0: cnt+1;
  else
    cnt <= 0;
end

// OUTPUT (C1X, C1Y), (C2X, C2Y)
always @(posedge CLK) begin
  if (RST)
  begin
    C1X <= 0;
    C1Y <= 0;
    C2X <= 0;
    C2Y <= 0;
  end
  else if (current_state == STEP_ONE || current_state == STEP_TWO || current_state == STEP_THREE)
  begin
    if(cnt == 6'd20) begin
      if(cover_current > cover_max) begin
        C1X <= tmpX1;
        C1Y <= tmpY1;
        C2X <= tmpX2;
        C2Y <= tmpY2;
      end
    end
  end
end


always @(posedge CLK) begin
  if(RST)
    DONE <= 1'b0;
  else if (next_state == OUTPUT)
    DONE <= 1'b1;
  else
    DONE <= 1'b0;
end

endmodule

// 5-bit maximal-length LFSR 
always @(posedge CLK) begin
  /* 
    q = 1 ~ 31
    if used as probability function, 
    sampled q < 4 approximately equals to 10%
  */
  if (RST) 
    q <= 5'h1;
  else begin
    q[4] <= 1'b0 ^ q[0];
    q[3] <= q[4];
    q[2] <= q[0] ^ q[3];
    q[1] <= q[2];
    q[0] <= q[1];
  end
end