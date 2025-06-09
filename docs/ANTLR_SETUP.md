# ANTLR Setup for Locus Programming Language

This document describes the ANTLR tooling setup for the Locus programming language compiler.

## Prerequisites

- Java 17 or later (OpenJDK recommended)
- ANTLR 4.13.1 (included in `tools/` directory)

## Project Structure

```
locus/
├── grammar/           # ANTLR grammar files
│   └── Locus.g4      # Main Locus language grammar
├── src/              # Compiler source code
│   ├── LocusCompiler.java
│   └── LocusSemanticAnalyzer.java
├── build/            # Build output
│   ├── classes/      # Compiled Java classes
│   └── generated/    # ANTLR generated files
├── examples/         # Example Locus programs
│   ├── hello.locus
│   └── complex.locus
├── tools/            # External tools
│   └── antlr-4.13.1-complete.jar
├── antlr.sh         # ANTLR convenience script
└── build.sh         # Build script
```

## Grammar Features

The Locus grammar supports:

### Core Language Features
- Function declarations with return types
- Variable declarations with optional initialization
- Basic data types: `i32`, `i64`, `f32`, `f64`, `bool`, `String`
- Generic types: `Type<T>`
- Control flow: `if/else`, `while` loops
- Expressions with operator precedence
- Function calls and parameter passing

### Locus-Specific Features
- **Locality modes**: `local`, `global`
- **Uniqueness modes**: `unique`, `shared`, `exclusive`
- Mode annotations on variables and parameters
- Combined mode specifications (e.g., `local unique`, `shared global`)

### Example Code

```locus
// Function with mode annotations
fn process_data(local unique String data) -> i32 {
    local i32 count = 0;
    shared String result = transform(data);
    return count;
}

fn main() -> i32 {
    local String input = "Hello, Locus!";
    global i32 result = process_data(input);
    return result;
}
```

## Usage

### 1. Generate Parser from Grammar

```bash
./antlr.sh generate grammar/Locus.g4
```

### 2. Build the Compiler

```bash
./build.sh
```

### 3. Compile Locus Programs

```bash
java -cp ".:tools/antlr-4.13.1-complete.jar:build/classes" LocusCompiler examples/hello.locus
```

### 4. Test Grammar with ANTLR TestRig

```bash
# View tokens
java -cp ".:tools/antlr-4.13.1-complete.jar:build/generated/grammar" \
  org.antlr.v4.gui.TestRig Locus program examples/hello.locus -tokens

# View parse tree
java -cp ".:tools/antlr-4.13.1-complete.jar:build/generated/grammar" \
  org.antlr.v4.gui.TestRig Locus program examples/hello.locus -tree

# Launch GUI (if X11 available)
java -cp ".:tools/antlr-4.13.1-complete.jar:build/generated/grammar" \
  org.antlr.v4.gui.TestRig Locus program examples/hello.locus -gui
```

## Development Workflow

1. **Modify Grammar**: Edit `grammar/Locus.g4`
2. **Regenerate Parser**: Run `./antlr.sh generate grammar/Locus.g4`
3. **Update Semantic Analyzer**: Modify `src/LocusSemanticAnalyzer.java` if needed
4. **Rebuild**: Run `./build.sh`
5. **Test**: Run compiler on example programs

## ANTLR Commands Reference

The `antlr.sh` script provides convenient commands:

```bash
./antlr.sh generate <grammar-file>  # Generate parser from grammar
./antlr.sh test <grammar-file>      # Test grammar with TestRig
```

## Generated Files

ANTLR generates the following files from `Locus.g4`:

- `LocusLexer.java` - Tokenizer
- `LocusParser.java` - Parser with all rule methods
- `LocusBaseListener.java` - Base listener for parse tree walking
- `LocusListener.java` - Listener interface
- `*.tokens` - Token definition files
- `*.interp` - Interpreter data files

## Next Steps

1. **Enhanced Semantic Analysis**: Implement type checking, scope resolution
2. **Code Generation**: Add LLVM IR or bytecode generation
3. **Error Handling**: Improve error messages and recovery
4. **Standard Library**: Define built-in functions and types
5. **Testing Framework**: Add comprehensive test suite

## Troubleshooting

### Common Issues

1. **Java Version**: Ensure Java 17+ is installed
2. **Classpath**: Make sure ANTLR JAR is in classpath
3. **Grammar Errors**: Check grammar syntax with ANTLR error messages
4. **Build Failures**: Clean build directory and regenerate

### Debugging

- Use `-tokens` flag to inspect tokenization
- Use `-tree` flag to view parse tree structure
- Add debug prints in semantic analyzer
- Use ANTLR's built-in error handling mechanisms