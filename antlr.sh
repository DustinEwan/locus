#!/bin/bash
# ANTLR convenience script for Locus project

ANTLR_JAR="./tools/antlr-4.13.1-complete.jar"

if [ ! -f "$ANTLR_JAR" ]; then
    echo "Error: ANTLR JAR not found at $ANTLR_JAR"
    exit 1
fi

# Set up CLASSPATH
export CLASSPATH=".:$ANTLR_JAR:$CLASSPATH"

# Function to generate parser from grammar
generate() {
    if [ -z "$1" ]; then
        echo "Usage: ./antlr.sh generate <grammar-file>"
        echo "Example: ./antlr.sh generate grammar/Locus.g4"
        exit 1
    fi
    
    echo "Generating parser from $1..."
    java -jar "$ANTLR_JAR" -Dlanguage=Java -o build/generated "$1"
}

# Function to test grammar with input
test() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: ./antlr.sh test <grammar-name> <start-rule> [input-file]"
        echo "Example: ./antlr.sh test Locus program input.locus"
        exit 1
    fi
    
    GRAMMAR_NAME="$1"
    START_RULE="$2"
    INPUT_FILE="$3"
    
    cd build/generated
    javac -cp ".:../../$ANTLR_JAR" *.java
    
    if [ -n "$INPUT_FILE" ]; then
        java -cp ".:../../$ANTLR_JAR" org.antlr.v4.gui.TestRig "$GRAMMAR_NAME" "$START_RULE" -gui "../../$INPUT_FILE"
    else
        java -cp ".:../../$ANTLR_JAR" org.antlr.v4.gui.TestRig "$GRAMMAR_NAME" "$START_RULE" -gui
    fi
    cd ../..
}

# Function to show help
help() {
    echo "ANTLR convenience script for Locus"
    echo ""
    echo "Usage: ./antlr.sh <command> [args...]"
    echo ""
    echo "Commands:"
    echo "  generate <grammar-file>                    Generate parser from grammar file"
    echo "  test <grammar-name> <start-rule> [input]   Test grammar with TestRig"
    echo "  help                                       Show this help"
    echo ""
    echo "Examples:"
    echo "  ./antlr.sh generate grammar/Locus.g4"
    echo "  ./antlr.sh test Locus program examples/hello.locus"
}

# Main command dispatcher
case "$1" in
    generate)
        generate "$2"
        ;;
    test)
        test "$2" "$3" "$4"
        ;;
    help|--help|-h)
        help
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run './antlr.sh help' for usage information"
        exit 1
        ;;
esac