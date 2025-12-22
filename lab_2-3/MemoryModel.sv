class MemoryModel;
  // 4 banks x 16K x 47-bit
  logic [46:0] mem [4][16384];

  function new();
    $display("\n=== Memory Model Initialized (4 banks x 16K x 47-bit) ===\n");
    for (int b = 0; b < 4; b++)
      for (int r = 0; r < 16384; r++)
        mem[b][r] = '0;
  endfunction

  // Write task - only writes if strobe high
  task automatic write_mem(input logic wr_strobe, input logic [15:0] wr_addr, input logic [46:0] wr_data);
    if (wr_strobe) begin
      int bank = wr_addr[15:14];
      int row = wr_addr[13:0];
      mem[bank][row] = wr_data;
      $display("[%0t] WRITE → addr=%04h bank=%0d row=%0d data=%012h", $time, wr_addr, bank, row, wr_data);
    end else begin
      $display("[%0t] WRITE IGNORED - wr_strobe low", $time);
    end
  endtask

  // Read task - only returns data if strobe high, with 5ns delay
  task automatic read_mem(input logic rd_strobe, input logic [15:0] rd_addr, output logic [46:0] rd_data);
    if (rd_strobe) begin
      int bank = rd_addr[15:14];
      int row = rd_addr[13:0];
      #5;  // 5ns delay as per spec
      rd_data = mem[bank][row];
      $display("[%0t] READ → addr=%04h bank=%0d row=%0d data=%012h", $time, rd_addr, bank, row, rd_data);
    end else begin
      rd_data = 'x;
      $display("[%0t] READ IGNORED - rd_strobe low", $time);
    end
  endtask

endclass