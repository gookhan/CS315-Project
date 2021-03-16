%{
#include <stdio.h>
#include <stdlib.h>
%}

%token NOT
%token CALL
%token LP
%token RP
%token LCB
%token RCB
%token LSB
%token RSB
%token DOT
%token COMMA
%token SEMICOLON
%token ASSIGN_OP
%token DIVIDE_ASSIGN_OP
%token MULTIPLY_ASSIGN_OP
%token MOD_ASSIGN_OP
%token PLUS_ASSIGN_OP
%token MINUS_ASSIGN_OP
%token IS_EQUAL_OP
%token NOT_EQUAL_OP
%token STRING_IDENTIFIER
%token CHAR_IDENTIFIER
%token PLUS
%token MINUS
%token MULTIPLY_OP
%token DIVIDE_OP
%token MOD_OP
%token GT
%token LT
%token LTE
%token GTE
%token AND
%token OR
%token MAIN
%token SOUTH
%token NORTH
%token EAST
%token WEST
%token PLAYERX
%token PLAYERY
%token MOVE
%token NEW_LINE
%token UNDERSCORE
%token EGG_IN
%token EGG_OUT
%token INT
%token DOUBLE
%token STRING
%token CHAR
%token BOOL
%token IF
%token ELSE
%token FOR
%token WHILE
%token DO
%token VOID
%token RETURN
%token POW
%token MAX
%token MIN
%token SQUARE_ROOT
%token BOOL_STMT
%token STRING_STMT
%token CONST
%token INT_STMT
%token DOUBLE_STMT
%token CHAR_STMT
%token IDENTIFIER
%token COMMENT
%token LINE_COMMENT

%start program
%%
program:
	stmts

stmts:

	stmt NEW_LINE | stmts stmt NEW_LINE

stmt:
	matched_stmt 
	| unmatched_stmt

matched_stmt:
	IF LP logical_expression RP LCB matched_stmt RCB ELSE LCB matched_stmt RCB
	| non_if_stmt

unmatched_stmt:
	IF LP logical_expression RP LCB stmts RCB
	| IF LP logical_expression RP LCB matched_stmt RCB ELSE LCB unmatched_stmt RCB

non_if_stmt:
	| loops
	| arithmetic_operations SEMICOLON
	| function_call
	| function_declaration
	| declaration
	| initialization
	| declaration_and_initialization
	| input_stmt
	| output_stmt
	| COMMENT NEW_LINE
	| LINE_COMMENT

loops:
	while_loop
	| for_loop
	| do_while_loop

while_loop: 
	WHILE LP logical_expression RP LCB stmts RCB

for_loop:
	FOR LP loop_initialization logical_expression SEMICOLON arithmetic_operations RP LCB stmts RCB

do_while_loop:
	DO LCB stmts RCB WHILE LP logical_expression RP SEMICOLON

loop_initialization:
	initialization
	| declaration_and_initialization

logical_expression:
	recursive_expression

single_expression: 
	term logical_operator term 
	| BOOL_STMT
	| NOT BOOL_STMT

recursive_expression: 
	recursive_expression logical_connector single_expression 
	| single_expression

term:
	var

var:
	IDENTIFIER

logical_connector:
	AND
	| OR

logical_operator:
	IS_EQUAL_OP 
	| NOT_EQUAL_OP 
	| NOT 
	| GT 
	| LT
	| GTE
	| LTE

arithmetic_operations:
	arithmetic_operations PLUS divisionAndMultiplication 
	|arithmetic_operations MINUS divisionAndMultiplication 
	|divisionAndMultiplication
	|modulo
	|sqrt
	|power
	|max
	|min

divisionAndMultiplication: 
	divisionAndMultiplication DIVIDE_OP factor
	|divisionAndMultiplication MULTIPLY_OP factor
	| factor
 

modulo:
	factor MOD_OP factor

power: 
	POW LP INT_STMT COMMA INT_STMT RP
	| POW LP INT_STMT COMMA DOUBLE_STMT RP
	| POW LP DOUBLE_STMT COMMA INT_STMT RP
	| POW LP DOUBLE_STMT COMMA DOUBLE_STMT RP

constant_identifier:
	CONST term


factor:
	LP term RP
	| term

max:
	MAX LP INT_STMT COMMA INT_STMT RP 
	| MAX LP DOUBLE_STMT COMMA DOUBLE_STMT RP

min:
	MIN LP INT_STMT COMMA INT_STMT RP
	| MIN LP DOUBLE_STMT RP COMMA DOUBLE_STMT RP

sqrt:
	SQUARE_ROOT LP INT_STMT RP
	| SQUARE_ROOT LP DOUBLE_STMT RP

declaration: 
	types term SEMICOLON
	| types constant_identifier SEMICOLON

types:
	INT | DOUBLE | STRING | CHAR | BOOL

function_call:
	CALL IDENTIFIER LP IDENTIFIER RP SEMICOLON

initialization: 
	term assignment_operator assignment_values SEMICOLON

declaration_and_initialization:
	types term assignment_operator assignment_values SEMICOLON
	| types constant_identifier assignment_operator assignment_values SEMICOLON

assignment_operator: 
	ASSIGN_OP
	| DIVIDE_ASSIGN_OP
	| MULTIPLY_ASSIGN_OP
	| MOD_ASSIGN_OP
	| PLUS_ASSIGN_OP
	| MINUS_ASSIGN_OP

assignment_values: 
	BOOL_STMT
	| INT_STMT
	| STRING_STMT 
	| DOUBLE_STMT
	| CHAR_STMT

input_stmt: 
	EGG_IN LP input_context RP SEMICOLON

output_stmt: 
	EGG_OUT LP output_context RP SEMICOLON

input_context: 
	term PLUS input_context 
	| term

output_context: 
	term 
	| assignment_values
	| term PLUS output_context
	| assignment_values PLUS output_context

function_declaration:
	VOID IDENTIFIER LP parameter RP LCB stmts RCB 
	| types IDENTIFIER LP parameter RP LCB stmts RETURN assignment_values SEMICOLON RCB 
	| VOID IDENTIFIER LP parameter RP LCB stmts RETURN VOID SEMICOLON RCB

parameter:
	parameter COMMA types IDENTIFIER
	| types IDENTIFIER

%%

#include "lex.yy.c"
int lineno;

main() {
  return yyparse();
}

yyerror( char *s ) { fprintf( stderr, "line %d: %s\n", yylineno,s); };
