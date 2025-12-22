#!/bin/bash
echo "=== Compiling 477-bit Random Number Lab ==="

rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top random_477bit -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo
echo "--------- YOUR OUTPUT ---------"
cat run.log
echo "-------------------------------"
echo
echo "Submission ready!"
