//
// -----------CLASS BASED TEST BENCH -------
//      
//           --- DUAL PORT RAM------
//
//
//
//




// Declared the package so as to put the necessory data that can be imported to the test bench 
 
 package dual_ram;
  
   parameter DATA_WIDTH = 8, ADDR_WIDTH =3,READ_LATENCY =3, WRITE_LATENCY =3;



 endpackage






import dual_ram::*;


// It sits between the driver and dut as well as the dut and monitor 

 interface dual_inf ();
 
   logic  [DATA_WIDTH-1:0] i_dina;
   logic  [ADDR_WIDTH-1:0] i_addra;
   logic                   i_ena;
   logic                   i_clka ; 
   logic                   i_wea;
   logic  [DATA_WIDTH-1:0] i_dinb;
   logic  [ADDR_WIDTH-1:0] i_addrb;
   logic                   i_enb;
   logic                   i_clkb;
   logic                   i_web;
   logic  [DATA_WIDTH-1:0] o_douta;
   logic  [DATA_WIDTH-1:0] o_doutb;

 endinterface 


// Transaction Class  which is resposible for the greneration of the Rendom stimuls responsible for the driving the inputs for the DUT


class  transction ;

 randc  bit [DATA_WIDTH-1:0] i_dina;
 randc  bit [ADDR_WIDTH-1:0] i_addra;
 randc  bit                  i_ena;
 randc  bit                  i_wea;
 randc  bit [DATA_WIDTH-1:0] i_dinb;
 randc  bit [ADDR_WIDTH-1:0] i_addrb;
 randc  bit                  i_enb; 
 randc  bit                  i_web;
        bit [DATA_WIDTH-1:0] o_douta;
        bit [DATA_WIDTH-1:0] o_doutb;
  
   function transction copy();
      copy=new();
	  copy.i_dina  = this.i_dina;
	  copy.i_addra = this.i_addra;
	  copy.i_ena   = this.i_en; 
      copy.i_wea   = this.i_wea;
      copy.i_dinb  = this.i_dinb;
      copy.i_addrb = this.i_addrb;
      copy.i_enb   = this.i_enb; 
      copy.i_web   = this.i_web;
      copy.o_dout  = this.o_douta;
      copy.o_dout  = this.o_doutb;
   endfunction

  constraint a1 {
                if(i_addra== i_addrb)
               { 
			     !((i_wea==1'b1) -> ( i_web));
				 !((i_web==1'b1) ->  (i_wea));
			   }
			   }
  			 
endclass

// Class Generator which is responsible for the Generating the random Stimuls for the input and sending it to the  drivers

class generator;

  transction t;
  mailbox mbx;
  event done;

  function new(mailbox mbx);
    this.mbx=mbx;
  endfunction


  task run();
	 t=new();
     for (int i=0;i<20;i++)
	 begin
	   t.randomize();
	   mbx.put(t);
	   $display("[GEN] : Data sent to drivers");
	 end
	  @(done);
	  #10;
  endtask


endclass


// Class  Drivers that are Responsible for Recieve the data from the monitor and sent the data to the interface 


class  drivers;
 
  transction t;
  virtual  dual_inf vif ;
  mailbox mbx;
  event done;
  function new(mailbox mbx);
   this.mbx=mbx;
  endfunction 

  task run ();
    t=new();
    forever begin
	  mbx.get(t);
	  vif.i_dina  =t.i_dina;
      vif.i_addra =t.i_addra;
      vif.i_ena   =t.i_ena;
      vif.i_wea   =t.i_wea;
      vif.i_dinb  =t.i_dinb;
      vif.i_addrb =t.i_addrb;
      vif.i_enb   =t.i_enb;
      vif.i_web   =t.i_web;
	  $display("[DRV] Triggered Interface"); 
	  ->done;
	  repeat(2) (posedge i_clka);
	end
  endtask 

endclass



// class Monitor it is responsible for the Recieving the Data from the  Virtual interface and transmitting to the Scoreboard  

class monitor ;
   
  virtual  dual_inf vif ;
  transcar
  mailbox mbx;
  function new(mailbox mbx);
   this.mbx=mbx;
  endfunction 
  task run();
    t=new();
	forever begin
      t.i_dina  = vif.i_dina;
      t.i_addra = vif.i_addra;
      t.i_ena   = vif.i_ena;
      t.i_wea   = vif.i_wea;
      t.i_dinb  = vif.i_dinb;
      t.i_addrb = vif.i_addrb;
      t.i_enb   = vif.i_enb;
      t.i_web   = vif.i_web;
	  t.o_douta = vif.o_douta;
	  t.o_doutb = vif.o_doutb;
	  mbx.put(t);
	  $display("[MON]: Data sent to score board ");
	  repeat (2) (posedge i_clka);
	  end
  endtask 
endclass



class scoreboard;
 mailbox mbx;
 transction t;
 function new(mailbox mbx);
   this.mbx=mbx;
  endfunction 
  task run();
    t=new();
	forever begin
	  mbx.get(t);
	  $display("[SCO]: Data recieved from the monitor ");
	  repeat (2) (posedge i_clka);
	end
  endtask
 
  
endclass

class evironment;
  generator   gen;
  drivers     drv;
  monitor     mon;
  scoreboard  sco;
  virtual  dual_inf vif ;
  mailbox gd_mbx;
  mailbox ms_mbx;
  event done_gd;

  function new(mailbox gd_mbx, mailbox ms_mbx);
    this.gd_mbx = gd_mbx;
	this.ms_mbx = ms_mbx;
	gen         = new(gd_mbx);
	drv         = new(gd_mbx);
	mon         = new(ms_mbx);
	sco         = new(ms_mbx);
	gen.done    =done_gd

  endfunction




endclass


 
