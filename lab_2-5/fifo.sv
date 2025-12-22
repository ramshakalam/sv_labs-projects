module fifo(clk,rst,din,pop,push, dout,empty,full,dump);
  parameter DW = 32;
  parameter AW = 9;
  parameter RS = 512;

  // Port Declarations
  input clk;
  input rst;
  input pop;
  input push;
  input dump;
  input [DW-1:0] din;
  output full;
  output empty;
  output [DW-1:0] dout;

  logic [DW-1:0] mem [RS];
  logic valid_rd;
  logic valid_wr;
  logic empty;
  logic dump;
  reg [AW-1:0] wr_ptr;
  reg [AW-1:0] rd_ptr;
  reg [AW:0] cnt;
  reg [DW-1:0] dout;

  task shmem();
    $write ("MEMDUMP:@@%0d ",$time);
    for (int i=0; i<512; i++) $write ("%0d:%0h, ",i, mem[i]);
    $write ("\n");
  endtask

  always @(dump) begin
    if(dump === 1'b1) begin
      shmem();
    end
  end

  assign full = (cnt == RS);
  assign empty = (cnt == 0)||(pop&&cnt==1);
  assign valid_rd = pop ;
  assign valid_wr = push ;

  always @ (posedge clk) begin
    wr_ptr <= rst ? 0 : valid_wr ? wr_ptr +1 : wr_ptr;
  end

  always @(posedge clk) begin
    if (valid_wr) begin
      mem[wr_ptr] <= din;
    end
  end

  always @* dout = pop ? mem[rd_ptr] : 32'hx;

  always @ (posedge clk) begin
    rd_ptr <= rst ? 0 : valid_rd ? rd_ptr + 1 : rd_ptr;
  end

  always @ (posedge clk) begin
    cnt <= rst ? 10'd0 : pop & ~push ? cnt - 10'd1 : push & ~pop ? cnt + 10'd1 : cnt;
  end
endmodule