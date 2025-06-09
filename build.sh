#!/bin/bash

# Build script for Locus compiler

echo "Building Locus compiler..."

# Create build directories
mkdir -p build/classes

# Generate ANTLR parser if needed
if [ ! -f "build/generated/grammar/LocusParser.java" ]; then
    echo "Generating ANTLR parser..."
    ./antlr.sh generate grammar/Locus.g4
fi

# Compile ANTLR generated files
echo "Compiling ANTLR generated files..."
cd build/generated/grammar
javac -cp ".:../../../tools/antlr-4.13.1-complete.jar" *.java
cd ../../..

# Copy generated classes to build directory
cp build/generated/grammar/*.class build/classes/

# Compile our source files
echo "Compiling Locus compiler source files..."
javac -cp ".:tools/antlr-4.13.1-complete.jar:build/classes" -d build/classes src/*.java

echo "Build completed successfully!"
echo ""
echo "To run the compiler:"
echo "  java -cp \".:tools/antlr-4.13.1-complete.jar:build/classes\" LocusCompiler <source-file>"