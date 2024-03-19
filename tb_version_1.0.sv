
//
//    *****	MODULE BASED TEST BENCH FOR THE DUAL PORT RAM******
//   
//    --------------   Initilizations No  -------------------  
// 
//     --> Dual Port Ram
//     --> Test bench of its Dual Port Ram  
//    
//    --------------   General Info       -------------------
//    
//     --> This TB  will go with cover the Coverage such as Code coverage and functional coverage of the dual Port RAM 
//     --> This will initiate the test Vectors to the given DUT and verify the Functionality of the DUT 
//     --> And also We have to go with the Functional Coverage and Code coverage of the given DUT 
//
//
//


module tb_dual_cverage_upgraded # (parameter ADDR_WIDTH = 4 ,DATA_WIDTH =8, READ_LANTENCY =1 ,WRITE_LANTENCY =1)();
 
  reg        [DATA_WIDTH-1:0] i_dina;
  reg        [ADDR_WIDTH-1:0] i_addra;
  reg                         i_ena;
  reg                         i_clka;  
  reg                         i_wea;
  reg        [DATA_WIDTH-1:0] i_dinb;
  reg        [ADDR_WIDTH-1:0] i_addrb;
  reg                         i_enb;
  reg                         i_clkb;
  reg                         i_web;
  wire       [DATA_WIDTH-1:0] o_douta;
  wire       [DATA_WIDTH-1:0] o_doutb;
   
 dual_port_ram # ( ADDR_WIDTH  ,DATA_WIDTH , READ_LANTENCY  ,WRITE_LANTENCY ) dut (
 
  .i_dina(i_dina),
  .i_addra(i_addra),
  .i_ena(i_ena),
  .i_clka(i_clka), 
  .i_wea(i_wea),
  .i_dinb(i_dinb),
  .i_addrb(i_addrb),
  .i_enb(i_enb),
  .i_clkb(i_clkb),
  .i_web(i_web),
  . o_douta(o_douta),
  . o_doutb(o_doutb)
   
 );

 //--------------CLOCKING BLOCK ---------------------------------  


  initial begin
    i_clka =1'b0;
    i_clkb =1'b0;
  end
  always #5 i_clka = !i_clka;

  always #5 i_clkb = !i_clkb;

//-----------------MAIN INILIZATION BLOCK ------------------------ 


  initial begin
    fork 
      begin
	    repeat(5)
        test_porta();
	  end
	   begin
	     repeat(5)
      	 test_portb();
	   end
    join 
  end 

    

//--------------TASK BLOCK OF THE TEST BENCH TO EVALVATE THE SET OF SEQUENCE FOR THE A & B PORTS--------------------


// Declared the task to generate teh Random stimuls and give it to the random adderss and data  of the port a 
 
  task  test_porta(); 
    repeat(2) @( posedge (i_clka));
    i_ena =1'b1;
    i_wea =1'b1;
    i_dina = $urandom;
    i_addra=$urandom_range(0,8);
    repeat(2) @( posedge (i_clka));
    i_ena =1'b1;
    i_wea =1'b0;
   endtask 
 
// Declared the task to generate teh Random stimuls and give it to the random adderss and data  of the port b 

   task test_portb();  
     i_enb =1'b1;
     i_web  =1'b1;
     i_dinb = $urandom;
     i_addrb=$urandom_range(0,8);
      repeat(2) @( posedge (i_clkb));
     i_enb =1'b1;
     i_web =1'b0;
   endtask
 
 initial begin
  # 500 ;
  $finish();
 end

endmodule
