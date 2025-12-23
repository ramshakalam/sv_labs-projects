#!/bin/bash
echo "=== Compiling Lab 6-1: Randomization and Constraints ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top test -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo
echo "Sample generated packets:"
echo "----------------------------------------"
grep -A 6 "=== Generated Packet ===" run.log | head -n 60
echo "----------------------------------------"
echo "Full log in run.log"
