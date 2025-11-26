#include <stdio.h>
#include <stdlib.h>

int yyparse(void);        // Generado por Bison
extern int yylineno;      // Línea actual (la exporta Flex/Bison)
extern FILE *yyin;        // Flujo de entrada que usa el lexer

int main(int argc, char **argv) {
    // Si me pasan un fichero por parámetro, lo uso como entrada
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("No se pudo abrir el fichero de entrada");
            return 1;
        }
    }

    int res = yyparse();  // Llama al analizador sintáctico (que a su vez llama al léxico)

    if (res == 0) {
        printf("Analisis sintactico correcto.\n");
    } else {
        printf("Analisis sintactico terminado con errores.\n");
    }

    if (argc > 1 && yyin) {
        fclose(yyin);
    }
    return res;
}
