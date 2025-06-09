import java.util.*;
import java.io.*;

public class LocusLLVMGenerator extends LocusBaseListener {
    private StringBuilder llvmIR = new StringBuilder();
    private Map<String, String> symbolTable = new HashMap<>();
    private Map<String, String> typeTable = new HashMap<>();
    private int currentScope = 0;
    private int labelCounter = 0;
    private int tempCounter = 0;
    private String currentFunction = "";
    private boolean inMainFunction = false;
    
    // Type mappings from Locus to LLVM
    private Map<String, String> typeMapping = new HashMap<>();
    
    public LocusLLVMGenerator() {
        initializeTypeMapping();
        generateHeader();
    }
    
    private void initializeTypeMapping() {
        typeMapping.put("i32", "i32");
        typeMapping.put("i64", "i64");
        typeMapping.put("f32", "float");
        typeMapping.put("f64", "double");
        typeMapping.put("bool", "i1");
        typeMapping.put("void", "void");
    }
    
    private void generateHeader() {
        llvmIR.append("; Generated LLVM IR for Locus program\n");
        llvmIR.append("target datalayout = \"e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128\"\n");
        llvmIR.append("target triple = \"x86_64-pc-linux-gnu\"\n\n");
        
        // Declare external functions
        llvmIR.append("declare i32 @printf(i8*, ...)\n");
        llvmIR.append("declare i32 @puts(i8*)\n");
        llvmIR.append("declare noalias i8* @malloc(i64)\n");
        llvmIR.append("declare void @free(i8*)\n\n");
    }
    
    @Override
    public void enterFunctionDeclaration(LocusParser.FunctionDeclarationContext ctx) {
        String functionName = ctx.IDENTIFIER().getText();
        currentFunction = functionName;
        inMainFunction = functionName.equals("main");
        
        // Get return type
        String returnType = "void";
        if (ctx.type() != null) {
            returnType = getLLVMType(getTypeString(ctx.type()));
        }
        
        // Start function declaration
        llvmIR.append("define ").append(returnType).append(" @").append(functionName).append("(");
        
        currentScope++; // Increment scope before processing parameters
        
        // Add parameters
        if (ctx.parameterList() != null) {
            List<LocusParser.ParameterContext> params = ctx.parameterList().parameter();
            for (int i = 0; i < params.size(); i++) {
                if (i > 0) llvmIR.append(", ");
                LocusParser.ParameterContext param = params.get(i);
                String paramType = getLLVMType(getTypeString(param.type()));
                String paramName = param.IDENTIFIER().getText();
                llvmIR.append(paramType).append(" %").append(paramName);
                
                // Add to symbol table with current scope
                symbolTable.put(paramName + "_" + currentScope, "%" + paramName);
                typeTable.put(paramName + "_" + currentScope, paramType);
            }
        }
        
        llvmIR.append(") {\n");
        llvmIR.append("entry:\n");
    }
    
    @Override
    public void exitFunctionDeclaration(LocusParser.FunctionDeclarationContext ctx) {
        llvmIR.append("}\n\n");
        
        currentScope--;
        currentFunction = "";
        inMainFunction = false;
    }
    
    @Override
    public void enterVariableDeclaration(LocusParser.VariableDeclarationContext ctx) {
        String varName = ctx.IDENTIFIER().getText();
        String varType = getLLVMType(getTypeString(ctx.type()));
        
        // Allocate space for the variable
        String allocaName = "%" + varName + "_" + tempCounter++;
        llvmIR.append("  ").append(allocaName).append(" = alloca ").append(varType).append("\n");
        
        // Store initial value if provided
        if (ctx.expression() != null) {
            String value = generateExpression(ctx.expression());
            llvmIR.append("  store ").append(varType).append(" ").append(value)
                  .append(", ").append(varType).append("* ").append(allocaName).append("\n");
        }
        
        // Add to symbol table
        String key = varName + "_" + currentScope;
        symbolTable.put(key, allocaName);
        typeTable.put(key, varType);
    }
    
    @Override
    public void enterReturnStatement(LocusParser.ReturnStatementContext ctx) {
        if (ctx.expression() != null) {
            String value = generateExpression(ctx.expression());
            String returnType = "i32"; // Default for now
            if (currentFunction.equals("main")) {
                returnType = "i32";
            }
            llvmIR.append("  ret ").append(returnType).append(" ").append(value).append("\n");
        } else {
            llvmIR.append("  ret void\n");
        }
    }
    
