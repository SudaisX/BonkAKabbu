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

`timescale 1ns/1ps
module pixel_gen(
  input gameState,
  output reg [3:0] black=0,
  output reg [3:0] green=0,
  output reg [3:0] blue=0,
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

        blue <= video_on?((((pixel_x>112) & (pixel_x<138)) || ((pixel_x>287) & (pixel_x<313)) || ((pixel_x>462) & (pixel_x<484))) 
      && (((pixel_y>82) & (pixel_y<108)) || ((pixel_y>227) & (pixel_y<253)) || ((pixel_y>372) & (pixel_y<398))) ? 4'hA:4'h0):(4'h0);
      
        green <= video_on?(pixel_y > 480? 4'h0:4'h0):(4'h0);
      end

//        blue <= video_on?(((pixel_x>287) & (pixel_x<313)) && (((pixel_y>227) & (pixel_y<253))) ? 4'hB:4'h0):(4'h0);
       else begin
          blue <= video_on?((((pixel_x>112) & (pixel_x<138)) || ((pixel_x>287) & (pixel_x<313)) || ((pixel_x>462) & (pixel_x<484))) 
      && (((pixel_y>82) & (pixel_y<108)) || ((pixel_y>227) & (pixel_y<253)) || ((pixel_y>372) & (pixel_y<398))) ? 4'hA:4'h0):(4'h0);
          green <= video_on?(pixel_y > 480? 4'h0:4'h0):(4'h0);
       end
         

//        black <= video_on?((pixel_x>75) & (pixel_x<175) & (pixel_x>250) & (pixel_x<350) & (pixel_y>45) & (pixel_y<145) & (pixel_y>190) & (pixel_y<290) ? 4'hF:4'h0):(4'h0);
//      #5
//      black <= video_on?((pixel_x>75) & (pixel_x<175) & (pixel_y>190) & (pixel_y<290) ? 4'hF:4'h0):(4'h0);
//      #5
//      black <= video_on?((pixel_x>75) & (pixel_x<175) & (pixel_y>335) & (pixel_y<435) ? 4'hF:4'h0):(4'h0);
//      #5
      
//      black <= video_on?((pixel_x>250) & (pixel_x<350) & (pixel_y>45) & (pixel_y<145) ? 4'hF:4'h0):(4'h0);
//      #5
//      black <= video_on?((pixel_x>250) & (pixel_x<350) & (pixel_y>190) & (pixel_y<290) ? 4'hF:4'h0):(4'h0);
//      #5
//      black <= video_on?((pixel_x>250) & (pixel_x<350) & (pixel_y>335) & (pixel_y<435) ? 4'hF:4'h0):(4'h0);
//      #5
      
//      black <= video_on?((pixel_x>425) & (pixel_x<525) & (pixel_y>45) & (pixel_y<145) ? 4'hF:4'h0):(4'h0);
//      #5
//      black <= video_on?((pixel_x>425) & (pixel_x<525) & (pixel_y>190) & (pixel_y<290) ? 4'hF:4'h0):(4'h0);
//      #5
//      black <= video_on?((pixel_x>425) & (pixel_x<525) & (pixel_y>335) & (pixel_y<435) ? 4'hF:4'h0):(4'h0);
//      #5
      
      
    end
  end
endmodule


// Random Module
//module rand();
//    integer mynumber;

//    initial begin
//	mynumber = {$random} %10 ; // random numbers between 0 and 9.
//    end
//endmodule

module toplevelmodule(black,blue,green,h_sync,v_sync,clk,gameState);
  output h_sync,v_sync;
  output [3:0] black,blue,green;
  input clk;
  input  gameState;
  wire clkd,vtrig,videoon;
  wire [9:0] hcount,vcount,xloc,yloc;

  clk_div cd(clkd, clk);
  h_counter hc(hcount, vtrig, clkd);
  v_counter vc(vcount, clkd, vtrig);
  vga_sync vs(h_sync, v_sync, videoon, xloc, yloc, hcount, vcount);
  pixel_gen pg(gameState,black, green,blue, clkd, xloc, yloc, videoon);
endmodule