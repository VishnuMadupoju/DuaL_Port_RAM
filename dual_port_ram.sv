/*

       ******************* Dual Port RAM ********************

 Inputs :    1 set --> Parameterized bit i_dina, Parameterized bit i_addra, i_ena, i_wea
             2 set --> Parameterized bit i_dinb, Parameterized bit i_addrb, i_enb, i_web

 Outputs :   1 set --> Parameterized bit o_douta
             2 set --> Parameterized bit o_doutb


       -------------------  General Operation ---------------

  1.This module implements a dual-port RAM that allows simultaneous read and write operations from two independent ports (Port A and Port B).

  2.The module uses parameters to configure the address and data bus widths, as well as the read and write latencies.

  3. When the i_ena , i_enb and the i_wea, i_web, is high the write operations wil be fallowed 

  4. When the i_ena , i_enb  is hign and the i_wea, i_web, is low the read operations wil be fallowed  

  5. The module ensures that only one write operation can occur on the same address at a given time, even from different ports.

  6.  The read operation from each port outputs the data from the memory with the specified read latency.

       ------------------- Latency Operation  ---------------

  1. Read and Write Latency  operation is produced by using the Parametarized Shift Registers in this Code
  
  2. Internal registers are used to pipeline the data and handle the read and write latencies 
 
*/

module dual_port_ram # (parameter ADDR_WIDTH = 3 ,DATA_WIDTH =8, READ_LATENCY =1 ,WRITE_LATENCY =1 )(
 
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
  // Declaring the Memory size to the Parameterized size

  reg [DATA_WIDTH-1:0]  mem [2** ADDR_WIDTH -1:0]; 
  

  
  // Declaring internal register for a to create the delay for the read and write latency

  reg [DATA_WIDTH-1:0] q_a_reg [READ_LATENCY-1:0]; 

  reg [DATA_WIDTH-1:0] q_a_reg_addr [WRITE_LATENCY-1:0]; 
  
  reg [DATA_WIDTH-1:0] q_a_reg_data [WRITE_LATENCY-1:0]; 
   
  reg [1:0] q_a_reg_enable [WRITE_LATENCY-1:0];
  
  reg [1:0] q_a_reg_write  [WRITE_LATENCY-1:0];

 // Declaring internal register for B to create the delay for the read and write latency

  reg [DATA_WIDTH-1:0] q_b_reg [READ_LATENCY-1:0]; 

  reg [DATA_WIDTH-1:0] q_b_reg_addr [WRITE_LATENCY-1:0]; 
  
  reg [DATA_WIDTH-1:0] q_b_reg_data [WRITE_LATENCY-1:0]; 
   
  reg [1:0] q_b_reg_enable [WRITE_LATENCY-1:0];
  
  reg [1:0] q_b_reg_write  [WRITE_LATENCY-1:0];



 // Declaring A task to put you into the Read and write Enable Signals  

    /*task error_injuction  (input bit [11:0] din, input bit [2:0] addr);
      mem [addr] = din;   
    endtask */
   
  
 // logic  for the first port 

  always @(posedge i_clka)
  begin
    if(i_ena)
    begin
      if(i_wea)                          
      begin 
         q_a_reg_addr  [0]   <= i_addra;  //   Capturing Address, Data, and Enable/Write Signals for Write Operation
         q_a_reg_data  [0]   <= i_dina;
         q_a_reg_enable[0]   <= i_ena;
         q_a_reg_write [0]   <= i_wea;
      end
      else
      begin
        q_a_reg[0]          <=  mem[i_addra];//   Capturing  Data, and Enable/Write Signals for Read Operation
        q_a_reg_enable[0]   <= i_ena;
        q_a_reg_write [0]   <= i_wea;
      end 
    end
    else
    begin
       q_a_reg_enable[0]   <= i_ena;
       q_a_reg_write [0]   <= i_wea;  
    end 
  end

 // Port A write logic with added latency by using parameterized Shift registers

  always @( posedge i_clka ) 
  begin
    for (int i = 1; i < WRITE_LATENCY-1; i++)
    begin
      q_a_reg_addr[i]     <= q_a_reg_addr[i-1];
      q_a_reg_data[i]     <= q_a_reg_data[i-1];
      q_a_reg_enable[i]   <= q_a_reg_enable[i-1] ;
      q_a_reg_write [i]   <= q_a_reg_write [i-1] ;   
    end
      mem [ q_a_reg_addr[WRITE_LATENCY-2] ] <= (q_a_reg_enable[WRITE_LATENCY-2]==1'b1 && q_a_reg_write[WRITE_LATENCY-2]==1'b1 )? q_a_reg_data[WRITE_LATENCY-2]: mem [ q_a_reg_addr[WRITE_LATENCY-2] ];   
  end


  

