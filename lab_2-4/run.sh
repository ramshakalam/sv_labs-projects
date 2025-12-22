#!/bin/bash
echo "=== Compiling Lab: Construct exArr and randomizeall entries ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top tb -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Output:"
echo "----------------------------------------"
cat run.log
echo "----------------------------------------"