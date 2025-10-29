`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of St. Thomas
// Engineer: Jampal Penortsang
// 
// Create Date: 10/29/2025 01:19:15 PM
// Design Name: 
// Module Name: tb_Test2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_adders;
//============================================================
// tb_adders.v  (corrected)
// Vivado 2018.2 Compatible Testbench
// Tests RCA, CLA, and Prefix Adders at 8, 16, 32, and 64 bits
//============================================================

    // Simulation Parameters
    parameter NUM_TESTS = 10; // number of random test vectors per width

    // 64-bit stimulus; we'll slice this for smaller widths
    reg  [63:0] A64;
    reg  [63:0] B64;
    reg         Cin;

    // Outputs from DUTs (each adder instantiated per width)
    wire [7:0]  Sum_rca_8,   Sum_cla_8,   Sum_pref_8;
    wire        Cout_rca_8,  Cout_cla_8,  Cout_pref_8;

    wire [15:0] Sum_rca_16,  Sum_cla_16,  Sum_pref_16;
    wire        Cout_rca_16, Cout_cla_16, Cout_pref_16;

    wire [31:0] Sum_rca_32,  Sum_cla_32,  Sum_pref_32;
    wire        Cout_rca_32, Cout_cla_32, Cout_pref_32;

    wire [63:0] Sum_rca_64,  Sum_cla_64,  Sum_pref_64;
    wire        Cout_rca_64, Cout_cla_64, Cout_pref_64;

    // Instantiate DUTs at module scope (no instantiation inside tasks)
    // 8-bit
    rca    #(.WIDTH(8))  rca8  (.A(A64[7:0]),   .B(B64[7:0]),   .Cin(Cin), .Sum(Sum_rca_8),  .Cout(Cout_rca_8));
    cla    #(.WIDTH(8))  cla8  (.A(A64[7:0]),   .B(B64[7:0]),   .Cin(Cin), .Sum(Sum_cla_8),  .Cout(Cout_cla_8));
    prefix #(.WIDTH(8))  pref8 (.A(A64[7:0]),   .B(B64[7:0]),   .Cin(Cin), .Sum(Sum_pref_8), .Cout(Cout_pref_8));

    // 16-bit
    rca    #(.WIDTH(16)) rca16 (.A(A64[15:0]),  .B(B64[15:0]),  .Cin(Cin), .Sum(Sum_rca_16), .Cout(Cout_rca_16));
    cla    #(.WIDTH(16)) cla16 (.A(A64[15:0]),  .B(B64[15:0]),  .Cin(Cin), .Sum(Sum_cla_16), .Cout(Cout_cla_16));
    prefix #(.WIDTH(16)) pref16(.A(A64[15:0]),  .B(B64[15:0]),  .Cin(Cin), .Sum(Sum_pref_16),.Cout(Cout_pref_16));

    // 32-bit
    rca    #(.WIDTH(32)) rca32 (.A(A64[31:0]),  .B(B64[31:0]),  .Cin(Cin), .Sum(Sum_rca_32), .Cout(Cout_rca_32));
    cla    #(.WIDTH(32)) cla32 (.A(A64[31:0]),  .B(B64[31:0]),  .Cin(Cin), .Sum(Sum_cla_32), .Cout(Cout_cla_32));
    prefix #(.WIDTH(32)) pref32(.A(A64[31:0]),  .B(B64[31:0]),  .Cin(Cin), .Sum(Sum_pref_32),.Cout(Cout_pref_32));

    // 64-bit
    rca    #(.WIDTH(64)) rca64 (.A(A64[63:0]),  .B(B64[63:0]),  .Cin(Cin), .Sum(Sum_rca_64), .Cout(Cout_rca_64));
    cla    #(.WIDTH(64)) cla64 (.A(A64[63:0]),  .B(B64[63:0]),  .Cin(Cin), .Sum(Sum_cla_64), .Cout(Cout_cla_64));
    prefix #(.WIDTH(64)) pref64(.A(A64[63:0]),  .B(B64[63:0]),  .Cin(Cin), .Sum(Sum_pref_64),.Cout(Cout_pref_64));

    // helper function to create mask for a width
    function [63:0] mask_of_width;
        input integer width;
        begin
            if (width == 64)
                mask_of_width = 64'hFFFFFFFFFFFFFFFF;
            else
                mask_of_width = (64'h1 << width) - 1;
        end
    endfunction

    // check_results task: compare DUT outputs to reference
    task check_results;
        input integer WIDTH;
        input [63:0] A_in;
        input [63:0] B_in;
        input        Cin_in;

        reg [63:0] mask;
        reg [63:0] sum_ref;
        reg        cout_ref;

        begin
            mask = mask_of_width(WIDTH);
            sum_ref = (A_in & mask) + (B_in & mask) + (Cin_in ? 1 : 0);
            cout_ref = (sum_ref >> WIDTH) & 1'b1;
            sum_ref = sum_ref & mask;

            case (WIDTH)
                8: begin
                    if ({Cout_rca_8, Sum_rca_8} !== {cout_ref, sum_ref[7:0]} ||
                        {Cout_cla_8, Sum_cla_8} !== {cout_ref, sum_ref[7:0]} ||
                        {Cout_pref_8,Sum_pref_8} !== {cout_ref, sum_ref[7:0]}) begin
                        $display("? MISMATCH W=8 A=%h B=%h Cin=%b", A_in[7:0], B_in[7:0], Cin_in);
                        $display("   RCA    Sum=%h Cout=%b", Sum_rca_8, Cout_rca_8);
                        $display("   CLA    Sum=%h Cout=%b", Sum_cla_8, Cout_cla_8);
                        $display("   PREF   Sum=%h Cout=%b", Sum_pref_8, Cout_pref_8);
                        $display("   REF    Sum=%h Cout=%b", sum_ref[7:0], cout_ref);
                    end else begin
                        $display("? PASS W=8: A=%h B=%h Cin=%b -> Sum=%h Cout=%b",
                                 A_in[7:0], B_in[7:0], Cin_in, sum_ref[7:0], cout_ref);
                    end
                end
                16: begin
                    if ({Cout_rca_16, Sum_rca_16} !== {cout_ref, sum_ref[15:0]} ||
                        {Cout_cla_16, Sum_cla_16} !== {cout_ref, sum_ref[15:0]} ||
                        {Cout_pref_16,Sum_pref_16} !== {cout_ref, sum_ref[15:0]}) begin
                        $display("? MISMATCH W=16 A=%h B=%h Cin=%b", A_in[15:0], B_in[15:0], Cin_in);
                        $display("   RCA    Sum=%h Cout=%b", Sum_rca_16, Cout_rca_16);
                        $display("   CLA    Sum=%h Cout=%b", Sum_cla_16, Cout_cla_16);
                        $display("   PREF   Sum=%h Cout=%b", Sum_pref_16, Cout_pref_16);
                        $display("   REF    Sum=%h Cout=%b", sum_ref[15:0], cout_ref);
                    end else begin
                        $display("? PASS W=16: A=%h B=%h Cin=%b -> Sum=%h Cout=%b",
                                 A_in[15:0], B_in[15:0], Cin_in, sum_ref[15:0], cout_ref);
                    end
                end
                32: begin
                    if ({Cout_rca_32, Sum_rca_32} !== {cout_ref, sum_ref[31:0]} ||
                        {Cout_cla_32, Sum_cla_32} !== {cout_ref, sum_ref[31:0]} ||
                        {Cout_pref_32,Sum_pref_32} !== {cout_ref, sum_ref[31:0]}) begin
                        $display("? MISMATCH W=32 A=%h B=%h Cin=%b", A_in[31:0], B_in[31:0], Cin_in);
                        $display("   RCA    Sum=%h Cout=%b", Sum_rca_32, Cout_rca_32);
                        $display("   CLA    Sum=%h Cout=%b", Sum_cla_32, Cout_cla_32);
                        $display("   PREF   Sum=%h Cout=%b", Sum_pref_32, Cout_pref_32);
                        $display("   REF    Sum=%h Cout=%b", sum_ref[31:0], cout_ref);
                    end else begin
                        $display("? PASS W=32: A=%h B=%h Cin=%b -> Sum=%h Cout=%b",
                                 A_in[31:0], B_in[31:0], Cin_in, sum_ref[31:0], cout_ref);
                    end
                end
                64: begin
                    if ({Cout_rca_64, Sum_rca_64} !== {cout_ref, sum_ref[63:0]} ||
                        {Cout_cla_64, Sum_cla_64} !== {cout_ref, sum_ref[63:0]} ||
                        {Cout_pref_64,Sum_pref_64} !== {cout_ref, sum_ref[63:0]}) begin
                        $display("? MISMATCH W=64 A=%h B=%h Cin=%b", A_in, B_in, Cin_in);
                        $display("   RCA    Sum=%h Cout=%b", Sum_rca_64, Cout_rca_64);
                        $display("   CLA    Sum=%h Cout=%b", Sum_cla_64, Cout_cla_64);
                        $display("   PREF   Sum=%h Cout=%b", Sum_pref_64, Cout_pref_64);
                        $display("   REF    Sum=%h Cout=%b", sum_ref[63:0], cout_ref);
                    end else begin
                        $display("? PASS W=64: A=%h B=%h Cin=%b -> Sum=%h Cout=%b",
                                 A_in, B_in, Cin_in, sum_ref[63:0], cout_ref);
                    end
                end
                default: $display("Unsupported width %0d", WIDTH);
            endcase
        end
    endtask

    // run_tests task: performs deterministic + random tests for a width
    task run_tests;
        input integer WIDTH;
        integer j;
        reg [63:0] mask;
        begin
            mask = mask_of_width(WIDTH);
            $display("\n============================================");
            $display("Testing %0d-bit Adders", WIDTH);
            $display("============================================");

            // deterministic edge cases
            // all zeros
            A64 = 64'h0; B64 = 64'h0; Cin = 0; #1; check_results(WIDTH, A64, B64, Cin);
            // max + 0
            A64 = mask; B64 = 64'h0; Cin = 0; #1; check_results(WIDTH, A64, B64, Cin);
            // max + max
            A64 = mask; B64 = mask; Cin = 0; #1; check_results(WIDTH, A64, B64, Cin);
            // alternating bits
            A64 = (64'hAAAAAAAAAAAAAAAA & mask); B64 = (64'h5555555555555555 & mask); Cin = 0; #1; check_results(WIDTH, A64, B64, Cin);
            // overflow test (MSB set)
            if (WIDTH == 64) begin
                A64 = 64'h8000000000000000; B64 = 64'h8000000000000000; Cin = 0; #1; check_results(WIDTH, A64, B64, Cin);
            end else begin
                // for smaller widths pick top-bit set for that width
                A64 = (64'h1 << (WIDTH-1)); B64 = (64'h1 << (WIDTH-1)); Cin = 0; #1; check_results(WIDTH, A64, B64, Cin);
            end
            // small carry test
            A64 = 1; B64 = 1; Cin = 1; #1; check_results(WIDTH, A64, B64, Cin);

            // randomized tests
            for (j = 0; j < NUM_TESTS; j = j + 1) begin
                A64 = $urandom;
                A64 = A64 ^ ($urandom << 16); // mix more random bits
                B64 = $urandom;
                B64 = B64 ^ ($urandom << 16);
                Cin = $urandom & 1;
                #1;
                check_results(WIDTH, A64, B64, Cin);
            end
        end
    endtask

    //========================================================
    // Main Simulation
    //========================================================
    initial begin
        $display("============================================");
        $display("Starting Adder Verification Testbench (Vivado 2018.2)");
        $display("============================================");

        run_tests(8);
        run_tests(16);
        run_tests(32);
        run_tests(64);

        $display("\n============================================");
        $display("All Tests Completed.");
        $display("============================================");
        $finish;
    end

endmodule
