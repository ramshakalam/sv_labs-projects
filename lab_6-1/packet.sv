class Packet;
  // Fields
  rand bit [47:0] destination;  // 48-bit random destination
  rand bit [47:0] source;       // 48-bit random source
  rand bit [15:0] length;       // 16-bit length field
  rand bit [7:0] payload[];     // dynamic array for payload (0-1500 bytes)
  bit [31:0] crc;               // CRC (not calculated)

  // Constraint: total length 64 to 1518 bytes
  constraint valid_length_c {
    length inside {[64:1518]};
  }

  // Constraint: payload size = length - 18 
  constraint payload_size_c {
    payload.size() == length - 18;
    payload.size() inside {[0:1500]};
  }

  // Constraint: bursty generation - higher probability of short packets
  constraint bursty_c {
    length dist {
      [64:256]    := 50,   // 50% very short
      [257:512]   := 30,   // 30% short
      [513:1024]  := 15,   // 15% medium
      [1025:1518] := 5     // 5% long
    };
  }

  // Constructor
  function new();
    payload = new[0];  // initialize empty payload
  endfunction

  // Display method
  function void display();
    $display("=== Generated Packet ===");
    $display("Destination : %12h", destination);
    $display("Source      : %12h", source);
    $display("Length      : %0d bytes", length);
    $display("Payload size: %0d bytes", payload.size());
    $display("CRC         : %08h (not calculated)", crc);
    $display("==========================");
  endfunction
endclass

module test();
  initial begin
    Packet pkt;
    int num_packets = 20;

    $display("\n=== Lab 6-1: Random Packet Generation with Constraints ===\n");

    repeat (num_packets) begin
      pkt = new();
      if (pkt.randomize()) begin
        pkt.display();
      end else begin
        $display("ERROR: Randomization failed!");
      end
      #1;
    end

    $display("\nSimulation complete - %0d packets generated!", num_packets);
    #10 $finish;
  end
endmodule
