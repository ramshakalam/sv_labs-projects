class axi_interconnect;

    bit ACLK;
    bit ARESETn;

    axi_master_if master_if[4];
    axi_slave_if  slave_if [4];
    addr_decoder decoders[4];
    rr_arbiter   arbiters[4];
    id_entry id_table[$];

    function new(
        axi_master_if m_if[4],
        axi_slave_if  s_if[4],
        bit clk,
        bit rst_n
    );
        master_if = m_if;
        slave_if  = s_if;
        ACLK      = clk;
        ARESETn   = rst_n;

        foreach (decoders[i])
            decoders[i] = new();

        foreach (arbiters[i])
            arbiters[i] = new();
    endfunction

    // Run all channels
    task run();
        fork
            handle_write();
            handle_read();
            handle_response();
        join
    endtask

    // Handle Write Path
    task handle_write();
        bit [3:0] target_slave[4];
        bit slave_req[4][4];
        int win_master;

        forever begin
            @(posedge ACLK);
            if (!ARESETn)
                continue;

            // Decode write addresses
            foreach(master_if[m]) begin
                if (master_if[m].AWVALID)
                    target_slave[m] = decoders[m].decode(master_if[m].AWADDR);
            end

            // Build request matrix
            foreach(slave_req[s][m])
                slave_req[s][m] = 0;

            foreach(master_if[m]) begin
                if (master_if[m].AWVALID)
                    slave_req[target_slave[m]][m] = 1;
            end

            // Arbitration per slave
            foreach(slave_if[s]) begin
                win_master = arbiters[s].grant(slave_req[s]);

                if (win_master >= 0) begin
                    // Route AW channel
                    slave_if[s].AWVALID = master_if[win_master].AWVALID;
                    slave_if[s].AWADDR  = master_if[win_master].AWADDR;
                    slave_if[s].AWID    = master_if[win_master].AWID;
                    master_if[win_master].AWREADY = slave_if[s].AWREADY;

                    // Route W channel
                    slave_if[s].WVALID = master_if[win_master].WVALID;
                    slave_if[s].WDATA  = master_if[win_master].WDATA;
                    slave_if[s].WLAST  = master_if[win_master].WLAST;
                    master_if[win_master].WREADY = slave_if[s].WREADY;

                    // Capture ID for response
                    if (slave_if[s].AWREADY && master_if[win_master].AWVALID) begin
                        id_entry entry = new();
                        entry.id        = master_if[win_master].AWID;
                        entry.master_id = win_master;
                        entry.slave_id  = s;
                        entry.is_read   = 0;
                        id_table.push_back(entry);
                    end
                end
            end
        end
    endtask

    // Handle Read Path
    task handle_read();
        int m,s,granted_master;
        forever begin
            @(posedge ACLK);
            if (!ARESETn)
                continue;

            // Decode and arbitrate
            foreach(s_slave[s]) begin
                bit request[4];
                foreach(master_if[m])
                    request[m] = master_if[m].ARVALID && (decoders[m].decode(master_if[m].ARADDR)==s);

                granted_master = arbiters[s].grant(request);
                if (granted_master >=0) begin
                    m = granted_master;
                    slave_if[s].ARADDR  = master_if[m].ARADDR;
                    slave_if[s].ARID    = master_if[m].ARID;
                    slave_if[s].ARVALID = 1;
                    master_if[m].ARREADY = slave_if[s].ARREADY;

                    if (slave_if[s].ARREADY && master_if[m].ARVALID) begin
                        id_entry entry = new();
                        entry.id        = master_if[m].ARID;
                        entry.master_id = m;
                        entry.slave_id  = s;
                        entry.is_read   = 1;
                        id_table.push_back(entry);
                    end
                end
            end
        end
    endtask

    // Handle Response (R & B)
    task handle_response();
        int i;
        forever begin
            @(posedge ACLK);
            if (!ARESETn)
                continue;

            // Write response
            foreach(id_table[i]) begin
                if (!id_table[i].is_read) begin
                    int m = id_table[i].master_id;
                    int s = id_table[i].slave_id;
                    if (slave_if[s].BVALID) begin
                        master_if[m].BRESP  = slave_if[s].BRESP;
                        master_if[m].BID    = slave_if[s].BID;
                        master_if[m].BVALID = 1;
                        slave_if[s].BREADY  = master_if[m].BREADY;
                    end
                end
            end

            // Read response
            foreach(id_table[i]) begin
                if (id_table[i].is_read) begin
                    int m = id_table[i].master_id;
                    int s = id_table[i].slave_id;
                    if (slave_if[s].RVALID) begin
                        master_if[m].RDATA  = slave_if[s].RDATA;
                        master_if[m].RID    = slave_if[s].RID;
                        master_if[m].RLAST  = slave_if[s].RLAST;
                        master_if[m].RVALID = 1;
                        slave_if[s].RREADY  = master_if[m].RREADY;
                    end
                end
            end
        end
    endtask

endclass