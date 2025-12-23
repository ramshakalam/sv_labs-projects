#!/bin/bash
echo "=== Compiling Lab 10-1: Coverage ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top test -debug_access+all -cm line+cond+fsm+tgl+branch+assert

echo "=== Running Simulation ==="
./simv -l run.log -cm line+cond+fsm+tgl+branch+assert

echo "=== DONE ==="
echo "Coverage report:"
echo "----------------------------------------"
grep "Coverage" run.log
echo "----------------------------------------"
echo "Check run.log for full coverage details"
