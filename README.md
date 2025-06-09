# The Locus Programming Language

**Status:** `[ Alpha / Functional Compiler ]`

**Vision:** A systems programming language that combines the expressive power of Rust's type system with a novel, intuitive memory safety model based on locality.

---

## What is Locus?

Locus is a new programming language born from a simple question: Can we have the compile-time memory safety and performance of Rust without the cognitive overhead of its lifetime system?

We believe the answer is yes. Locus provides:

* **A Rich Type System:** Full support for `structs` and `enums` with exhaustive `match` expressions for creating robust, domain-specific types.
* **Compile-Time Memory Safety:** Guarantees against dangling pointers, data races, and other common memory errors, enforced by the compiler before your code ever runs.
* **No Lifetimes:** The explicit lifetime annotations (`'a`) found in Rust are completely removed.
* **LLVM Backend:** Compiles to native machine code via LLVM IR for optimal performance.

Instead of lifetimes, Locus's safety model is built on **Locality and Uniqueness Modes**, an idea inspired by the research and extensions developed at Jane Street. This shifts the core question of memory safety from:

* **Time-based (Rust):** *"How long does this reference live?"*
* **Place-based (Locus):** *"Where in the code can this reference be used?"*

We believe this "spatial" or "place-based" mental model is more intuitive and leads to a more ergonomic developer experience without sacrificing safety.

### The Core Modes

The Locus compiler understands a set of "modes" that are orthogonal to a value's type. These modes describe the scope and access rules for any variable:

* **Locality Modes (`local` vs. `global`):** This is the lifetime replacement. A `local` reference is guaranteed by the compiler to never escape its defining scope (e.g., a function body), preventing dangling pointers. A `global` value can escape and is typically heap-allocated.
* **Uniqueness Modes (`unique` vs. `shared` vs. `exclusive`):** This is the ownership and borrowing model.
    * `unique`: Sole, owned access (like Rust's `String` or `Box<T>`).
    * `shared`: Multiple, read-only borrows (like `&T`).
    * `exclusive`: A single, mutable borrow (like `&mut T`).

## Current Features

Locus currently supports a comprehensive set of language features:

### ✅ Implemented Features
- **Complete Grammar**: ANTLR-based parser with full language support
- **Data Types**: Primitives (`i32`, `i64`, `f32`, `f64`, `bool`, `String`) and complex types
- **Structs & Enums**: Full support with generics and mode annotations
- **Functions**: Declaration, parameters, return types, and calls
- **Control Flow**: `if`/`else` statements, `while` loops, and nested control structures
- **Pattern Matching**: Comprehensive `match` expressions with literal, enum variant, and wildcard patterns
- **Expression-Oriented Programming**: Match expressions return values, implicit returns from functions
- **LLVM Backend**: Complete LLVM IR generation and native code compilation
- **Memory Safety**: Mode system implementation (locality and uniqueness modes)

### 🔧 Example Programs
```locus
// Expression-oriented programming with match expressions
enum Color { Red, Green, Blue }

fn get_color_value(color: Color) -> i32 {
    // Match expression returns value directly
    match color {
        Color::Red => 10,
        Color::Green => 20,
        Color::Blue => 30
    }
}

fn double_value(x: i32) -> i32 {
    x * 2  // Implicit return - no semicolon needed
}

fn main() -> i32 {
    // Match expressions can be used in variable assignments
    let result = match Color::Blue {
        Color::Red => 1,
        Color::Green => 2,
        Color::Blue => 3
    };
    
    // Functions with implicit returns
    let doubled = double_value(result);
    
    return doubled; // Returns 6
}
```

## Development Roadmap

### Phase 1: Bootstrap with ANTLR ✅ COMPLETE
- ✅ **Parser Generation**: ANTLR v4 parser from formal grammar (`Locus.g4`)
- ✅ **Core Tooling**: Java-based compiler driver with LLVM backend
- ✅ **LLVM Integration**: Full LLVM IR generation and native compilation
- ✅ **Language Features**: Complete type system, control flow, and pattern matching

### Phase 2: Advanced Features (Current Focus)
- 🔄 **Enhanced Type System**: Advanced generics and trait-like features
- 🔄 **Memory Management**: Full locality/uniqueness mode enforcement
- 🔄 **Standard Library**: Core data structures and I/O operations
- 🔄 **Error Handling**: Comprehensive error types and propagation

### Phase 3: Self-Hosting (Future)
- 🔮 **Language Refinement**: Features for systems development
- 🔮 **Parser Rewrite**: Hand-written recursive descent parser
- 🔮 **Self-Hosted Compiler**: Locus compiler written in Locus



## Getting Started

### Prerequisites
- OpenJDK 17 or later
- LLVM 15.0.6 (with `llc-15` and `clang-15`)
- ANTLR 4.13.1 (included in `tools/`)

### Building and Running
```bash
# Build the compiler
./build.sh

# Compile a Locus program
java -cp ".:tools/antlr-4.13.1-complete.jar:build/classes" LocusCompiler examples/test_expression_oriented.locus

# Generate assembly and executable
llc examples/test_expression_oriented.ll -o test_expression_oriented.s
gcc test_expression_oriented.s -o test_expression_oriented

# Run the program
./test_expression_oriented
echo "Exit code: $?"

# Clean up generated files
./clean.sh
```

### Example Programs
The `examples/` directory contains various Locus programs demonstrating language features:
- `test_expression_oriented.locus` - Expression-oriented programming with match expressions and implicit returns
- `comprehensive_expression_test.locus` - Advanced expression-oriented features with nested match expressions
- `simple_match_test.locus` - Basic pattern matching
- `comprehensive_match_test.locus` - Advanced pattern matching with functions
- `if_test.locus`, `while_test.locus` - Control flow examples
- `structs_enums.locus` - Data type definitions

## Documentation

Detailed documentation is available in the `docs/` directory:

- **[Pattern Matching Status](docs/PATTERN_MATCHING_STATUS.md)** - Complete pattern matching implementation details
- **[Control Flow Status](docs/CONTROL_FLOW_STATUS.md)** - If/else and while loop implementation
- **[LLVM Status](docs/LLVM_STATUS.md)** - LLVM IR generation and compilation details
- **[Struct/Enum Summary](docs/STRUCT_ENUM_SUMMARY.md)** - Type system implementation
- **[ANTLR Setup](docs/ANTLR_SETUP.md)** - Parser and grammar development
- **[Documentation Index](docs/README.md)** - Complete documentation overview

## How to Contribute

Locus is actively developed and welcomes contributions! The compiler is functional with core features implemented. Current focus areas include:

- Advanced type system features
- Memory safety enforcement
- Standard library development
- Performance optimizations

## License

To be determined. Likely a permissive open-source license like **MIT** or **Apache 2.0**.
