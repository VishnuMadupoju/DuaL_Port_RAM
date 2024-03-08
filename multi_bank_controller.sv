///
//
// ---------------------MULTI BANK MEMORY DESIGN---------------------
//       
//    Inputs  :   1 set --> Parameterized bit i_dina, Parameterized bit i_addra, i_ena, i_wea
//                2 set --> Parameterized bit i_dinb, Parameterized bit i_addrb, i_enb, i_web
//                3     --> No of blocks that are parameterid that are needed to be initilized 
//
//    Outputs :   1 set --> Parameterized bit o_douta
//                2 set --> Parameterized bit o_doutb
//
//
// ------------------------  General Operation-----------------------
//
//      1.This module implements a dual-port RAM that allows simultaneous read and write operations from two independent ports (Port A and Port B).
//    
//      2.The module uses parameters to configure the address and data bus widths, as well as the read and write latencies.
//    
//      3. When the i_ena , i_enb and the i_wea, i_web, is high the write operations wil be fallowed 
//    
//      4. When the i_ena , i_enb  is hign and the i_wea, i_web, is low the read operations wil be fallowed  
//    
//      5. The module ensures that only one write operation can occur on the same address at a given time, even from different ports.
//    
//      6.  The read operation from each port outputs the data from the memory with the specified read latency.
//    
// -------------------------- Latency Operation  --------------------
//    
//      1. Read and Write Latency  operation is produced by using the Parametarized Shift Registers in this Code
//      
//      2. Internal registers are used to pipeline the data and handle the read and write latencies 
//
// --------------------------Operation of the Multi Bank -----------
//
//      1. The paramter of the number of the banks that was given gives the no of banks that has to be initilizied
//       
//      2. It Gives the size that was needed to create the memory that was Required 
//
//  -------------------- Version  0.5------------------------------------
//
//

 module multi_bank_controller # (parameter ADDR_WIDTH = 12 ,DATA_WIDTH =8, READ_LATENCY =3 ,WRITE_LATENCY =3, BANK_NO=4 )(

   input         [DATA_WIDTH-1:0] i_dina,
   input         [ADDR_WIDTH-1:0] i_addra,
   input                          i_ena,
   input                          i_clka , 
   input                          i_wea,
   input         [DATA_WIDTH-1:0] i_dinb,
   input         [ADDR_WIDTH-1:0] i_addrb,
   input                          i_enb,
   input                          i_clkb,
   input                          i_web,
   output logic  [DATA_WIDTH-1:0] o_douta,
   output logic  [DATA_WIDTH-1:0] o_doutb
   
                 );


// Declaring The Internal Varables for the usage of the generator Block 

 reg  [3:0] i_ena_reg ;
 reg  [3:0] i_wea_reg ;
 reg  [3:0] i_enb_reg ;
 reg  [3:0] i_web_reg ;


//----------------------REPLECATION GENERATION BLOCK----------------------------

// Initiation of the memory block that means that it generate the no of  instatations of the banks that was providing the number of banks 

// it will Replica of the Dual Port RAMs that was Fixed sizes defined by the BANK_NO 

   genvar g;

   generate 

     for (g=0 ; g <BANK_NO;g=g+1 )
      begin
          dual_port_ram # ( ADDR_WIDTH -2 ,DATA_WIDTH , READ_LATENCY ,WRITE_LATENCY  ) dut (
         
           .i_dina(i_dina),
           .i_addra(i_addra[ADDR_WIDTH-3:0]),
           .i_ena(i_ena_reg [g]),
           .i_clka(i_clka) , 
           .i_wea(i_wea_reg[g]),
           .i_dinb(i_dinb),
           .i_addrb(i_addrb),
           .i_enb(i_enb_reg[g]),
           .i_clkb(i_clkb),
           .i_web(i_web_reg [g]),
           .o_douta(o_douta),
           .o_doutb (o_doutb)
           
         );
      end  
  endgenerate

// ---------------- BANK ROUTING  BLOCK -----------------
   
     enum bit [1:0]{Bank0,Bank1,Bank2,Bank3} Bank_no ;

//   Always Block for the Port A allocations 
// when the addrs of the port a the logic will put the route the i_en and i_we signals to the specific memory that was destined   
   always_comb
   begin
     case({i_addra[ADDR_WIDTH-1], i_addra[ADDR_WIDTH-2]} )// It will check the 12 and 11 bits of the given Port A Address
        Bank0: begin
                 i_ena_reg[0] =i_ena; // When the 12 and 11 bit of addres a  is 00 it routes to the Bank0 memory of the address port a  
                 i_wea_reg[0] =i_wea;
               end
        Bank1: begin
                 i_ena_reg[1] =i_ena;
                 i_wea_reg[1] =i_wea;
               end
        Bank2: begin
                 i_ena_reg[2] =i_ena;
                 i_wea_reg[2] =i_wea;
               end
        Bank3: begin
                 i_ena_reg[3] =i_ena;
                 i_wea_reg[3] =i_wea;
               end
     endcase
   end
  

//   Always Block for the Port B allocations 
// when the addrs of the port a the logic will put the route the i_en and i_we signals to the specific memory that was destined   
   always_comb
   begin
     case({i_addrb[ADDR_WIDTH-1], i_addrb[ADDR_WIDTH-2]} )// It will check the 12 and 11 bits of the given Port B Address
        Bank0: begin
                 i_enb_reg[0] =i_enb; // When the 12 and 11 bit of addres a  is 00 it routes to the Bank0 memory of the address port a  
                 i_web_reg[0] =i_web;
               end        
        Bank1: begin      
                 i_enb_reg[1] =i_enb;
                 i_web_reg[1] =i_web;
               end        
        Bank2: begin      
                 i_enb_reg[2] =i_enb;
                 i_web_reg[2] =i_web;
               end        
        Bank3: begin      
                 i_enb_reg[3] =i_enb;
                 i_web_reg[3] =i_web;
               end
     endcase
   end
    
 endmodule










//--------------------MODULE BASED TEST BENCH ---------------------------

module tb_ multi_bank_controller #(parameter ADDR_WIDTH = 12 ,DATA_WIDTH =8, READ_LATENCY =3 ,WRITE_LATENCY =3, BANK_NO=4 )() ;

   reg         [DATA_WIDTH-1:0] i_dina;
   reg         [ADDR_WIDTH-1:0] i_addra;
   reg                          i_ena;
   reg                          i_clka ; 
   reg                          i_wea;
   reg         [DATA_WIDTH-1:0] i_dinb;
   reg         [ADDR_WIDTH-1:0] i_addrb;
   reg                          i_enb;
   reg                          i_clkb;
   reg                          i_web;
   wire        [DATA_WIDTH-1:0] o_douta;
   wire        [DATA_WIDTH-1:0] o_doutb;

 multi_bank_controller # ( ADDR_WIDTH  ,DATA_WIDTH , READ_LATENCY ,WRITE_LATENCY , BANK_NO ) dut (

   .i_dina(i_dina),
   .i_addra(i_addra),
   .i_ena(i_ena),
   .i_clka (i_clka), 
   .i_wea(i_wea),
   .i_dinb(i_dinb),
   .i_addrb(i_addrb),
   .i_enb(i_enb),
   .i_clkb(i_clkb),
   .i_web(i_web),
   .o_douta(o_douta),
   .o_doutb(o_doutb)
                         );

 endmodule
