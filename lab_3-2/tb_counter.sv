
`timescale 1ns / 1ps

module your_module;
  // your code
endmodulemodule tb_counter;

  logic clk = 0;
  logic reset;
  logic enable;
  logic [2:0] mode;
  logic up_down;
  logic load;
  logic [31:0] din;
  logic [31:0] sat_count;
  logic [31:0] count;
  logic timer_event;

  counter_32bit dut (.*);

  always #5 clk = ~clk;

  initial begin
    $display("\n=== Lab 3-2: 32-bit Counter Testbench ===\n");

    // Initial reset
    reset = 1;
    enable = 0;
    load = 0;
    #20;
    reset = 0;

    // Test 1: Count up in steps 1 to 8
    $display("Test 1: Count up in steps 1 to 8");
    enable = 1;
    up_down = 1;
    sat_count = 100;
    for (int m = 0; m < 8; m++) begin
      mode = m;
      #50;  // 5 counts
      $display("Mode %0d: count = %0d", m, count);
    end

    // Reset before Test 2
    reset = 1;
    #20;
    reset = 0;
    $display("\nTest 2: Count down to 0");
    enable = 1;
    up_down = 0;
    mode = 0;
    load = 1;
    din = 50;  // Load starting value
    #10;
    load = 0;
    #500;  // let it count down
    $display("Count down to 0: timer_event = %0b, final count = %0d", timer_event, count);

    // Reset before Test 3
    reset = 1;
    #20;
    reset = 0;
    $display("\nTest 3: Load new value");
    load = 1;
    din = 123456;
    #10;
    load = 0;
    $display("Loaded count = %0d", count);

    // Reset before Test 4
    reset = 1;
    #20;
    reset = 0;
    $display("\nTest 4: Saturation in up count");
    enable = 1;
    up_down = 1;
    mode = 0;
    sat_count = 200;
    #2000;  // let it reach sat
    $display("Saturation test: count = %0d, timer_event = %0b", count, timer_event);

    #100 $finish;
  end

  always @(posedge clk) begin
    if (timer_event)
      $display("[%0t] TIMER EVENT asserted!", $time);
  end

endmodule
