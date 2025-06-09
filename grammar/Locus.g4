grammar Locus;

// Parser Rules
program
    : statement* EOF
    ;

statement
    : functionDeclaration
    | structDeclaration
    | enumDeclaration
    | ifStatement
    | whileStatement
    | matchStatement
    | returnStatement
    | variableDeclaration
    | expressionStatement
    ;

variableDeclaration
    : modeAnnotation? type IDENTIFIER ('=' expression)? ';'
    ;

functionDeclaration
    : FN IDENTIFIER ('<' typeList '>')? '(' parameterList? ')' ('->' modeAnnotation? type)? block
    ;

structDeclaration
    : STRUCT IDENTIFIER ('<' typeList '>')? '{' structField* '}'
    ;

structField
    : modeAnnotation? IDENTIFIER COLON type ';'
    ;

enumDeclaration
    : ENUM IDENTIFIER ('<' typeList '>')? '{' enumVariant (',' enumVariant)* ','? '}'
    ;

enumVariant
    : IDENTIFIER ('(' typeList ')')?
    ;

parameterList
    : parameter (',' parameter)*
    ;

parameter
    : modeAnnotation? IDENTIFIER COLON type
    | modeAnnotation? type IDENTIFIER
    ;

modeAnnotation
    : localityMode uniquenessMode?
    | uniquenessMode localityMode?
    ;

localityMode
    : LOCAL
    | GLOBAL
    ;

uniquenessMode
    : UNIQUE
    | SHARED
    | EXCLUSIVE
    ;

type
    : primitiveType
    | genericType
    | IDENTIFIER  // User-defined types
    ;

primitiveType
    : 'i32'
    | 'i64'
    | 'f32'
    | 'f64'
    | 'bool'
    | 'String'
    ;

genericType
    : IDENTIFIER '<' typeList '>'
    ;

typeList
    : type (',' type)*
    ;

block
    : '{' statement* '}'
    ;

ifStatement
    : IF expression block (ELSE block)?
    ;

whileStatement
    : WHILE expression block
    ;

matchStatement
    : MATCH expression '{' matchArm* '}'
    ;

matchArm
    : pattern ARROW block ','?
    ;

pattern
    : literalPattern
    | identifierPattern
    | enumVariantPattern
    | wildcardPattern
    ;

literalPattern
    : INTEGER
    | FLOAT
    | STRING
    | TRUE
    | FALSE
    ;

identifierPattern
    : IDENTIFIER
    ;

enumVariantPattern
    : IDENTIFIER DOUBLE_COLON IDENTIFIER ('(' patternList ')')?
    ;

wildcardPattern
    : UNDERSCORE
    ;

patternList
    : pattern (',' pattern)*
    ;

returnStatement
    : RETURN expression? ';'
    ;

expressionStatement
    : expression ';'
    ;

expression
    : primary
    | expression '.' IDENTIFIER                    // Field access
    | expression '(' argumentList? ')'             // Function call
    | expression '[' expression ']'               // Array/index access
    | ('!' | '-') expression                      // Unary operators
    | expression ('*' | '/' | '%') expression     // Multiplicative
    | expression ('+' | '-') expression           // Additive
    | expression ('<' | '<=' | '>' | '>=' | '==' | '!=') expression  // Relational
    | expression ('&&' | '||') expression         // Logical
    | expression '=' expression                   // Assignment
    ;

argumentList
    : expression (',' expression)*
    ;

primary
    : IDENTIFIER
    | INTEGER
    | FLOAT
    | STRING
    | TRUE
    | FALSE
    | '(' expression ')'
    | structInitializer
    | enumVariantAccess
    ;

structInitializer
    : IDENTIFIER '{' fieldInitList? '}'
    ;

fieldInitList
    : fieldInit (',' fieldInit)*
    ;

fieldInit
    : IDENTIFIER COLON expression
    ;

enumVariantAccess
    : IDENTIFIER DOUBLE_COLON IDENTIFIER
    ;

// Lexer Rules
// Keywords (must come before IDENTIFIER)
STRUCT : 'struct';
ENUM : 'enum';
FN : 'fn';
IF : 'if';
ELSE : 'else';
WHILE : 'while';
MATCH : 'match';
RETURN : 'return';
LOCAL : 'local';
GLOBAL : 'global';
UNIQUE : 'unique';
SHARED : 'shared';
EXCLUSIVE : 'exclusive';
TRUE : 'true';
FALSE : 'false';

// Symbols
COLON : ':';
DOUBLE_COLON : '::';
UNDERSCORE : '_';
ARROW : '=>';

IDENTIFIER
    : [a-zA-Z_][a-zA-Z0-9_]*
    ;

INTEGER
    : [0-9]+
    ;

FLOAT
    : [0-9]+ '.' [0-9]+
    ;

STRING
    : '"' (~["\r\n] | '\\' .)* '"'
    ;



// Whitespace and Comments
WS
    : [ \t\r\n]+ -> skip
    ;

LINE_COMMENT
    : '//' ~[\r\n]* -> skip
    ;

BLOCK_COMMENT
    : '/*' .*? '*/' -> skip
    ;