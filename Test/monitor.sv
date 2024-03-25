//
//
// ---------------- CLASS MONITOR------------------
//
//
//
//
//
//
// class Monitor it is responsible for the Recieving the Data from the  Virtual interface and transmitting to the Scoreboard 



`ifndef  MONITOR
`define  MONITOR




import  dual_port_pkg ::*;

class monitor ;
   
  virtual  dual_inf vif ;
  transction t;
  mailbox #(transction)mbx;
  function new(mailbox #(transction)mbx);
   this.mbx=mbx;
  endfunction 
  task run();
    t=new();
	forever begin
      t.dina  = vif.dina;
      t.addra = vif.addra;
      t.ena   = vif.ena;
      t.wea   = vif.wea;
      t.dinb  = vif.dinb;
      t.addrb = vif.addrb;
      t.enb   = vif.enb;
      t.web   = vif.web;
	  t.douta = vif.douta;
	  t.doutb = vif.doutb;
	  mbx.put(t);
      $display("[MON]: Data sent to score board  time = %0t",$time);
	// $display ("[MON]: Values to the ScoreBoard are i_dina:%0d  ,o_douta =%0d ,o_doutb = %0d ",vif.i_dina,vif.o_douta, vif.o_doutb  );
	  repeat (1) @ (posedge vif.clka);
	  end
  endtask 
endclass

`endif   // MONITOR

