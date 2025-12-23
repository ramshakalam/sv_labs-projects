covergroup pkt_size_cg (ref bit [15:0] len_ref);
  coverpoint len_ref {
    bins size_64   = {64};
    bins size_128  = {128};
    bins size_192  = {192};
    bins size_256  = {256};
    bins size_512  = {512};
    bins size_768  = {768};
    bins size_1024 = {1024};
    bins size_1518 = {1518};
  }

  function void print_bin_coverage();
    $display("64 bytes:    %0.2f%%", size_64.get_coverage());
    $display("128 bytes:   %0.2f%%", size_128.get_coverage());
    $display("192 bytes:   %0.2f%%", size_192.get_coverage());
    $display("256 bytes:   %0.2f%%", size_256.get_coverage());
    $display("512 bytes:   %0.2f%%", size_512.get_coverage());
    $display("768 bytes:   %0.2f%%", size_768.get_coverage());
    $display("1024 bytes:  %0.2f%%", size_1024.get_coverage());
    $display("1518 bytes:  %0.2f%%", size_1518.get_coverage());
  endfunction
endgroup
