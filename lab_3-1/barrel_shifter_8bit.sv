module barrel_shifter_8bit(
  input logic [7:0] data,
  input logic [2:0] amt,
  output logic [7:0] out
);

  always_comb begin
    case (amt)
      3'd0: out = data;
      3'd1: out = {data[0], data[7:1]};
      3'd2: out = {data[1:0], data[7:2]};
      3'd3: out = {data[2:0], data[7:3]};
      3'd4: out = {data[3:0], data[7:4]};
      3'd5: out = {data[4:0], data[7:5]};
      3'd6: out = {data[5:0], data[7:6]};
      3'd7: out = {data[6:0], data[7]};
      default: out = {data[6:0], data[7]};
    endcase
  end
endmodule