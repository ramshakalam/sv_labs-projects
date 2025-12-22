#!/bin/bash
echo "=== Compiling FIFO Lab 2-5 ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top test -debug_access+all +v2k

if [ $? -ne 0 ]; then
  echo "Compilation FAILED!"
  exit 1
fi

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo
echo "Key operations:"
echo "----------------------------------------"
grep "WR\|RD\|ERROR\|Reset" run.log
echo "----------------------------------------"
echo
echo "Check run.log for full log"