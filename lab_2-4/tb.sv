module tb;
  myex exArr[10];  

  initial begin
    $display("\n=== Lab: Construct exArr and randomize using genex() ===\n");

    // Construct all 10 objects
    foreach (exArr[i]) begin
      exArr[i] = new();
    end

    // Randomize all entries and print
    foreach (exArr[i]) begin
      exArr[i].genex();  
      exArr[i].pr();
    end

    $display("\nAll 10 entries randomized using genex() and printed!");
    #10 $finish;
  end
endmodule