module updown_ctr (
  input clk, reset, load, up, enable,
  input [31:0] din,
  output [31:0] count
);
  reg [31:0] count;

  always @(posedge clk) begin
    if (reset)
      count <= 0;
    else if (load)
      count <= din;
    else if (enable && up)
      count <= count + 1;
    else if (enable && ~up)
      count <= count - 1;
  end
endmodule
