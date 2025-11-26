%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "listaSimbolos.h"

    int yylex(void);
    void yyerror(const char *s);
    extern int yylineno;

    /* Tabla de símbolos global */
    Lista tabla_de_simbolos;

    /* Tipo que se está declarando en este momento (VARIABLE / CONSTANTE) */
    Tipo tipo_actual;

    /* Contador de errores semánticos */
    int errores_semanticos = 0;
    int contador_cadenas = 0;
    int contador_etiquetas_de_salto = 1;
    bool registros_en_uso[9];

    /* Funciones auxiliares sobre la tabla de símbolos */
    static int existe_simbolo(const char *nombre);
    static void insertar_simbolo(const char *nombre, Tipo t);
    static Tipo tipo_simbolo(const char *nombre);
%}

%code requires {
  #include "listaCodigo.h"
}

/* ---------- Valores semánticos ---------- */
%union {
    char *str;   /* para ID y STRING */
    ListaC codigo;
}

/* TOKENS con campo del %union */
%token <str> ID STRING NUM
%type <codigo> expression statement print_list print_item

%token VAR_DECL CONST_DECL INT_TYPE IF_ST ELSE_ST WHILE_ST PRINT_ST READ_ST
%token ASSIGN ADD SUB MUL DIV
%token LPAREN RPAREN LBRACE RBRACE
%token COMMA SEMIC QMARK COLON

/* Precedencias */
%left  ADD SUB
%left  MUL DIV
%right ASSIGN
%right QMARK COLON

//LOWER_THAN_ELSE tiene menos precedencia
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE_ST

%start program

%%

/* ===================================================== */
/*       GRAMÁTICA + ACCIONES SEMÁNTICAS BÁSICAS        */
/* ===================================================== */

/* program → id ( ) { declarations statement_list } */
program
    : { tabla_de_simbolos = creaLS(); }
      ID LPAREN RPAREN LBRACE declarations statement_list RBRACE
      {
        printf("Aplica regla: program -> id ( ) { declarations statement_list }\n");
      }
    ;

/* declarations → declarations VAR tipo var_list ;
                | declarations CONST tipo const_list ;
                | λ
*/
declarations
    : declarations VAR_DECL tipo { tipo_actual = VARIABLE; } var_list SEMIC
      {
        printf("Aplica regla: declarations -> declarations var tipo var_list ;\n");
      }
    | declarations CONST_DECL tipo { tipo_actual = CONSTANTE; } const_list SEMIC
      {
        printf("Aplica regla: declarations -> declarations const tipo const_list ;\n");
      }
    | /* vacío */
      {
        printf("Aplica regla: declarations -> λ\n");
      }
    ;

/* tipo → int (ahora mismo no hacemos nada más con él) */
tipo
    : INT_TYPE
      {
        printf("Aplica regla: tipo -> int\n");
      }
    ;

/* var_list → id
            | var_list , id
   Aquí insertamos variables en la tabla y comprobamos redeclaraciones.
*/
var_list
    : ID
      {
        if (existe_simbolo($1)) {
            fprintf(stderr,
                    "Error semantico (linea %d): variable '%s' redeclarada\n",
                    yylineno, $1);
            errores_semanticos++;
        } else {
            insertar_simbolo($1, tipo_actual);  /* VARIABLE */
        }
        printf("Aplica regla: var_list -> id\n");
      }
    | var_list COMMA ID
      {
        if (existe_simbolo($3)) {
            fprintf(stderr,
                    "Error semantico (linea %d): variable '%s' redeclarada\n",
                    yylineno, $3);
            errores_semanticos++;
        } else {
            insertar_simbolo($3, tipo_actual);  /* VARIABLE */
        }
        printf("Aplica regla: var_list -> var_list , id\n");
      }
    ;

