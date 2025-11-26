
%{
#include <stdio.h>
void yyerror();
extern int yylex();
%}

%union{
int entero;
char *cadena;
}

%token PARI PARD FIN ASIG
%token <entero> NUM
%token <cadena> ID
%left MAS MENOS
%left POR DIV MOD
%left UMENOS
%type <entero> expresion entrada


%%

entrada : 	              {$$=1;}
	| entrada {printf("Expr n. %d: ",$1);} linea        {$$=$1+1;}
        ;

linea : expresion FIN {printf("%d\n",$1);} 
	| ID ASIG expresion FIN {printf("La variable %s toma el valor %d\n",$1,$3);}
	| error FIN   
        ;

expresion : expresion MAS expresion {$$ = $1 + $3; }
          | expresion MENOS expresion {$$ = $1 - $3;}
          | expresion POR expresion {$$ = $1 * $3;}
       	  | expresion DIV expresion {$$ = $1 / $3;}
        | expresion MOD expresion {$$ = $1 % $3;}
        | PARI expresion PARD {$$ = $2;}
	| MENOS expresion %prec UMENOS {$$=-$2;} 
       | NUM ;

%%

void yyerror()
{
printf("Se ha producido un error en esta expresion\n");
}

