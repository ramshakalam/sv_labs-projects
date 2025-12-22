#!/bin/bash
echo "=== Compiling Lab1_1 ==="
vcs -full64 -sverilog -f file_list.f -top hello_world -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Your output:"
cat run.log
