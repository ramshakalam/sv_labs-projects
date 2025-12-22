module barrel_shifter_32bit(
  input logic [31:0] data,
  input logic [4:0] amt,
  output logic [31:0] out
);

  always_comb begin
    case (amt)
      5'd0:  out = data;
      5'd1:  out = {data[0], data[31:1]};
      5'd2:  out = {data[1:0], data[31:2]};
      5'd3:  out = {data[2:0], data[31:3]};
      5'd4:  out = {data[3:0], data[31:4]};
      5'd5:  out = {data[4:0], data[31:5]};
      5'd6:  out = {data[5:0], data[31:6]};
      5'd7:  out = {data[6:0], data[31:7]};
      5'd8:  out = {data[7:0], data[31:8]};
      5'd9:  out = {data[8:0], data[31:9]};
      5'd10: out = {data[9:0], data[31:10]};
      5'd11: out = {data[10:0], data[31:11]};
      5'd12: out = {data[11:0], data[31:12]};
      5'd13: out = {data[12:0], data[31:13]};
      5'd14: out = {data[13:0], data[31:14]};
      5'd15: out = {data[14:0], data[31:15]};
      5'd16: out = {data[15:0], data[31:16]};
      5'd17: out = {data[16:0], data[31:17]};
      5'd18: out = {data[17:0], data[31:18]};
      5'd19: out = {data[18:0], data[31:19]};
      5'd20: out = {data[19:0], data[31:20]};
      5'd21: out = {data[20:0], data[31:21]};
      5'd22: out = {data[21:0], data[31:22]};
      5'd23: out = {data[22:0], data[31:23]};
      5'd24: out = {data[23:0], data[31:24]};
      5'd25: out = {data[24:0], data[31:25]};
      5'd26: out = {data[25:0], data[31:26]};
      5'd27: out = {data[26:0], data[31:27]};
      5'd28: out = {data[27:0], data[31:28]};
      5'd29: out = {data[28:0], data[31:29]};
      5'd30: out = {data[29:0], data[31:30]};
      5'd31: out = {data[30:0], data[31]};
      default: out = data;
    endcase
  end
endmodule