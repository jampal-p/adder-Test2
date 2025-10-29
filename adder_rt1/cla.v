`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of St. Thomas
// Engineer: Jampal Penortsang
// 
// Create Date: 10/29/2025 01:15:10 PM
// Design Name: 
// Module Name: cla
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


module cla #(
    parameter WIDTH = 32,
    parameter BLK   = 4
)(
    input  wire [WIDTH-1:0] A,
    input  wire [WIDTH-1:0] B,
    input  wire Cin,
    output wire [WIDTH-1:0] Sum,
    output wire Cout
);
    localparam NBLKS = (WIDTH + BLK - 1) / BLK;

    wire [WIDTH-1:0] g, p;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign g[i] = A[i] & B[i];
            assign p[i] = A[i] ^ B[i];
        end
    endgenerate

    wire [NBLKS-1:0] Gblk, Pblk;
    wire [NBLKS:0] Cblk;
    assign Cblk[0] = Cin;

    genvar blk;
    generate
        for (blk = 0; blk < NBLKS; blk = blk + 1) begin : gen_block
            localparam LO = blk*BLK;
            localparam HI = (LO + BLK - 1 < WIDTH) ? LO + BLK - 1 : WIDTH - 1;
            localparam BW = HI - LO + 1;

            wire [BW-1:0] g_local = g[HI:LO];
            wire [BW-1:0] p_local = p[HI:LO];
            wire [BW:0] c_local;

            assign c_local[0] = Cblk[blk];

            genvar b;
            for (b = 0; b < BW; b = b + 1) begin : gen_carry
                assign c_local[b+1] = g_local[b] | (p_local[b] & c_local[b]);
                assign Sum[LO + b]  = p_local[b] ^ c_local[b];
            end

            assign Pblk[blk] = &p_local;
            assign Gblk[blk] = g_local[BW-1] |
                               (p_local[BW-1] & g_local[BW-2]) |
                               (p_local[BW-1] & p_local[BW-2] & g_local[BW-3]) |
                               (BW > 3 ? (p_local[BW-1] & p_local[BW-2] & p_local[BW-3] & g_local[BW-4]) : 1'b0);

            assign Cblk[blk+1] = Gblk[blk] | (Pblk[blk] & Cblk[blk]);
        end
    endgenerate

    assign Cout = Cblk[NBLKS];
endmodule