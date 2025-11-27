%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "sintaxis.tab.h"  
    
    static int linea_inicio_comentario = 0;
    static int linea_inicio_cadena = 0;

    extern YYSTYPE yylval;
%}

%option noyywrap
%option yylineno

%x COMENT_BLOQUE

car_invalido  [^[:space:][:alnum:]_(){};,=+\-*/?:\"]

%%


[ \t\r]+            {  }

\n                  {  }

"//".*              {  }

"/*" {
    linea_inicio_comentario = yylineno;
    BEGIN(COMENT_BLOQUE);
}

<COMENT_BLOQUE>"*/" { BEGIN(INITIAL); }

<COMENT_BLOQUE>.    { }

<COMENT_BLOQUE>\n   { }

<COMENT_BLOQUE><<EOF>> {
    fprintf(stderr,
            "Comentario sin cerrar (empezó en la línea %d)\n",
            linea_inicio_comentario);
    exit(1);
}

"var"       { return VAR_DECL; }
"const"     { return CONST_DECL; }
"int"       { return INT_TYPE; }
"if"        { return IF_ST; }
"else"      { return ELSE_ST; }
"while"     { return WHILE_ST; }
"print"     { return PRINT_ST; }
"read"      { return READ_ST; }


"="         { return ASSIGN; }
"+"         { return ADD; }
"-"         { return SUB; }
"*"         { return MUL; }
"/"         { return DIV; }

"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
","         { return COMMA; }
";"         { return SEMIC; }
"?"         { return QMARK; }
":"         { return COLON; }



\"([^"\n\\]|\\.)* {
    fprintf(stderr,
            "Hay una cadena de caracteres sin cerrar en linea %d\n",
            yylineno);
    exit(1);
}


\"([^\"\\]|\\.)*\" {
    
    size_t len = strlen(yytext);
   
    char *contenido = (char *)malloc(len - 1);  
    if (!contenido) {
        fprintf(stderr, "Error de memoria al procesar cadena (línea %d)\n", yylineno);
        exit(1);
    }

   
    strncpy(contenido, yytext + 1, len - 2);
    contenido[len - 2] = '\0';

   
    yylval.str = contenido;
    return STRING;
}


([A-Za-z_])([A-Za-z0-9_])*  {
    if (strlen(yytext) > 32)
        fprintf(stderr, "Identificador demasiado largo (línea %d): %s\n", yylineno, yytext);

    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+ {
    long val = atol(yytext);
    if (val > 2147483648)
        fprintf(stderr, "Número fuera de rango en línea %d\n", yylineno);

    yylval.str = strdup(yytext);
    return NUM;
}

{car_invalido}+ {
    fprintf(stderr,
            "Secuencia inválida \"%s\" en línea %d\n", yytext, yylineno);
}

. {
    fprintf(stderr,
            "Carácter inesperado '%s' en línea %d\n", yytext, yylineno);
}

%%

