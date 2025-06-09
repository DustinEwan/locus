grammar Locus;

// Parser Rules
program
    : statement* EOF
    ;

statement
    : variableDeclaration
    | functionDeclaration
    | expressionStatement
    | ifStatement
    | whileStatement
    | returnStatement
    ;

variableDeclaration
    : modeAnnotation? type IDENTIFIER ('=' expression)? ';'
    ;

functionDeclaration
    : 'fn' IDENTIFIER '(' parameterList? ')' ('->' type)? block
    ;

parameterList
    : parameter (',' parameter)*
    ;

parameter
    : modeAnnotation? type IDENTIFIER
    ;

modeAnnotation
    : localityMode uniquenessMode?
    | uniquenessMode localityMode?
    ;

localityMode
    : 'local'
    | 'global'
    ;

uniquenessMode
    : 'unique'
    | 'shared'
    | 'exclusive'
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
    : 'if' expression block ('else' block)?
    ;

whileStatement
    : 'while' expression block
    ;

returnStatement
    : 'return' expression? ';'
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
    | BOOLEAN
    | '(' expression ')'
    ;

// Lexer Rules
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

BOOLEAN
    : 'true'
    | 'false'
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