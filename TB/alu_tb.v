`timescale 1ns/1ps  // time unit / precision

module alu_tb;

    // Declare inputs as reg (we drive these)
    reg [7:0] A;
    reg [7:0] B;
    reg [3:0] opcode;

    // Declare outputs as wire 
    wire [7:0] result;
    wire Z, C, V, N;

    // Connect testbench to alu_top
    alu_top uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .Z(Z),
        .C(C),
        .V(V),
        .N(N)
    );

    // Apply Waveforms to file
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

    // Apply test cases
    initial begin
        $display("--- ALU TESTBENCH START ---");
        $display("Op\t\tA\tB\tResult\tZ C V N");
        $display("--------------------------------------------------");

        // --- ARITHMETIC ---

        // ADD: 5 + 3 = 8
        A = 8'd5; B = 8'd3; opcode = 4'b0000; #10;
        $display("ADD\t\t%0d\t%0d\t%0d\t%b %b %b %b", A, B, result, Z, C, V, N);

        // SUB: 10 - 4 = 6
        A = 8'd10; B = 8'd4; opcode = 4'b0001; #10;
        $display("SUB\t\t%0d\t%0d\t%0d\t%b %b %b %b", A, B, result, Z, C, V, N);

        // INC: 7 + 1 = 8
        A = 8'd7; B = 8'd0; opcode = 4'b0010; #10;
        $display("INC\t\t%0d\t-\t%0d\t%b %b %b %b", A, result, Z, C, V, N);

        // DEC: 7 - 1 = 6
        A = 8'd7; B = 8'd0; opcode = 4'b0011; #10;
        $display("DEC\t\t%0d\t-\t%0d\t%b %b %b %b", A, result, Z, C, V, N);

        // ADD causing Carry: 255 + 1 = overflow
        A = 8'd255; B = 8'd1; opcode = 4'b0000; #10;
        $display("ADD(carry)\t%0d\t%0d\t%0d\t%b %b %b %b", A, B, result, Z, C, V, N);

        // SUB causing Zero: 5 - 5 = 0
        A = 8'd5; B = 8'd5; opcode = 4'b0001; #10;
        $display("SUB(zero)\t%0d\t%0d\t%0d\t%b %b %b %b", A, B, result, Z, C, V, N);

        // --- LOGIC ---

        // AND: 1100 & 1010 = 1000
        A = 8'b11001100; B = 8'b10101010; opcode = 4'b0100; #10;
        $display("AND\t\t%0d\t%0d\t%0d\t%b %b %b %b", A, B, result, Z, C, V, N);

        // OR: 1100 | 1010 = 1110
        A = 8'b11001100; B = 8'b10101010; opcode = 4'b0101; #10;
        $display("OR\t\t%0d\t%0d\t%0d\t%b %b %b %b", A, B, result, Z, C, V, N);

        // XOR: 1100 ^ 1010 = 0110
        A = 8'b11001100; B = 8'b10101010; opcode = 4'b0110; #10;
        $display("XOR\t\t%0d\t%0d\t%0d\t%b %b %b %b", A, B, result, Z, C, V, N);

        // NOT: ~A
        A = 8'b11001100; B = 8'd0; opcode = 4'b0111; #10;
        $display("NOT\t\t%0d\t-\t%0d\t%b %b %b %b", A, result, Z, C, V, N);

        // --- SHIFTS ---

        // SHL: 0000 1111 << 1 = 0001 1110
        A = 8'b00001111; B = 8'd0; opcode = 4'b1011; #10;
        $display("SHL\t\t%0d\t-\t%0d\t%b %b %b %b", A, result, Z, C, V, N);

        // SHR: 0000 1111 >> 1 = 0000 0111
        A = 8'b00001111; B = 8'd0; opcode = 4'b1100; #10;
        $display("SHR\t\t%0d\t-\t%0d\t%b %b %b %b", A, result, Z, C, V, N);

        // ASR: 1000 1111 >>> 1 = 1100 0111 (sign preserved)
        A = 8'b10001111; B = 8'd0; opcode = 4'b1101; #10;
        $display("ASR\t\t%0d\t-\t%0d\t%b %b %b %b", A, result, Z, C, V, N);

        // --- UTILITY ---

        // PASS: just passes A through
        A = 8'd42; B = 8'd0; opcode = 4'b1111; #10;
        $display("PASS\t\t%0d\t-\t%0d\t%b %b %b %b", A, result, Z, C, V, N);

        $display("--------------------------------------------------");
        $display("--- ALU TESTBENCH END ---");
        $finish;
    end

endmodule
