%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    static int linea_inicio_comentario = 0;
    static int linea_inicio_cadena = 0;
%}

%option noyywrap
%option yylineno

%x COMENT_BLOQUE
%x CADENA

car_invalido  [^[:space:][:alnum:]_(){};,=+\-*/?:\"]

%%


[ \t\r\n]+          { }

"//".*              { }

"/*" {
    linea_inicio_comentario = yylineno;
    BEGIN(COMENT_BLOQUE);
}

<COMENT_BLOQUE>"*/" {
    BEGIN(INITIAL);
}

<COMENT_BLOQUE>.   { }

<COMENT_BLOQUE><<EOF>> {
    fprintf(stderr,
            "Comentario de bloque sin cerrar (empezó en la linea %d)\n",
            linea_inicio_comentario);
    return 0;
}


"var"       { printf("TOKEN VAR_DECL (linea %d)\n", yylineno); }
"const"     { printf("TOKEN CONST_DECL (linea %d)\n", yylineno); }
"int"       { printf("TOKEN INT_TYPE (linea %d)\n", yylineno); }
"if"        { printf("TOKEN IF_ST (linea %d)\n", yylineno); }
"else"      { printf("TOKEN ELSE_ST (linea %d)\n", yylineno); }
"while"     { printf("TOKEN WHILE_ST (linea %d)\n", yylineno); }
"print"     { printf("TOKEN PRINT_ST (linea %d)\n", yylineno); }
"read"      { printf("TOKEN READ_ST (linea %d)\n", yylineno); }


"="         { printf("TOKEN ASSIGN (linea %d)\n", yylineno); }
"+"         { printf("TOKEN ADD (linea %d)\n", yylineno); }
"-"         { printf("TOKEN SUB (linea %d)\n", yylineno); }
"*"         { printf("TOKEN MUL (linea %d)\n", yylineno); }
"/"         { printf("TOKEN DIV (linea %d)\n", yylineno); }

"("         { printf("TOKEN LPAREN (linea %d)\n", yylineno); }
")"         { printf("TOKEN RPAREN (linea %d)\n", yylineno); }
"{"         { printf("TOKEN LBRACE (linea %d)\n", yylineno); }
"}"         { printf("TOKEN RBRACE (linea %d)\n", yylineno); }

","         { printf("TOKEN COMMA (linea %d)\n", yylineno); }
";"         { printf("TOKEN SEMIC (linea %d)\n", yylineno); }
"?"         { printf("TOKEN QMARK (linea %d)\n", yylineno); }
":"         { printf("TOKEN COLON (linea %d)\n", yylineno); }

\" {
    linea_inicio_cadena = yylineno;
    BEGIN(CADENA);
}

<CADENA>\" {
    printf("TOKEN STRING (linea %d)\n", linea_inicio_cadena);
    BEGIN(INITIAL);
}

<CADENA>\n {
    fprintf(stderr,
            "Cadena de caracteres sin cerrar (empezó en la linea %d)\n",
            linea_inicio_cadena);
    BEGIN(INITIAL);
}

<CADENA>.  { }

<CADENA><<EOF>> {
    fprintf(stderr,
            "Cadena de caracteres sin cerrar al final del fichero (empezó en la linea %d)\n",
            linea_inicio_cadena);
    return 0;
}

([A-Za-z_])([A-Za-z0-9_])*  {
    if (strlen(yytext) > 32) {
        fprintf(stderr,
                "Existe un identificador muy largo en la linea %d: %s\n",
                yylineno, yytext);
    }
    printf("TOKEN ID %s (linea %d)\n", yytext, yylineno);
}


[0-9]+ {
    if (atol(yytext) > 2147483648) {
        printf("Existe un numero muy largo en la linea %d\n", yylineno);
    }
    printf("TOKEN NUM %s (linea %d)\n", yytext, yylineno);
}


{car_invalido}+ {
    fprintf(stderr,
            "Secuencia de caracteres no valida \"%s\" en linea %d\n",
            yytext, yylineno);
}

. {
    fprintf(stderr,
            "Error lexico: caracter inesperado '%s' en linea %d\n",
            yytext, yylineno);
}

%%
