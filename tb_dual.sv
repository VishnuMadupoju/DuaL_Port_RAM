/*

    *****SAMPLE TEST BENCH FOR THE DUAL PORT RAM******

  


*/



module tb_dual # (parameter ADDR_WIDTH = 5 ,DATA_WIDTH =32, READ_LANTENCY =3 ,WRITE_LANTENCY =3 )();
 
  reg        [DATA_WIDTH-1:0] i_dina;
  reg        [ADDR_WIDTH-1:0] i_addra;
  reg                         i_ena;
  reg                         i_clka;  
  reg                         i_wea;
  reg        [DATA_WIDTH-1:0] i_dinb;
  reg        [ADDR_WIDTH-1:0] i_addrb;
  reg                         i_enb;
  reg                         i_clkb;
  reg                         i_web;
  wire       [DATA_WIDTH-1:0] o_douta;
  wire       [DATA_WIDTH-1:0] o_doutb;
   
 dual_port_ram # ( ADDR_WIDTH  ,DATA_WIDTH , READ_LANTENCY  ,WRITE_LANTENCY ) dut (
 
  .i_dina(i_dina),
  .i_addra(i_addra),
  .i_ena(i_ena),
  .i_clka(i_clka), 
  .i_wea(i_wea),
  .i_dinb(i_dinb),
  .i_addrb(i_addrb),
  .i_enb(i_enb),
  .i_clkb(i_clkb),
  .i_web(i_web),
  . o_douta(o_douta),
  . o_doutb(o_doutb)
   
 );

  

  initial begin
    i_clka =1'b0;
    i_clkb =1'b0;
  end
  always #5 i_clka = !i_clka;

  always #5 i_clkb = !i_clkb;

  
  initial begin 
   i_dina= 8'h12;
   i_addra= 3'b001;
   repeat(2) @( posedge (i_clka));
   i_ena =1'b1;
   i_wea =1'b1;
   repeat(5) @( posedge (i_clka));
   i_ena =1'b1;
   i_wea =1'b0;
  end
 
  /*initial begin  
   i_dinb= 8'h13;
   i_addrb= 3'b011;
   repeat(2) @( posedge (i_clkb));
   i_enb =1'b1;
   i_web =1'b1;
   repeat(5) @( posedge (i_clkb));
   i_enb =1'b1;
   i_web =1'b0;
  end 
 */
 
 initial begin
  # 500 ;
  $finish();
 end

endmodule