/* const_list → id = expression
              | const_list , id = expression
   Aquí insertamos constantes y también comprobamos redeclaraciones.
*/
const_list
    : ID ASSIGN expression
      {
        if (existe_simbolo($1)) {
            fprintf(stderr,
                    "Error semantico (linea %d): identificador '%s' redeclarado\n",
                    yylineno, $1);
            errores_semanticos++;
        } else {
            insertar_simbolo($1, CONSTANTE);
        }
        printf("Aplica regla: const_list -> id = expression\n");
      }
    | const_list COMMA ID ASSIGN expression
      {
        if (existe_simbolo($3)) {
            fprintf(stderr,
                    "Error semantico (linea %d): identificador '%s' redeclarado\n",
                    yylineno, $3);
            errores_semanticos++;
        } else {
            insertar_simbolo($3, CONSTANTE);
        }
        printf("Aplica regla: const_list -> const_list , id = expression\n");
      }
    ;

/* statement_list → statement_list statement
                  | λ
*/
statement_list
    : statement_list statement
      { printf("Aplica regla: statement_list -> statement_list statement\n"); }
    | /* vacío */
      { printf("Aplica regla: statement_list -> λ\n"); }
    ;

/* statement con semántica en la asignación:

   - LHS debe existir.
   - LHS no puede ser CONSTANTE.
*/
statement
    : ID ASSIGN expression SEMIC
      {
        if (!existe_simbolo($1)) {
            fprintf(stderr,
                    "Error semantico (linea %d): variable '%s' usada sin declarar\n",
                    yylineno, $1);
            errores_semanticos++;
        } else if (tipo_simbolo($1) == CONSTANTE) {
            fprintf(stderr,
                    "Error semantico (linea %d): no se puede asignar a la constante '%s'\n",
                    yylineno, $1);
            errores_semanticos++;
        }
        printf("Aplica regla: statement -> id = expression ;\n");
      }
    | LBRACE statement_list RBRACE
      { $$ = $2; }
    | IF_ST LPAREN expression RPAREN statement ELSE_ST statement
      { $$ = reduccion_if_else($3, $5, $7); }
    | IF_ST LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
      { $$ = reduccion_if_simple(); }
    | WHILE_ST LPAREN expression RPAREN statement
      { $$ = reduccion_while(); }
    | PRINT_ST LPAREN print_list RPAREN SEMIC
      { $$ = $3; }
    | READ_ST LPAREN read_list RPAREN SEMIC
      { $$ = $3; }
    ;

print_list
    : print_item
      { $$ = $1; }
    | print_list COMMA print_item
      { if (errores_semanticos == 0) concatenaLC($1,$3); $$ = $1; }
    ;

print_item
    : expression
      { 
        $$ = reduccion_print_item_expresion($1);
        liberar_registro(recuperaResLC($1)); 
      }
    | STRING
      { 
        insertar_simbolo($1, CADENA);
        contador_cadenas++;
        $$ = reduccion_print_item_string("aqui hay que pasarle una cadena que ya investigaré como pasarch");
      }
    ;

/* read_list → id | read_list , id
   Aquí también comprobamos que las variables a leer estén declaradas.
*/
read_list
    : ID
      {
        if (!existe_simbolo($1)) {
            fprintf(stderr,
                    "Error semantico (linea %d): variable '%s' usada sin declarar en read\n",
                    yylineno, $1);
            errores_semanticos++;
        }
        printf("Aplica regla: read_list -> id\n");
      }
    | read_list COMMA ID
      {
        if (!existe_simbolo($3)) {
            fprintf(stderr,
                    "Error semantico (linea %d): variable '%s' usada sin declarar en read\n",
                    yylineno, $3);
            errores_semanticos++;
        }
        printf("Aplica regla: read_list -> read_list , id\n");
      }
    ;

expression
    : expression ADD expression
      { $$ = reduccion_expresion_operacion_expresion($1, $3, "add"); }
    | expression SUB expression
      { $$ = reduccion_expresion_operacion_expresion($1, $3, "sub"); }
    | expression MUL expression
      { $$ = reduccion_expresion_operacion_expresion($1, $3, "mul"); }
    | expression DIV expression
      { $$ = reduccion_expresion_operacion_expresion($1, $3, "div"); }
    | LPAREN expression QMARK expression COLON expression RPAREN
      { $$ = $2 }
    | SUB expression
      { $$ = reduccion_expresion_negada($2); }
    | LPAREN expression RPAREN
      { $$ = $2; }
    | ID
      { $$ = reduccion_ID($1); }
    | NUM
      { $$ = reduccion_NUM($1); }
    ;

