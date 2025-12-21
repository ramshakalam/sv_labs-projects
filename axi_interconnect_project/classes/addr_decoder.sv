class add_decoder;

    function bit [3:0] decocde(bit [31:0] addr);
        case(addr [31:28])
            4 'h0: decocde= 4'd0;
            4 'h1: decocde= 4'd1;
            4 'h2: decocde= 4'd2;
            4 'h3: decocde= 4'd3;
            default: decocde= 4'd15;
        endcase
    endfunction
endclass