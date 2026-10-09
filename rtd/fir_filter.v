module fir_filter (
    input  wire               clk,
    input  wire               rst_n,
    input  wire signed [15:0] x_in,
    output reg  signed [15:0] y_out
);

    // 1. Coefficient Storage (Dummy values for now)
    // replace these with the actual hex values once the MATLAB step is done.
    localparam signed [15:0] H0  = 16'sh0100;
    localparam signed [15:0] H1  = 16'sh0100;
    localparam signed [15:0] H2  = 16'sh0100;
    localparam signed [15:0] H3  = 16'sh0100;
    localparam signed [15:0] H4  = 16'sh0100;
    localparam signed [15:0] H5  = 16'sh0100;
    localparam signed [15:0] H6  = 16'sh0100;
    localparam signed [15:0] H7  = 16'sh0100;
    localparam signed [15:0] H8  = 16'sh0100;
    localparam signed [15:0] H9  = 16'sh0100;
    localparam signed [15:0] H10 = 16'sh0100;
    localparam signed [15:0] H11 = 16'sh0100;
    localparam signed [15:0] H12 = 16'sh0100;
    localparam signed [15:0] H13 = 16'sh0100;
    localparam signed [15:0] H14 = 16'sh0100;
    localparam signed [15:0] H15 = 16'sh0100;

    // 2. The Delay Line (Shift Register)
    reg signed [15:0] delay_line [0:15];
    integer i;

    // 3. Parallel Multipliers
    wire signed [31:0] prod [0:15];
    
    assign prod[0]  = delay_line[0]  * H0;
    assign prod[1]  = delay_line[1]  * H1;
    assign prod[2]  = delay_line[2]  * H2;
    assign prod[3]  = delay_line[3]  * H3;
    assign prod[4]  = delay_line[4]  * H4;
    assign prod[5]  = delay_line[5]  * H5;
    assign prod[6]  = delay_line[6]  * H6;
    assign prod[7]  = delay_line[7]  * H7;
    assign prod[8]  = delay_line[8]  * H8;
    assign prod[9]  = delay_line[9]  * H9;
    assign prod[10] = delay_line[10] * H10;
    assign prod[11] = delay_line[11] * H11;
    assign prod[12] = delay_line[12] * H12;
    assign prod[13] = delay_line[13] * H13;
    assign prod[14] = delay_line[14] * H14;
    assign prod[15] = delay_line[15] * H15;

    // 4. Combinational Adder Tree
    wire signed [35:0] acc;
    assign acc = prod[0]  + prod[1]  + prod[2]  + prod[3]  +
                 prod[4]  + prod[5]  + prod[6]  + prod[7]  +
                 prod[8]  + prod[9]  + prod[10] + prod[11] +
                 prod[12] + prod[13] + prod[14] + prod[15];

    // 5. Sequential Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 16; i = i + 1) begin
                delay_line[i] <= 16'sh0000;
            end
            y_out <= 16'sh0000;
        end else begin
            // Shift input into the delay line
            delay_line[0] <= x_in;
            for (i = 1; i < 16; i = i + 1) begin
                delay_line[i] <= delay_line[i-1];
            end
            
            // Truncate the Q6.30 accumulator to Q1.15 output
            y_out <= acc[30:15];
        end
    end

endmodule