#!/bin/bash
echo "=== Compiling Lab 5-2: Wall Clock with Stopwatch ==="
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

vcs -full64 -sverilog -f file_list.f -top test -debug_access+all

if [ $? -ne 0 ]; then
  echo "Compilation FAILED!"
  exit 1
fi

echo "=== Running Simulation ==="
./simv -l run.log

echo "=== DONE ==="
echo
echo "Output (sample time display and laps):"
echo "----------------------------------------"
grep -E "Stopwatch|Lap|started|stopped|%02d:%02d:%02d" run.log
echo "----------------------------------------"
echo
echo "Full log in run.log"
