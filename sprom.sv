/*
 ****** Single port Read only Memory*****

// inputs verctor of size 3 i_addr , i_clk,i_en

// Outputs : o_dout of size 8 bit size

         version 0.5
*/



module sprom(
  input        i_en,
  input        i_clk,
  input   [2:0]i_addr,
  output  [7:0]o_dout 

);
// Declaring  the reg varable to store and to give access to the output dout when there is the enable signal is high 

  reg [7:0] data_in;

// assigning the values if the enable is high

  assign o_dout=(i_en)? data_in:'bx;
 
  always @(posedge i_clk)
    case(i_addr)
      0:data_in <= 8'h00;
      1:data_in <= 8'h01;
      2:data_in <= 8'h02;
      3:data_in <= 8'h03;
      4:data_in <= 8'h04;
      5:data_in <= 8'h05;
      6:data_in <= 8'h06;
      7:data_in <= 8'h07;   
    endcase

endmodule
 

// ******* sample Test bench ********

module tb_SpRom();
  reg        i_en;
  reg        i_clk;
  reg   [2:0]i_addr;
  wire  [7:0]o_dout; 

// Dut Initilization //

 SpRom dut (
  .i_en(i_en),
  .i_clk(i_clk),
  .i_addr(i_addr),
  .o_dout(o_dout) 
);
   initial begin
     i_clk=1'b0;
   end
   
 always #5 i_clk=!i_clk;

// Adding test vectors //
  initial begin
    $monitor("value of the i_addr and the o_dout ", i_addr, o_dout);
    #10;
    i_addr=1;
    i_en=1'b0;
    #20;
    i_en =1'b1;
    #20;
    i_addr=2;
    #20;
    i_addr=3;
    #20;
    i_addr=4;
    #20;
    i_addr=5;
    #20;
    i_addr=6;
    #20;
    i_addr=7;
    #20;
  end
 initial begin
 #500;
 $finish();
 end
endmodule

 
