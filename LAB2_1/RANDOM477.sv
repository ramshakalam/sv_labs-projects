module random_477bit;
  function automatic logic [476:0] rand477();
    logic [479:0] tmp;
    tmp = {$urandom, $urandom, $urandom, $urandom,
           $urandom, $urandom, $urandom, $urandom,
           $urandom, $urandom, $urandom, $urandom,
           $urandom, $urandom, $urandom};
    return tmp[476:0];
  endfunction

  initial begin
    automatic logic [476:0] num = rand477();
    logic [31:0] word;
    int hi, lo;
    $display("\n=== 477-bit Random Number ===\n");

    for (int i = 14; i >= 0; i--) begin
      word = num[i*32 +: 32];  
      hi = (i == 14) ? 476 : i*32 + 31;
      lo = i*32;
      $display("Word %02d [%4d:%4d] = 0x%08h", i, hi, lo, word);
    end

    #10 $finish;
  end
endmodule