    private String generateExpression(LocusParser.ExpressionContext ctx) {
        if (ctx.primary() != null) {
            return generatePrimary(ctx.primary());
        } else if (ctx.getChildCount() == 3 && ctx.expression().size() == 2) {
            // Binary operation
            String left = generateExpression(ctx.expression(0));
            String right = generateExpression(ctx.expression(1));
            String op = ctx.getChild(1).getText();
            
            return generateBinaryOp(left, right, op);
        } else if (ctx.getChildCount() >= 3 && ctx.getChild(1).getText().equals("(")) {
            // Function call (with or without arguments)
            String functionName = ctx.expression(0).getText();
            return generateFunctionCall(functionName, ctx.argumentList());
        }
        
        return "0"; // Default
    }
    
    private String generatePrimary(LocusParser.PrimaryContext ctx) {
        if (ctx.INTEGER() != null) {
            return ctx.INTEGER().getText();
        } else if (ctx.FLOAT() != null) {
            return ctx.FLOAT().getText();
        } else if (ctx.TRUE() != null) {
            return "1";
        } else if (ctx.FALSE() != null) {
            return "0";
        } else if (ctx.IDENTIFIER() != null) {
            String varName = ctx.IDENTIFIER().getText();
            // Try current scope first, then parameter scope
            String key = varName + "_" + currentScope;
            String allocaName = symbolTable.get(key);
            String varType = typeTable.get(key);
            
            // If not found in current scope, try parameter scope (scope 1)
            if (allocaName == null && currentScope > 1) {
                key = varName + "_1";
                allocaName = symbolTable.get(key);
                varType = typeTable.get(key);
            }
            
            if (allocaName != null && varType != null) {
                // If it's a parameter (starts with %), return directly
                if (allocaName.startsWith("%") && !allocaName.contains("_")) {
                    return allocaName;
                }
                // Otherwise, load from alloca
                String loadName = "%temp_" + tempCounter++;
                llvmIR.append("  ").append(loadName).append(" = load ").append(varType)
                      .append(", ").append(varType).append("* ").append(allocaName).append("\n");
                return loadName;
            }
            return "0";
        }
        
        return "0"; // Default
    }
    
    private String generateFunctionCall(String functionName, LocusParser.ArgumentListContext argList) {
        String resultName = "%temp_" + tempCounter++;
        StringBuilder call = new StringBuilder();
        
        call.append("  ").append(resultName).append(" = call i32 @").append(functionName).append("(");
        
        if (argList != null && argList.expression() != null) {
            List<LocusParser.ExpressionContext> args = argList.expression();
            for (int i = 0; i < args.size(); i++) {
                if (i > 0) call.append(", ");
                String argValue = generateExpression(args.get(i));
                call.append("i32 ").append(argValue);
            }
        }
        
        call.append(")\n");
        llvmIR.append(call.toString());
        
        return resultName;
    }
    
    private String generateBinaryOp(String left, String right, String op) {
        String resultName = "%temp_" + tempCounter++;
        String instruction = "";
        
        switch (op) {
            case "+":
                instruction = "add i32";
                break;
            case "-":
                instruction = "sub i32";
                break;
            case "*":
                instruction = "mul i32";
                break;
            case "/":
                instruction = "sdiv i32";
                break;
            case "==":
                instruction = "icmp eq i32";
                break;
            case "!=":
                instruction = "icmp ne i32";
                break;
            case "<":
                instruction = "icmp slt i32";
                break;
            case ">":
                instruction = "icmp sgt i32";
                break;
            default:
                instruction = "add i32"; // Default
        }
        
        llvmIR.append("  ").append(resultName).append(" = ").append(instruction)
              .append(" ").append(left).append(", ").append(right).append("\n");
        
        return resultName;
    }
    
    private String getTypeString(LocusParser.TypeContext ctx) {
        if (ctx.primitiveType() != null) {
            return ctx.primitiveType().getText();
        } else if (ctx.genericType() != null) {
            return ctx.genericType().getText();
        } else if (ctx.IDENTIFIER() != null) {
            return ctx.IDENTIFIER().getText();
        }
        return "i32"; // Default
    }
    
    private String getLLVMType(String locusType) {
        return typeMapping.getOrDefault(locusType, "i32");
    }
    
    public String getLLVMIR() {
        return llvmIR.toString();
    }
    
    public void writeToFile(String filename) throws IOException {
        try (PrintWriter writer = new PrintWriter(new FileWriter(filename))) {
            writer.print(llvmIR.toString());
        }
    }
}