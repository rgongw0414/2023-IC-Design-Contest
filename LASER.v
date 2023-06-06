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

reg [3:0]current_state;
reg [3:0]next_state;

parameter  INIT = 0;
parameter READ = 1;

parameter STEP_ONE = 2;
parameter STEP_TWO = 3;
parameter STEP_THREE = 4;
// parameter OPTIMIZE = 8;
parameter OUTPUT = 5;

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

reg [3:0] tmpx1, tmpx2, tmpy1, tmpy2;
wire [8:0] mul1, mul2;
assign mul1 =(tmpx1 - bufferX[cnt])*(tmpx1 - bufferX[cnt]) + (tmpy1 - bufferY[cnt])*(tmpy1 - bufferY[cnt]);
assign mul2 =(tmpx2 - bufferX[cnt])*(tmpx2 - bufferX[cnt]) + (tmpy2 - bufferY[cnt])*(tmpy2 - bufferY[cnt]);
always @(posedge CLK or posedge RST) begin
    if(RST)
        current_state <= INIT;
    else 
        current_state <= next_state;
end

always @(*) begin
case (current_state)
    INIT:
        next_state =(RST)?INIT:READ;
    READ:
        next_state =  (cnt == 6'd39)?CAL_CIRCLE2_LOCATION:READ;
    CAL_CIRCLE2_LOCATION:
        next_state = CAL_COVER_RATE;
    CAL_COVER_RATE:
        next_state = (cnt == 6'd40)?CAL_DOWN:CAL_COVER_RATE;
    CAL_DOWN:
        next_state =(cnt == 6'd40)?CAL_UP:CAL_DOWN;
    CAL_UP:
        next_state =(cnt == 6'd40)?CAL_RIGHT:CAL_UP;
    
    CAL_RIGHT:
        next_state =(cnt == 6'd40)?CAL_LEFT:CAL_RIGHT;
    CAL_LEFT:
        next_state =(cnt == 6'd40)?OPTIMIZE:CAL_LEFT;
        
    OPTIMIZE:
        next_state =(dir1 == 0 && dir2 == 0 && change ==0 && interval == 3'd7)?OUTPUT:CAL_DOWN;
    OUTPUT:
        next_state = READ;
    default: 
        next_state = INIT;
endcase
end

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

// circle
always @(posedge CLK) begin
if(RST)
    circle <= 0;
else if(current_state == CAL_LEFT)
begin
    if(cnt == 6'd40)
        if((!circle && dir2==0) || (circle && dir1 == 0))
            circle <= ~circle;
end
else if(current_state == OUTPUT)
    circle <= 0;
end


// cnt, or Temperature for 15 ~ 25 round
always @(posedge CLK) begin
if(RST)
    cnt <= 0;
else if(current_state == OUTPUT)
    cnt <= 0;
else if(next_state == READ)
    cnt <= cnt + 1;
else if(current_state == CAL_CIRCLE2_LOCATION)
    cnt <= 0;
else if(current_state == CAL_COVER_RATE)
begin
    if(cnt == 40)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end
else if(current_state == CAL_UP || current_state == CAL_DOWN || current_state == CAL_LEFT|| current_state == CAL_RIGHT )
begin
    if(cnt ==6'd40)
        cnt <= 0;
    else 
        cnt <= cnt +1;
end
else 
    cnt <= 0;
end

// OUTPUT
always @(posedge CLK) begin
if(RST)
begin
    C1X <= 0;
    C1Y <= 0;
    C2X <= 0;
    C2Y <= 0;
end
else if(current_state == CAL_CIRCLE2_LOCATION)
begin
    C1X <= add_1/40;
    C1Y <= add_2/40;
    C2X <= add_1/40;
    C2Y <= add_2/40;
end
else if(current_state == CAL_UP || current_state == CAL_DOWN || current_state == CAL_LEFT || current_state == CAL_RIGHT)
begin
    if(cnt == 6'd40)
    begin
        if(cover_current > cover_max)
        begin
            C1X <= tmpx1;
            C1Y <= tmpy1;
            C2X <= tmpx2;
            C2Y <= tmpy2;
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

