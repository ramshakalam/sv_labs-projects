`timescale 1ns/1ps

module tb_axi_interconnect_parallel;

    //-----------------------------
    // Clock & Reset
    //-----------------------------
    bit ACLK = 0;
    bit ARESETn = 0;
    always #5 ACLK = ~ACLK;

    //-----------------------------
    // Interfaces
    //-----------------------------
    axi_master_if m_if[4](ACLK, ARESETn);
    axi_slave_if  s_if[4](ACLK, ARESETn);

    //-----------------------------
    // Interconnect object
    //-----------------------------
    axi_interconnect ic;

    //-----------------------------
    // Waveform
    //-----------------------------
    initial begin
        $dumpfile("wave_parallel.vcd");
        $dumpvars(0, tb_axi_interconnect_parallel);
    end

    //-----------------------------
    // Reset & init
    //-----------------------------
    initial begin
        foreach (m_if[i]) begin
            m_if[i].AWVALID = 0;
            m_if[i].WVALID  = 0;
            m_if[i].BREADY  = 1;
            m_if[i].ARVALID = 0;
            m_if[i].RREADY  = 1;
        end

        ARESETn = 0;
        #20 ARESETn = 1;
    end

    //-----------------------------
    // Master stimulus
    //-----------------------------
    initial begin
        @(posedge ARESETn);

        // ---- Parallel writes to different slaves
        m_if[0].AWVALID = 1; m_if[0].AWADDR = 32'h0000_0000; m_if[0].AWID = 0;
        m_if[1].AWVALID = 1; m_if[1].AWADDR = 32'h1000_0000; m_if[1].AWID = 1;
        m_if[2].AWVALID = 1; m_if[2].AWADDR = 32'h2000_0000; m_if[2].AWID = 2;
        m_if[3].AWVALID = 1; m_if[3].AWADDR = 32'h3000_0000; m_if[3].AWID = 3;

        m_if[0].WVALID = 1; m_if[0].WDATA = 32'hAAAA_0000; m_if[0].WLAST = 1;
        m_if[1].WVALID = 1; m_if[1].WDATA = 32'hBBBB_1111; m_if[1].WLAST = 1;
        m_if[2].WVALID = 1; m_if[2].WDATA = 32'hCCCC_2222; m_if[2].WLAST = 1;
        m_if[3].WVALID = 1; m_if[3].WDATA = 32'hDDDD_3333; m_if[3].WLAST = 1;

        @(posedge ACLK);
        foreach (m_if[i]) begin
            m_if[i].AWVALID = 0;
            m_if[i].WVALID  = 0;
        end

        // ---- Parallel reads
        #20;
        foreach (m_if[i]) begin
            m_if[i].ARVALID = 1;
            m_if[i].ARADDR  = i << 28;
            m_if[i].ARID    = i;
        end

        @(posedge ACLK);
        foreach (m_if[i]) m_if[i].ARVALID = 0;

        // ---- Multiple masters → same slave (RR arbitration)
        #20;
        m_if[0].AWVALID = 1; m_if[0].AWADDR = 32'h0000_0100; m_if[0].AWID = 0;
        m_if[1].AWVALID = 1; m_if[1].AWADDR = 32'h0000_0200; m_if[1].AWID = 1;

        m_if[0].WVALID = 1; m_if[0].WDATA = 32'h1111_1111; m_if[0].WLAST = 1;
        m_if[1].WVALID = 1; m_if[1].WDATA = 32'h2222_2222; m_if[1].WLAST = 1;

        @(posedge ACLK);
        m_if[0].AWVALID = 0; m_if[0].WVALID = 0;
        m_if[1].AWVALID = 0; m_if[1].WVALID = 0;

        #200 $finish;
    end

    //-----------------------------
    // Slave model
    //-----------------------------
    initial begin
        foreach (s_if[i]) begin
            s_if[i].AWREADY = 1;
            s_if[i].WREADY  = 1;
            s_if[i].ARREADY = 1;
            s_if[i].BVALID  = 0;
            s_if[i].RVALID  = 0;
        end

        forever begin
            @(posedge ACLK);
            foreach (s_if[i]) begin

                // Write response
                if (s_if[i].AWVALID && s_if[i].WVALID) begin
                    s_if[i].BVALID <= 1;
                    s_if[i].BID    <= s_if[i].AWID;
                    s_if[i].BRESP  <= 2'b00;
                end else if (s_if[i].BREADY) begin
                    s_if[i].BVALID <= 0;
                end

                // Read response
                if (s_if[i].ARVALID) begin
                    s_if[i].RVALID <= 1;
                    s_if[i].RID    <= s_if[i].ARID;
                    s_if[i].RDATA  <= 32'h1000_0000 + i;
                    s_if[i].RLAST  <= 1;
                end else if (s_if[i].RREADY) begin
                    s_if[i].RVALID <= 0;
                end

            end
        end
    end

    //-----------------------------
    // Interconnect start
    //-----------------------------
    initial begin
        ic = new(m_if, s_if, ACLK, ARESETn);
        fork
            ic.run();
        join_none
    end

endmodule
