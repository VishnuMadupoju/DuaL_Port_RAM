/*

       ************ Hamming Encoder**********

    Inputs - 8 bit vector data of the i_data
   
    Outputs -8 bit vector data of the o_data_out

    -----------------General Operation -----------

    1. This module uses the  even parity encoding Technic to encode the Given bit of the Data
   
    2. It will  Append the Parity bits with respective its Parity locations such as 2**n (where the n is 0 , 1, 2, ..) Position  

*/
 
 
 module ham_enco (

   input              i_clk ,
   input       [7:0]  i_data_in,
   output reg  [11:0] o_data_out
);
  
   // Internal Register 
   reg [3:0] p;
  always @(posedge i_clk)
  begin
    p[0]=i_data_in[0]^ i_data_in[1]^i_data_in[3]^i_data_in[4]^i_data_in[6];
    p[1]=i_data_in[0]^ i_data_in[2]^i_data_in[3]^i_data_in[5]^i_data_in[6];
    p[2]=i_data_in[1]^ i_data_in[2]^i_data_in[3]^i_data_in[7];
    p[3]=i_data_in[4]^ i_data_in[5]^i_data_in[6]^i_data_in[7]; 
    o_data_out  ={i_data_in[7:4],p[3],i_data_in[3:1],p[2],i_data_in[0],p[1],p[0]};
  end
 endmodule 

 //-----------------Simple Test --------------------------------


 module tb_ham_enco();

   reg  [7:0]  i_data_in;
  
   reg i_clk;

   wire [11:0] o_data_out;

  ham_enco dut (

   . i_data_in(i_data_in),
   . o_data_out(o_data_out),
   .i_clk(i_clk)
  );

   initial begin
     i_clk =1'b0; 
   end
   always #5 i_clk = !i_clk;

   initial begin 
    i_data_in = 8'h11;
    #10;
    i_data_in = 8'h12;
    #10;
    i_data_in = 8'h13;
   end
   initial begin
     #500;
     $finish();
   end

 endmodule


  

