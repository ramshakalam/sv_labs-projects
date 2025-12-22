//`timescale 1ns/1ps

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
genvar gi;
generate
    for (gi = 0; gi < 4; gi++) begin : INIT_MASTERS
        initial begin
            m_if[gi].AWVALID = 0;
            m_if[gi].WVALID  = 0;
            m_if[gi].BREADY  = 1;
            m_if[gi].ARVALID = 0;
            m_if[gi].RREADY  = 1;
        end
    end
endgenerate

initial begin
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
m_if[0].AWVALID = 0; m_if[0].WVALID = 0;
m_if[1].AWVALID = 0; m_if[1].WVALID = 0;
m_if[2].AWVALID = 0; m_if[2].WVALID = 0;
m_if[3].AWVALID = 0; m_if[3].WVALID = 0;


        // ---- Parallel reads
#20;
m_if[0].ARVALID = 1; m_if[0].ARADDR = 32'h0000_0000; m_if[0].ARID = 0;
m_if[1].ARVALID = 1; m_if[1].ARADDR = 32'h1000_0000; m_if[1].ARID = 1;
m_if[2].ARVALID = 1; m_if[2].ARADDR = 32'h2000_0000; m_if[2].ARID = 2;
m_if[3].ARVALID = 1; m_if[3].ARADDR = 32'h3000_0000; m_if[3].ARID = 3;


@(posedge ACLK);
m_if[0].ARVALID = 0;
m_if[1].ARVALID = 0;
m_if[2].ARVALID = 0;
m_if[3].ARVALID = 0;


        // ---- Multiple masters_same slave (RR arbitration)
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
genvar sj;
generate
    for (sj = 0; sj < 4; sj++) begin : SLAVE_MODEL

        // -----------------
        // Initialization
        // -----------------
        initial begin
            s_if[sj].AWREADY = 1;
            s_if[sj].WREADY  = 1;
            s_if[sj].ARREADY = 1;
            s_if[sj].BVALID  = 0;
            s_if[sj].RVALID  = 0;
        end

        // -----------------
        // Runtime behavior
        // -----------------
        always @(posedge ACLK) begin

            // Write response
            if (s_if[sj].AWVALID && s_if[sj].WVALID) begin
                s_if[sj].BVALID <= 1;
                s_if[sj].BID    <= s_if[sj].AWID;
                s_if[sj].BRESP  <= 2'b00;
            end
            else if (s_if[sj].BREADY) begin
                s_if[sj].BVALID <= 0;
            end

            // Read response
            if (s_if[sj].ARVALID) begin
                s_if[sj].RVALID <= 1;
                s_if[sj].RID    <= s_if[sj].ARID;
                s_if[sj].RDATA  <= 32'h1000_0000 + sj;
                s_if[sj].RLAST  <= 1;
            end
            else if (s_if[sj].RREADY) begin
                s_if[sj].RVALID <= 0;
            end

        end
    end
endgenerate


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
