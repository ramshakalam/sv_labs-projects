`timescale 1ms/1us

class Wallclock;
  // Data members
  int hours;
  int minutes;
  int seconds;

  // Constructor
  function new();
    hours = 0;
    minutes = 0;
    seconds = 0;
  endfunction

  // Method to update time (called on each tick)
  function void update();
    seconds++;
    if (seconds >= 60) begin
      seconds = 0;
      minutes++;
      if (minutes >= 60) begin
        minutes = 0;
        hours++;
        if (hours >= 24) hours = 0;
      end
    end
  endfunction

  // Method to display time in hh:mm:ss
  function void display();
    $display("%02d:%02d:%02d", hours, minutes, seconds);
  endfunction
endclass

module test();
  logic time_tick;
  Wallclock clock = new();

  // Generate time_tick every 1ms
  initial begin
    time_tick = 0;
    forever begin
      #0.5ms time_tick = ~time_tick;  // Toggle every 0.5ms to make full 1ms cycle
    end
  end

  // Update and display on each positive edge of time_tick
  always @(posedge time_tick) begin
    clock.update();
    clock.display();
  end

  initial begin
    $display("\n=== Lab 5-1: Wall Clock Simulation ===\n");
    #500ms $finish;  // Run for 500 seconds (500,000 ticks)
  end
endmodule
