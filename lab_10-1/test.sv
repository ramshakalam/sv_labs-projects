`timescale 1ns/1ps

//------------------- Covergroup declaration -------------------
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
endgroup

//------------------- Testbench -------------------
module test;
  packet pkt_gen;
  packet pkt;
  pkt_size_cg cg;        // covergroup instance
  bit [15:0] cg_len;     // reference variable for covergroup

  initial begin
    cg = new(cg_len);    // instantiate covergroup

    $display("\n=== Packet Size Coverage Test ===\n");

    pkt_gen = new(0);

    repeat (50000) begin
      pkt = pkt_gen.gen();
      if (pkt != null) begin
        cg_len = pkt.len;
        cg.sample();
      end
    end

    $display("Total coverage: %0.2f%%", cg.get_coverage());

    #10 $finish;
  end
endmodule

