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
parameter LFSR_WIDTH = 10;
parameter [LFSR_WIDTH-1:0] threshold = 100;
reg [LFSR_WIDTH-1:0] q; // random value from 1 to 31 

wire feedback; // Feedback bit

// Taps from polynomial x^10 + x^7 + 1
assign feedback = q[9] ^ q[6];

always @(posedge CLK) begin
    if (RST)
        q <= 10'h1; // Non-zero seed (avoid all-zero state)
    else
        q <= {q[LFSR_WIDTH-2:0], feedback}; // Shift left with feedback
end

wire [3:0] step;
assign step = (q[5:4] == 2'b11)? {3'b000, q[0]}: {2'b0, q[5:4]};  // step: {0,1,1,2}
// assign step = {1'b0, q[9], q[3], q[7]};
// assign step = {2'b0, q[3], q[7]};

// wire [3:0] testX;
// wire [3:0] testY;

// FSM
reg [1:0] current_state;
reg [1:0] next_state;
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
reg [3:0] dx1, dy1, dx2, dy2;

// reg round_flag;
reg [9:0] round; // sub-rounds count

// assign testX = corX[cnt];
// assign testY = corY[cnt];


// READ and store the inputs into array
always @(posedge CLK) begin
  if (current_state == INIT) begin
    corX[cnt] <= X;
    corY[cnt] <= Y;
  end
  if (current_state == READ || next_state == READ) begin
    corX[cnt] <= X;
    corY[cnt] <= Y;
  end
end

always @(*) begin
  if (cnt == 6'd40 || next_state == READ || RST) begin
    dx1 = 4'd0; dy1 = 4'd0;
    dx2 = 4'd0; dy2 = 4'd0;
  end
  else if (next_state == WALK) begin
    dx1 = (tmpX1 > corX[cnt])? tmpX1 - corX[cnt] : corX[cnt] - tmpX1;
    dy1 = (tmpY1 > corY[cnt])? tmpY1 - corY[cnt] : corY[cnt] - tmpY1;
    dx2 = (tmpX2 > corX[cnt])? tmpX2 - corX[cnt] : corX[cnt] - tmpX2;
    dy2 = (tmpY2 > corY[cnt])? tmpY2 - corY[cnt] : corY[cnt] - tmpY2;
  end
  else begin
    dx1 = 4'd0; dy1 = 4'd0;
    dx2 = 4'd0; dy2 = 4'd0;
  end
end

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
      next_state = (round == 10'd300)? OUTPUT: WALK;
    OUTPUT:
      next_state = INIT;
    default:
      next_state = INIT;
  endcase
end
/// ^^^^^^^^^^^  FSM  ^^^^^^^^^^^ ///


always @(posedge CLK) begin
  if (RST)
    round <= 10'd0;
  else if (current_state == OUTPUT)
    round <= 10'd0;
  else if (current_state == WALK) begin
    if (cnt == 6'd40)
      round <= round + 10'd1;
  end
end

// tmpX1, tmpY1, tmpX2, tmpY2
// walk to new point
always @(posedge CLK) begin
  if (RST) begin
    tmpX2 <= 4'd7; 
  end
  else if (current_state == OUTPUT) begin
    tmpX2 <= 4'd7;
  end
  else if (current_state == WALK) begin
    // take whatever 4 bits of q as direction, because q is pseudo-random
    if (q[5]) tmpX2 <= (x2+step < 16)? x2+step : 15; 
      // tmpX2 <= x2+step;
    else      tmpX2 <= (x2 > step) ? x2-step : 0;  
      // tmpX2 <= x2-step;  
  end
end

always @(posedge CLK) begin
  if (RST) begin
    tmpY2 <= 4'd7;
  end
  else if (current_state == OUTPUT) begin
    tmpY2 <= 4'd7;
  end
  else if (current_state == WALK) begin
    // take whatever 4 bits of q as direction, because q is pseudo-random
    if (q[9]) tmpY2 <= (y2+step < 16)? y2+step : 15;
      //   tmpY2 <= y2+step;
    else      tmpY2 <= (y2 > step)? y2-step : 0;  
      // tmpY2 <= y2-step;  
  end
end

always @(posedge CLK) begin
  if (RST) begin
    tmpX1 <= 4'd7;
  end
  else if (current_state == OUTPUT) begin
    tmpX1 <= 4'd7;
  end
  else if (current_state == WALK) begin
    // take whatever 4 bits of q as direction, because q is pseudo-random
    if (q[0]) tmpX1 <= (x1+step < 16)? x1+step : 15; // keep it walking in the field
    else      tmpX1 <= (x1 > step)? x1-step : 0; 
  end
end

always @(posedge CLK) begin
  if (RST) begin
    tmpY1 <= 4'd7;
  end
  else if (current_state == OUTPUT) begin
    tmpY1 <= 4'd7;
  end
  else if (current_state == WALK) begin
    // take whatever 4 bits of q as direction, because q is pseudo-random
    if (q[3]) tmpY1 <= (y1+step < 16)? y1+step : 15; 
    else      tmpY1 <= (y1 > step)? y1-step : 0;  
  end
end

// current best x1, y1, x2, y2
always @(posedge CLK) begin
  if (RST) begin
    x1 <= 4'd7; y1 <= 4'd7;
    x2 <= 4'd7; y2 <= 4'd7;
  end
  else if (current_state == OUTPUT) begin
    x1 <= 4'd7; y1 <= 4'd7;
    x2 <= 4'd7; y2 <= 4'd7;
  end
  else if (current_state == WALK) begin
    if (cnt == 6'd40) begin      
      if(cover_current > cover_prev) begin
        x1 <= tmpX1; y1 <= tmpY1;
        x2 <= tmpX2; y2 <= tmpY2;
      end
      else begin // accept worse result with probability
        if (q < threshold) begin // 10% acceptance
          x1 <= tmpX1; y1 <= tmpY1;
          x2 <= tmpX2; y2 <= tmpY2;
        end
      end
    end
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
      else begin // accept worse result with probability
        if (q < threshold)  // 10% acceptance
          cover_prev <= cover_current;
      end
    end
  end
end

// cover_current
always @(posedge CLK) begin
  if(RST)
    cover_current <= 6'd0;
  else if(next_state == OUTPUT)  // *** order of codes matter! Wrong order could generate 'unkonwn' *** //
    cover_current <= 6'd0;
  else if(current_state == WALK) begin
    if(cnt > 0) begin
      if (cnt == 6'd40)
        cover_current <= 6'd0;
      else begin
        cover_current <= cover_current +
        ((dx1 + dy1 <= 4) || (dx1 == 3 && dy1 == 2) || (dx1 == 2 && dy1 == 3) ||
         (dx2 + dy2 <= 4) || (dx2 == 3 && dy2 == 2) || (dx2 == 2 && dy2 == 3));        
      end
    end
    else 
      cover_current <= 6'd0;
  end
  else
    cover_current <= 6'd0;
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
  if (RST)
    cnt <= 0;
  else if (current_state == OUTPUT || next_state == OUTPUT)
    cnt <= 0;
  else if (next_state == READ) // read input patterns
    cnt <= cnt + 1;
  else if (current_state == WALK) begin
      cnt <= (cnt == 6'd40)? 0: cnt+1;
  end
  else
    cnt <= 0;
end

// OUTPUT: (C1X, C1Y), (C2X, C2Y)
always @(posedge CLK) begin
  if (RST) begin
    C1X <= 4'd7; C1Y <= 4'd7;
    C2X <= 4'd7; C2Y <= 4'd7;
  end
  else if (current_state == WALK) begin
    if(cnt == 6'd40) begin
      if(cover_current > cover_max) begin
        C1X <= tmpX1; C1Y <= tmpY1;
        C2X <= tmpX2; C2Y <= tmpY2;
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

// // 5-bit maximal-length LFSR 
// always @(posedge CLK) begin
//   /* 
//     q = 1 ~ 31
//     if used as probability function, 
//     sampled q < 4 approximately equals to 10%
//   */
//   if (RST) 
//     q <= 5'h1;
//   else begin
//     q[4] <= 1'b0 ^ q[0];
//     q[3] <= q[4];
//     q[2] <= q[0] ^ q[3];
//     q[1] <= q[2];
//     q[0] <= q[1];
//   end
// end
endmodule
