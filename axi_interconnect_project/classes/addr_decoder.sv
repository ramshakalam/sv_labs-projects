class addr_decoder;

    function bit [3:0] decode(bit [31:0] addr);
        case(addr [31:28])
            4 'h0: decode= 4'd0;
            4 'h1: decode= 4'd1;
            4 'h2: decode= 4'd2;
            4 'h3: decode= 4'd3;
            default: decode= 4'd15;
        endcase
    endfunction
endclass