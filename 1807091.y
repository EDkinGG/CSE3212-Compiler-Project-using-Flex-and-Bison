
%{
#include<stdio.h>
#include <math.h>
#include<stdlib.h>
#include<string.h>
extern lineNo;


   char var_name[1000][1000];

   int store[1000];


	int ttp = 0;

   /*--------------For handling if else statement-------------*/
	int ifptr = 0;
	int ifdone[1000];

	//variable counter
	int var_cnt = 1;

	/*-------------For SWITCH handling-------------*/
	int sw_var_val=0,case_ex=0;

   /*--------For handling Function----------*/
	char func_parameter[100][100];
	int func_count = 1;
   int func_exists(char *s)
	{
 		int i;
      for(i=1; i<func_count; i++)
		{
         if(strcmp(func_parameter[i],s) == 0)
				return 1;
      }
		return 0;
	}

	/*--------declaring Function----------*/
   int func_dec(char *s)
   {
      strcpy(func_parameter[func_count],s); 
		func_count++;
		return 1;
   }

	/*--------------Checking if a Variable is already declared or not-------------*/
   int chkDeclared(char *s){
        int i;
        for(i=1; i<var_cnt; i++){
            if(strcmp(var_name[i],s) == 0)
					return 1;
        }
		  return 0;
    }
    
	/*--------------Declaring Variable-------------*/
   int init_asn(char *s)
   {
      if(chkDeclared(s)==1)
		{
			return 0;
		}
      strcpy(var_name[var_cnt],s);
		store[var_cnt]=0;
		var_cnt++;
		return 1;
   }

	/*--------------Assigning Value to declared Variable-------------*/
    int setValue(char *s,int val)
    {
        if(chkDeclared(s) == 0)
            return 0;
        int ok=0, i;
        for( i=1; i<var_cnt; i++)
        {
            if(strcmp(var_name[i],s) == 0)
            {
                ok=i;
                break;
            }
        }
        store[ok]=val;
        return 1;
    }

	/*-----------getting the initialized variable value-------*/
   int getValue(char *s)
   {
        int pos=-1;
        int i;
        for( i=1; i<var_cnt; i++)
        {
            if(strcmp(var_name[i],s) == 0)
            {
                pos=i;
                break;
            }
        }
        return pos;
    }
    


%}

%union
{
   char *string;
   int num;
	double flt;
}
%error-verbose
%token <num>  NUMBER
%token <string>  VARIABLE
%type <num> expression
%type <num> END
%type <num> more
%type <num> cstatement

%type  <num> param

%type  <num> SIN
%type  <num> COS
%type  <num> TAN
%type  <num> LN
%type  <num> LOG10
%type  <num> ODDEVEN
%type  <num> FACTORIAL
%type  <num> MAX
%type  <num> MIN
%type  <num> PRIME
%type  <num> IF
%type  <num> ELIF
%type  <num> ELSE
%token MAIN_FN DEF INT FLOAT CHAR DOUBLE STRING INC DEC NOT END BREAK CONT CASE SWITCH DEFAULT WHILE FOR IF ELIF ELSE MOD LT GT EQEQ GEQ LEQ NEQ SIN COS TAN LN LOG10 ODDEVEN FACTORIAL MAX MIN PRIME WRITE IMPORT HEADER POS_STEP NEG_STEP READ

%left LT GT GEQ LEQ EQEQ NEQ
%left '+' '-'
%left '*' '/' MOD
%left '^'



%%
program:
        import func MAIN_FN '(' ')' '{' statements '}'  {printf("\nProgram successfully ended\n");}
        | /* NULL */
        ;

import: IMPORT HEADER { printf("\nHeader File Found!\n\n"); }
		| /* NULL */
		;



func: DEF VARIABLE '(' param ')' '{' statements '}'
	{
		printf("\nFUNC Declared!\n\n");		
	}
	| { printf("\nEmpty func \n\n");}
	;


param	:
		param ',' ptype pid	{ printf("\nValid func param declaration-1!\n"); } 
	|	ptype pid 	{ printf("\nValid func param declaration-2!\n"); } 
	;

