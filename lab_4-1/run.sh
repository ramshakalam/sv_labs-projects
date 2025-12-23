#!/bin/bash
echo "=== Compiling Lab 4-1: 32-bit Up/Down Counter ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top test -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Key events:"
echo "----------------------------------------"
grep "Reset\|Loaded\|Count\|started" run.log
echo "----------------------------------------"
