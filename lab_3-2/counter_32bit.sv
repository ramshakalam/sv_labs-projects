module counter_32bit (
  input  logic        clk,
  input  logic        reset,
  input  logic        enable,
  input  logic [2:0]  mode,        // 0: +1, 1: +2, ..., 7: +8
  input  logic        up_down,     // 1: up, 0: down
  input  logic        load,
  input  logic [31:0] din,         // load value
  input  logic [31:0] sat_count,   // saturation value (for up count)
  output logic [31:0] count,
  output logic        timer_event
);

  logic [31:0] next_count;
  logic timer_next;

  always_comb begin
    if (load) begin
      next_count = din;
      timer_next = 0;
    end else if (!enable) begin
      next_count = count;
      timer_next = 0;
    end else if (up_down) begin
      // Count up
      next_count = count + (mode + 1);
      timer_next = (next_count >= sat_count);
      if (timer_next) next_count = sat_count;
    end else begin
      // Count down
      next_count = count - (mode + 1);
      timer_next = (next_count <= 0);
      if (timer_next) next_count = 0;
    end
  end

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 0;
      timer_event <= 0;
    end else begin
      count <= next_count;
      timer_event <= timer_next;
    end
  end

endmodule
