//
//
// -----------  ENVIRONMENT CLASS ----------
//
//
// It was used to initiate all generator , Drivers , monitor and Scoreborad and Interface 
// It is also used for connecting all the mail boxes and events and Interface



`ifndef ENIRONMENT

`define ENIRONMENT


import  dual_port_pkg ::*;

class evironment;
  generator   gen;
  drivers     drv;
  monitor     mon;
  scoreboard  sco;
  virtual  dual_inf vif ;
  mailbox #(transction)gd_mbx;
  mailbox #(transction)ms_mbx;
  event done_gd;

  function new(mailbox #(transction) gd_mbx, mailbox #(transction) ms_mbx);
    this.gd_mbx = gd_mbx;
	this.ms_mbx = ms_mbx;
	gen         = new(gd_mbx);     // Connecting all The mail boxes
	drv         = new(gd_mbx);
	mon         = new(ms_mbx);
	sco         = new(ms_mbx);
  endfunction
   
  task run ();
    gen.done = done_gd;            // Connecting all events 
    drv.done = done_gd; 
    drv.vif  = vif;                // Connecting all the Interface 
    mon.vif  = vif;

	fork 
      gen.run();
	  drv.run();
	  mon.run();
	  sco.run();
	join 
  endtask 


endclass

`endif // ENVIRONMENT
