//
// ------------TRANSCTION CLASS------------
//  Transaction Class  which is resposible for the greneration of the Rendom stimuls responsible for the driving the inputs for the DUT
//
//
//
//  Version 0.5
//

`ifndef  TRANSCTION
`define  TRANSCTION

import  dual_port_pkg ::*;

class transction ;

  rand  bit   [DATA_WIDTH-1:0] dina;
  rand  bit   [ADDR_WIDTH-1:0] addra;
  rand  bit                    ena;
  rand  bit                    wea;
  rand  bit   [DATA_WIDTH-1:0] dinb;
  rand  bit   [ADDR_WIDTH-1:0] addrb;
  rand  bit                    enb; 
  rand  bit                    web;
        logic [DATA_WIDTH-1:0] douta;
        logic [DATA_WIDTH-1:0] doutb;
   
    function transction copy();
      copy=new();
 	  copy.dina  = this.dina;
 	  copy.addra = this.addra;
 	  copy.ena   = this.ena; 
      copy.wea   = this.wea;
      copy.dinb  = this.dinb;
      copy.addrb = this.addrb;
      copy.enb   = this.enb; 
      copy.web   = this.web;
      copy.douta = this.douta;
      copy.doutb = this.doutb;
    endfunction
 
   
 // When the address of the Port A and Port B are Same the Writing operation from the both the ports is unpredictable
 // Similarly while reading from Same address and writing at Same  address location at same clock pulse from different ports gives us previous Data

   constraint fault_override {
                 if(addra== addrb)
                { 
 			     !((wea==1'b1) -> ( web));
 				 !((web==1'b1) ->  (wea));
 			   }
 			   }
  	  			 
endclass

 `endif // TRANSCTION

