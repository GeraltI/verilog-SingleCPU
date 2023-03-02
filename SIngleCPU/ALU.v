module ALU(
    input  [ 3:0]       op,
    input           branch,
    input  [31:0]        a,
    input  [31:0]        b,
    output       if_branch,
    output [31:0]      cal
    );
    
    reg [31:0] result;
    
    assign                   cal = result;
    assign if_branch = result[0] & branch;
    

    always@(*)
    begin
        case(op)
            4'b0000 :result = a + b;
            4'b0001 :result = a - b;
            4'b0010 :result = a & b;
            4'b0011 :result = a | b;
            4'b0100 :result = a ^ b;
            4'b0101 :result = a << b[4:0];
            4'b0110 :result = a >> b[4:0];
            4'b0111 :result = $signed(a) >>> b[4:0];
            4'b1000 :result = $signed(a) < $signed(b) ?  1 : 0;
            4'b1001 :result = a < b ?  1 : 0;
            4'b1010 :result = a == b ?  1 : 0;
            4'b1011 :result = a != b ?  1 : 0;
            4'b1100 :result = $signed(a) >= $signed(b) ?  1 : 0;
            4'b1101 :result = a >= b ?  1 : 0;
            4'b1110 :result = b;  
            default:;
        endcase
    end
endmodule