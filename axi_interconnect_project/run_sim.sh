#!/bin/bash
rm -rf simv csrc ucli.key DVEfiles wave_parallel.vcd

vcs -full64 -sverilog -debug_access+all \
    interfaces/axi_master_if.sv \
    interfaces/axi_slave_if.sv \
    classes/addr_decoder.sv \
    classes/rr_arbiter.sv \
    classes/id_entry.sv \
    classes/axi_interconnect.sv \
    tb/tb_axi_interconnect_parallel.sv \
    -o simv

./simv +vcs+gui &
