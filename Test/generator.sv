//
//
//
//
// --------------------CLASS GENERATOR ---------------------
//
//
//
//
//
//
//  Class Generator which is responsible for the Generating the random Stimuls for the input and sending it to the  drivers



`ifndef GENERATOR

`define GENERATOR


import  dual_port_pkg ::*;

class generator;

  transction t;
  mailbox #(transction) mbx ;
  event done;

  function new( mailbox #(transction)  mbx );
    this.mbx=mbx;
  endfunction


  task run();

    for (int i=0;i<100;i++)
	begin
	t=new();
	  t.randomize();
	  mbx.put(t);
	  $display("[GEN] : Data sent to drivers");
	  @(done);
	end
	 #10;
  endtask


endclass


`endif// GENERATOR
