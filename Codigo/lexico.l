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
    return 0;
}

"var"       { return VAR_DECL; }
"const"     { return CONST_DECL; }
"int"       { return INT_TYPE; }
"if"        { return IF_ST; }
"else"      { return ELSE_ST; }
"while"     { return WHILE_ST; }
"print"     { return PRINT_ST; }
"read"      { return READ_ST; }


"+"         { return ADD; }
"-"         { return SUB; }
"*"         { return MUL; }
"/"         { return DIV; }

"="         { return ASSIGN; }
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
        fprintf(stderr, "Advertencia (Línea %d): ID largo, solo se usan los primeros 32 caracteres.\n", yylineno);

    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+ {
    long numero = atol(yytext);
        if (numero > 2147483648) {
        fprintf(stderr, "Error semántico en línea %d: Desbordamiento de entero.\n", yylineno);
    }

    yylval.str = strdup(yytext);
    return NUM;
}

[^[:space:][:alnum:]_(){};,=+\-*/?:\"]+ {
    fprintf(stderr,
            "Secuencia inválida \"%s\" en línea %d\n", yytext, yylineno);
}

. {
    fprintf(stderr,
            "Caracter inesperado '%s' en línea %d\n", yytext, yylineno);
}

%%

