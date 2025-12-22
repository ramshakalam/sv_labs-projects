module hello_world ();

  task greet(string greeting);
    $display("%0t ns : %s", $realtime, greeting);
  endtask

  initial begin
    greet("My First SystemVerilog Program");
    #10;
    $finish;
  end

endmodule
