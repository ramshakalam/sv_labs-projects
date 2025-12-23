interface counter_if;
  logic clk;
  logic reset;
  logic load;
  logic enable;
  logic inc;
  logic dec;
  logic done;
  logic [31:0] count;
  logic [31:0] din;

  modport dut (
    input clk, reset, load, enable, inc, dec, din,
    output count, done
  );

  modport tb (
    input count, done,
    output clk, reset, load, enable, inc, dec, din
  );
endinterface
