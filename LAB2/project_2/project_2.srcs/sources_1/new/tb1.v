`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2023 01:27:22 PM
// Design Name: 
// Module Name: tb1
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


module tb1();
    
    reg [11:0] D;
    
    wire S;
    wire [2:0] E;
    wire [3:0] F;
    
    converter oumuamua(
        // outputs
        .S(S),
        .E(E),
        .F(F),
        // inputs
        .D(D)
    );
    
    initial begin
        // check with differnt D values
        
        D = 12'b000000101100;
        
//        D = 12'b000000011111; // e = 2. f = 8
        
        #100;
        
//        D = 12'b000000000000; // e = 0, f = 0
        
//        #100
        
//        D =  12'b100000000000; // s = 1, e = 7, f = 15
        
//        #100
        
//        D = 12'b011111111111; // same as before
        
//        #100
        
//        D = 12'b000000001111; // e = 0, f = 15
        
//        #100
        
//        D = 12'b000110100110; // e = 5, f = 13
        
//        #100
        
//        D = 12'b111001011010; // s = 1, e = 5, f = 13
        
        // finish simulation
        $finish;
    end
endmodule
