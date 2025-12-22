module string_array;
  string sarr[256];
  string s;

  // Random character generator
  function automatic byte rand_char();
    int rnd = $urandom();
    case (rnd % 3)
      0: return "0" + (rnd % 10);
      1: return "A" + (rnd % 26);
      2: return "a" + (rnd % 26);
    endcase
  endfunction

  initial begin
    foreach (sarr[i]) begin
      int len = $urandom_range(8,20);  
      byte chars[];                     
      chars = new[len];
      for (int j = 0; j < len; j++)
        chars[j] = rand_char();
      s = "";
      for (int j = 0; j < len; j++)
        s = {s, chars[j]};
      sarr[i] = s; 
    end
    for (int i = 0; i < 20; i++)
      $display("sarr[%3d] = \"%s\"  len=%0d", 
                i, sarr[i], sarr[i].len());
  end
endmodule

