#!/bin/bash

# Locus Compiler Cleanup Script
# Removes intermediate compilation artifacts and compiled binaries

echo "Cleaning up Locus compilation artifacts..."

# Remove LLVM IR files
find . -name "*.ll" -type f -delete

# Remove assembly files
find . -name "*.s" -type f -delete

# Remove compiled binaries (executables without extensions in examples/)
find examples/ -type f -executable ! -name "*.locus" ! -name "*.sh" -delete

# Remove any other common build artifacts
find . -name "*.o" -type f -delete
find . -name "*.obj" -type f -delete
find . -name "*.tmp" -type f -delete

# Remove any accidentally created executables in root directory
# (executables that don't have extensions and aren't scripts)
find . -maxdepth 1 -type f -executable ! -name "*.sh" ! -name "build.sh" ! -name "clean.sh" -delete

echo "Cleanup completed!"
echo ""
echo "Removed:"
echo "  - LLVM IR files (*.ll)"
echo "  - Assembly files (*.s)"
echo "  - Compiled binaries in examples/"
echo "  - Object files (*.o, *.obj)"
echo "  - Temporary files (*.tmp)"