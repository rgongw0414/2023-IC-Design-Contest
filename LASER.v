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
reg [4:0] q; // random value from 1 to 31 
wire [3:0] step;

// FSM
reg [1:0]current_state;
reg [1:0]next_state;
parameter  INIT = 0;
parameter READ = 1;
parameter WALK = 2;
parameter OUTPUT = 3;

// caculate max cover
// cnt
reg [5:0] cover_prev; // num of previous covered points
reg [5:0] cover_current; // num of current covered points
reg [5:0] cover_max; // max_global
reg [5:0] cnt; // counter
reg [3:0] corX [39:0]; // coordinates array of all input points
reg [3:0] corY [39:0];
reg [3:0] x1, y1, x2, y2; // current x and y
reg [3:0] tmpX1, tmpY1, tmpX2, tmpY2; 
wire [4:0] dx1, dy1, dx2, dy2;

// reg round_flag;
reg [3:0] round; // sub-rounds count


assign step = (q[1:0] == 2'b11)? {3'b000, q[0]}: {2'b0, q[1:0]};

// compute abs value of dist. b/t tmpX/Y and corXY
assign  dx1 = (tmpX1 > corX[cnt])? tmpX1 - corX[cnt] : corX[cnt] - tmpX1;
assign  dy1 = (tmpY1 > corY[cnt])? tmpY1 - corY[cnt] : corY[cnt] - tmpY1;
assign  dx2 = (tmpX2 > corX[cnt])? tmpX2 - corX[cnt] : corX[cnt] - tmpX2;
assign  dy2 = (tmpY2 > corY[cnt])? tmpY2 - corY[cnt] : corY[cnt] - tmpY2;

/// vvvvvvvvvvv  FSM  vvvvvvvvvvv ///
always @(posedge CLK or posedge RST) begin
  if (RST)
    current_state <= INIT;
  else
    current_state <= next_state;
end

// State transition
always @(*) begin
  case (current_state)
    INIT:
      next_state = (RST)? INIT: READ;
    READ:
      next_state = (cnt == 6'd39)? WALK: READ;
    WALK: // check 40 points covering
      next_state = (round == 4'd10)? OUTPUT: WALK;
    OUTPUT:
      next_state = READ;
    default:
      next_state = INIT;
  endcase
end
/// ^^^^^^^^^^^  FSM  ^^^^^^^^^^^ ///


// reg [3:0] round
always @(posedge CLK) begin
  if (RST)
    round <= 4'd0;
  else if (current_state == OUTPUT)
    round <= 4'd0;
  else if (current_state == WALK) begin
    round <= (cnt == 6'd40)? round <= round+4'd1: 4'd0; // round++
    // if (cnt == 6'd40) 
    //   round <= round + 4'd1;
    // else
    //   round <= 4'd0;
  end
end

// current best x1, y1, x2, y2
always @(posedge CLK) begin
  if (RST) begin
    x1 <= 4'd7; y1 <= 4'd7;
    x1 <= 4'd7; y2 <= 4'd7;
  end
  else if (current_state == OUTPUT) begin
    x1 <= 4'd7; y1 <= 4'd7;
    x2 <= 4'd7; y2 <= 4'd7;
  end
  else if (current_state == WALK) begin
    if (cnt == 6'd40) begin
      if (cover_current > cover_max) begin
        x1 <= tmpX1; y1 <= tmpY1;
        x2 <= tmpX2; y2 <= tmpY2;
      end
    end
  end
end

// tmpX1, tmpY1, tmpX2, tmpY2
// walk to new point
always @(posedge CLK) begin
  if (RST) begin
    tmpX1 <= 4'd7; tmpY1 <= 4'd7;
    tmpX2 <= 4'd7; tmpY2 <= 4'd7;
  end
  else if (current_state == OUTPUT) begin
    tmpX1 <= 4'd7; tmpY1 <= 4'd7;
    tmpX2 <= 4'd7; tmpY2 <= 4'd7;
  end
  else if (current_state == WALK) begin
    tmpX1 <= (q[0])? tmpX1 <= x1 + step: tmpX1 <= x1 - step; 
    tmpY1 <= (q[1])? tmpY1 <= y1 + step: tmpY1 <= y1 - step; 
    tmpX2 <= (q[2])? tmpX2 <= x2 + step: tmpX2 <= x2 - step; 
    tmpY2 <= (q[3])? tmpY2 <= y2 + step: tmpY2 <= y2 - step; 
  end
end

// cover_prev
always @(posedge CLK) begin
  if (RST)
    cover_prev <= 6'd0;
  else if (current_state == OUTPUT)
    cover_prev <= 6'd0;
  else if (current_state == WALK) begin
    if(cnt == 6'd40) begin // finished checking the covering of the 40 points
      if(cover_current > cover_prev)
        cover_prev <= cover_current;
      // else begin // accept worse result with probability
      //   if (q < 5'd4)  // 10% acceptance
      //     cover_prev <= cover_current;
      // end
    end
  end
end

// cover_current
always @(posedge CLK) begin
  if(RST)
    cover_current <= 6'd0;
  else if(current_state == WALK) begin
    if(cnt > 0) begin
        cover_current <= cover_current +
        ((dx1 + dy1 <= 4) || (dx1 == 3 && dy1 == 2) || (dx1 == 2 && dy1 == 3) ||
         (dx2 + dy2 <= 4) || (dx2 == 3 && dy2 == 2) || (dx2 == 2 && dy2 == 3));
    end
    else 
      cover_current <= 0;
  end
  else if(current_state == OUTPUT)
    cover_current <= 0;
  else
    cover_current <= 0;
end

// cover_max
always @(posedge CLK) begin
  if(RST)
    cover_max <= 6'd0;
  else if(current_state == WALK) begin
    if(cnt == 6'd40) begin // finished checking the covering of the 40 points
      if(cover_current > cover_max)
        cover_max <= cover_current;
    end
  end
  else if(current_state == OUTPUT)
    cover_max <= 0;
  else
    cover_max <= 0;
end

// cnt, or Temperature for 5 ~ 15 round
always @(posedge CLK) begin
  if(RST)
    cnt <= 0;
  else if(next_state == READ) // read input patterns
    cnt <= cnt + 1;
  else if(current_state == OUTPUT)
    cnt <= 0;
  else if(current_state == WALK) begin
      cnt <= (cnt == 6'd40)? cnt <= 0: cnt+1;
  end
  else
    cnt <= 0;
end

// OUTPUT: (C1X, C1Y), (C2X, C2Y)
always @(posedge CLK) begin
  if (RST) begin
    C1X <= 0; C1Y <= 0;
    C2X <= 0; C2Y <= 0;
  end
  else if (current_state == WALK) begin
    if(cnt == 6'd40) begin
      if(cover_current > cover_max) begin
        C1X <= tmpX1; C1Y <= tmpY1;
        C2X <= tmpX2; C2Y <= tmpY2;
      end
      // else begin // accept worse result with probability
      //   if (q < 5'd4) begin // 10% acceptance
      //     C1X <= tmpX1; C1Y <= tmpY1;
      //     C2X <= tmpX2; C2Y <= tmpY2;
      //   end
      // end
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

// 5-bit maximal-length LFSR 
always @(posedge CLK) begin
  /* 
    q = 1 ~ 31
    if used as probability function, 
    sampled q < 4 approximately equals to 10%
  */
  if (RST) 
    q <= 5'd1;
  else begin
    q[4] <= 1'b0 ^ q[0];
    q[3] <= q[4];
    q[2] <= q[0] ^ q[3];
    q[1] <= q[2];
    q[0] <= q[1];
  end
end

endmodule