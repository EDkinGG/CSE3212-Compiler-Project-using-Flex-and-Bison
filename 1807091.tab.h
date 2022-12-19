
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     VARIABLE = 259,
     MAIN_FN = 260,
     DEF = 261,
     INT = 262,
     FLOAT = 263,
     CHAR = 264,
     DOUBLE = 265,
     STRING = 266,
     INC = 267,
     DEC = 268,
     NOT = 269,
     END = 270,
     BREAK = 271,
     CONT = 272,
     CASE = 273,
     SWITCH = 274,
     DEFAULT = 275,
     WHILE = 276,
     FOR = 277,
     IF = 278,
     ELIF = 279,
     ELSE = 280,
     MOD = 281,
     LT = 282,
     GT = 283,
     EQEQ = 284,
     GEQ = 285,
     LEQ = 286,
     NEQ = 287,
     SIN = 288,
     COS = 289,
     TAN = 290,
     LN = 291,
     LOG10 = 292,
     ODDEVEN = 293,
     FACTORIAL = 294,
     MAX = 295,
     MIN = 296,
     PRIME = 297,
     WRITE = 298,
     IMPORT = 299,
     HEADER = 300,
     POS_STEP = 301,
     NEG_STEP = 302,
     READ = 303
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 111 "1807091.y"

   char *string;
   int num;
	double flt;



/* Line 1676 of yacc.c  */
#line 108 "1807091.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


