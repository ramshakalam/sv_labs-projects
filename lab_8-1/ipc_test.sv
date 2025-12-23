module test;

  // Fixed: Use 'memory' instead of 'buf'
  reg [7:0] memory [512];
  bit [8:0] addr_a, addr_b;
  bit [7:0] d_a, d_b;

  // Semaphore for arbitration between wr_a and wr_b
  semaphore buf_sem = new(1);  // Only one writer at a time

  // Clock generation
  bit clk = 0;
  always #5 clk = ~clk;

  // Writer task A
  task wr_a(bit [8:0] addr, bit [7:0] d);
    buf_sem.get(1);  // Acquire semaphore
    memory[addr] = d;
    $display("[%0t] wr_a: addr=%0d data=%0h", $time, addr, d);
    buf_sem.put(1);  // Release semaphore
  endtask

  // Writer task B
  task wr_b(bit [8:0] addr, bit [7:0] d);
    buf_sem.get(1);  // Acquire semaphore
    memory[addr] = d;
    $display("[%0t] wr_b: addr=%0d data=%0h", $time, addr, d);
    buf_sem.put(1);  // Release semaphore
  endtask

  // Reader task
  task rd();
    bit [8:0] addr;
    bit [7:0] data;
    addr = $urandom_range(0,511);
    data = memory[addr];
    $display("[%0t] rd: addr=%0d data=%0h", $time, addr, data);
  endtask

  // Process A: Writer A
  task proc_a();
    repeat (10) begin
      addr_a = $urandom_range(0,511);
      d_a = $urandom();
      wr_a(addr_a, d_a);
      @(posedge clk);
    end
  endtask

  // Process B: Writer B
  task proc_b();
    repeat (10) begin
      addr_b = $urandom_range(0,511);
      d_b = $urandom();
      wr_b(addr_b, d_b);
      @(posedge clk);
    end
  endtask

  // Process C: Reader
  task proc_c();
    repeat (20) begin
      rd();
      @(posedge clk);
    end
  endtask

  initial begin
    $display("\n=== Lab 8-1: Inter-process Communication with Semaphore ===\n");

    fork
      proc_a();
      proc_b();
      proc_c();
    join_none

    #500 $finish;
  end

endmodule
