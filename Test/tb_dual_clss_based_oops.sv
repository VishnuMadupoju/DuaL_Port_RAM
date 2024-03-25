//     
//
//--------Module Test Bench-------- 
// 
//  --> It is also initiated the Environment and Interface 
//  --> Passed down the Mailboxes and to the Environment 
//  --> Connected the interface 
//
//      Version 0.5 

`ifndef  TB_TOP
`define  TB_TOP




//`include "interface_inf.sv"


import  dual_port_pkg ::*;


module tb_dual_clss_based_oops_1();

  evironment env;

  mailbox #(transction)gd_mbx, ms_mbx ;

  dual_inf vif();

  dual_port_ram_10 # (ADDR_WIDTH  ,DATA_WIDTH , READ_LATENCY  ,WRITE_LATENCY  ) dut(
   
    .i_dina(vif.dina),
    .i_addra(vif.addra),
    .i_ena(vif.ena),
    .i_clka(vif.clka) , 
    .i_wea(vif.wea),
    .i_dinb(vif.dinb),
    .i_addrb(vif.addrb),
    .i_enb(vif.enb),
    .i_clkb(vif.clkb),
    .i_web(vif.web),
    .o_douta(vif.douta),
    .o_doutb(vif.doutb)
    
   );

  always # 5 vif.clka = !vif.clka;
  
  always # 5 vif.clkb= !vif. clkb;

  initial begin
    vif.clka = 1'b0;
	vif.clkb = 1'b0;
  end


  initial begin
   gd_mbx  = new();
   ms_mbx  = new();
   env     = new(gd_mbx,ms_mbx);
   env.vif = vif;
   env.run();
  end


  initial begin
    #500;
	$finish();

  end


endmodule

`endif //TB_TOP

 