ptype	:
	INT { ttp = 0;}

	| FLOAT  { ttp = 1;}

	| STRING  { ttp = 2;}
	;

pid	:
		 VARIABLE
		{
		   if(chkDeclared($1)==1)
      		printf("\nDuplicate Declaration! \n");
   		else
      	  init_asn($1);
		}
	;



/* function ends */


statements	:  /* NULL */ {printf("\nempty here \n");}
   |NUMBER 
	
	|statements cstatement

	| declare 
	;


declare	:
	type id END      	{ printf("\nValid declaration!\n"); } 
	;


type	:
	INT { ttp = 0;}

	| FLOAT  { ttp = 1;}

	| STRING  { ttp = 2;}
	;


id	:
	id ',' VARIABLE
		{
			// printf("var1 \n");
   		 if(chkDeclared($3)==1)
      			printf("\nDuplicate Declaration!");
   		 else
    			   init_asn($3);
		}

	| VARIABLE
		{
			// printf("var2 \n");
		   if(chkDeclared($1)==1)
      			printf("\nDuplicate Declaration! \n");
   		 else
      			init_asn($1);
		}
	
	| VARIABLE '=' expression
		{
			// printf("var3 \n");
		   if(chkDeclared($1)==1)
      			printf("\nDuplicate Declaration! \n");
   		 else
      			init_asn($1);
			
			if( setValue($1,$3) == 0 )
			{
				// $$ = 0;
				printf("\nvar not declared \n");
			}
			else
			{
				// $$=$3;
				// printf("\nvar declared initialize\n");
			}
		}
	;

cstatement: 
	cstatement more

	| more
	;

more:
	END
	| declare
	| expression END
		{
			$$=$1;
		}
	| WRITE '(' VARIABLE ')' END
	{
		if(chkDeclared($3)==0)
			{
				printf("\nCan't print, Value is not declared.\n");
			}
			else 
			{
				printf("\nWRITE_FUNC--> Value of the variable %s:  %d\t\n\n",$3, store[getValue($3)]);
			}
	}
	| READ '(' VARIABLE ')' END 
	{
      if(chkDeclared($3)==1)
            {
            printf("READ is successful.\n");
        }
		  }
	| VARIABLE '=' expression END 
	{
		if( setValue($1,$3) == 0 )
		{
			$$ = 0;
			printf("\nvar not declared \n");
		}
		else
		{
			$$=$3;
		}
	}
	| IF '(' expression ')' '{' cstatement '}'
	{
		ifptr++;
		if( $3 == 1 )
		{
			ifdone[ifptr] = 1;
			printf("\nif executed \n");
		}
	}
	| ELIF '(' expression ')' '{' cstatement '}' 
	{
		if( $3 == 1 && ifdone[ifptr] == 0)
		{
			ifdone[ifptr] = 1;
			printf("\nelseif executed \n");
		}
	}
	| ELSE '{' cstatement '}'
	{
		if( ifdone[ifptr] == 0)
		{
			ifdone[ifptr] = 1;
			printf("\nelse executed \n");
		}
	}

	| FOR '(' VARIABLE '=' NUMBER ',' VARIABLE LEQ NUMBER ',' VARIABLE POS_STEP NUMBER  ')' '{' cstatement '}'
		{			
			if( setValue($3,$5) == 0 )
			{
				printf("\nvar not declared loop cant be execute \n");
			}
			else
			{
			   int i;
				for(i= $5 ; i <= $9 ; i+=$13)
				{
					setValue($3,i);
					printf("for loop exp increasing %d\n",i);
				} 
				printf("\n");	
			} 			    
		}
	| FOR '(' VARIABLE '=' NUMBER ',' VARIABLE LT NUMBER ',' VARIABLE POS_STEP NUMBER  ')' '{' cstatement '}'
		{			
			if( setValue($3,$5) == 0 )
			{
				printf("\nvar not declared loop cant be execute \n");
			}
			else
			{
			   int i;
				for(i= $5 ; i < $9 ; i+=$13)
				{
					setValue($3,i);
					printf("for loop exp increasing %d\n",i);
				} 
				printf("\n");	
			} 			    
		}
	| FOR '(' VARIABLE '=' NUMBER ',' VARIABLE GEQ NUMBER ',' VARIABLE NEG_STEP NUMBER  ')' '{' cstatement '}'
		{			
			if( setValue($3,$5) == 0 )
			{
				printf("\nvar not declared loop cant be execute \n");
			}
			else
			{
			   int i;
				for(i= $5 ; i >= $9 ; i-=$13)
				{
					setValue($3,i);
					printf("for loop exp increasing %d\n",i);
				} 
				printf("\n");	
			} 			    
		}
	| FOR '(' VARIABLE '=' NUMBER ',' VARIABLE GT NUMBER ',' VARIABLE NEG_STEP NUMBER  ')' '{' cstatement '}'
		{			
			if( setValue($3,$5) == 0 )
			{
				printf("\nvar not declared loop cant be execute \n");
			}
			else
			{
			   int i;
				for(i= $5 ; i > $9 ; i-=$13)
				{
					setValue($3,i);
					printf("for loop exp increasing %d\n",i);
				} 
				printf("\n");	
			} 			    
		}
	| WHILE '(' VARIABLE LT NUMBER ')' '{' cstatement '}'
		{
			int a = store[getValue($3)];
			while((a+=1)< $5)
			{
				printf("While loop exp increasing %s : %d\n", $3, a);
			}
		}
	| SWITCH SWval '{' SWstatement '}'
	;

