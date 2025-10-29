`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of St. Thomas
// Engineer: Jampal Penortsang
// 
// Create Date: 10/29/2025 01:16:30 PM
// Design Name: 
// Module Name: prefix
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


module prefix #(
    parameter WIDTH = 32
    )(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire Cin,
    output wire [WIDTH-1:0] Sum,
    output wire Cout
    );
    wire [WIDTH-1:0] g0, p0;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign g0[i] = A[i] & B[i];
            assign p0[i] = A[i] ^ B[i];
        end
    endgenerate

    wire [WIDTH-1:0] g1, p1, g2, p2, g3, p3, g4, p4, g5, p5, g6, p6;

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i == 0) begin
                assign g1[i] = g0[i];
                assign p1[i] = p0[i];
            end else begin
                assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
                assign p1[i] = p0[i] & p0[i-1];
            end
        end
    endgenerate

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i < 2) begin
                assign g2[i] = g1[i];
                assign p2[i] = p1[i];
            end else begin
                assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
                assign p2[i] = p1[i] & p1[i-2];
            end
        end
    endgenerate

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i < 4) begin
                assign g3[i] = g2[i];
                assign p3[i] = p2[i];
            end else begin
                assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
                assign p3[i] = p2[i] & p2[i-4];
            end
        end
    endgenerate

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i < 8) begin
                assign g4[i] = g3[i];
                assign p4[i] = p3[i];
            end else begin
                assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
                assign p4[i] = p3[i] & p3[i-8];
            end
        end
    endgenerate

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i < 16) begin
                assign g5[i] = g4[i];
                assign p5[i] = p4[i];
            end else begin
                assign g5[i] = g4[i] | (p4[i] & g4[i-16]);
                assign p5[i] = p4[i] & p4[i-16];
            end
        end
    endgenerate
    
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (i < 32) begin
                assign g6[i] = g5[i];
                assign p6[i] = p5[i];
            end else begin
                assign g6[i] = g5[i] | (p5[i] & g5[i-32]);
                assign p6[i] = p5[i] & p5[i-32];
            end
        end
    endgenerate

    wire [WIDTH:0] c;
    assign c[0] = Cin;

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign c[i+1] = g6[i] | (p6[i] & Cin);
            assign Sum[i] = p0[i] ^ c[i];
        end
    endgenerate

    assign Cout = c[WIDTH];
endmodule
