module test ();

  parameter DW = 32;
  parameter AW = 9;
  parameter RS = 512;

  logic pop;
  logic push;
  logic [31:0] dout;
  logic [31:0] din;
  logic empty, full;
  logic rst;
  logic clk;

  // reference FIFO
  logic [31:0] refq [$];

  logic [31:0] rd_data, wr_data;

  fifo dut (.clk(clk),.rst(rst),.dump(dump), .din(din),.dout(dout),.push(push), .pop(pop),.empty(empty),.full(full));

  initial begin
    clk = 1'b0;
    wr_data = $urandom();
    reset_fifo();
    repeat ($urandom()%16) @(posedge clk);
    wr_data = 32'h10;
    wr(wr_data++);
    wr(wr_data++);
    repeat ($urandom()%16) @(posedge clk);
    rd(rd_data);
    rd(rd_data);
    @(posedge clk);
    repeat (1000) @(posedge clk);
    $finish;
  end

  //generate a clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Tasks to fill (as required)
  task reset_fifo ();
    rst = 1;
    push = 0;
    pop = 0;
    din = '0;
    refq.delete();
    #20;  // hold reset
    rst = 0;
    #20;  // wait after deassert
    if (!empty || full) $display("ERROR: Reset failed - empty=%0b full=%0b", empty, full);
    else $display("Reset OK: empty=%0b full=%0b", empty, full);
  endtask

  task wr (logic [31:0] wd);
    din = wd;
    push = 1;
    #10;  // one cycle
    push = 0;
    refq.push_back(wd);  // add to reference queue
    $display("WR: %0h", wd);
  endtask

  task rd(output logic [31:0] rd);
    pop = 1;
    #10;  // one cycle
    pop = 0;
    rd = dout;
    if (refq.size() > 0) begin
      if (rd != refq[0]) $display("ERROR: dout=%0h expected=%0h", rd, refq[0]);
      refq.delete(0);
    end else begin
      $display("ERROR: Reading empty FIFO");
    end
    $display("RD: %0h", rd);
  endtask

endmodule