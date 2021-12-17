module clk_div(clk_d, clk);
  parameter div_value = 1;
  output clk_d;
  input clk;

  reg clk_d;
  reg count;

  initial
    begin
      clk_d = 0;
      count = 0;
    end

  always @ (posedge clk)
    begin
      if (count == div_value)
        count <= 0;
      else
        count <= count + 1;
    end

  always @ (posedge clk)
    begin
      if (count == div_value)
        clk_d <= ~clk_d;
    end
endmodule

module clk_screen(clk_divscrn, clk);
  parameter div_value = 99999999; //99999999
  output clk_divscrn;
  input clk;

  reg clk_d;
  reg count;

  initial
    begin
      clk_d = 0;
      count = 0;
    end

  always @ (posedge clk)
    begin
      if (count == div_value)
        count <= 0;
      else
        count <= count + 1;
    end

  always @ (posedge clk)
    begin
      if (count == div_value)
        clk_d <= ~clk_d;
    end
endmodule

module h_counter(h_count, trig_v, clk);
  output [9:0] h_count;
  output trig_v;
  input clk;

  reg [9:0] h_count;
  reg trig_v;

  initial h_count = 0;
  initial trig_v = 0;

  always @ (posedge clk)
    begin
      if (h_count < 799)
        begin
          h_count <= h_count + 1;
          trig_v = 0;
        end
      else
        begin
          h_count <= 0;
          trig_v = 1;
        end
    end
endmodule

module v_counter(v_count, enable_v, clk);
  output [9:0] v_count;
  input enable_v, clk;

  reg [9:0] v_count;

  always @ (posedge clk)
    begin
      if (v_count < 524)
        v_count <= v_count + 1;
      else
        v_count <= 0;
    end
endmodule

