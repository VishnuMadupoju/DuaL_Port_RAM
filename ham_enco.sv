/*

     ************ Hamming Encoder**********

    Inputs - 8 bit vector data of the i_data
   
    Outputs -8 bit vector data of the o_data_out

*/
 
 
 module ham_enco (

   input  [7:0]  i_data_in;
   output [11:0] o_data_out;
);

  wire po, p1,p2,p3;

  assign po=i_data_in[0]^ i_data_in[1]^i_data_in[3]^i_data_in[4]^i_data_in[6];
  assign p1=i_data_in[0]^ i_data_in[2]^i_data_in[3]^i_data_in[5]^i_data_in[6];
  assign p2=i_data_in[1]^ i_data_in[2]^i_data_in[3]^i_data_in[7];
  assign p3=i_data_in[4]^ i_data_in[5]^i_data_in[6]^i_data_in[7];

  assign o_data_out  ={i_data_in[7:4],p3,i_data_in[3:1],p2,i_data_in[0],p1,po};


 endmodule 

 //-----------------Simple Test --------------------------------


 module tb_ham_enco();

   reg  [7:0]  i_data_in;

   wire [11:0] o_data_out;

  ham_enco dut (

   . i_data_in(i_data_in),
   . o_data_out(o_data_out),
  );

  


 endmodule


  

