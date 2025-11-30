%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "listaSimbolos.h"
    #include <stdbool.h>
    #include "listaCodigo.h"

    ListaC genera_expr_numero(char *numero);
    ListaC genera_expr_ident(char *identificador);
    ListaC genera_expresion_negada(ListaC expresion);
    ListaC genera_expr_condicional(ListaC cond, ListaC expr_true, ListaC expr_false);
    ListaC genera_if(ListaC condicion, ListaC bloque_if);
    ListaC genera_if_else(ListaC condicion, ListaC bloque_if, ListaC bloque_else);
    ListaC genera_while(ListaC cond, ListaC cuerpo);
    ListaC reduccion_print_item_expresion(ListaC expr);
    ListaC reduccion_print_item_string(char *lexema);
    ListaC reduccion_statment_list(ListaC lista, ListaC st);
    ListaC reduccion_const_asignacion(char *id, ListaC expr);
    ListaC reduccion_read_id(char *ident);
    ListaC reduccion_asignacion(char *ident, ListaC expr);
    ListaC reduccion_asignacion_multiple(char *ident, ListaC expr);
    ListaC sumar_expresiones(ListaC e1, ListaC e2);
    ListaC restar_expresiones(ListaC e1, ListaC e2);
    ListaC multiplicar_expresiones(ListaC e1, ListaC e2);
    ListaC dividir_expresiones(ListaC e1, ListaC e2);

    char  *registro(void);
    void liberar_estructuras();
    void   liberar_registro(char *reg);
    void   generar_MIPS(ListaC declaraciones, ListaC sentencias);
    void   declarar_identificador(char *nombre);
    Operacion new_op(char *operando, char *resultado,
                          char *argumento1, char *argumento2);
    int yylex(void);
    void yyerror(const char *s);
    extern int yylineno;

    Lista simb_table;

    Tipo tipo_actual;

    bool error_encontrado = false;
    int contador_cadenas = 0;
    int indice_label = 1;
    bool registros_en_uso[9];

    static int existe_simb_tabla(const char *nombre);
    static void meter_simb_tabla(const char *nombre, Tipo t);
    static Tipo tipo_simbolo(const char *nombre);
%}

%code requires {
  #include "listaCodigo.h"
}


