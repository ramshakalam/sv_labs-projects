class packet;
  rand bit [47:0] dest;
  rand bit [47:0] src;
  rand bit [15:0] len;
  rand bit [7:0] payld [$];
  rand bit [31:0] crc;
  int cnt;

  constraint len_lim {
    payld.size() inside {[0:1500]};
  }

  constraint pktc {
    len == (payld.size()+18);
    dest inside {[24:48]};
    src inside {[256:292]};
  }

  function new (int cnt);
    this.cnt = cnt;
  endfunction

  function bit [31:0] calc_crc();
  endfunction

  function packet gen();
    packet pkt;
    pkt = new(cnt);
    if (!pkt.randomize()) 
      $display ("Randomization Error\n");
    else 
      return pkt;
  endfunction
endclass