%%

/* ========================= */
/*   CÓDIGO C DE APOYO       */
/* ========================= */

void yyerror(const char *s) {
    fprintf(stderr, "Error sintactico en linea %d: %s\n", yylineno, s);
}

int main(void) {
    int res = yyparse();
    if (res == 0 && errores_semanticos == 0) {
        printf("Analisis sintactico y semantico correcto.\n");
    } else if (res == 0) {
        printf("Analisis sintactico correcto, pero hay %d errores semanticos.\n",
               errores_semanticos);
    }
    return res;
}

/* --------- Funciones auxiliares sobre la tabla de símbolos ---------- */

static int existe_simbolo(const char *nombre) {
    PosicionLista p = buscaLS(tabla_de_simbolos, (char *)nombre);
    return p != finalLS(tabla_de_simbolos);
}

static void insertar_simbolo(const char *nombre, Tipo t) {
    Simbolo s;
    s.nombre = strdup(nombre);
    s.tipo   = t;
    s.valor  = 0;     /* por ahora no lo usamos */
    insertaLS(tabla_de_simbolos, finalLS(tabla_de_simbolos), s);
}

static Tipo tipo_simbolo(const char *nombre) {
    PosicionLista p = buscaLS(tabla_de_simbolos, (char *)nombre);
    if (p == finalLS(tabla_de_simbolos)) {
        /* No debería llamarse sin comprobar antes existe_simbolo */
        return VARIABLE;
    }
    Simbolo s = recuperaLS(tabla_de_simbolos, p);
    return s.tipo;
}

static boolean es_constante(){

}

static void imprimirTablaS(){

}

char* registro(){
  int i = 0;
  wile(i<9){
    if(!registros_en_uso[i]) {
        registros_en_uso[i] = true;
        char* registro;
        asprintf(&registro,"$t%d",i);
        return registro;
    }
    i++;
  }
  yyerror("No quedan registros libres");
}

ListaC reduccion_NUM(ListaC numero){
  if(errores_semanticos > 0) return NULL;
  ListaC lista = creaLC();
  char *r = registro();
  insertaLC(lista, finalLC(lista),nueva_operacion("li",r,numero,NULL));
  guardaResLC(lista,r); 
  return lista;
}

ListaC reduccion_ID(ListaC identificador){
  if (!existe_simbolo(identificador)) {
    fprintf(stderr, "Error semantico (linea %d): variable '%s' usada sin declarar\n", yylineno, identificador);
    errores_semanticos++;
  }
  if(errores_semanticos > 0) return NULL;
  ListaC lista = creaLC();
  char *r = registro();
  char *id;
  asprintf(&id,"_%s",identificador);
  insertaLC(lista, finalLC(lista), nueva_operacion("lw", r, id, NULL));
  guardaResLC(lista,r);
  return lista;
}

ListaC reduccion_expresion_negada(ListaC expresion){
  if(errores_semanticos > 0) return NULL;
  insertaLC(expresion,finalLC(expresion),nueva_operacion("neg",recuperaResLC(expresion),recuperaResLC(expresion),0));
  return expresion;
}

ListaC reduccion_expresion_operacion_expresion(ListaC expresion1, ListaC expresion2, char *operando){
    if(errores_semanticos > 0) return NULL;
    concatenaLC(expresion1,expresion2);
    insertaLC(expresion1,finalLC(expresion1),nueva_operacion(operando,recuperaResLC(expresion1),recuperaResLC(expresion1),recuperaResLC(expresion2)));
    liberar_registro(recuperaResLC(expresion2));
    return expresion1; 
}

Operacion nueva_operacion(char *operando, char *resultado,char *argumento1,char *argumenton2 ){
    Operacion operacion_creada;
    operacion.op = operando;
    operacion.res = resultado;
    operacion.arg1 = argumento1;
    operacion.arg2 = argumenton2;
    return operacion_creada;
} 

