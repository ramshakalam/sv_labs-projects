class rr_arbiter;
    bit[1:0]rr_ptr;
    function int grant(bit request[4]);
        int i;
        for(i=0;i<4;i++)begin
            int idx= (rr_ptr+i)%4;
            if(request[idx])begin
                rr_ptr=(idx+1)%4;                   
                return idx;
            end
        end
        return-1;
    endfunction
endclass

        