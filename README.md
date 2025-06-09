# The Locus Programming Language

**Status:** `[ Pre-Alpha / Design Phase ]`

**Vision:** A systems programming language that combines the expressive power of Rust's type system with a novel, intuitive memory safety model based on locality.

---

## What is Locus?

Locus is a new programming language born from a simple question: Can we have the compile-time memory safety and performance of Rust without the cognitive overhead of its lifetime system?

We believe the answer is yes. Locus aims to provide:

* **A Rich Type System:** The full power of Rust's `structs` and `enums` along with exhaustive `match` expressions for creating robust, domain-specific types.
* **Compile-Time Memory Safety:** Guarantees against dangling pointers, data races, and other common memory errors, enforced by the compiler before your code ever runs.
* **No Lifetimes:** The explicit lifetime annotations (`'a`) found in Rust are completely removed.

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

## Development Roadmap

Our development plan follows a pragmatic two-phase strategy:

#### Phase 1: Bootstrap with ANTLR
The initial goal is to get a working compiler and interpreter running as quickly as possible to validate the core concepts of the language.

1.  **Parser Generation:** We will use **ANTLR v4** to generate a robust parser from a formal grammar file (`Locus.g4`). This allows us to focus on semantics rather than parsing logic.
2.  **Core Tooling:** The compiler driver will be written in a mature language (e.g., Java, Rust, or Python).
3.  **Focus:** The primary effort will be on building the **semantic analyzer and type checker**, which is where the novel locality/uniqueness logic resides.
4.  **Outcome:** A functional interpreter that can execute Locus code, proving that the memory model is sound and usable.

#### Phase 2: Dogfooding and Self-Hosting
Once Locus is powerful enough, we will begin the "dogfooding" process: rewriting the Locus compiler in Locus itself.

1.  **Language Refinement:** We will enhance the language with the features necessary for systems development (better I/O, concurrency primitives, etc.).
2.  **Parser Rewrite:** The ANTLR-based parser will be replaced with a **hand-written recursive descent parser**. This will give us maximum control over performance and, crucially, the quality of compiler error messages.
3.  **Outcome:** A fully self-hosted Locus compiler, representing a major milestone in the language's maturity.

## Task Checklist & Progress

*Last Updated: June 7, 2024*

### Milestone 1: Foundational Setup
- [x] Formalize core design philosophy.
- [x] Choose a name and establish the development roadmap.
- [x] Create initial project `README.md`.
- [ ] Initialize Git repository and project structure.

### Milestone 2: Parsing (ANTLR Bootstrap)
- [ ] Draft initial `Locus.g4` grammar for ANTLR.
- [ ] Refine grammar to handle operator precedence and more complex expressions.
- [ ] Set up the compiler driver application.
- [ ] Implement the logic to consume the ANTLR parse tree and build our own internal AST.

### Milestone 3: Semantic Analysis & Type Checking
- [ ] Design the internal Abstract Syntax Tree (AST) data structures.
- [ ] Implement symbol table management for tracking variables, types, and functions.
- [ ] **Implement the Type and Mode Checker:**
    - [ ] Basic type resolution (e.g., `String`, `i32`).
    - [ ] Generic type resolution (`List<T>`).
    - [ ] **Locality Analysis:** Enforce `local` vs. `global` scoping rules.
    - [ ] **Uniqueness Analysis:** Enforce `unique`, `shared`, and `exclusive` borrowing rules.
- [ ] Implement `struct` and `impl` resolution.

### Milestone 4: Interpretation
- [ ] Design the structure for runtime values (e.g., `Value::Integer(i64)`, `Value::String(String)`).
- [ ] Implement an AST-walking interpreter.
- [ ] Implement runtime memory management for `global unique` pointers.
- [ ] Handle control flow (`if`/`else`) and function calls within the interpreter.
- [ ] Implement the standard library functions defined in the prelude.

### Milestone 5: The Future (Self-Hosting)
- [ ] Enhance the language with features required for compiler development (e.g., File I/O).
- [ ] Begin writing the new Locus compiler in Locus.

## How to Contribute

This project is in its infancy. For now, the focus is on implementing the core compiler functionality as outlined in the roadmap. As the project matures, guidelines for contribution will be established here.

## License

To be determined. Likely a permissive open-source license like **MIT** or **Apache 2.0**.
