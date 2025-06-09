#!/bin/bash

# Test script for Locus ANTLR setup

echo "=== Locus ANTLR Setup Test ==="
echo

# Test 1: Check Java version
echo "1. Checking Java version..."
java -version
echo

# Test 2: Check ANTLR installation
echo "2. Testing ANTLR installation..."
if [ -f "tools/antlr-4.13.1-complete.jar" ]; then
    echo "✓ ANTLR JAR found"
else
    echo "✗ ANTLR JAR not found"
    exit 1
fi

# Test 3: Generate parser
echo "3. Generating parser from grammar..."
./antlr.sh generate grammar/Locus.g4
if [ $? -eq 0 ]; then
    echo "✓ Parser generation successful"
else
    echo "✗ Parser generation failed"
    exit 1
fi

# Test 4: Build compiler
echo "4. Building compiler..."
./build.sh
if [ $? -eq 0 ]; then
    echo "✓ Compiler build successful"
else
    echo "✗ Compiler build failed"
    exit 1
fi

# Test 5: Test with example programs
echo "5. Testing with example programs..."

echo "  Testing hello.locus..."
java -cp ".:tools/antlr-4.13.1-complete.jar:build/classes" LocusCompiler examples/hello.locus > /dev/null
if [ $? -eq 0 ]; then
    echo "  ✓ hello.locus compiled successfully"
else
    echo "  ✗ hello.locus compilation failed"
    exit 1
fi

echo "  Testing complex.locus..."
java -cp ".:tools/antlr-4.13.1-complete.jar:build/classes" LocusCompiler examples/complex.locus > /dev/null
if [ $? -eq 0 ]; then
    echo "  ✓ complex.locus compiled successfully"
else
    echo "  ✗ complex.locus compilation failed"
    exit 1
fi

echo
echo "=== All tests passed! ANTLR setup is working correctly. ==="
echo
echo "You can now:"
echo "  - Edit grammar/Locus.g4 to modify the language"
echo "  - Add new example programs in examples/"
echo "  - Extend src/LocusSemanticAnalyzer.java for semantic analysis"
echo "  - Run './antlr.sh generate grammar/Locus.g4' after grammar changes"
echo "  - Run './build.sh' to rebuild the compiler"