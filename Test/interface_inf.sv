//
//
// ----------	INTEFACE ---------
//
//  --> It connects the signal based components to class based components
//       
//  --> It sits between the driver and dut as well as the dut and monitor 
//
//
//


`ifndef INTERFACE
`define INTERFACE


import  dual_port_pkg ::*;


interface dual_inf ();
 
   logic  [DATA_WIDTH-1:0] dina;
   logic  [ADDR_WIDTH-1:0] addra;
   logic                   ena;
   logic                   clka ; 
   logic                   wea;
   logic  [DATA_WIDTH-1:0] dinb;
   logic  [ADDR_WIDTH-1:0] addrb;
   logic                   enb;
   logic                   clkb;
   logic                   web;
   logic  [DATA_WIDTH-1:0] douta;
   logic  [DATA_WIDTH-1:0] doutb;

   




 endinterface 


`endif // INTERFACE
