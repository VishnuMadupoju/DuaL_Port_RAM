/* 

  ---------------Top Modulule----------------

 Inputs :    1 set --> Parameterized bit i_dina, Parameterized bit i_addra, i_ena, i_wea
             2 set --> Parameterized bit i_dinb, Parameterized bit i_addrb, i_enb, i_web

 Outputs :   1 set --> Parameterized bit o_douta
             2 set --> Parameterized bit o_doutb
  ---------------General Initialization---------

     1> Dual Port Ram
     2> Hamming Encoder 
     3> Hamming Decoder

  -------------- General operation-----------

     --> The data is sent from the Hamming Encoder so it was written in the Some memory location in Dual port Ram
     --> Where as the hamming Decoder will Decode the Data by reading the data from that memory Location and by correcting one bit memory Error.


*/

module top_dram # (parameter ADDR_WIDTH = 3 ,DATA_WIDTH =12, READ_LATENCY =3 ,WRITE_LATENCY =3 )(  
  input         [7:0]            i_dina,
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
  output logic  [DATA_WIDTH-1:0] o_doutb,
  output logic  [7:0]            o_decoded_data
 );

// Data that has to be enncoded so the output has to be written in the memory so it has declared as the output wire


  wire   [11:0] i_din_encoder;

// Data that has to be declared as the Wire to write it into the Hamming decoder
  wire  [DATA_WIDTH-1:0] o_douta_decoder;

 // To have the output of the data that is stored as the data is

// Ham encoder initilization 

 ham_enco encoder_1  (

  . i_clk(i_clka) ,
  . i_data_in(i_dina),
  . o_data_out( i_din_encoder)
);


// Dual port Ram inilization 

 dual_port_ram  #(ADDR_WIDTH ,DATA_WIDTH , READ_LATENCY ,WRITE_LATENCY ) DRAM(
 
             .i_dina(i_din_encoder),
             .i_addra(i_addra),
             .i_ena(i_ena),
             .i_clka (i_clka), 
             .i_wea(i_wea),
             .i_dinb(i_dinb),
             .i_addrb(i_addrb),
             .i_enb(i_enb),
             .i_clkb(i_clkb),
             .i_web(i_web),
             .o_douta(o_douta_decoder),
             .o_doutb (o_doutb)
   
 );

// Ham decoder initilization 

 ham_dec decoder_1 (
  
  . i_data(o_douta_decoder),
  . i_clk(i_clka),
  .  o_data(o_decoded_data)
  
 );
 
 endmodule




//-----------Test bench for the Use of the Hamming Encoder and Decoder Test Bench 


module tb_top_dram # (parameter ADDR_WIDTH = 3 ,DATA_WIDTH =12, READ_LATENCY =3 ,WRITE_LATENCY =3 )(); 
  reg        [7:0] i_dina;
  reg        [ADDR_WIDTH-1:0] i_addra;
  reg                         i_ena;
  reg                         i_clka ; 
  reg                         i_wea;
  reg        [DATA_WIDTH-1:0] i_dinb;
  reg        [ADDR_WIDTH-1:0] i_addrb;
  reg                         i_enb;
  reg                         i_clkb;
  reg                         i_web;
  wire       [DATA_WIDTH-1:0] o_douta;
  wire       [DATA_WIDTH-1:0] o_doutb;
  wire       [7:0]            o_decoded_data;


// Initiolization of the module that was put it into 


top_dram # (ADDR_WIDTH ,DATA_WIDTH , READ_LATENCY  ,WRITE_LATENCY ) top_1(  
      . i_dina(i_dina),
      . i_addra(i_addra),
      . i_ena(i_ena),
      . i_clka (i_clka), 
      . i_wea(i_wea),
      . i_dinb(i_dinb),
      . i_addrb(i_addrb),
      . i_enb(i_enb),
      . i_clkb(i_clkb),
      . i_web(i_web),
      . o_douta(o_douta),
      . o_doutb(o_doutb),
      . o_decoded_data(o_decoded_data)
 );


   
   
  initial begin
    i_clka =1'b0;
    i_clkb =1'b0;
  end
  always #5 i_clka = !i_clka;

  always #5 i_clkb = !i_clkb;

  
  initial begin            
   repeat(2) @( posedge (i_clka));
   i_ena =1'b1;
   i_wea =1'b1;
   i_dina = 8'b10101011;
   i_addra= 3'b001;
   repeat(5) @( posedge (i_clka));
   i_ena =1'b1;
   i_wea =1'b0;
   repeat (6) @(posedge (i_clka));
   top_1.DRAM.error_injuction(12'b101001011110,i_addra);// //  Error Injuction of the data so as to test Wheather it is going to work or not 
   repeat(5) @( posedge (i_clka));
   i_ena =1'b1;
   i_wea =1'b0;
  
  end
 
  /*initial begin  
   i_dinb= 8'h13;
   i_addrb= 3'b011;
   repeat(2) @( posedge (i_clkb));
   i_enb =1'b1;
   i_web =1'b1;
   repeat(5) @( posedge (i_clkb));
   i_enb =1'b1;
   i_web =1'b0;
  end 
 */

 initial begin
  # 500 ;
  $finish();
 end
  



endmodule



