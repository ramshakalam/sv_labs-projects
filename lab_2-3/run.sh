#!/bin/bash
echo "=== Compiling Lab 2-3: Memory Model ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top tb -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Key operations:"
echo "----------------------------------------"
grep "READ\|WRITE" run.log
echo "----------------------------------------"