SWval :
	expression
		{
    		case_ex = 0;
    		sw_var_val = $1;
		}
	;

SWstatement: /* empty */

	| SWstatement CASE expression ':' cstatement BREAK END
		{
    		if($3 == sw_var_val && case_ex == 0 )
    			{
        			printf("\nExecuted choice %d\n",$3);
        			case_ex = 1;
   			 }
		}

	| SWstatement DEFAULT ':' cstatement 
		{
  		  if(case_ex == 0)
   			 {
    			   case_ex = 1;
     			   printf("\nDefault Block executed\n");
    			}
		}
	;

expression:
	NUMBER		   		  
	{
		$$ = $1;
	}

	| VARIABLE
		{
  		  if( chkDeclared($1) == 0)
   			 {
    			    $$=0;
     			   printf("\nNot declaredd!\n");
   			 }
    		else
       			 $$=store[getValue($1)];
					//  printf("Got value %d\n",$$);
		}
	| VARIABLE INC
		{
  		  if( chkDeclared($1) == 0)
   		{
    			$$=0;
     			printf("\nNot declaredd!\n");
   		}
    		else
			{
				int tmp = store[getValue($1)];
				tmp = tmp+1;
				store[getValue($1)] = tmp;
				$$=store[getValue($1)];
				//  printf("Got value %d\n",$$);
			}

		}
	| VARIABLE DEC
		{
  		  if( chkDeclared($1) == 0)
   		{
    			$$=0;
     			printf("\nNot declaredd!\n");
   		}
    		else
			{
				int tmp = store[getValue($1)];
				tmp = tmp-1;
				store[getValue($1)] = tmp;
				$$=store[getValue($1)];
				//  printf("Got value %d\n",$$);
			}
		}
	| VARIABLE NOT
		{
  		  if( chkDeclared($1) == 0)
   		{
    			$$=0;
     			printf("\nNot declaredd!\n");
   		}
    		else
			{
				int tmp = store[getValue($1)];
				tmp = !tmp;
				store[getValue($1)] = tmp;
				$$=store[getValue($1)];
				//  printf("Got value %d\n",$$);
			}

		}
	
	| expression '+' expression	  	
		 { 	
			$$ = $1 + $3; 
			printf("\nSum value %d\n",$$);
		 }

	| expression '-' expression	 	  
		{
  			$$ = $1 - $3; 
			printf("\nSubtraction value %d\n",$$);
		}

	| expression '*' expression
		{
 			   $$ = $1 * $3;
 			   printf("\nMultiplication value %d\n",$$);
		}

	| expression '/' expression	 	  
		{ 	
			if($3)
 			   {
  			      $$ = $1 / $3;
     				printf("\nDivision value %d\n",$$);
  			   }
   			 else
    			{
      				 $$ = 0;
       				 printf("\nDivision by zero\t");
    			}
		}

	| expression '^' expression 		
		{ 	
			$$=pow($1,$3); 
			printf("\nPower value %d\n",$$);
		}

	| expression MOD expression 		
		{	 
			$$=$1 % $3; 
			printf("\nRemainder value %d\n",$$);
		}

	| '(' expression ')'		  
    		 { $$ = $2 ;}
	| expression LT expression	
		{
			//  $$ = $1 < $3; 
			 if( $1 < $3 )
			 {
				$$ = 1;
			 }
			 else{
				$$ = 0;
			 }
			 printf("\n%d less check val \n",$$);
		}

	| expression GT expression	
		{
			$$ = $1 > $3; 
			printf("\n%d great check val \n",$$);
		}

	| expression LEQ expression  
		{ 
			$$ = $1 <= $3;
			printf("\n%d less eq check val \n",$$); 
		}

	| expression GEQ expression   
 		{ 
			$$ = $1 >= $3; 
		 	printf("\n%d great eq check val \n",$$);
		}
	
	| expression EQEQ expression   
 		{ 
			$$ = $1 == $3; 
		 	printf("\n%d eqeq check val \n",$$);
		}
	
	| expression NEQ expression   
 		{ 
			$$ = $1 != $3; 
		 	printf("\n%d not eq check val \n",$$);
		}
	| SIN '(' expression ')' 			
		{
			printf("\nValue of Sin(%d) is %lf\n",$3,sin($3*3.1416/180)); $$=sin($3*3.1416/180);
		}

	| COS '(' expression ')' 	 			
		{
			printf("\nValue of Cos(%d) is %lf\n",$3,cos($3*3.1416/180)); $$=cos($3*3.1416/180);
		}

	| TAN '(' expression ')'			
		{
			printf("\nValue of Tan(%d) is %lf\n",$3,tan($3*3.1416/180)); $$=tan($3*3.1416/180);
		}

	| LOG10 '(' expression ')'			
		{
			printf("\nValue of Log10(%d) is %lf\n",$3,(log($3*1.0)/log(10.0))); $$=(log($3*1.0)/log(10.0));
		}

	| LN '(' expression ')'			
		{
			printf("\nValue of ln(%d) is %lf\n",$3,(log($3))); $$=(log($3));
		}

	|ODDEVEN '(' expression ')'         
		{
			if($3%2==0)
			{
				$$ = 0;
				printf("\nvalue provided for OddEven function is %d which is even\n",$3);
			} 
			else
			{
				$$ = 1;
				printf("\nvalue provided for OddEven function is %d which is odd\n",$3);
			} 
				
		}

	|FACTORIAL '(' expression ')'           
		{
			int ans = 1;
			int i; 
			for(i=1; i<=$3; i++)
			{
				ans*=i;
			}
			printf("\nFactorial of %d is %d\n",$3,ans);
			$$ = ans;
		}

	|MAX '(' expression ',' expression ')'           
		{
			if( $3 < $5 )
			{
				$$ = $5;
				printf("\nMAX %d \n",$5);
			}
			else
			{
				$$ = $3;
				printf("\nMAX %d \n",$3);
			}
		}
	|MIN '(' expression ',' expression ')'           
		{
			if( $3 < $5 )
			{
				$$ = $3;
				printf("\nMIN %d \n",$3);
			}
			else
			{
				$$ = $5;
				printf("\nMIN %d \n",$5);
			}
		}
	
	|PRIME '(' expression ')'           
		{
			int x = $3;
			int ck = 0;
			int i; 
			for(i=2; i*i<=x; i++)
			{
				if( x%i == 0 )
				{
					ck = 1;
					break;
				}
			}
			if( ck )
			{
				$$ = 0;
				printf("\n%d is Not prime \n",x);
			}
			else
			{
				$$ = 1;
				printf("\n%d is prime \n",x);
			}
		}
	;



%%

int yyerror(char *s)
{
    printf( "%s\n %d", s, lineNo);
}








