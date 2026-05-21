module alu_top (
    input  [7:0] A,        // Operand A
    input  [7:0] B,        // Operand B
    input  [3:0] opcode,   // Operation select
    output reg [7:0] result, // 8-bit result
    output Z,              // Zero flag
    output C,              // Carry flag
    output V,              // Overflow flag
    output N               // Negative flag
);

    // 9-bit wire to capture carry out from arithmetic ops
    reg [8:0] temp;

    always @(*) begin
        temp = 9'b0; // default
        case (opcode)
            4'b0000: temp = A + B;           // ADD
            4'b0001: temp = A - B;           // SUB
            4'b0010: temp = A + 1;           // INC
            4'b0011: temp = A - 1;           // DEC
            4'b0100: temp = A & B;           // AND
            4'b0101: temp = A | B;           // OR
            4'b0110: temp = A ^ B;           // XOR
            4'b0111: temp = ~A;              // NOT
            4'b1000: temp = ~(A & B);        // NAND
            4'b1001: temp = ~(A | B);        // NOR
            4'b1010: temp = ~(A ^ B);        // XNOR
            4'b1011: temp = A << 1;          // SHL
            4'b1100: temp = A >> 1;          // SHR
            4'b1101: temp = {A[7], A[7:1]};  // ASR (preserve sign bit)
            4'b1110: temp = A - B;           // CMP (flags only, result ignored)
            4'b1111: temp = A;               // PASS
            default: temp = 9'b0;
        endcase
        result = temp[7:0];
    end

    // Flag logic
    assign Z = (result == 8'b0);           // Zero: result is zero
    assign C = temp[8];                    // Carry: 9th bit from arithmetic
    assign N = result[7];                  // Negative: MSB of result
    assign V = (~A[7] & ~B[7] & result[7]) // Overflow: signed overflow
             | (A[7] & B[7] & ~result[7]);

endmodule