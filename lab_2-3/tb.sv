`timescale 1ns / 1ps

module your_module;
  // your code
endmodule
module tb;
  logic [46:0] data;
  logic clk = 0;
  always #5 clk = ~clk;

  MemoryModel mem_model = new();

  initial begin
    $display("\n=== Lab 2-3: 47-bit x 64K 4-Bank Memory Model Testbench ===\n");

    #20;

    // Test 1: Write with strobe high
    $display("Test 1: Writing to all 4 banks (strobe high)\n");
    mem_model.write_mem(1, 16'h0000, 47'h123456789ABCD); // Bank 0
    mem_model.write_mem(1, 16'h4000, 47'hDEADBEEF1234);  // Bank 1
    mem_model.write_mem(1, 16'h8000, 47'h555555555555);  // Bank 2
    mem_model.write_mem(1, 16'hC000, 47'hCAFEBABE0000);  // Bank 3

    // Test 2: Write with strobe low - should be ignored
    $display("\nTest 2: Write with strobe low (ignored)\n");
    mem_model.write_mem(0, 16'h0001, 47'h999999999999);  // Should NOT write

    // Test 3: Read with strobe high
    $display("\nTest 3: Reading from all 4 banks (strobe high)\n");
    mem_model.read_mem(1, 16'h0000, data); // Bank 0
    mem_model.read_mem(1, 16'h4000, data); // Bank 1
    mem_model.read_mem(1, 16'h8000, data); // Bank 2
    mem_model.read_mem(1, 16'hC000, data); // Bank 3

    // Test 4: Read with strobe low - should be ignored
    $display("\nTest 4: Read with strobe low (ignored)\n");
    mem_model.read_mem(0, 16'h0000, data); // Should return 'x or ignore

    #50;
    $display("\nSimulation complete!");
    $finish;
  end
endmodule
