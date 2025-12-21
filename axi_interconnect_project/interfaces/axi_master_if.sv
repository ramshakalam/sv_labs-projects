interface axi_master_if(input bit ACLK, input bit ARESETn);

    // WRITE ADDRESS
    bit        AWVALID;
    bit        AWREADY;
    bit [31:0] AWADDR;
    bit [3:0]  AWID;

    // WRITE DATA
    bit        WVALID;
    bit        WREADY;
    bit [31:0] WDATA;
    bit        WLAST;

    // WRITE RESPONSE
    bit        BVALID;
    bit        BREADY;
    bit [1:0]  BRESP;
    bit [3:0]  BID;

    // READ ADDRESS
    bit        ARVALID;
    bit        ARREADY;
    bit [31:0] ARADDR;
    bit [3:0]  ARID;

    // READ DATA
    bit        RVALID;
    bit        RREADY;
    bit [31:0] RDATA;
    bit        RLAST;
    bit [3:0]  RID;

endinterface