// Port A read logic with the added Latency by by using parameterized Shift registers

always @( posedge i_clka ) 
begin 
  for (int i = 1; i < READ_LATENCY-1; i++)
  begin
    q_a_reg[i]          <= q_a_reg[i-1];
    q_a_reg_enable[i]   <= q_a_reg_enable[i-1] ;
    q_a_reg_write [i]    <= q_a_reg_write [i-1] ;   


  end
    //o_douta    <=  (q_a_reg_enable[READ_LATENCY-2]==1'b1 && q_a_reg_write[READ_LATENCY-2]==1'b0 )? q_a_reg[READ_LATENCY-2] :o_douta ;
    o_douta    <= (q_a_reg_enable[READ_LATENCY-2]==1'b1 && q_a_reg_write[READ_LATENCY-2]==1'b0 )? q_a_reg[READ_LATENCY-2] :o_doutb ;
end



//Logic for the second port B 

    always @(posedge i_clkb)
  begin
    if(i_enb)
    begin
      if(i_web)
      begin
         q_b_reg_addr  [0]   <= i_addrb;
         q_b_reg_data  [0]   <= i_dinb;
         q_b_reg_enable[0]   <= i_enb;
         q_b_reg_write [0]   <= i_web;
      end
      else
      begin
        q_b_reg[0]          <=  mem[i_addrb];
        q_b_reg_enable[0]   <= i_enb;
        q_b_reg_write [0]   <= i_web;
      end 
    end
    else
   begin
       q_b_reg_enable[0]   <= i_enb;
       q_b_reg_write [0]   <= i_web;  
   end 
  end

 // Port B write logic with added latency by using parameterized Shift registers
 

  always @( posedge i_clkb ) 
  begin
    for (int i = 1; i < WRITE_LATENCY-1; i++)
    begin
      q_b_reg_addr[i]     <= q_b_reg_addr[i-1];
      q_b_reg_data[i]     <= q_b_reg_data[i-1];
      q_b_reg_enable[i]   <= q_b_reg_enable[i-1] ;
      q_b_reg_write [i]   <= q_b_reg_write [i-1] ;   
    end
      mem [ q_b_reg_addr[WRITE_LATENCY-2] ] <= (q_b_reg_enable[WRITE_LATENCY-2]==1'b1 && q_b_reg_write[WRITE_LATENCY-2]==1'b1 )? q_b_reg_data[WRITE_LATENCY-2]: mem [ q_b_reg_addr[WRITE_LATENCY-2] ];   
  end


  

// Port B read logic with the added Latency by using parameterized Shift registers

always @( posedge i_clkb ) 
begin 
  for (int i = 1; i < READ_LATENCY-1; i++)
  begin
    q_b_reg[i]          <= q_b_reg[i-1];
    q_b_reg_enable[i]   <= q_b_reg_enable[i-1] ;
    q_b_reg_write [i]   <= q_b_reg_write [i-1] ;   

  end
    o_doutb    <= (q_b_reg_enable[READ_LATENCY-2]==1'b1 && q_b_reg_write[READ_LATENCY-2]==1'b0 )? q_b_reg[READ_LATENCY-2] :o_doutb ;
end


endmodule


  





