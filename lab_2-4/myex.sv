class myex;
  int a;
  int b;

  function void genex();
    a = $urandom() % 7;
    b = $urandom() % 23;
  endfunction

  task pr();
    $display("a:%0d b:%0d", a, b);
  endtask
endclass
