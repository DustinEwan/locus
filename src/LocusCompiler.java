import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class LocusCompiler {
    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            System.err.println("Usage: java LocusCompiler <source-file>");
            System.exit(1);
        }
        
        String inputFile = args[0];
        
        // Create input stream from file
        ANTLRInputStream input = new ANTLRFileStream(inputFile);
        
        // Create lexer
        LocusLexer lexer = new LocusLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        
        // Create parser
        LocusParser parser = new LocusParser(tokens);
        
        // Parse starting from the 'program' rule
        ParseTree tree = parser.program();
        
        // Print the parse tree (for debugging)
        System.out.println("Parse tree:");
        System.out.println(tree.toStringTree(parser));
        
        // Create and run semantic analyzer
        LocusSemanticAnalyzer analyzer = new LocusSemanticAnalyzer();
        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(analyzer, tree);
        
        // Generate LLVM IR
        LocusLLVMGenerator llvmGenerator = new LocusLLVMGenerator();
        walker.walk(llvmGenerator, tree);
        
        // Write LLVM IR to file
        String outputFile = inputFile.replaceAll("\\.locus$", ".ll");
        try {
            llvmGenerator.writeToFile(outputFile);
            System.out.println("\nLLVM IR generated: " + outputFile);
        } catch (Exception e) {
            System.err.println("Error writing LLVM IR: " + e.getMessage());
        }
        
        System.out.println("\nCompilation completed successfully!");
    }
}