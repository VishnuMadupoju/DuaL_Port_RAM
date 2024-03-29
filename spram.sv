/*

         *********** Single port RAM **********

// Inputs  : i_en, i_we,i_din vecor of 8 bit, vector 3 bit size i_addr, and i_clk 

// Outputs : vector of 8 bit o_dout

//  Read operation is performed when the i_we is low and the i_en is high 

//  Write operation is performed when the i_we and the i_en is high
*/



module spram(
  input               i_clk,
  input       [7:0]   i_din,
  input       [2:0]   i_addr,
  input               i_we,
  input               i_en,
  output reg  [7:0]   o_dout

);
//Declaring the memory size of the 2^3 address location as the address lines are of the size 3 bits

  reg [7:0] mem [0:8]; //  The data size is of the 8 bit size as mentioned

  always @(posedge i_clk)
  begin
    if(i_en)
    begin
      if(i_we)
        mem [i_addr] <= i_din;
      else
        o_dout       <= mem [i_addr]; 
    end
    else
      o_dout         <= 'bx; 

  end

endmodule



/// ***** Sample Test Bench *********

module tb_sram();
 
  reg  i_clk;
  reg [7:0]  i_din;
  reg [2:0]  i_addr;
  reg        i_we;
  reg        i_en;
  wire [7:0] o_dout;
  spram dut (
    . i_clk(i_clk),
    . i_din(i_din),
    . i_addr(i_addr),
    . i_we(i_we),
    . i_en(i_en),
    . o_dout(o_dout)
   );

  initial i_clk=1'b0;
  always  #5 i_clk= !i_clk;
 int i;
  initial begin
    #10;
    i_din=8'h11;
    #10;
    i_en=1'b1;
    i_we=1'b1;
    for (i=0;i<8;i++)
    begin
     i_addr =i;
     i_din  = $urandom();
     #10;
    end
    #10;
    i_en=1'b1;
    i_we=1'b0;
    for (i=0;i<8;i++)
    begin
      i_addr=i;
      $display("Values  are %0b",dut.mem[i] );
      #10;
    end
    #10;
    i_en=1'b0;
    #10;
  end
  initial begin
   #500;
   $finish();
  end
   
endmodule


