/*
 
  ******************* Hamming decoder*********************
 
  Inputs : i_data Encoded Signal i.e of the size 12 bit as it was Developed

  Outputs : o_data Original Signals of the Data Type it there is the error That will be co



*/


module ham_dec (
  
  input       [11:0] i_data,
  input              i_clk,
  output  reg  [7:0]  o_data
  
 );
   // Syndrome Input 

  reg [3:0] data_sy;

  always @(posedge i_clk)
  begin

    data_sy [0] =i_data[0]^ i_data[2]^i_data[4]^i_data[6]^i_data[8]^i_data[10];
  
    data_sy [1] =i_data[1]^ i_data[2]^i_data[5]^i_data[6]^i_data[9]^i_data[10];
  
    data_sy [2] =i_data[3]^ i_data[4]^i_data[5]^i_data[6]^i_data[11];
  
    data_sy [3] =i_data[7]^ i_data[8]^i_data[9]^i_data[10]^i_data[11];
  
  end
 
  always @(posedge i_clk)
  begin
  if (data_sy >= 'b1 )
  begin
     case(data_sy)        //based on syndrome error is calculated    
               4'b0001:
                 o_data<={i_data[11:8],i_data[6:4],i_data[2]};
               4'b0010:
                 o_data<={i_data[11:8],i_data[6:4],i_data[2]};
               4'b0011:
                 o_data<={i_data[11:8],i_data[6:4],!i_data[2]};
               4'b0100:
                 o_data<={i_data[11:8],i_data[6:4],i_data[2]};
               4'b0101:
                 o_data<={i_data[11:8],i_data[6:5],!i_data[4],i_data[2]};
               4'b0110:
                 o_data<={i_data[11:8],i_data[6],!i_data[5],i_data[4],i_data[2]};
               4'b0111:
                 o_data<={i_data[11:8],!i_data[6],i_data[5:4],i_data[2]};
               4'b1000:
                 o_data<={i_data[11:8],i_data[6:4],i_data[2]};
               4'b1001:
                 o_data<={i_data[11:9],!i_data[8],i_data[6:4],i_data[2]};
               4'b1010:
                 o_data<={i_data[11:10],!i_data[9],i_data[8],i_data[6:4],i_data[2]};
               4'b1011:
                 o_data<={i_data[11],!i_data[10],i_data[9:8],i_data[6:4],i_data[2]};
               4'b1100:
              o_data<={!i_data[11],i_data[10:8],i_data[6:4],i_data[2]};
     endcase
    
  end
  else 
    o_data            <= {i_data[11:8],i_data[6:4],i_data[2]};

  end

endmodule

//---------------------Simple Test bench ------------------

module tb_ham_dec ();

  reg  [11:0] i_data;
  wire [7:0]  o_data;
  reg         i_clk;
 
  ham_dec  dut (
  
   . i_data(i_data),
   . o_data(o_data),
   . i_clk (i_clk) 
  );

  initial
    i_clk =1'b0;

  always #5 i_clk = ! i_clk;
 
  initial begin
    #10;
    i_data=12'b101001001100;//10101010
    #10;
     i_data=12'b101111001100;//10101010

  end
  
  initial begin
    #500;
    $finish();
  end               

  
endmodule  


