//
//
//    
//---------------CLASS SCOREBOARD ------------
//
//
//
//
// It is responsible for the Checking  the Functionality of the Design Under Test
//
//      Version 0.5

 `ifndef SCOREBOARD
 `define SCOREBOARD

import  dual_port_pkg ::*;


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
      $display("[SCO] Data Recieved to the Scoreborad ");       
       // Port A update 
      if (t.ena)
     	begin
     	  if(t.wea)
     	    ref_model[t.addra] <=  #(WRITE_LATENCY*TIME_PERIOD) t.dina;

          else 
         	 temp_a_out        <= #(READ_LATENCY *TIME_PERIOD) ref_model[t.addra] ;
     		 
        end
      if (t.enb)         // port B update
        begin
     	  if(t.web)
     	    ref_model[t.addrb] <= #(WRITE_LATENCY*TIME_PERIOD) t.dinb;
        else 
            temp_b_out         <=  #(READ_LATENCY*TIME_PERIOD)  ref_model[t.addrb] ;
      end
   
  // ----------------------SCORE BOARD CAMPARISION BLOCK -----------------

  // --------------------- PORT A SCORE BOARD -----------------------------

    $display ("[SCO]: [OUT] Data values written to the ref_model is %0p",ref_model);
	  fork 
      if (t.ena)
      begin
     	if(t.wea==1'b0)
     	  begin
		    #(READ_LATENCY *TIME_PERIOD) ;
     	    if(t.douta ===temp_a_out) begin
     		   $display("[SCO]TEST PASSED  at Port A time = %0t t.out_a =%0d  and temp_a_out ", $time,t.douta, temp_a_out);
			   $display ("[SCO]: Data values written to the ref_model is %0p",ref_model);
			 end
     		else begin 
     		   $display("[SCO]TEST FAILED at  POrt A time =%0t t.out_a =%0d  and temp_a_out ", $time,t.douta, temp_a_out);
			   $display ("[SCO]: Data values written to the ref_model is %0p",ref_model);
			end
     	    end
     		    
        end



  //---------------------- PORT B SCORE BOARD------------------------------- 


   if (t.enb)
      begin
     	if(t.web==1'b0)
     	 begin
		    #(READ_LATENCY *TIME_PERIOD) ;
     	   if(t.doutb ===temp_b_out) begin
     		 $display("[SCO]TEST PASSED  at Port B time = %0t t.out_b =%0d  and temp_b_out ", $time,t.doutb, temp_b_out);
			 $display ("[SCO]: Data values written to the ref_model is %0p",ref_model);
		   end
     	   else begin
     		 $display("[SCO]TEST FAILED at  Port  B time =%0t t.out_b =%0d  and temp_b_out ", $time,t.doutb, temp_b_out);
			 $display ("[SCO]: Data values written to the ref_model is %0p",ref_model);
		   end
     	   end		    
        end

   
    join_none
	end
   endtask
   
endclass
 

  `endif // SCOREBOARD

