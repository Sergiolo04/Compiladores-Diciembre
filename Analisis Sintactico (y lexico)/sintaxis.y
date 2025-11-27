%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "listaSimbolos.h"
    #include <stdbool.h>
    #include "listaCodigo.h"
    void generar_MIPS(ListaC codigo_final);

    ListaC reduccion_NUM(char *numero);
    ListaC reduccion_ID(char *identificador);
    ListaC reduccion_expresion_negada(ListaC expresion);
    ListaC reduccion_expresion_operacion_expresion(ListaC e1, ListaC e2, char *op);
    ListaC reduccion_if_simple(ListaC condicion, ListaC bloque_if);
    ListaC reduccion_if_else(ListaC condicion, ListaC bloque_if, ListaC bloque_else);
    ListaC reduccion_while(ListaC cond, ListaC cuerpo);
    ListaC reduccion_print_item_expresion(ListaC expr);
    ListaC reduccion_print_item_string(char *lexema);
    ListaC reduccion_statment_list(ListaC lista, ListaC st);
    ListaC reduccion_const_asignacion(char *id, ListaC expr);
    ListaC reduccion_read_id(char *ident);
    ListaC reduccion_asignacion(char *ident, ListaC expr);
    ListaC reduccion_asignacion_sin_liberar(char *ident, ListaC expr);


    char  *registro(void);
    void   liberar_registro(char *reg);
    void   generar_MIPS(ListaC codigo_final);
    void   declarar_identificador(char *nombre);
    Operacion nueva_operacion(char *operando, char *resultado,
                          char *argumento1, char *argumento2);
    int yylex(void);
    void yyerror(const char *s);
    extern int yylineno;

    Lista tabla_de_simbolos;

    Tipo tipo_actual;

    int errores_semanticos = 0;
    int contador_cadenas = 0;
    int contador_etiquetas_de_salto = 1;
    bool registros_en_uso[9];

    static int existe_simbolo(const char *nombre);
    static void insertar_simbolo(const char *nombre, Tipo t);
    static Tipo tipo_simbolo(const char *nombre);
%}

%code requires {
  #include "listaCodigo.h"
}


%union {
    char *str;   /* para ID y STRING */
    ListaC codigo;
}

/* TOKENS con campo del %union */
%token <str> ID STRING NUM
%type <codigo> expression statement print_list print_item statement_list declarations const_list read_list asig

%token VAR_DECL CONST_DECL INT_TYPE IF_ST ELSE_ST WHILE_ST PRINT_ST READ_ST
%token ASSIGN ADD SUB MUL DIV
%token LPAREN RPAREN LBRACE RBRACE
%token COMMA SEMIC QMARK COLON

%left  ADD SUB
%left  MUL DIV
%right ASSIGN
%right QMARK COLON

//LOWER_THAN_ELSE tiene menos precedencia
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE_ST

%start program

%%
program
    : { tabla_de_simbolos = creaLS(); 
        for(int i=0; i<9; i++){
          registros_en_uso[i] = false;
        }
    }
      ID LPAREN RPAREN LBRACE declarations statement_list RBRACE
      {
        if (errores_semanticos == 0) {
            concatenaLC($6, $7); 
            generar_MIPS($6);   
        }
      }
    ;

  declarations
      : declarations VAR_DECL tipo { tipo_actual = VARIABLE; } var_list SEMIC
        {
          $$ = $1;
        }
      | declarations CONST_DECL tipo { tipo_actual = CONSTANTE; } const_list SEMIC
        {
        if (errores_semanticos == 0) {
            concatenaLC($1, $5); 
        }
        $$ = $1; 
      }
      | 
        {
          $$ = creaLC();
        }
      ;

tipo
    : INT_TYPE
      { }
    ;


var_list
    : ID
      { declarar_identificador($1); }
    | var_list COMMA ID
      { declarar_identificador($3); }
    ;

const_list
    : ID ASSIGN expression
      {
        $$ = reduccion_const_asignacion($1, $3);
      }
    | const_list COMMA ID ASSIGN expression
      {
        ListaC nuevo = reduccion_const_asignacion($3, $5);
        if (errores_semanticos == 0) concatenaLC($1, nuevo);
        $$ = $1;
      }
    ;

statement_list
    : statement_list statement
      { $$ = reduccion_statment_list($1, $2); }
    | 
      { $$ = creaLC(); }
    ;

statement
    : ID ASSIGN asig SEMIC
      {
        $$ = reduccion_asignacion($1, $3);
      }
    | LBRACE statement_list RBRACE
      { $$ = $2; }
    | IF_ST LPAREN expression RPAREN statement ELSE_ST statement
      { $$ = reduccion_if_else($3, $5, $7); }
    | IF_ST LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
      { $$ = reduccion_if_simple($3, $5); }
    | WHILE_ST LPAREN expression RPAREN statement
      { $$ = reduccion_while($3, $5); }
    | PRINT_ST LPAREN print_list RPAREN SEMIC
      { $$ = $3; }
    | READ_ST LPAREN read_list RPAREN SEMIC
      { $$ = $3; }
    ;

