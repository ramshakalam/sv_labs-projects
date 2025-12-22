`timescale 1ns / 10ps

module testbench;
  // For 8-bit
  logic [7:0] data8;
  logic [2:0] amt8;
  logic [7:0] out8;

  barrel_shifter_8bit dut8 ( .data(data8), .amt(amt8), .out(out8) );

  // For 32-bit
  logic [31:0] data32;
  logic [4:0] amt32;
  logic [31:0] out32;

  barrel_shifter_32bit dut32 ( .data(data32), .amt(amt32), .out(out32) );

  initial begin
    $display("\n=== Lab 3-1: 8-bit Barrel Shifter Testbench ===\n");

    // Exhaustive test for 8-bit
    logic [7:0] expected8;
    int error_count8 = 0;

    for (int d = 0; d < 256; d++) begin
      for (int a = 0; a < 8; a++) begin
        data8 = d;
        amt8 = a;
        #10;  // Wait for comb logic
        expected8 = (data8 >> a) | (data8 << (8 - a));  // Expected right circular shift
        if (out8 != expected8) error_count8++;
      end
    end

    $display("8-bit exhaustive test complete: Errors = %0d (of 2048 tests)", error_count8);
    $display("Why possible: 256 data x 8 shifts = 2048 cases – runs in seconds. Combinational logic, no state.");

    $display("\n=== Extension: 32-bit Barrel Shifter Testbench ===\n");

    // Random test for 32-bit (exhaustive impossible)
    logic [31:0] expected32;
    int error_count32 = 0;

    repeat (1000000) begin  // 1 million random tests – feasible
      data32 = $urandom();
      amt32 = $urandom_range(0,31);
      #10;
      expected32 = (data32 >> amt32) | (data32 << (32 - amt32));  // Expected right circular shift
      if (out32 != expected32) error_count32++;
    end

    $display("32-bit random test complete: Errors = %0d (of 1,000,000 tests)", error_count32);
    $display("Why not exhaustive: 2^32 data x 32 shifts = 137 billion cases – would take years to simulate.");

    $finish;
  end
endmodule