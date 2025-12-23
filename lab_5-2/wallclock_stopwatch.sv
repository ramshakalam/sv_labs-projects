`timescale 1ms/1us

class WallClock;
  int hours;
  int minutes;
  int seconds;

  function new();
    hours = 0;
    minutes = 0;
    seconds = 0;
  endfunction

  function void tick();
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

  function void display();
    $display("%02d:%02d:%02d", hours, minutes, seconds);
  endfunction
endclass

class Stopwatch extends WallClock;
  bit running = 0;
  int lap_count = 0;
  int lap_times[$];               // lap times in seconds
  int total_start_seconds;        // total seconds at start
  int lap_start_seconds;          // total seconds at last lap/start

  function int get_total_seconds();
    return (hours * 3600) + (minutes * 60) + seconds;
  endfunction

  function void start();
    if (!running) begin
      running = 1;
      total_start_seconds = get_total_seconds();
      lap_start_seconds = total_start_seconds;
      $display("Stopwatch started at %02d:%02d:%02d (total sec = %0d)", hours, minutes, seconds, total_start_seconds);
    end
  endfunction

  function void stop();
    if (running) begin
      running = 0;
      $display("Stopwatch stopped at %02d:%02d:%02d (total sec = %0d)", hours, minutes, seconds, get_total_seconds());
    end
  endfunction

  function void lap();
    if (running) begin
      int current_total = get_total_seconds();
      int lap_time = current_total - lap_start_seconds;
      lap_times.push_back(lap_time);
      lap_count++;
      lap_start_seconds = current_total;
      $display("Lap %0d: %0d seconds (total time: %02d:%02d:%02d)", lap_count, lap_time, hours, minutes, seconds);
    end else begin
      $display("Stopwatch not running  cannot lap");
    end
  endfunction

  function void display_laps();
    $display("\nLap Times:");
    foreach (lap_times[i])
      $display("Lap %0d: %0d seconds", i+1, lap_times[i]);
  endfunction

  function void tick();
    if (running) begin
      super.tick();  // update time
    end
  endfunction
endclass

module test();
  Stopwatch sw = new();

  initial begin
    $display("\n=== Lab 5-2: Wall Clock with Stopwatch ===\n");

    // Simulate time ticks (1ms each)
    repeat (5000) begin  // 5 seconds
      sw.tick();
      #1ms;
    end

    sw.display();  // show current time

    sw.start();  // start stopwatch

    repeat (3000) begin  // 3 seconds
      sw.tick();
      #1ms;
    end

    sw.lap();  // lap after 3s

    repeat (2000) begin  // 2 seconds
      sw.tick();
      #1ms;
    end

    sw.lap();  // lap after 5s total

    sw.stop();

    sw.display_laps();  // show lap times

    $display("\nSimulation complete!");
    #10 $finish;
  end
endmodule
