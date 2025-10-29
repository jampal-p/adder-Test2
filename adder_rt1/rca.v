`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of St. Thomas
// Engineer: Jampal Penortsang
// 
// Create Date: 10/29/2025 12:58:36 PM
// Design Name: 
// Module Name: rca.v
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


module rcv(
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module rca #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire Cin,
    output wire [WIDTH-1:0] Sum,
    output wire Cout
);
    wire [WIDTH:0] c;
    assign c[0] = Cin;
    assign Cout = c[WIDTH];

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_fa
            rcv fa (
                .a   (A[i]),
                .b  (B[i]),
                .cin    (c[i]),
                .sum    (Sum[i]),
                .cout   (c[i+1])
            );
        end
    endgenerate
endmodule