/*

// Controll Register 

// Inputs : i_CE,i_clk,i_d

// outputs: o_q

// It will allow the out to be canged if only the i_CE is high else the o_q reamains as the same as privious value

*/

module ctrlreg(
  
  input        i_clk,
  input        i_CE,
  input        i_d,
  output reg   o_q 
 
);

  reg q_o = 1'b0;

  always @(posedge i_clk)
  begin
    if(i_CE)
     begin
       q_o <= i_d; 
     end
    else 
    begin
      o_q  <= q_o; 
    end
  end

endmodule
 

///********** Simple Test Bench *******

module tb_CtrlReg();
  
  reg i_clk;
  reg i_CE;
  reg i_d;
  wire o_q;
 
 CtrlReg dut (
  . i_clk(i_clk),
  . i_CE(i_CE),
  . i_d(i_d),
  . o_q(o_q) 
 );
  initial begin
    i_clk=1'b0;
  end
  
  always #5 i_clk=!i_clk;  
  
  initial begin
    #10; 
    i_d=1'b1;
    #10;
    i_CE=1'b1;
    #10;
    i_d=1'b0;
    #10;
    i_CE=1'b0;
    #10;
  end
 initial begin
 #100;
 $finish();
 end
 
endmodule 

