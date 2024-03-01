module DualPortRAM #(
    parameter integer DATA_WIDTH = 8,
    parameter integer ADDRESS_WIDTH = 5,
    parameter integer READ_LATENCY = 1,
    parameter integer WRITE_LATENCY = 1
) (
    input clk,
    input rst,

    // Port A
    input [ADDRESS_WIDTH-1:0] addr_a,
    input [DATA_WIDTH-1:0] data_a,
    input en_a,
    input we_a,
    output reg [DATA_WIDTH-1:0] q_a,

    // Port B
    input [ADDRESS_WIDTH-1:0] addr_b,
    input [DATA_WIDTH-1:0] data_b,
    input en_b,
    input we_b,
    output reg [DATA_WIDTH-1:0] q_b
);

// Internal registers for pipelined data
reg [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH-1:0];
reg [DATA_WIDTH-1:0] q_a_reg [READ_LATENCY-1:0];
reg [DATA_WIDTH-1:0] q_b_reg [READ_LATENCY-1:0];

// Asynchronous reset
always @( posedge rst ) begin
    q_a <= 0;
    q_b <= 0;
    
    // Reset internal registers
    for (int i = 0; i < READ_LATENCY; i++) begin
        q_a_reg[i] <= 0;
        q_b_reg[i] <= 0;
    end
end

// Port A write logic
always @( posedge clk ) begin
    if (we_a && en_a) begin
        mem[addr_a] <= data_a;
    end
end

// Port B write logic
always @( posedge clk ) begin
    if (we_b && en_b) begin
        mem[addr_b] <= data_b;
    end
end

// Port A read logic with pipeline
always @( posedge clk ) begin
    q_a_reg[0] <= mem[addr_a];
    for (int i = 1; i < READ_LATENCY; i++) begin
        q_a_reg[i] <= q_a_reg[i-1];
    end
    q_a <= q_a_reg[READ_LATENCY-1];
end

// Port B read logic with pipeline
always @( posedge clk ) begin
    q_b_reg[0] <= mem[addr_b];
    for (int i = 1; i < READ_LATENCY; i++) begin
        q_b_reg[i] <= q_b_reg[i-1];
    end
    q_b <= q_b_reg[READ_LATENCY-1];
end

// Enable logic (optional)
always @( posedge clk ) begin
    if (!en_a) begin
        q_a <= 0;
    end
    if (!en_b) begin
        q_b <= 0;
    end
end

endmodule

