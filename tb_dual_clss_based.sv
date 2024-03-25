//
// -----------CLASS BASED TEST BENCH -------
//      
//           --- DUAL PORT RAM------
//  
//
//
//
//  ---------- Version 0.5------------------




// Declared the package so as to put the necessory data that can be imported to the test bench 
 
 package dual_ram;
  
   parameter DATA_WIDTH = 8, ADDR_WIDTH =3,READ_LATENCY =1, WRITE_LATENCY =1,TIME_PERIOD=10;

 endpackage




import dual_ram::*;



// It connects the signal based components to class based components
// It sits between the driver and dut as well as the dut and monitor 

/* interface dual_inf ();
 
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

 endinterface */


// Transaction Class  which is resposible for the greneration of the Rendom stimuls responsible for the driving the inputs for the DUT

// Don't use randc unless that is the requirement;
// Reason: randc usage makes the tool to store all generated values in memory, 

//class members will no thave directions as they are not ports but they are members
class transction ;

  rand  bit   [DATA_WIDTH-1:0] i_dina;
  rand  bit   [ADDR_WIDTH-1:0] i_addra;
  rand  bit                    i_ena;
  rand  bit                    i_wea;
  rand  bit   [DATA_WIDTH-1:0] i_dinb;
  rand  bit   [ADDR_WIDTH-1:0] i_addrb;
  rand  bit                    i_enb; 
  rand  bit                    i_web;
        logic [DATA_WIDTH-1:0] o_douta;
        logic [DATA_WIDTH-1:0] o_doutb;
   
    function transction copy();
      copy=new();
 	  copy.i_dina  = this.i_dina;
 	  copy.i_addra = this.i_addra;
 	  copy.i_ena   = this.i_ena; 
      copy.i_wea   = this.i_wea;
      copy.i_dinb  = this.i_dinb;
      copy.i_addrb = this.i_addrb;
      copy.i_enb   = this.i_enb; 
      copy.i_web   = this.i_web;
      copy.o_douta = this.o_douta;
      copy.o_doutb = this.o_doutb;
    endfunction
 
   // give a meaningful name and explanation
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
  mailbox #(transction) mbx ;
  event done;

  function new( mailbox #(transction)  mbx );
    this.mbx=mbx;
  endfunction


  task run();
	t=new();
    for (int i=0;i<100;i++)
	begin
	  t.randomize();
	  mbx.put(t);
	  $display("[GEN] : Data sent to drivers");
	  @(done);
	end
	 #10;
  endtask


endclass


// Class  Drivers that are Responsible for Recieve the data from the monitor and sent the data to the interface 


class  drivers;
 
  transction t;
  virtual  dual_inf vif ;
  mailbox #(transction)mbx;
  event done;
  function new(mailbox #(transction) mbx);
   this.mbx    = mbx;
  endfunction 

  // the logic written in the forever loop has 
  // repeat (4) @ posedge vif.i_clka which means the enable, addr, and data 
  // driven onto the design for 4 consecutive cloks; effectively 4 packets driven onto the DUT 
  // for every packet that is received from Sequencer
  //
  task run ();
    t=new();
    forever begin
	  mbx.get(t);
	 //@(posedge vif.i_clka);
	  vif.i_dina  = t.i_dina;
      vif.i_addra = t.i_addra;
      vif.i_ena   = t.i_ena;
      vif.i_wea   = t.i_wea;
      vif.i_dinb  = t.i_dinb;
      vif.i_addrb = t.i_addrb;
      vif.i_enb   = t.i_enb;
      vif.i_web   = t.i_web;
	//  $display(" [DRV]: Recieved the Randoamized Value are i_dina:%0d ,i_addra: %0d,i_ena:%0d ,i_wea: %0d,i_dinb:%0d ,i_addrb: %0d ",t.i_dina, t.i_addra, t.i_ena, t.i_wea, t.i_dinb, t.i_addrb); 
//	   $display("[DRV] :Value recieved form the Randoamized Value are i_enb:%0d ,i_web: %0d" ,t.i_enb, t.i_web); 
      $display("[DRV]:Triggered Interface"); 
	  ->done;
	  repeat(1) @(posedge vif.i_clka);
	 // #20;
	end
  endtask 

endclass



// class Monitor it is responsible for the Recieving the Data from the  Virtual interface and transmitting to the Scoreboard  

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
	// $display ("[MON]: Values to the ScoreBoard are i_dina:%0d  ,o_douta =%0d ,o_doutb = %0d ",vif.i_dina,vif.o_douta, vif.o_doutb  );
	  repeat (1) @ (posedge vif.i_clka);
	  end
  endtask 
endclass

// It is responsible for the Checking  the Functionality of the Design Under Test

class scoreboard;
 mailbox #(transction)mbx;
 transction t;

 reg [DATA_WIDTH-1:0] ref_model [2**ADDR_WIDTH-1:0];
 reg [DATA_WIDTH-1:0] temp_a_out,temp_b_out; 

  function new(mailbox #(transction)mbx);
   this.mbx   =mbx; 
  endfunction 
  task  run();
    t=new();
	forever begin
	  mbx.get(t);
	   $display("[SCO]: Data recieved from the monitor Values are at wea=%0d , ena=%0d, enb=%0d, web=%0d ,wea=%0d, dina =%0d ,dinb =%0d ,adrra =%0d ,addrb =%0d time=%0t", t.i_ena, t.i_enb ,t.i_wea, t.i_web,t.i_wea,t.i_dina, t.i_dinb,t.i_addra,t.i_addrb,$time);
	    $display ("[SCO]: Data values written to the ref_model is %0p",ref_model);
 
	  // Port A update 
	    if (t.i_ena)
		begin
		   if(t.i_wea)
		   begin
		     ref_model[t.i_addra] <=# (WRITE_LATENCY*TIME_PERIOD)t.i_dina;
			 $display ("[SCO]: Data values written to the ref_model is %0p",ref_model);
			 end


	       else 
	    	 temp_a_out           <= #(READ_LATENCY *TIME_PERIOD) ref_model[t.i_addra] ;
			 
	    end
	    if (t.i_enb)         // port B update
	    begin
		  if(t.i_web)
		  begin
		     ref_model[t.i_addrb] <= #(WRITE_LATENCY*TIME_PERIOD) t.i_dinb;
			 $display ("[SCO]: Data values written to the ref_model is %0p",ref_model);
	      end
	      else 
	        temp_b_out            <= #(READ_LATENCY*TIME_PERIOD)  ref_model[t.i_addrb] ;
	    end
  
 // ----------------------SCORE BOARD CAMPARISION BLOCK -----------------

 // --------------------- PORT A SCORE BOARD -----------------------------

    
        if (t.i_ena)
     	begin
		   if(t.i_wea==1'b0)
		   begin
		       if(t.o_douta ===temp_a_out)
			    $display("[SCO]TEST PASSED  at Port A time = %0t t.out_a =%0d  and temp_a_out ", $time,t.o_douta, temp_a_out);
			 else 
			    $display("[SCO]TEST FAILED at  POrt A time =%0t t.out_a =%0d  and temp_a_out ", $time,t.o_douta, temp_a_out);
		   end
			    
	    end



 //---------------------- PORT B SCORE BOARD------------------------------- 


  if (t.i_enb)
     	begin
		   if(t.i_web==1'b0)
		   begin
		       if(t.o_doutb ===temp_b_out)
			    $display("[SCO]TEST PASSED  at Port B time = %0t t.out_b =%0d  and temp_b_out ", $time,t.o_doutb, temp_b_out);
			 else 
			    $display("[SCO]TEST FAILED at  Port  B time =%0t t.out_b =%0d  and temp_b_out ", $time,t.o_doutb, temp_b_out);
		   end
			    
	    end



	   //   $display("[SCO]: Data recieved from the monitor Values are at wea=%0d , ena=%0d, enb=%0d, web=%0d ,wea=%0d, dina =%0d ,dinb =%0d ,adrra =%0d ,addrb =%0d time=%0t", t.i_ena, t.i_enb ,t.i_wea, t.i_web,t.i_wea,t.i_dina, t.i_dinb,t.i_addra,t.i_addrb,$time);
	 // $display ("[SCO]: Data values written to the ref_model is %0p",ref_model);
 
	end
  endtask
 
  
endclass


// It was used to initiate all generator , Drivers , monitor and Scoreborad and Interface 
// It is also used for connecting all the mail boxes and events and Interface

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


// Module Test Bench 



module tb_dual_clss_based_oops_inter();

  evironment env;

  mailbox #(transction)gd_mbx, ms_mbx ;

  dual_inf vif();

  dual_port_ram_10 # (ADDR_WIDTH  ,DATA_WIDTH , READ_LATENCY  ,WRITE_LATENCY  ) dut(
   
    .i_dina(vif.i_dina),
    .i_addra(vif.i_addra),
    .i_ena(vif.i_ena),
    .i_clka(vif.i_clka) , 
    .i_wea(vif.i_wea),
    .i_dinb(vif.i_dinb),
    .i_addrb(vif.i_addrb),
    .i_enb(vif.i_enb),
    .i_clkb(vif.i_clkb),
    .i_web(vif.i_web),
    .o_douta(vif.o_douta),
    .o_doutb(vif.o_doutb)
    
   );

  always # 5 vif.i_clka = !vif.i_clka;
  
  always # 5 vif.i_clkb= !vif. i_clkb;

  initial begin
    vif.i_clka = 1'b0;
	vif.i_clkb = 1'b0;
  end


  initial begin
   gd_mbx  = new();
   ms_mbx  = new();
   env     = new(gd_mbx,ms_mbx);
   env.vif = vif;
   env.run();
  end


  initial begin
    #300;
	$finish();

  end


endmodule


 
