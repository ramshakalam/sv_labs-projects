module test();
  counter_if cif();

  // DUT
  counter dut(cif.dut);

  // Clock generation
  initial begin
    cif.clk = 0;
    forever #5 cif.clk = ~cif.clk;
  end

  // Tasks
  task reset_ctr();
    cif.reset = 1;
    cif.enable = 0;
    cif.load = 0;
    cif.inc = 0;
    cif.dec = 0;
    #20;
    cif.reset = 0;
    #20;
    $display("Reset complete: count = %0d", cif.count);
  endtask

  task ld_ctr(logic [31:0] value);
    cif.din = value;
    cif.load = 1;
    #10;
    cif.load = 0;
    $display("Loaded count = %0d", cif.count);
  endtask

  initial begin
    $display("\n=== Lab 7-1: Interfaces  Counter Testbench ===\n");

    reset_ctr();

    ld_ctr(160);

    cif.enable = 1;
    cif.inc = 1;
    repeat (10) @(posedge cif.clk);
    cif.inc = 0;
    cif.dec = 1;
    repeat (25) @(posedge cif.clk);
    cif.dec = 0;

    #40;
    if (cif.done)
      $display("SUCCESS: Counter reached target");
    else
      $display("ERROR: Ctr did not dec");

    #100 $finish;
  end

endmodule