%union {
    char *str; 
    ListaC codigo;
}
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
    : { simb_table = creaLS(); 
        for(int i=0; i<9; i++){
          registros_en_uso[i] = false;
        }
      }
      ID LPAREN RPAREN LBRACE declarations statement_list RBRACE
      {
        if (!error_encontrado) {
            generar_MIPS($6, $7);  
        }
        liberar_estructuras();
      }
    ;

  declarations
      : declarations VAR_DECL tipo { tipo_actual = VARIABLE; } var_list SEMIC
        {
          $$ = $1;
        }
      | declarations CONST_DECL tipo { tipo_actual = CONSTANTE; } const_list SEMIC
        {
        if (!error_encontrado) {
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
        if (!error_encontrado){
          concatenaLC($1, nuevo);
        }
        $$ = $1;
      }
    ;

statement_list
    : statement_list statement
      { 
        $$ = reduccion_statment_list($1, $2); 
      }
    | 
      { 
        $$ = creaLC();
      }
    ;

statement
    : ID ASSIGN asig SEMIC
      {
        $$ = reduccion_asignacion($1, $3);
      }
    | LBRACE statement_list RBRACE
      { $$ = $2; }
    | IF_ST LPAREN expression RPAREN statement ELSE_ST statement
      { $$ = genera_if_else($3, $5, $7); }
    | IF_ST LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
      { $$ = genera_if($3, $5); }
    | WHILE_ST LPAREN expression RPAREN statement
      { $$ = genera_while($3, $5); }
    | PRINT_ST LPAREN print_list RPAREN SEMIC
      { $$ = $3; }
    | READ_ST LPAREN read_list RPAREN SEMIC
      { $$ = $3; }
    ;

asig
    : ID ASSIGN asig
      {
        $$ = reduccion_asignacion_multiple($1, $3);
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
      { if (!error_encontrado){
            concatenaLC($1, $3); 
        }
        $$ = $1; 
      }
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
        if (!error_encontrado) {
            concatenaLC($1, nuevo);
        }
        $$ = $1;
      }
    ;

expression
    : expression ADD expression
      { $$ = sumar_expresiones($1, $3); }
    | expression SUB expression
      { $$ = restar_expresiones($1, $3); }
    | expression MUL expression
      { $$ = multiplicar_expresiones($1, $3); }
    | expression DIV expression
      { $$ = dividir_expresiones($1, $3); }
    //esto es: x = (A ? B : C) + 1;
    | LPAREN expression QMARK expression COLON expression RPAREN
      { $$ = genera_expr_condicional($2, $4, $6); }
    | SUB expression
      { $$ = genera_expresion_negada($2); }
    | LPAREN expression RPAREN
      { $$ = $2; }
    | ID
      { $$ = genera_expr_ident($1); }
    | NUM
      { $$ = genera_expr_numero($1); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error sintactico en linea %d: %s\n", yylineno, s);
}

static int existe_simb_tabla(const char *nombre) {
    PosicionLista posicion = buscaLS(simb_table, (char *)nombre);
    return posicion != finalLS(simb_table);
}

static void meter_simb_tabla(const char *nombre, Tipo t) {
    Simbolo s;
    s.nombre = strdup(nombre);
    s.tipo   = t;
    if (t == CADENA) {
        s.valor = contador_cadenas;
    } else {
        s.valor = 0;
    }
    insertaLS(simb_table, finalLS(simb_table), s);
}

static Tipo tipo_simbolo(const char *nombre) {
    PosicionLista posicion = buscaLS(simb_table, (char *)nombre);
    if (posicion == finalLS(simb_table)) {
        return VARIABLE;
    }
    Simbolo s = recuperaLS(simb_table, posicion);
    return s.tipo;
}

char* registro(void) {
    int idx = 0;
    while (idx < 9) {
        if (registros_en_uso[idx] == false)
            break;
        idx++;
    }
    if (idx == 9) {
        yyerror("No hay registros disponibles");
        return NULL;
    }
    registros_en_uso[idx] = true;
    char *nombre_reg = NULL;
    asprintf(&nombre_reg, "$t%d", idx);
    return nombre_reg;
}

ListaC genera_expr_numero(char *numero){
  if(error_encontrado){
    return creaLC();
  }
  ListaC lista = creaLC();
  char *r = registro();
  insertaLC(lista, 
            finalLC(lista),
            new_op("li",r,numero,NULL));
  guardaResLC(lista,r); 
  return lista;
}

ListaC genera_expr_ident(char *identificador){
  if (!existe_simb_tabla(identificador)) {
    fprintf(stderr, "[SEMÁNTICO] Linea %d: variable '%s' usada sin declarar\n", yylineno, identificador);
    error_encontrado = true;
  }
  if(error_encontrado){
    return creaLC();
  }
  ListaC lista = creaLC();
  char *r = registro();
  char *id;
  asprintf(&id,"_%s",identificador);
  insertaLC(lista, 
            finalLC(lista), 
            new_op("lw", r, id, NULL));
  guardaResLC(lista,r);
  return lista;
}

ListaC genera_expresion_negada(ListaC expresion){
    if(error_encontrado){
      return expresion;
    }
    char *reg_cero = registro();
    insertaLC(expresion, 
              finalLC(expresion), 
              new_op("li", reg_cero, "0", NULL));
    char *reg_res = recuperaResLC(expresion);
    insertaLC(expresion, 
              finalLC(expresion), 
              new_op("sub", reg_res, reg_cero, reg_res));
    liberar_registro(reg_cero);
    return expresion;
}

ListaC sumar_expresiones(ListaC e1, ListaC e2) {
    if (error_encontrado) {
        return e1;
    }
    concatenaLC(e1, e2);
    char *reg_res_dest = recuperaResLC(e1);
    char *reg_arg2 = recuperaResLC(e2);
    
    Operacion op_suma = new_op(
        "add", 
        reg_res_dest, 
        reg_res_dest, 
        reg_arg2
    );
    insertaLC(e1, finalLC(e1), op_suma);
    liberar_registro(reg_arg2);
    return e1; 
}

ListaC restar_expresiones(ListaC e1, ListaC e2) {
    if (error_encontrado) {
        return e1;
    }
    concatenaLC(e1, e2);
    char *reg_res_dest = recuperaResLC(e1);
    char *reg_arg2 = recuperaResLC(e2);

    Operacion op_resta = new_op(
        "sub", 
        reg_res_dest, 
        reg_res_dest, 
        reg_arg2
    );
    insertaLC(e1, finalLC(e1), op_resta);
    liberar_registro(reg_arg2);
    return e1; 
}

ListaC multiplicar_expresiones(ListaC e1, ListaC e2) {
    if (error_encontrado) {
        return e1;
    }
    concatenaLC(e1, e2);
    char *reg_res_dest = recuperaResLC(e1);
    char *reg_arg2 = recuperaResLC(e2);

    Operacion op_multiplicacion = new_op(
        "mul", 
        reg_res_dest, 
        reg_res_dest, 
        reg_arg2
    );
    insertaLC(e1, finalLC(e1), op_multiplicacion);
    liberar_registro(reg_arg2);
    return e1; 
}

ListaC dividir_expresiones(ListaC e1, ListaC e2) {
    if (error_encontrado) {
        return e1;
    }
    concatenaLC(e1, e2);
    char *reg_res_dest = recuperaResLC(e1);
    char *reg_arg2 = recuperaResLC(e2);

    Operacion op_division = new_op(
        "div", 
        reg_res_dest, 
        reg_res_dest, 
        reg_arg2
    );
    insertaLC(e1, finalLC(e1), op_division);
    liberar_registro(reg_arg2);
    return e1; 
}

ListaC genera_expr_condicional(ListaC cond, ListaC expr_true, ListaC expr_false) {
    if (error_encontrado) {
        return cond;
    }
    char *etq_false;
    char *etq_fin;
    asprintf(&etq_false, "$l%d", indice_label++);
    asprintf(&etq_fin, "$l%d", indice_label++);
    char *reg_resultado_final = registro();
    ListaC resultado = creaLC();
    concatenaLC(resultado, cond);
    char *reg_cond = recuperaResLC(cond);
    insertaLC(
        resultado,
        finalLC(resultado),
        new_op("beqz", reg_cond, etq_false, NULL)
    );
    liberar_registro(reg_cond);
    concatenaLC(resultado, expr_true);
    char *reg_true = recuperaResLC(expr_true);
    insertaLC(resultado, finalLC(resultado), new_op("move", reg_resultado_final, reg_true, NULL));
    liberar_registro(reg_true);
    insertaLC(resultado, finalLC(resultado), new_op("j", etq_fin, NULL, NULL));
    insertaLC(resultado, finalLC(resultado), new_op("etiq", etq_false, NULL, NULL));
    concatenaLC(resultado, expr_false);
    char *reg_false = recuperaResLC(expr_false);
    insertaLC(resultado, finalLC(resultado), new_op("move", reg_resultado_final, reg_false, NULL));
    liberar_registro(reg_false);
    insertaLC(resultado, finalLC(resultado), new_op("etiq", etq_fin, NULL, NULL));
    guardaResLC(resultado, reg_resultado_final);
    return resultado;
}

Operacion new_op(char *operando, char *resultado,char *argumento1,char *argumenton2 ){
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

ListaC genera_if(ListaC condicion, ListaC bloque_if) {
    if (error_encontrado){
      return condicion;
    }
    char *etq_fin;
    asprintf(&etq_fin, "$l%d", indice_label++);
    char *reg_cond = recuperaResLC(condicion);
    insertaLC(
        condicion,
        finalLC(condicion),
        new_op("beqz", reg_cond, etq_fin, NULL)
    );
    liberar_registro(reg_cond);
    concatenaLC(condicion, bloque_if);
    insertaLC(
        condicion,
        finalLC(condicion),
        new_op("etiq", etq_fin, NULL, NULL)
    );
    return condicion;
}

ListaC genera_if_else(ListaC condicion, ListaC bloque_if, ListaC bloque_else) {
    if (error_encontrado){
      return condicion;
    }
    char *etq_else;
    char *etq_fin;
    asprintf(&etq_else, "$l%d", indice_label++);
    asprintf(&etq_fin,  "$l%d", indice_label++);
    char *reg_cond = recuperaResLC(condicion);
    insertaLC(condicion,finalLC(condicion),new_op("beqz", reg_cond, etq_else, NULL));
    liberar_registro(reg_cond);
    concatenaLC(condicion, bloque_if);
    insertaLC(
        condicion,
        finalLC(condicion),
        new_op("j", etq_fin, NULL, NULL)
    );
    insertaLC(
        condicion,
        finalLC(condicion),
        new_op("etiq", etq_else, NULL, NULL)
    );
    concatenaLC(condicion, bloque_else);
    insertaLC(
        condicion,
        finalLC(condicion),
        new_op("etiq", etq_fin, NULL, NULL)
    );
    return condicion;
}

ListaC genera_while(ListaC cond, ListaC cuerpo) {
    if (error_encontrado){
      return cond;
    }
    char *etq_inicio;
    char *etq_salida;
    asprintf(&etq_inicio, "$l%d", indice_label++);
    asprintf(&etq_salida, "$l%d", indice_label++);
    ListaC resultado = creaLC();
    insertaLC(resultado, 
        finalLC(resultado),
        new_op("etiq", etq_inicio, NULL, NULL)
    );
    concatenaLC(resultado, cond);
    char *reg_cond = recuperaResLC(cond);
    insertaLC(resultado, 
        finalLC(resultado),
        new_op("beqz", reg_cond, etq_salida, NULL)
    );
    liberar_registro(reg_cond);
    concatenaLC(resultado, cuerpo);
    insertaLC(resultado, 
        finalLC(resultado),
        new_op("j", etq_inicio, NULL, NULL)
    );
    insertaLC(resultado, 
        finalLC(resultado),
        new_op("etiq", etq_salida, NULL, NULL)
    );
    return resultado;
}

ListaC reduccion_print_item_expresion(ListaC expr) {
    if (error_encontrado) {
        return expr;
    }
    char *registro_valor = recuperaResLC(expr);
    insertaLC(
        expr,
        finalLC(expr),
        new_op("move", "$a0", registro_valor, NULL)
    );
    insertaLC(
        expr,
        finalLC(expr),
        new_op("li", "$v0", "1", NULL)
    );
    Operacion op_syscall = new_op("syscall", NULL, NULL, NULL);
    insertaLC(
        expr,
        finalLC(expr),
        op_syscall
    );
    liberar_registro(registro_valor);
    return expr;
}

ListaC reduccion_print_item_string(char *lexema){
    if (error_encontrado){
        return creaLC();
    }
    meter_simb_tabla(lexema, CADENA);
    ListaC salida = creaLC();
    char *etiqueta;
    asprintf(&etiqueta, "$str%d", contador_cadenas);
    insertaLC(
        salida,
        finalLC(salida),
        new_op("la", "$a0", etiqueta, NULL)
    );
    insertaLC(
        salida,
        finalLC(salida),
        new_op("li", "$v0", "4", NULL)
    );
    insertaLC(
        salida,
        finalLC(salida),
        new_op("syscall", NULL, NULL, NULL)
    );
    contador_cadenas++;
    return salida;
}

ListaC reduccion_statment_list(ListaC statement_list, ListaC statement){
  if (error_encontrado){ 
    return statement_list;
  }
  concatenaLC(statement_list, statement);
  return statement_list;
}

ListaC reduccion_const_asignacion(char *identificador, ListaC expresion_derecha) {
    if (existe_simb_tabla(identificador)) {
        fprintf(stderr,
                "Error semantico (linea %d): identificador '%s' redeclarado\n",
                yylineno, identificador);
        error_encontrado = true;
        return expresion_derecha; 
    }
    meter_simb_tabla(identificador, CONSTANTE);
    if (error_encontrado) {
        return expresion_derecha;
    }
    char *reg_res = recuperaResLC(expresion_derecha);
    char *dest_id;
    Operacion operacion;
    asprintf(&dest_id, "_%s", identificador);
    operacion.arg1 = dest_id; 
    operacion.res = reg_res;
    operacion.op = "sw";
    operacion.arg2 = NULL; 
    insertaLC(expresion_derecha, finalLC(expresion_derecha), operacion);
    liberar_registro(reg_res); // Liberar reg_res usado por la expresión
    return expresion_derecha;
}

void declarar_identificador(char *nombre){
    if (existe_simb_tabla(nombre)) {
        fprintf(stderr,
                "Error semantico (linea %d): variable '%s' redeclarada\n",
                yylineno, nombre);
        error_encontrado = true;
    } else {
        meter_simb_tabla(nombre, tipo_actual);
    }
}

ListaC reduccion_read_id(char *ident) {
    if (!existe_simb_tabla(ident)) {
        fprintf(stderr,
                "Error semantico (linea %d): variable '%s' usada sin declarar en read\n",
                yylineno, ident);
        error_encontrado = true;
        return creaLC();
    }
    if (tipo_simbolo(ident) == CONSTANTE) {
        fprintf(stderr,
                "Error semantico (linea %d): no se puede hacer read sobre la constante '%s'\n",
                yylineno, ident);
        error_encontrado = true;
        return creaLC();
    }
    if (error_encontrado) {
        return creaLC();
    }
    ListaC codigo = creaLC();
    insertaLC(
        codigo,
        finalLC(codigo),
        new_op("li", "$v0", "5", NULL)
    );
    insertaLC(
        codigo,
        finalLC(codigo),
        new_op("syscall", NULL, NULL, NULL)
    );
    char *dest;
    asprintf(&dest, "_%s", ident);
    insertaLC(codigo, finalLC(codigo),new_op("sw", "$v0", dest, NULL));
    return codigo;
}

ListaC reduccion_asignacion(char *ident, ListaC expr) {
    if (!existe_simb_tabla(ident)) {
        fprintf(stderr,
                "Error semantico (linea %d): variable '%s' usada sin declarar\n",
                yylineno, ident);
        error_encontrado = true;
        return expr;   // devolvemos la lista tal cual, sin añadir sw
    }
    if (tipo_simbolo(ident) == CONSTANTE) {
        fprintf(stderr,
                "Error semantico (linea %d): no se puede asignar a la constante '%s'\n",
                yylineno, ident);
        error_encontrado = true;
        return expr;
    }
    if (error_encontrado) {
        return expr;
    }
    char *reg_res = recuperaResLC(expr);
    char *dest;
    asprintf(&dest, "_%s", ident);
    insertaLC(
        expr,
        finalLC(expr),
        new_op("sw", reg_res, dest, NULL)
    );
    liberar_registro(reg_res);
    return expr;
}

void generar_MIPS(ListaC declaraciones, ListaC sentencias) {
    concatenaLC(declaraciones, sentencias);
    ListaC codigo_final = declaraciones;
    FILE *f = fopen("output.asm", "w");
    if (!f) {
        perror("No se pudo abrir output.asm");
        exit(1);
    }
    fprintf(f, ".data\n");
    if (simb_table != NULL) {
        PosicionLista posicion = inicioLS(simb_table);
        while (posicion != finalLS(simb_table)) {
            Simbolo s = recuperaLS(simb_table, posicion);
            if (s.tipo == CADENA) {
                fprintf(f, "$str%d: .asciiz \"%s\"\n", s.valor, s.nombre);
            } else {
                fprintf(f, "_%s: \t.word %d\n", s.nombre, s.valor);
            }
            posicion = siguienteLS(simb_table, posicion);
        }
    }
    fprintf(f, "\n.text\n");
    fprintf(f, ".globl main\n");
    fprintf(f, "main:\n");
    PosicionListaC posicionc = inicioLC(codigo_final);
    while (posicionc != finalLC(codigo_final)) {
        Operacion op = recuperaLC(codigo_final, posicionc);

        if (strcmp(op.op, "etiq") == 0) {
            fprintf(f, "%s:\n", op.res);
        } else {
            fprintf(f, "%s", op.op);
            if (op.res){
              fprintf(f, " %s", op.res);
            }
            if (op.arg1){
              fprintf(f, ", %s", op.arg1);
            }
            if (op.arg2){
              fprintf(f, ", %s", op.arg2);
            }
            fprintf(f, "\n");
        }
        posicionc = siguienteLC(codigo_final, posicionc);
    }
    fprintf(f, "li $v0, 10\n");
    fprintf(f, "syscall\n");
    fprintf(f, "# Código generado por mi compilador MiniC\n");
    fclose(f);
}

ListaC reduccion_asignacion_multiple(char *ident, ListaC expr) {
    if (!existe_simb_tabla(ident)) {
        fprintf(stderr,
                "Error semantico (linea %d): variable '%s' usada sin declarar\n",
                yylineno, ident);
        error_encontrado = true;
        return expr;
    }
    if (tipo_simbolo(ident) == CONSTANTE) {
        fprintf(stderr,
                "Error semantico (linea %d): no se puede asignar a la constante '%s'\n",
                yylineno, ident);
        error_encontrado = true;
        return expr;
    }
    if (error_encontrado) {
        return expr;
    }
    char *registro_fuente = recuperaResLC(expr);
    char *destino_memoria;
    asprintf(&destino_memoria, "_%s", ident);
    Operacion op_sw;
    op_sw.op = "sw";
    op_sw.res = registro_fuente; 
    op_sw.arg1 = destino_memoria;
    op_sw.arg2 = NULL;
    insertaLC(expr,finalLC(expr),op_sw);
    return expr;
}

void liberar_estructuras() {
    if (simb_table != NULL) {
        PosicionLista posicion = inicioLS(simb_table);
        while (posicion != finalLS(simb_table)) {
            Simbolo s = recuperaLS(simb_table, posicion);
            free(s.nombre); 
            posicion = siguienteLS(simb_table, posicion);
        }
        free(simb_table);
    }
    simb_table = NULL; 
}