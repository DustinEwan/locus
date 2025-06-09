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
        
        // Create and run our custom listener/visitor
        LocusSemanticAnalyzer analyzer = new LocusSemanticAnalyzer();
        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(analyzer, tree);
        
        System.out.println("\nCompilation completed successfully!");
    }
}