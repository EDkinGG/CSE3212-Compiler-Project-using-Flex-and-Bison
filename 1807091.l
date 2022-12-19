chars [a-zA-Z]
digits [0-9]
special [$_@]
space " "
newline "\n"
Datatype "int_d"|"float_f"|"char_ch"|"double_lf"|"void"
Arithmatic_operator "+"|"-"|"/"|"*"|"&"|"|"|"mod"
Logical_operator "&&"|"||"|"!!"|"^^"
Unary_operator "#++"|"#--"|"!#"
Relation_operator "less"|"great"|"eqeq"|"great_eq"|"less_eq"|"noteq"
Assignment_operator "="|"+="|"-="|"/="|"*="
integer (-|+)?[0-9]+
float [+-]?[0-9]+[.][0-9]+|[+-]?[0-9]+[.][0-9]|[1-9]+e[-+][0-9]+
double [+-]?[0-9]+[.][0-9]+{6,12}|[+-]?[.][0-9]+|[1-9]+e[+-][0-9]+{6,12}
char [A-Za-z]+
Identifiers [a-zA-Z][a-zA-Z0-9]*
S_comment [/][/]~.*
M_comment [ ]*[/][~][a-zA-Z0-9!@#*(){}_+-,.:\|?><\n\t ]*[~][/]

%{
	#include "1807091.tab.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	int varindex(char *var);
	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	extern FILE *yyout;
	lineNo=1;
%}

%%


{S_comment} { printf("single line comment\n"); }
{M_comment} { printf("multiple_line_comment\n"); }


"s_start" { return MAIN_FN; }
"def"     { return DEF; }




"int_d"		{ return INT; }
"float_f"	{ return FLOAT; }
"char_ch"	{ return CHAR; }
"double_lf"	{ return DOUBLE; }
"string"    { return STRING; }





"#++" { return INC; }
"#--"	{ return DEC; }
"!#"	{ return NOT; }


{Logical_operator}	{ printf("Logical Operator "); }





"(("	  { return '('; }
"))"	  { return ')'; }
"{"	  { return '{'; }
"}"	  { return '}'; }
"["	  { return '['; }
"]"	  { return ']'; }
";#"    { return END; }
","     { return ','; }



"baireJah"    			{ return BREAK; }
"jeteThak"				{ return CONT; }
"choice"      			{ return CASE; }
"switch_case"      	{ return SWITCH;	}
"standby"     			{ return DEFAULT;	}





"go_till" { return WHILE; }
"go_for"  { return FOR; }
"pstep"   { return POS_STEP; }
"nstep"   { return NEG_STEP; }








"jodi"			{ return IF; }
"abar_jodi"		{ return ELIF; }
"naHoy"			{ return ELSE; }


":"     		{ return ':';}





"+"	{ return '+'; }
"-"	{ return '-'; }
"*"	{ return '*'; }
"/"	{ return '/'; }
"^"	{ return '^'; }
"mod"	{ return MOD; }
"="	{ return '='; }




"less"	{ return LT; }
"great"	{ return GT;; }
"eqeq"	{ return EQEQ; }
"great_eq"	{ return GEQ; }
"less_eq"	{ return LEQ; }
"noteq"	{ return NEQ; }





"sin"				{ return SIN; }
"cos"				{ return COS; }
"tan"				{ return TAN; }
"ln"				{ return LN; }
"log10"			{ return LOG10; }
"oddEven"		{ return ODDEVEN; }
"fctrl"			{ return FACTORIAL;  }
"sobar_boro"	{ return MAX; }
"sobar_choto"	{ return MIN; }
"prime_num"		{ return PRIME; }


"display"      { return WRITE; }
"poro"         { return READ; }


"\""(.)*"\"" 	{ 
						yylval.string = strdup(yytext);
					  	return STRING;
					}
					
{double} 	   { 
						yylval.flt = atof(yytext);
					  	return DOUBLE;
 					}

"-"?{digits}+  {
						yylval.num = atoi(yytext);
					  	return NUMBER;
					}
"-"?{digits}+?"."{digits}+ {
						yylval.num=atoi(yytext);
						return NUMBER;
					}


[ \t]*	;
[\n]    {lineNo++;}

"#Attach"  { return IMPORT; }
{Identifiers}".h" { return HEADER; }
{Identifiers} { 
	// printf("%s helloo \n",yytext);
	yylval.string = strdup(yytext);
	return VARIABLE; 
	}





%%

/* user subroutines */

int yywrap()
{
	return 1;
}

int main()
{
	
	yyin = freopen("input.txt","r",stdin);
	yyout = freopen("output.txt","w",stdout);
	yyparse();
	return 0;
	
}