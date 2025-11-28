prueba() {
    const int a = 0, b = 0;
    var int c, d, e;

    print("Inicio del programa\n");

    c = 5 + 2 - 2;

    if (a)
        print("a", "\n");
    else if (b)
        print("No a y b\n");
    else
        while (c) {
            print("c = ", c, "\n");
            c = c - 2 + 1;
        }

    print("Final de If/While\n");

    // ----------------------------
    // PRUEBA DE ASIGNACIÓN MÚLTIPLE
    // ----------------------------
    c = d = e = 10;

    print("Asignaciones múltiples:\n");
    print("c = ", c, "\n");
    print("d = ", d, "\n");
    print("e = ", e, "\n");

    // Cambiamos valores para ver si de verdad se copian bien
    c = d = e = c + 5; // c, d, e ahora valen 15

    print("Tras c = d = e = c + 5:\n");
    print("c = ", c, "\n");
    print("d = ", d, "\n");
    print("e = ", e, "\n");

    // ----------------------------
    // PRUEBA DE EXPRESIÓN NEGADA (UNARIA)
    // ----------------------------
    print("\n--- PRUEBA DE EXPRESIÓN NEGADA ---\n");
    d = 20;
    e = -d; // e debería valer -20

    print("d = ", d, "\n");
    print("e = -d: ", e, "\n");
    
    // Segunda prueba de negación
    d = -(e + 5); // e = -20. e + 5 = -15. d = -(-15), d = 15

    print("e + 5 = ", e + 5, "\n");
    print("d = -(e + 5): ", d, "\n");


    // ----------------------------
    // PRUEBA DE EXPRESIÓN CONDICIONAL TERNARIA
    // ----------------------------
    print("\n--- PRUEBA DE TERNARIA (A ? B : C) ---\n");
    
    // 1. Condición FALSA (d=15, lo usaremos como condición, es TRUE)
    // Para probar la rama FALSE, necesitamos una condición que sea 0.
    c = 0; // Condición FALSE
    d = 1; // Condición TRUE

    e = (c ? 100 : 200); // c es 0 (Falso) -> e debe ser 200
    print("e = (0 ? 100 : 200): ", e, "\n"); 

    e = (d ? 100 : 200); // d es 1 (Verdadero) -> e debe ser 100
    print("e = (1 ? 100 : 200): ", e, "\n"); 

    // 2. Anidamiento y Expresiones (Para probar la complejidad de la pila)
    // d = 1 (TRUE), c = 0 (FALSE)
    e = (d ? (c + 5) : (c - 5)); // d es TRUE. Resultado: c + 5 = 0 + 5 = 5
    print("e = (d ? (c + 5) : (c - 5)): ", e, "\n"); 

    // ----------------------------
    // PRUEBA DE READ
    // ----------------------------
    print("\n--- PRUEBA DE LECTURA ---\n");
    print("Introduce un nuevo valor para c:\n");
    read(c);
    print("Nuevo valor de c = ", c, "\n");
}