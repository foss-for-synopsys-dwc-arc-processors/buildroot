#!/bin/sh
#
# Welcome message for ARC-V RPX-100 RISC-V Demo
#

echo ""
echo "=============================================="
echo "   ARC-V RPX-100 RISC-V Linux Demo"
echo "=============================================="
echo ""
echo "Available commands:"
echo "  coremark          - Run CoreMark benchmark"
echo "  cat /tmp/coremark_results.txt - View last results"
echo ""
echo "System Info:"
echo "  CPU: $(cat /proc/cpuinfo | grep 'isa' | head -1 | cut -d: -f2)"
echo "  Kernel: $(uname -r)"
echo ""
echo "=============================================="
echo ""

