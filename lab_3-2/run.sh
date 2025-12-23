#!/bin/bash
echo "=== Compiling Lab 3-2: 32-bit Counter ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top tb_counter -debug_access+all

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo "Key events:"
echo "----------------------------------------"
grep "count\|timer_event\|Loaded\|Saturation" run.log
echo "----------------------------------------"
