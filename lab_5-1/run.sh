#!/bin/bash
echo "=== Compiling Lab 5-1: Wall Clock ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top test -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Output (sample of time display):"
echo "----------------------------------------"
grep "%02d:%02d:%02d" run.log | head -n 20
echo "----------------------------------------"
echo "Full log in run.log"
