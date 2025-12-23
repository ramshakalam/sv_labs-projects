`timescale 1ns / 1ps

module your_module;
  // your code
endmodule
module test ();
  logic clk;
  logic reset;
  logic load;
  logic [31:0] din;
  logic up_down;
  logic enable;
  logic [31:0] count;

  updown_ctr dut (
    .clk(clk),
    .reset(reset),
    .load(load),
    .din(din),
    .up(up_down),
    .enable(enable),
    .count(count)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Tasks to fill 
  task reset_ctr();
    reset = 1;
    load = 0;
    enable = 0;
    up_down = 0;
    din = '0;
    #20;  // hold reset
    reset = 0;
    #20;  // wait after deassert
    $display("Reset complete: count = %0d", count);
  endtask

  task ld_data(logic [31:0] din);
    load = 1;
    din = din;
    #10;  // one cycle
    load = 0;
    $display("Loaded din = %0d, count = %0d", din, count);
  endtask

  task count_up();
    up_down = 1;
    enable = 1;
    $display("Counting up enabled");
  endtask

  task start();
    enable = 1;
    $display("Counter started");
  endtask

  initial begin
    reset_ctr();

    // Test 1: Load value
    ld_data(32'h00001234);

    // Test 2: Count up
    count_up();
    start();

    repeat (10) @(posedge clk);
    $display("Count after 10 cycles up: %0d", count);

    // Test 3: Load new value during count
    ld_data(32'h0000ABCD);

    repeat (5) @(posedge clk);
    $display("Count after load and 5 cycles: %0d", count);

    #100 $finish;
  end

endmodule
