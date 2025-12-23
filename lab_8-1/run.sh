#!/bin/bash
echo "=== Compiling Lab 8-1: Inter-process Communication ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top test -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Sample operations:"
echo "----------------------------------------"
grep "wr_a\|wr_b\|rd" run.log | head -n 30
echo "----------------------------------------"
echo "Full log in run.log"