void liberar_registro(char *reg) {
    int num = -1;

    if (sscanf(reg, "$t%d", &num) != 1) { //si sscanf consigue leer un entero devuelve 1 (si no, devuelve 0)
        fprintf(stderr, "Error: formato de registro inválido (%s)\n", reg);
        return;
    }

    if (num < 0 || num >= 9) {
        fprintf(stderr, "Error: número de registro fuera de rango (%d)\n", num);
        return;
    }

    if (!registros_en_uso[num]) {
        fprintf(stderr, "Aviso: intento de liberar un registro que ya esta libre (%s)\n", reg);
        return;
    }

    registros_en_uso[num] = false;
}

ListaC reduccion_if_simple(ListaC condicion, ListaC bloque_if) {
    if (errores_semanticos > 0) return NULL;
    char *etq_fin;
    asprintf(&etq_fin, "$l%d", contador_etiquetas_de_salto++);
    char *reg_cond = recuperaResLC(condicion);
    insertaLC(
        condicion,
        finalLC(condicion),
        nueva_operacion("beqz", reg_cond, etq_fin, NULL)
    );
    liberar_registro(reg_cond);
    concatenaLC(condicion, bloque_if);
    insertaLC(
        condicion,
        finalLC(condicion),
        nueva_operacion("etiq", etq_fin, NULL, NULL)
    );
    return condicion;
}

ListaC reduccion_if_else(ListaC condicion, ListaC bloque_if, ListaC bloque_else) {
    if (errores_semanticos > 0) return NULL;
    char *etq_else;
    char *etq_fin;
    asprintf(&etq_else, "$l%d", contador_etiquetas_de_salto++);
    asprintf(&etq_fin,  "$l%d", contador_etiquetas_de_salto++);
    char *reg_cond = recuperaResLC(condicion);
    insertaLC(
        condicion,
        finalLC(condicion),
        nueva_operacion("beqz", reg_cond, etq_else, NULL)
    );
    liberar_registro(reg_cond);
    concatenaLC(condicion, bloque_if);
    insertaLC(
        condicion,
        finalLC(condicion),
        nueva_operacion("j", etq_fin, NULL, NULL)
    );
    insertaLC(
        condicion,
        finalLC(condicion),
        nueva_operacion("etiq", etq_else, NULL, NULL)
    );
    concatenaLC(condicion, bloque_else);
    insertaLC(
        condicion,
        finalLC(condicion),
        nueva_operacion("etiq", etq_fin, NULL, NULL)
    );
    return condicion;
}

ListaC reduccion_while(ListaC cond, ListaC cuerpo) {
    if (errores_semanticos > 0) return NULL;
    char *etq_inicio;
    char *etq_salida;
    asprintf(&etq_inicio, "$l%d", contador_etiquetas_de_salto++);
    asprintf(&etq_salida, "$l%d", contador_etiquetas_de_salto++);
    ListaC resultado = creaLC();
    insertaLC(resultado, 
        finalLC(resultado),
        nueva_operacion("etiq", etq_inicio, NULL, NULL)
    );
    concatenaLC(resultado, cond);
    char *reg_cond = recuperaResLC(cond);
    insertaLC(resultado, 
        finalLC(resultado),
        nueva_operacion("beqz", reg_cond, etq_salida, NULL)
    );
    liberar_registro(reg_cond);
    concatenaLC(resultado, cuerpo);
    insertaLC(resultado, 
        finalLC(resultado),
        nueva_operacion("j", etq_inicio, NULL, NULL)
    );
    insertaLC(resultado, 
        finalLC(resultado),
        nueva_operacion("etiq", etq_salida, NULL, NULL)
    );
    return resultado;
}

ListaC reduccion_print_item_expresion(ListaC expr) {
    if (errores_semanticos > 0) return NULL;
    char *rtmp = recuperaResLC(expr);
    insertaLC(
        expr,
        finalLC(expr),
        nueva_operacion("move","$a0",rtmp,NULL)
    );
    insertaLC(
        expr,
        finalLC(expr),
        nueva_operacion("li","$v0","1",NULL)
    );
    insertaLC(
        expr,
        finalLC(expr),
        nueva_operacion("syscall",NULL,NULL,NULL)
    );

    return expr;
}
