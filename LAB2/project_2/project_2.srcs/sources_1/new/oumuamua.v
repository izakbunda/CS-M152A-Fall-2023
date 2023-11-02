`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2023 12:40:46 PM
// Design Name: 
// Module Name: oumuamua
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


module converter(
    // OUTPUTS
    S, E, F,
    // INPUTS
    D
    );
    
    input [11:0] D;
    
    output S;
    output [2:0] E;
    output [3:0] F;
    
    wire [11:0] num;
    wire [4:0] frac;
    wire [2:0] exp;
    
    // instantiate all modules
    sign get_sign(
        // outputs
        .sign_bit(S),
        .num(num),
        // input
        .D(D)
    );
    
    extraction extract(
        // outputs
        .frac(frac),
        .exp(exp),
        // input
        .num(num) 
    );
    always @exp
    begin
        $display("Exp is %3b", exp);
    end
    
    round round(
        // outputs
        .significand(F),
        .final_exponent(E),
        // input
        .fraction(frac),
        .exponent(exp)
    );
   
endmodule

module sign (
    // OUTPUTS
    sign_bit, num,
    // INPUTS
    D
);
    input [11:0] D;
    
    output sign_bit;
    output [11:0] num;

    reg [11:0] number;
    initial begin
            $display("Sign");
        end
    always @*
        // if neg, negate + return number
        if (D[11]) begin
            number[11:0] = ~D[11:0] + 1'b1;
        end
        // if pos, just return the number
        else begin 
            number[11:0] = D[11:0];
        end
        
        assign sign_bit = D[11];
        assign num[11:0] = number[11:0];
  
endmodule 

module extraction(
    // OUTPUTS
    frac, exp,
    //INPUTS
    num
);
    input [11:0] num;
    
    output [4:0] frac;
    output [2:0] exp;
    
    reg [4:0] fraction;
    reg [2:0] exponent;
    reg [11:0] number;
    reg break;
    
    integer i;
    
    initial begin
        exponent = 3'b111;
        break = 1'b0;
        $display("Extracting");
    end
    
    always @*    
    // count # of leading zeros
    for (i = 10; i > 3; i = i - 1) begin
        if (num[i] && break != 1) begin
            break = 1'b1;
            case(i)
                10: begin
                    exponent = 3'b111;
                    fraction = num[10:6];
                    $display("10");
                end
                9: begin
                    exponent = 3'b110;
                    fraction = num[9:5];
                    $display("9");
                end
                8: begin
                    exponent = 3'b101;
                    fraction = num[8:4];
                    $display("8");
                end
                7: begin
                    exponent = 3'b100;
                    fraction = num[7:3];
                    $display("7");
                end
                6: begin
                    exponent = 3'b011;
                    fraction = num[6:2];
                    $display("6");
                end
                5: begin
                    exponent = 3'b010;
                    fraction = num[5:1];
                    $display("5");
                end
                4: begin
                    exponent = 3'b001;
                    fraction = num[4:0];
                    $display("4");
                end
                default: begin
                    exponent = 3'b000;
                    fraction = {num[3:0], 1'b0};
                    $display("3");
                end
            endcase
        end
    end
    
    assign exp = exponent;
    assign frac = fraction;
    
endmodule

module round(
    // OUTPUTS
    significand, final_exponent,
    // INPUTS
    fraction, exponent
);
    input [4:0] fraction;
    input [2:0] exponent;
    
    output [3:0] significand;
    output [2:0] final_exponent;
    
    reg [3:0] sig;
    reg [2:0] exp;
    
    initial begin
        $display("Exp inside round: %2b", exponent);
        exp = exponent;
    end
    
    always @*
    // check last bit
    // if 0 truncate
    if (fraction[0] == 1'b0) begin
        sig = fraction[4:1];
    end
    else begin
        // overflow case
        if (fraction[4:1] == 4'b1111) begin
            sig = 4'b1000;
            exp = exponent + 1'b1;
        end 
        else begin
            sig = fraction[4:1] + 1'b1; 
        end
    end
    
    assign significand = sig;
    assign final_exponent = exp;
    
endmodule
