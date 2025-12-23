#!/bin/bash
echo "=== Compiling Lab 7-1: Interfaces ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top test -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Key output:"
echo "----------------------------------------"
grep "Reset\|Loaded\|SUCCESS\|ERROR" run.log
echo "----------------------------------------"
