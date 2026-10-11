`timescale 1ns / 1ps

module fir_filter_tb;

    // 1. UUT Signals
    reg clk;
    reg rst_n;
    reg signed [15:0] x_in;
    wire signed [15:0] y_out;

    // 2. Memory Arrays for File I/O
    // length matches the MATLAB test vectors
    parameter NUM_SAMPLES = 1000;
    
    reg signed [15:0] stimulus_mem [0:NUM_SAMPLES-1];
    reg signed [15:0] golden_mem   [0:NUM_SAMPLES-1];

    integer i;
    integer error_count;

    fir_filter dut (
        .clk(clk),
        .rst_n(rst_n),
        .x_in(x_in),
        .y_out(y_out)
    );

    // 3. Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz
    end

    // 4. Main Test Sequence
    initial begin
        x_in = 16'sh0000;
        error_count = 0;
        
        // load test vectors
        $readmemh("stimulus_case1.hex", stimulus_mem);
        $readmemh("golden_case1.hex", golden_mem);

        // trigger reset
        rst_n = 0;
        #20;
        rst_n = 1;
        #20;

        $display("Starting simulation...");
        
        for (i = 0; i < NUM_SAMPLES; i = i + 1) begin
            // drive input on falling edge to avoid setup/hold issues
            @(negedge clk);
            x_in = stimulus_mem[i];
            
            // check output on rising edge
            @(posedge clk);
            #1; // visual delay for waveforms
            
            // skip the first cycle since pipeline is empty
            if (i > 0) begin
                $display("Sample %4d | x_in: %d | y_out: %d | Golden: %d", 
                         i, x_in, y_out, golden_mem[i-1]);
                
                // allow +/- 1 LSB for matlab rounding vs hardware truncation diff
                if (y_out !== golden_mem[i-1] && 
                    y_out !== golden_mem[i-1] + 16'sh0001 && 
                    y_out !== golden_mem[i-1] - 16'sh0001) begin
                    
                    error_count = error_count + 1;
                end
            end
        end

        $display("Simulation complete. Total mismatches: %d", error_count);
        $stop;
    end

endmodule