import java.util.*;

public class LocusSemanticAnalyzer extends LocusBaseListener {
    private Map<String, String> symbolTable = new HashMap<>();
    private List<String> errors = new ArrayList<>();
    private int currentScope = 0;
    
    @Override
    public void enterFunctionDeclaration(LocusParser.FunctionDeclarationContext ctx) {
        String functionName = ctx.IDENTIFIER().getText();
        System.out.println("Entering function: " + functionName);
        currentScope++;
    }
    
    @Override
    public void exitFunctionDeclaration(LocusParser.FunctionDeclarationContext ctx) {
        String functionName = ctx.IDENTIFIER().getText();
        System.out.println("Exiting function: " + functionName);
        currentScope--;
    }
    
    @Override
    public void enterVariableDeclaration(LocusParser.VariableDeclarationContext ctx) {
        String varName = ctx.IDENTIFIER().getText();
        String varType = getTypeString(ctx.type());
        String mode = getModeString(ctx.modeAnnotation());
        
        System.out.println("Variable declaration: " + mode + " " + varType + " " + varName);
        
        // Add to symbol table
        String key = varName + "_" + currentScope;
        symbolTable.put(key, varType);
    }
    
    @Override
    public void enterParameter(LocusParser.ParameterContext ctx) {
        String paramName = ctx.IDENTIFIER().getText();
        String paramType = getTypeString(ctx.type());
        String mode = getModeString(ctx.modeAnnotation());
        
        System.out.println("Parameter: " + mode + " " + paramType + " " + paramName);
        
        // Add to symbol table
        String key = paramName + "_" + currentScope;
        symbolTable.put(key, paramType);
    }
    
    private String getTypeString(LocusParser.TypeContext ctx) {
        if (ctx.primitiveType() != null) {
            return ctx.primitiveType().getText();
        } else if (ctx.genericType() != null) {
            return ctx.genericType().getText();
        } else if (ctx.IDENTIFIER() != null) {
            return ctx.IDENTIFIER().getText();
        }
        return "unknown";
    }
    
    private String getModeString(LocusParser.ModeAnnotationContext ctx) {
        if (ctx == null) {
            return "";
        }
        
        StringBuilder mode = new StringBuilder();
        if (ctx.localityMode() != null) {
            mode.append(ctx.localityMode().getText()).append(" ");
        }
        if (ctx.uniquenessMode() != null) {
            mode.append(ctx.uniquenessMode().getText()).append(" ");
        }
        return mode.toString().trim();
    }
    
    public void printSymbolTable() {
        System.out.println("\nSymbol Table:");
        for (Map.Entry<String, String> entry : symbolTable.entrySet()) {
            System.out.println("  " + entry.getKey() + " : " + entry.getValue());
        }
    }
    
    public List<String> getErrors() {
        return errors;
    }
}