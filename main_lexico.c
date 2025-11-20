#include <stdio.h>

int yylex(void);
extern int yylineno;

int main(void) {
    int token;
    while ((token = yylex()) != 0) {
        /* El lexer ya imprime los tokens */
    }

    printf("Fin del analisis lexico. Lineas leidas: %d\n", yylineno);
    return 0;
}