asig
    : ID ASSIGN asig
      {
        /* asignación intermedia: NO liberamos el registro,
           lo reutilizarán las asignaciones de más a la izquierda */
        $$ = reduccion_asignacion_sin_liberar($1, $3);
      }
    | expression
      {
        $$ = $1;
      }
    ;

print_list
    : print_item
      { $$ = $1; }
    | print_list COMMA print_item
      { if (errores_semanticos == 0) concatenaLC($1,$3); $$ = $1; }
    ;

print_item
    : expression
      { $$ = reduccion_print_item_expresion($1); }
    | STRING
      { 
        $$ = reduccion_print_item_string($1);
      }
    ;

read_list
    : ID
      { $$ = reduccion_read_id($1); }
    | read_list COMMA ID
      {
        ListaC nuevo = reduccion_read_id($3);
        if (errores_semanticos == 0) {
            concatenaLC($1, nuevo);
        }
        $$ = $1;
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
      { $$ = $2; }
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

void yyerror(const char *s) {
    fprintf(stderr, "Error sintactico en linea %d: %s\n", yylineno, s);
}

static int existe_simbolo(const char *nombre) {
    PosicionLista p = buscaLS(tabla_de_simbolos, (char *)nombre);
    return p != finalLS(tabla_de_simbolos);
}

static void insertar_simbolo(const char *nombre, Tipo t) {
    Simbolo s;
    s.nombre = strdup(nombre);
    s.tipo   = t;
    if (t == CADENA) {
        s.valor = contador_cadenas;
    } else {
        s.valor = 0;
    }
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

char* registro(void) {
    for (int i = 0; i < 9; i++) {
        if (!registros_en_uso[i]) {
            registros_en_uso[i] = true;
            char *reg;
            asprintf(&reg, "$t%d", i);
            return reg;
        }
    }
    yyerror("No quedan registros libres");
    return NULL;
}


ListaC reduccion_NUM(char *numero){
  if(errores_semanticos > 0) return NULL;
  ListaC lista = creaLC();
  char *r = registro();
  insertaLC(lista, finalLC(lista),nueva_operacion("li",r,numero,NULL));
  guardaResLC(lista,r); 
  return lista;
}

ListaC reduccion_ID(char *identificador){
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
    operacion_creada.op = operando;
    operacion_creada.res = resultado;
    operacion_creada.arg1 = argumento1;
    operacion_creada.arg2 = argumenton2;
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
    liberar_registro(rtmp);
    return expr;
}

ListaC reduccion_print_item_string(char *lexema){
    if (errores_semanticos > 0) return NULL;
    insertar_simbolo(lexema, CADENA);
    ListaC salida = creaLC();
    char *etiqueta;
    asprintf(&etiqueta, "$str%d", contador_cadenas);
    insertaLC(
        salida,
        finalLC(salida),
        nueva_operacion("la", "$a0", etiqueta, NULL)   // cargar dirección de la cadena
    );
    insertaLC(
        salida,
        finalLC(salida),
        nueva_operacion("li", "$v0", "4", NULL)       // servicio print_string
    );
    insertaLC(
        salida,
        finalLC(salida),
        nueva_operacion("syscall", NULL, NULL, NULL)
    );
    contador_cadenas++;
    return salida;
}


ListaC reduccion_statment_list(ListaC statement_list, ListaC statement){
  if (errores_semanticos > 0) return NULL;
  concatenaLC(statement_list, statement);
  return statement_list;
}

ListaC reduccion_const_asignacion(char *identificador, ListaC expresion_derecha) {
    if (existe_simbolo(identificador)) {
        fprintf(stderr,
                "Error semantico (linea %d): identificador '%s' redeclarado\n",
                yylineno, identificador);
        errores_semanticos++;
        return expresion_derecha; 
    }
    insertar_simbolo(identificador, CONSTANTE);
    if (errores_semanticos > 0) 
        return expresion_derecha;
    Operacion operacion;
    operacion.op = "sw";
    operacion.arg2 = NULL;
    asprintf(&operacion.res, "%s", recuperaResLC(expresion_derecha));
    asprintf(&operacion.arg1, "_%s", identificador);
    insertaLC(expresion_derecha, finalLC(expresion_derecha), operacion);
    liberar_registro(recuperaResLC(expresion_derecha));
    return expresion_derecha;
}

void declarar_identificador(char *nombre){
    if (existe_simbolo(nombre)) {
        fprintf(stderr,
                "Error semantico (linea %d): variable '%s' redeclarada\n",
                yylineno, nombre);
        errores_semanticos++;
    } else {
        insertar_simbolo(nombre, tipo_actual);
    }
}

ListaC reduccion_read_id(char *ident) {
    if (!existe_simbolo(ident)) {
        fprintf(stderr,
                "Error semantico (linea %d): variable '%s' usada sin declarar en read\n",
                yylineno, ident);
        errores_semanticos++;
        return creaLC();
    }
    if (tipo_simbolo(ident) == CONSTANTE) {
        fprintf(stderr,
                "Error semantico (linea %d): no se puede hacer read sobre la constante '%s'\n",
                yylineno, ident);
        errores_semanticos++;
        return creaLC();
    }
    if (errores_semanticos > 0) {
        return creaLC();
    }
    ListaC codigo = creaLC();
    insertaLC(
        codigo,
        finalLC(codigo),
        nueva_operacion("li", "$v0", "5", NULL)
    );
    insertaLC(
        codigo,
        finalLC(codigo),
        nueva_operacion("syscall", NULL, NULL, NULL)
    );
    char *dest;
    asprintf(&dest, "_%s", ident);
    insertaLC(
        codigo,
        finalLC(codigo),
        nueva_operacion("sw", "$v0", dest, NULL)
    );
    return codigo;
}

ListaC reduccion_asignacion(char *ident, ListaC expr) {
    if (!existe_simbolo(ident)) {
        fprintf(stderr,
                "Error semantico (linea %d): variable '%s' usada sin declarar\n",
                yylineno, ident);
        errores_semanticos++;
        return expr;   // devolvemos la lista tal cual, sin añadir sw
    }
    if (tipo_simbolo(ident) == CONSTANTE) {
        fprintf(stderr,
                "Error semantico (linea %d): no se puede asignar a la constante '%s'\n",
                yylineno, ident);
        errores_semanticos++;
        return expr;
    }
    if (errores_semanticos > 0) {
        return expr;
    }
    char *reg_res = recuperaResLC(expr);
    char *dest;
    asprintf(&dest, "_%s", ident);
    insertaLC(
        expr,
        finalLC(expr),
        nueva_operacion("sw", reg_res, dest, NULL)
    );
    liberar_registro(reg_res);
    return expr;
}

void generar_MIPS(ListaC codigo_final) {
    FILE *f = fopen("output.asm", "w");
    if (!f) {
        perror("No se pudo abrir output.asm");
        exit(1);
    }
    fprintf(f, ".data\n");
    if (tabla_de_simbolos != NULL) {
        PosicionLista p = inicioLS(tabla_de_simbolos);
        while (p != finalLS(tabla_de_simbolos)) {
            Simbolo s = recuperaLS(tabla_de_simbolos, p);
            if (s.tipo == CADENA) {
                fprintf(f, "$str%d: .asciiz \"%s\"\n", s.valor, s.nombre);
            } else {
                fprintf(f, "_%s: .word %d\n", s.nombre, s.valor);
            }
            p = siguienteLS(tabla_de_simbolos, p);
        }
    }

    fprintf(f, "\n.text\n");
    fprintf(f, ".globl main\n");
    fprintf(f, "main:\n");

    PosicionListaC q = inicioLC(codigo_final);

    while (q != finalLC(codigo_final)) {
        Operacion op = recuperaLC(codigo_final, q);

        if (strcmp(op.op, "etiq") == 0) {
            fprintf(f, "%s:\n", op.res);
        } else {
            fprintf(f, "%s", op.op);
            if (op.res)  fprintf(f, " %s", op.res);
            if (op.arg1) fprintf(f, ", %s", op.arg1);
            if (op.arg2) fprintf(f, ", %s", op.arg2);
            fprintf(f, "\n");
        }

        q = siguienteLC(codigo_final, q);
    }

    fprintf(f, "li $v0, 10\n");
    fprintf(f, "syscall\n");

    fclose(f);
}

ListaC reduccion_asignacion_sin_liberar(char *ident, ListaC expr) {
    if (!existe_simbolo(ident)) {
        fprintf(stderr,
                "Error semantico (linea %d): variable '%s' usada sin declarar\n",
                yylineno, ident);
        errores_semanticos++;
        return expr;
    }

    if (tipo_simbolo(ident) == CONSTANTE) {
        fprintf(stderr,
                "Error semantico (linea %d): no se puede asignar a la constante '%s'\n",
                yylineno, ident);
        errores_semanticos++;
        return expr;
    }

    if (errores_semanticos > 0) {
        return expr;
    }

    char *reg_res = recuperaResLC(expr);
    char *dest;
    asprintf(&dest, "_%s", ident);

    insertaLC(
        expr,
        finalLC(expr),
        nueva_operacion("sw", reg_res, dest, NULL)
    );

    return expr;
}