`timescale 1ns / 1ps
module vga_sync (
  output h_sync,
  output v_sync,
  output video_on,         // active area
  output [9:0] x_loc,      // current pixel x - location
  output [9:0] y_loc,      // current pixel y - location
  input [9:0] h_count,
  input [9:0] v_count
);

  //horizontal
  localparam HD = 640;      // horizontal display area
  localparam HF = 16;       // horizontal (front porch) right border
  localparam HB = 48;       // horizontal (back porch) left border
  localparam HR = 96;       // horizontal retrace

  //vertical
  localparam VD = 480;      // vertical display area
  localparam VF = 10;       // vertical (front porch) bottom border
  localparam VB = 33;       // vertical (back borch) top border
  localparam VR = 2;        // vertical retrace

  assign x_loc = h_count;
  assign y_loc = v_count;

  assign h_sync = (h_count < (HD + HF)) | (h_count >= (HD + HF + HR));
  assign v_sync = (v_count < (VD + VF)) | (v_count >= (VD + VF + VR));
  assign video_on = (h_count < (HD)) && (v_count < VD);
endmodule                  // vga_sync

//module randomizer(clock,reset,rnd);
//  input clock;
//  input reset;
//  output [3:0] rnd;

//  reg [3:0] random, random_next, random_done;
//  assign rnd = random_done;
//  reg count, count_next; //to keep track of the shifts
//  wire feedback = random[3] ^ random[2] ^ random[1] ^ random[0]; 

//always @ (posedge clock or posedge reset)
//begin
// if (reset)
// begin
//  random <= 4'b1001; //An LFSR cannot have an all 0 state, thus reset to FF
//  count <= 0;
// end
 
// else
// begin
//  random <= random_next;
//  count <= count_next;
// end
//end

//  always @ (posedge clock)
//    begin
//      random_next = random; //default state stays the same
//      count_next = count;
  
//      random_next = {random[2:0], feedback}; //shift left the xor'd every posedge clock
//        count_next = count + 1;

//      if (count == 4)
//    begin
//      count = 0;
//      random_done = random; //assign the random number to output after 13 shifts
//    end
//    $display("clock rnd");
//    $monitor("%b,%b", clock, rnd);   
//    end
   
//endmodule

module Binary_To_Segment(i_Clk,score,sevenseg_enable,o_Segment_A,o_Segment_B,o_Segment_C,o_Segment_D,o_Segment_E,o_Segment_F,o_Segment_G);
input i_Clk;
input score;
output [3:0]sevenseg_enable;
output o_Segment_A;
output o_Segment_B;
output o_Segment_C;
output o_Segment_D;
output o_Segment_E;
output o_Segment_F;
output o_Segment_G;
  reg [3:0]scorebinary;
  reg [6:0]    r_Hex_Encoding = 7'h00;
  assign sevenseg_enable = 4'b1110;
  // Purpose: Creates a case statement for all possible input binary numbers.
  // Drives r_Hex_Encoding appropriately for each input combination.
  always @(posedge i_Clk)
    begin
    scorebinary <= (score==0) ? 4'b0000
: (score==1) ? 4'b0001 
: (score==2) ? 4'b0010 
: (score==3) ? 4'b0011 
: (score==4) ? 4'b0100 
: (score==5) ? 4'b0101 
: (score==6) ? 4'b0110 
: (score==7) ? 4'b0111 
: (score==8) ? 4'b1000
: (score==9) ? 4'b1001
: 4'b0000;
      case (scorebinary)
        4'b0000 : r_Hex_Encoding <= 7'h7E;
        4'b0001 : r_Hex_Encoding <= 7'h30;
        4'b0010 : r_Hex_Encoding <= 7'h6D;
        4'b0011 : r_Hex_Encoding <= 7'h79;
        4'b0100 : r_Hex_Encoding <= 7'h33;          
        4'b0101 : r_Hex_Encoding <= 7'h5B;
        4'b0110 : r_Hex_Encoding <= 7'h5F;
        4'b0111 : r_Hex_Encoding <= 7'h70;
        4'b1000 : r_Hex_Encoding <= 7'h7F;
        4'b1001 : r_Hex_Encoding <= 7'h7B;
        4'b1010 : r_Hex_Encoding <= 7'h77;
        4'b1011 : r_Hex_Encoding <= 7'h1F;
        4'b1100 : r_Hex_Encoding <= 7'h4E;
        4'b1101 : r_Hex_Encoding <= 7'h3D;
        4'b1110 : r_Hex_Encoding <= 7'h4F;
        4'b1111 : r_Hex_Encoding <= 7'h47;
      endcase
    end // always @ (posedge i_Clk)
 
  // r_Hex_Encoding[7] is unused
  assign o_Segment_A = r_Hex_Encoding[6];
  assign o_Segment_B = r_Hex_Encoding[5];
  assign o_Segment_C = r_Hex_Encoding[4];
  assign o_Segment_D = r_Hex_Encoding[3];
  assign o_Segment_E = r_Hex_Encoding[2];
  assign o_Segment_F = r_Hex_Encoding[1];
  assign o_Segment_G = r_Hex_Encoding[0];
 
endmodule // Binary_To_7Segment


module hit(clk,user_input,hit_position);
input clk;
input [8:0]user_input;
output reg [3:0]hit_position;
always @ (posedge clk) begin
hit_position <= (user_input==9'b000000001) ? 4'b0001 
: (user_input==9'b000000010) ? 4'b0010 
: (user_input==9'b000000100) ? 4'b0011 
: (user_input==9'b000001000) ? 4'b0100 
: (user_input==9'b000010000) ? 4'b0101 
: (user_input==9'b000100000) ? 4'b0110 
: (user_input==9'b001000000) ? 4'b0111 
: (user_input==9'b010000000) ? 4'b1000 
: (user_input==9'b100000000) ? 4'b1001
: 4'b0000;
end
endmodule

`timescale 1ns/1ps
module pixel_gen(
  input gameState,
  input [3:0]position,
  input [3:0]hit_position,
  output reg [3:0] black=0,
  output reg [3:0] green=0,
  output reg [3:0] blue=0,
  output reg score=0,
  output reg life=3,
  output reg [2:0]lifeLED = 3'b111,
  input clk_d,
  input [9:0] pixel_x,
  input [9:0] pixel_y,
  input video_on
);
  always @(posedge clk_d) begin
    if ((pixel_x == 0)||(pixel_x == 639)||(pixel_y == 0)||(pixel_y == 479)) begin
      black <= 4'hF;
      green <= 4'hF;
      blue <= 4'hF;

    end
    else begin
      if (gameState ==1) begin
        black <= video_on?((((pixel_x>75) & (pixel_x<175)) || ((pixel_x>250) & (pixel_x<350)) || ((pixel_x>425) & (pixel_x<525))) 
      && (((pixel_y>45) & (pixel_y<145)) || ((pixel_y>190) & (pixel_y<290)) || ((pixel_y>335) & (pixel_y<435))) ? 4'hF:4'h0):(4'h0);
      if (position[3:0] ==4'b0001) begin
        blue <= video_on?((((pixel_x>112) & (pixel_x<138)) & (((pixel_y>82) & (pixel_y<108)))) ? 4'hA:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
      if (position[3:0] ==4'b0010) begin
        blue <= video_on?((((pixel_x>112) & (pixel_x<138)) & (((pixel_y>227) & (pixel_y<253)))) ? 4'hA:4'h0):(4'h0);
      end
      if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      if (position[3:0] ==4'b0011) begin
        blue <= video_on?((((pixel_x>112) & (pixel_x<138)) & (((pixel_y>372) & (pixel_y<398)))) ? 4'hA:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
      if (position[3:0] ==4'b0100) begin
        blue <= video_on?((((pixel_x>287) & (pixel_x<313)) & (((pixel_y>82) & (pixel_y<108)))) ? 4'hA:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
      if (position[3:0] ==4'b0101) begin
        blue <= video_on?((((pixel_x>287) & (pixel_x<313)) & (((pixel_y>227) & (pixel_y<253)))) ? 4'hA:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
      if (position[3:0] ==4'b0110) begin
        blue <= video_on?((((pixel_x>287) & (pixel_x<313)) & (((pixel_y>372) & (pixel_y<398)))) ? 4'hA:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
      if (position[3:0] ==4'b0111) begin
        blue <= video_on?((((pixel_x>462) & (pixel_x<484)) & (((pixel_y>82) & (pixel_y<108)))) ? 4'hA:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
      if (position[3:0] ==4'b1000) begin
        blue <= video_on?((((pixel_x>462) & (pixel_x<484)) & (((pixel_y>227) & (pixel_y<253)))) ? 4'hA:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
      if (position[3:0] ==4'b1001) begin
        blue <= video_on?((((pixel_x>462) & (pixel_x<484)) & (((pixel_y>372) & (pixel_y<398)))) ? 4'hA:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
      
        green <= video_on?(pixel_y > 480? 4'h0:4'h0):(4'h0);
        if (position == hit_position) begin
        score <= score + 1;
        end
        else begin
        life <= life - 1;
        if (life == 2) begin
        lifeLED <= 3'b110;
        end
        if (life == 1) begin
        lifeLED <= 3'b100;
        end
        end
        if (life == 0) begin
        //game over screen here
        end
      end
       else begin
          black <= video_on?( 
          (
            // M
            ((pixel_x>20 & pixel_x<50) || (pixel_x>100 & pixel_x<130) || (pixel_x>170 & pixel_x<200) )  &  ((pixel_y>25 & pixel_y<440))
            || // A I N
            ((pixel_x>250 & pixel_x<280) || (pixel_x>330 & pixel_x<360) || (pixel_x>410 & pixel_x<440) || (pixel_x>490 & pixel_x<520) || (pixel_x>570 & pixel_x<600) )  &  ( (pixel_y>25 & pixel_y<200) )            
            || // Top A I N Lines
            ((pixel_x>20 & pixel_x<200) || (pixel_x>250 & pixel_x<360) || (pixel_x>490 & pixel_x<600) )  &  ((pixel_y>25 & pixel_y<65))
            || // Mid A Line
            (pixel_x>250 & pixel_x<360)  &  ((pixel_y>95 & pixel_y<125))
            || // E N U
            ((pixel_x>250 & pixel_x<280) || (pixel_x>360 & pixel_x<390) || (pixel_x>430 & pixel_x<460) || (pixel_x>500 & pixel_x<530) || (pixel_x>570 & pixel_x<600) )  &  ( (pixel_y>220 & pixel_y<440) )            
            || // Top E N Line
            ((pixel_x>250 & pixel_x<330) || (pixel_x>360 & pixel_x<460))  &  ((pixel_y>220 & pixel_y<250))
            || // Mid E Line
            ((pixel_x>250 & pixel_x<330))  &  ((pixel_y>315 & pixel_y<345))
            || // Bottom E U Line
            ((pixel_x>250 & pixel_x<330) || (pixel_x>500 & pixel_x<600))  &  ((pixel_y>410 & pixel_y<440))
          ) ? 4'hF:4'h0):(4'h0);
          green <= video_on?(pixel_y > 480? 4'h0:4'h0):(4'h0);
       end  
    end
  end
endmodule


module rand(clk,position);
    integer mynumber;
    input clk;
    output  reg [3:0]position;
    always @ (posedge clk) begin
	mynumber = {$random} %10; // random numbers between 0 and 9.
    position <= (mynumber ==0) ? 4'b0001 
: (mynumber ==1) ? 4'b0010 
: (mynumber ==2) ? 4'b0011 
: (mynumber ==3) ? 4'b0100 
: (mynumber ==4) ? 4'b0101 
: (mynumber ==5) ? 4'b0110 
: (mynumber ==6) ? 4'b0111 
: (mynumber ==7) ? 4'b1000 
: (mynumber ==8) ? 4'b1001
: 4'b0000;
end
endmodule

module toplevelmodule(black,blue,green,h_sync,v_sync,clk,reset,gameState,user_input,lifeLED,sevenseg_enable,CA,CB,CC,CD,CE,CF,CG);
  output h_sync,v_sync;
  output [3:0] black,blue,green;
  input clk;
  input reset;
  input  gameState;
  input [8:0]user_input;
  wire clkd,vtrig,videoon;
  wire [9:0] hcount,vcount,xloc,yloc;
  wire [3:0] kabbu_pos;
  wire clk_scrn;
  wire [3:0]hit_pos;
  wire score,life;
  output CA,CB,CC,CD,CE,CF,CG;
  output [2:0]lifeLED;
  output [3:0]sevenseg_enable;
  clk_div cd(clkd, clk);
  h_counter hc(hcount, vtrig, clkd);
  v_counter vc(vcount, clkd, vtrig);
  vga_sync vs(h_sync, v_sync, videoon, xloc, yloc, hcount, vcount);
  clk_screen clk_s(clk_scrn,clk);
  rand rnd(clk_scrn,kabbu_pos);
  hit(clk_scrn,user_input,hit_pos);
  pixel_gen pg(gameState,kabbu_pos,hit_pos,black, green,blue,score,life,lifeLED,clkd, xloc, yloc, videoon);
  Binary_To_Segment seg(clk_scrn,score,sevenseg_enable,CA,CB,CC,CD,CE,CF,CG);
endmodule