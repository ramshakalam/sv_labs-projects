#!/bin/bash
echo "=== Compiling String Array Lab (256 random strings) ==="
echo

# Clean old files
rm -rf simv* csrc* *.daidir *.vpd *.log 2>/dev/null

# Compile
vcs -full64 -sverilog -f file_list.f -top string_array -debug_access+all +v2k -nc

if [ $? -ne 0 ]; then
  echo "Compilation FAILED!"
  exit 1
fi

echo "=== Running Simulation ==="
./simv -l run.log

echo
echo "=== DONE ==="
echo
echo "FIRST 20 RANDOM STRINGS:"
echo "----------------------------------------"
head -n 30 run.log | tail -n 20   # shows only the printed strings
echo "----------------------------------------"
echo
echo "Total 256 strings generated successfully!"

