///
//
// ---------------------MULTI BANK MEMORY DESIGN--------------------
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
//  ------------------------   Version  0.5  -----------------------------------
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

 // Declaring the reg internally for the ports that has to be assigned to the outputs to the Wire type

 wire [3:0]  o_douta_wire;
 
 wire [3:0]  o_doutb_wire;


//----------------------REPLECATION GENERATION BLOCK----------------------------

// Initiation of the memory block that means that it generate the no of  instatations of the banks that was providing the number of banks 

// it will Replica of the Dual Port RAMs that was Fixed sizes defined by the BANK_NO 

   genvar g;

   generate 

     for (g=0 ; g <4;g=g+1 )
      begin:RAM_GEN
          dual_port_ram # ( ADDR_WIDTH -2 ,DATA_WIDTH , READ_LATENCY ,WRITE_LATENCY  ) Dual_Ram (
         
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
           .o_douta(o_douta_wire[g]),
           .o_doutb (o_doutb_wire[g])
           
         );
      end  
  endgenerate

// ---------------- BANK ROUTING  BLOCK [DECODER] -----------------
   
     enum bit [1:0]{Bank0,Bank1,Bank2,Bank3} Bank_no ;

//   Always Block for the Port A allocations 
// when the addrs of the port a the logic will put the route the i_en and i_we signals to the specific memory that was destined   
   always_comb
   begin
     case({i_addra[ADDR_WIDTH-1], i_addra[ADDR_WIDTH-2]} )// It will check the 12 and 11 bits of the given Port A Address
        Bank0: begin
                 i_ena_reg[0] =i_ena; // When the 12 and 11 bit of addres a  is 00 it routes to the Bank0 memory of the address port a  
                 i_wea_reg[0] =i_wea;
				 o_douta      =o_douta_wire[0];
               end
        Bank1: begin
                 i_ena_reg[1] =i_ena;
                 i_wea_reg[1] =i_wea;
                 o_douta      =o_douta_wire[1];
               end
        Bank2: begin
                 i_ena_reg[2] =i_ena;
                 i_wea_reg[2] =i_wea;
				 o_douta      =o_douta_wire[2];
               end
        Bank3: begin
                 i_ena_reg[3] =i_ena;
                 i_wea_reg[3] =i_wea;
				 o_douta      =o_douta_wire[3];

               end
     endcase
   end
  

//   Always Block for the Port B allocations 
// when the addrs of the port a the logic will put the route the i_en and i_we signals to the specific memory that was destined   
   always_comb
   begin
     case({i_addrb[ADDR_WIDTH-1], i_addrb[ADDR_WIDTH-2]} )// It will check the 12 and 11 bits of the given Port B Address
        Bank0: begin
                 i_enb_reg[0] =i_enb; // When the 12 and 11 bit of addres a  is 00 it routes to the Bank0 memory of the address port b 
                 i_web_reg[0] =i_web;
				 o_doutb      = o_doutb_wire[0];
               end        
        Bank1: begin      
                 i_enb_reg[1] =i_enb;
                 i_web_reg[1] =i_web;
				 o_doutb      = o_doutb_wire[1];
               end        
        Bank2: begin      
                 i_enb_reg[2] =i_enb;
                 i_web_reg[2] =i_web;
				 o_doutb      = o_doutb_wire[2];
               end        
        Bank3: begin      
                 i_enb_reg[3] =i_enb;
                 i_web_reg[3] =i_web;
				 o_doutb      =o_doutb_wire[3];

               end
     endcase
   end    
 endmodule






//--------------------MODULE BASED TEST BENCH ---------------------------

module tb_multi_bank_controller #(parameter ADDR_WIDTH = 12 ,DATA_WIDTH =8, READ_LATENCY =3 ,WRITE_LATENCY =3, BANK_NO=4 )() ;

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


 // -----------CLOCKING INITLIZATION AND GENERATION BLOCK-----------------------

   initial begin
     i_clka=1'b0;
	 i_clkb=1'b0;
   end
   always #5 i_clka= !i_clka;

   always #5 i_clkb=!i_clkb;



   initial begin
     test_porta();
	 #30;
     test_portb(); 
   end




//--------------TASK BLOCK OF THE TEST BENCH TO EVALVATE THE SET OF SEQUENCE FOR THE A & B PORTS--------------------


// Declared the task to generate teh Random stimuls and give it to the random adderss and data  of the port a 
 
  task  test_porta(); 
   i_dina= $urandom();
   i_addra=$urandom_range(0,4096);     // Range is Randomized since the no of address loactions are fixed and  depend on the addrss width 
   repeat(4) @( posedge (i_clka));
   i_ena =1'b1;
   i_wea =1'b1;

   //$display("Data Written into the memory of the adders[=%0d] and data[=%0d] ",i_addra ,i_dina, );
   repeat(5) @( posedge (i_clka));
   i_ena =1'b1;
   i_wea =1'b0;
  // $display("Data Read from the memory is %0d",dut.o_douta );  
   endtask 
 
// Declared the task to generate teh Random stimuls and give it to the random adderss and data  of the port b 

   task test_portb();  
     i_dinb= $urandom();
     i_addrb= $urandom_range(0,4096 );// Range is Randomized since the no of address loactions are fixed and depend on the addrss width
     repeat(4) @( posedge (i_clkb));
     i_enb =1'b1;
     i_web =1'b1;
   //   $display("Data Written into the memory of the adders[=%0d] and data[=%0d] ",i_dinb, i_addrb );
     repeat(5) @( posedge (i_clkb));
     i_enb =1'b1;
     i_web =1'b0; 
  // $display("Data Read from the memory is %0d",dut.o_doutb );
     endtask 
 
 
 initial begin
  # 500 ;
  $finish();
 end



 endmodule
