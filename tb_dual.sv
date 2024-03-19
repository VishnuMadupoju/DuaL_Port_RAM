/*

    *****	MODULE BASED TEST BENCH FOR THE DUAL PORT RAM******
   
    --------------   Initilizations No  -------------------  
 
     --> Dual Port Ram
     --> Test bench of its Dual Port Ram  
    
    --------------   General Info       -------------------
    
     --> This TB  will go with cover the Coverage such as Code coverage and functional coverage of the dual Port RAM 
     --> This will initiate the test Vectors to the given DUT and verify the Functionality of the DUT 
     --> And also We have to go with the Functional Coverage and Code coverage of the given DUT 

*/



module tb_dual_cverage_upgraded # (parameter ADDR_WIDTH = 4 ,DATA_WIDTH =8, READ_LANTENCY =3 ,WRITE_LANTENCY =3 )();
 
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
	  forever begin
        begin 
        test_porta();
		test_portb();
		if(d.get_coverage()==100) break;       
       end
     
      end
    join 
  end 

//------------------ FUNCTIONAL COVERAGE BLOCK  --------------------------------------------------------

// Adding functional coverage and the Cover group to the both the a and  b ports 
 
  covergroup  dual_port @(posedge i_clka);
    
    option.per_instance= 1;

    coverpoint  i_dina {
      bins din_a_range_0_to_49     ={[0:49]};
      bins din_a_range_50_to_99   ={[50:99]};
      bins din_a_range_100_to_149  ={[100:149]};
      bins din_a_range_150_to_199  ={[150:199]}; 
      bins din_a_range_200_to_255  ={[200:255]};

      }
    coverpoint  i_dinb{
      bins din_b_range_0_to_49     ={[0:49]};
      bins din_b_range_50_to_99   ={[50:99]};
      bins din_b_range_100_to_149  ={[100:149]};
      bins din_b_range_150_to_199  ={[150:199]}; 
      bins din_b_range_200_to_255  ={[200:255]};

      }
    coverpoint  o_douta {
      bins dout_a_range_0_to_49     ={[0:49]};
      bins dout_a_range_50_to_99   ={[50:99]};
      bins dout_a_range_100_to_149  ={[100:149]};
      bins dout_a_range_150_to_199  ={[150:199]}; 
      bins dout_a_range_200_to_255  ={[200:255]};

      }
     coverpoint  o_doutb {
      bins dout_b_range_0_to_49     ={[0:49]};
      bins dout_b_range_50_to_99   ={[50:99]};
      bins dout_b_range_100_to_149  ={[100:149]};
      bins dout_b_range_150_to_199  ={[150:199]}; 
      bins dout_b_range_200_to_255  ={[200:255]};
    }

    coverpoint i_addra {

      bins a_address_range[] =  {[0:15]};
      } 
    coverpoint i_addrb {
      bins b_address_range[] =  {[0:15]};
      } 
    coverpoint i_ena {
      bins en_a  []    = {[0:1]};   
      }
    coverpoint i_enb {
      bins en_b  []    = {[0:1]};   
      }
    coverpoint i_wea {
      bins we_a  []    = {[0:1]};   
      }
    coverpoint i_web {
      bins we_b  []    = {[0:1]};   

       }
   we_bXout_b: cross i_web ,o_doutb ;

   we_aXout_a: cross i_wea ,o_douta;
    
  endgroup
 
// Initialization of the constructor of the Functional Block 

   dual_port d =new();

    

//--------------TASK BLOCK OF THE TEST BENCH TO EVALVATE THE SET OF SEQUENCE FOR THE A & B PORTS--------------------


// Declared the task to generate teh Random stimuls and give it to the random adderss and data  of the port a 
 
  task  test_porta(); 
   i_dina= $urandom();
   i_addra=$urandom_range(0,17);     // Range is Randomized since the no of address loactions are fixed and  depend on the addrss width 
  @( posedge (i_clka));
   i_ena =$urandom_range(0,1);
   i_wea =$urandom_range(0,1);
  @( posedge (i_clka));
   endtask 
 
// Declared the task to generate teh Random stimuls and give it to the random adderss and data  of the port b 

   task test_portb();  
     i_dinb= $urandom();
     i_addrb= $urandom_range(0,17 );// Range is Randomized since the no of address loactions are fixed and depend on the addrss width
    @(posedge i_clkb);
     i_enb =$uradom_range(0,1);
     i_web =$uradom_range(0,2);
	 $display("Values of the i_en= %0d and i_we=%0d",i_enb,i_web);
    @(posedge i_clkb);
    endtask
 
 initial begin
  # 50000 ;
  $finish();
 end

endmodule
