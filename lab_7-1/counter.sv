module counter (
  counter_if.dut cif
);

  always @(posedge cif.clk) begin
    if (cif.reset) begin
      cif.count <= 0;
      cif.done <= 0;
    end else if (cif.load) begin
      cif.count <= cif.din;
      cif.done <= 0;
    end else if (cif.enable) begin
      if (cif.inc) cif.count <= cif.count + 1;
      if (cif.dec) cif.count <= cif.count - 1;
      cif.done <= (cif.count == cif.din);
    end
  end

endmodule
