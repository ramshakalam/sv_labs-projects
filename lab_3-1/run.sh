#!/bin/bash
echo "=== Compiling Lab 3-1 Barrel Shifter Testbench ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top testbench -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Check run.log for full details"
