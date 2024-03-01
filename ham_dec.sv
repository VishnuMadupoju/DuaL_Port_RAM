/*
 
  ******************* Hamming decoder*********************
 
  Inputs : i_data Encoded Signal i.e of the size 12 bit as it was Developed

  Outputs : o_data Original Signals of the Data Type it there is the error That will be co



*/


module ham_dec (
  
  input       [11:0] i_data,
  input  reg  [7:0]  o_data,
  input              i_clk
    
 );
   // Syndrome Input 

  reg [3:0] data_sy;

  // Temperary reg 
   reg    [11:0] t_data,

   reg   err_data_bit;
  always @(posedge i_clk)
  begin

    t_data = i_data;

    data_sy [0] =i_data_in[0]^ i_data_in[2]^i_data_in[4]^i_data_in[6]^i_data_in[8]^i_data_in[10];
  
    data_sy [1] =i_data_in[1]^ i_data_in[2]^i_data_in[5]^i_data_in[6]^i_data_in[9]]^i_data_in[10];
  
    data_sy [2] =i_data_in[3]^ i_data_in[4]^i_data_in[5]^i_data_in[6]^i_data_in[11]];
  
    data_sy [3] =i_data_in[7]^ i_data_in[8]^i_data_in[9]^i_data_in[10]^i_data_in[11]];
  
  end
 
  always @(posedge i_clk)
  begin
  if (data_sy >= 1 )
  begin
    err_data_bit      <= ![i_data[data_sy]];
    t_data[data_sy]   <=   err_data_bit;
    o_data            <= {t_data[11:8],t_data[6:4],t_data[2]};
  end
  else 
    o_data            <= {t_data[11:8],t_data[6:4],t_data[2]};

  end

endmodule

//---------------------Simple Test bench ------------------

module tb_ham_dec ();

  reg         [11:0] i_data;
  wire        [7:0]  o_data;
  input              i_clk;



endmodule  




