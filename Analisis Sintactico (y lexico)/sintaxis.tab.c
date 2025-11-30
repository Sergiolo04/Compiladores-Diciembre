/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "sintaxis.y"

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

#line 123 "sintaxis.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "sintaxis.tab.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_ID = 3,                         /* ID  */
  YYSYMBOL_STRING = 4,                     /* STRING  */
  YYSYMBOL_NUM = 5,                        /* NUM  */
  YYSYMBOL_VAR_DECL = 6,                   /* VAR_DECL  */
  YYSYMBOL_CONST_DECL = 7,                 /* CONST_DECL  */
  YYSYMBOL_INT_TYPE = 8,                   /* INT_TYPE  */
  YYSYMBOL_IF_ST = 9,                      /* IF_ST  */
  YYSYMBOL_ELSE_ST = 10,                   /* ELSE_ST  */
  YYSYMBOL_WHILE_ST = 11,                  /* WHILE_ST  */
  YYSYMBOL_PRINT_ST = 12,                  /* PRINT_ST  */
  YYSYMBOL_READ_ST = 13,                   /* READ_ST  */
  YYSYMBOL_ASSIGN = 14,                    /* ASSIGN  */
  YYSYMBOL_ADD = 15,                       /* ADD  */
  YYSYMBOL_SUB = 16,                       /* SUB  */
  YYSYMBOL_MUL = 17,                       /* MUL  */
  YYSYMBOL_DIV = 18,                       /* DIV  */
  YYSYMBOL_LPAREN = 19,                    /* LPAREN  */
  YYSYMBOL_RPAREN = 20,                    /* RPAREN  */
  YYSYMBOL_LBRACE = 21,                    /* LBRACE  */
  YYSYMBOL_RBRACE = 22,                    /* RBRACE  */
  YYSYMBOL_COMMA = 23,                     /* COMMA  */
  YYSYMBOL_SEMIC = 24,                     /* SEMIC  */
  YYSYMBOL_QMARK = 25,                     /* QMARK  */
  YYSYMBOL_COLON = 26,                     /* COLON  */
  YYSYMBOL_LOWER_THAN_ELSE = 27,           /* LOWER_THAN_ELSE  */
  YYSYMBOL_YYACCEPT = 28,                  /* $accept  */
  YYSYMBOL_program = 29,                   /* program  */
  YYSYMBOL_30_1 = 30,                      /* $@1  */
  YYSYMBOL_declarations = 31,              /* declarations  */
  YYSYMBOL_32_2 = 32,                      /* $@2  */
  YYSYMBOL_33_3 = 33,                      /* $@3  */
  YYSYMBOL_tipo = 34,                      /* tipo  */
  YYSYMBOL_var_list = 35,                  /* var_list  */
  YYSYMBOL_const_list = 36,                /* const_list  */
  YYSYMBOL_statement_list = 37,            /* statement_list  */
  YYSYMBOL_statement = 38,                 /* statement  */
  YYSYMBOL_asig = 39,                      /* asig  */
  YYSYMBOL_print_list = 40,                /* print_list  */
  YYSYMBOL_print_item = 41,                /* print_item  */
  YYSYMBOL_read_list = 42,                 /* read_list  */
  YYSYMBOL_expression = 43                 /* expression  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if !defined yyoverflow

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* !defined yyoverflow */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   122

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  28
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  16
/* YYNRULES -- Number of rules.  */
#define YYNRULES  39
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  94

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   282


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint8 yyrline[] =
{
       0,    83,    83,    83,    98,    98,   102,   102,   110,   116,
     122,   124,   129,   133,   144,   149,   155,   159,   161,   163,
     165,   167,   169,   174,   178,   185,   187,   196,   198,   205,
     207,   218,   220,   222,   224,   227,   229,   231,   233,   235
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if YYDEBUG || 0
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "ID", "STRING", "NUM",
  "VAR_DECL", "CONST_DECL", "INT_TYPE", "IF_ST", "ELSE_ST", "WHILE_ST",
  "PRINT_ST", "READ_ST", "ASSIGN", "ADD", "SUB", "MUL", "DIV", "LPAREN",
  "RPAREN", "LBRACE", "RBRACE", "COMMA", "SEMIC", "QMARK", "COLON",
  "LOWER_THAN_ELSE", "$accept", "program", "$@1", "declarations", "$@2",
  "$@3", "tipo", "var_list", "const_list", "statement_list", "statement",
  "asig", "print_list", "print_item", "read_list", "expression", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-61)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int8 yypact[] =
{
     -61,    10,    40,   -61,     0,    31,    44,   -61,     2,    53,
      53,     4,   -61,   -61,   -61,    48,    50,    51,    63,    65,
     -61,   -61,   -61,    64,    77,    47,    52,    52,    26,    82,
      11,   -61,    16,    83,    30,    89,   -61,    52,    52,    67,
      90,   -61,    72,    78,   -61,   -17,   -61,    90,   -61,    -2,
     -61,   106,   -61,    52,   107,   -61,    47,    41,    61,   -61,
      52,    52,    52,    52,    35,    35,    87,    26,    88,   110,
     -61,    90,   100,   -61,   -61,    52,    41,    41,   -61,   -61,
     105,   -61,   -61,   -61,   -61,   -61,    52,    57,    35,    90,
      52,   -61,    84,   -61
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       2,     0,     0,     1,     0,     0,     0,     8,    15,     0,
       0,     0,     9,     4,     6,     0,     0,     0,     0,     0,
      15,     3,    14,     0,     0,     0,     0,     0,     0,     0,
       0,    10,     0,     0,     0,    38,    39,     0,     0,     0,
      24,    38,     0,     0,    28,     0,    25,    27,    29,     0,
      17,     0,     5,     0,     0,     7,     0,    36,     0,    16,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      11,    12,     0,    23,    37,     0,    31,    32,    33,    34,
      19,    20,    21,    26,    22,    30,     0,     0,     0,    13,
       0,    18,     0,    35
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -61,   -61,   -61,   -61,   -61,   -61,   108,   -61,   -61,    96,
     -60,    66,   -61,    54,   -61,   -26
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
       0,     1,     2,     8,    23,    24,    13,    32,    34,    11,
      22,    39,    45,    46,    49,    40
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      42,    43,    47,    66,    80,    81,    67,    15,     9,    10,
       3,    57,    58,    16,    15,    17,    18,    19,    68,     5,
      16,    69,    17,    18,    19,    20,    21,    71,    91,    41,
      44,    36,    20,    50,    76,    77,    78,    79,    15,    51,
      52,    47,    37,     4,    16,    38,    17,    18,    19,    87,
      35,     6,    36,    54,    55,    41,    20,    36,    62,    63,
      89,    12,    25,    37,    92,     7,    38,    31,    37,    26,
      27,    38,    60,    61,    62,    63,    60,    61,    62,    63,
      33,    74,    28,    90,    29,    48,    75,    60,    61,    62,
      63,    59,    64,    60,    61,    62,    63,    53,    65,    60,
      61,    62,    63,    56,    93,    60,    61,    62,    63,    70,
      72,    82,    84,    85,    86,    88,    30,     0,    14,     0,
       0,    83,    73
};

static const yytype_int8 yycheck[] =
{
      26,    27,    28,    20,    64,    65,    23,     3,     6,     7,
       0,    37,    38,     9,     3,    11,    12,    13,    20,    19,
       9,    23,    11,    12,    13,    21,    22,    53,    88,     3,
       4,     5,    21,    22,    60,    61,    62,    63,     3,    23,
      24,    67,    16,     3,     9,    19,    11,    12,    13,    75,
       3,    20,     5,    23,    24,     3,    21,     5,    17,    18,
      86,     8,    14,    16,    90,    21,    19,     3,    16,    19,
      19,    19,    15,    16,    17,    18,    15,    16,    17,    18,
       3,    20,    19,    26,    19,     3,    25,    15,    16,    17,
      18,    24,    20,    15,    16,    17,    18,    14,    20,    15,
      16,    17,    18,    14,    20,    15,    16,    17,    18,     3,
       3,    24,    24,     3,    14,    10,    20,    -1,    10,    -1,
      -1,    67,    56
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    29,    30,     0,     3,    19,    20,    21,    31,     6,
       7,    37,     8,    34,    34,     3,     9,    11,    12,    13,
      21,    22,    38,    32,    33,    14,    19,    19,    19,    19,
      37,     3,    35,     3,    36,     3,     5,    16,    19,    39,
      43,     3,    43,    43,     4,    40,    41,    43,     3,    42,
      22,    23,    24,    14,    23,    24,    14,    43,    43,    24,
      15,    16,    17,    18,    20,    20,    20,    23,    20,    23,
       3,    43,     3,    39,    20,    25,    43,    43,    43,    43,
      38,    38,    24,    41,    24,     3,    14,    43,    10,    43,
      26,    38,    43,    20
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    28,    30,    29,    32,    31,    33,    31,    31,    34,
      35,    35,    36,    36,    37,    37,    38,    38,    38,    38,
      38,    38,    38,    39,    39,    40,    40,    41,    41,    42,
      42,    43,    43,    43,    43,    43,    43,    43,    43,    43
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     0,     8,     0,     6,     0,     6,     0,     1,
       1,     3,     3,     5,     2,     0,     4,     3,     7,     5,
       5,     5,     5,     3,     1,     1,     3,     1,     1,     1,
       3,     3,     3,     3,     3,     7,     2,     3,     1,     1
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif






/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* $@1: %empty  */
#line 83 "sintaxis.y"
      { simb_table = creaLS(); 
        for(int i=0; i<9; i++){
          registros_en_uso[i] = false;
        }
      }
#line 1213 "sintaxis.tab.c"
    break;

  case 3: /* program: $@1 ID LPAREN RPAREN LBRACE declarations statement_list RBRACE  */
#line 89 "sintaxis.y"
      {
        if (!error_encontrado) {
            generar_MIPS((yyvsp[-2].codigo), (yyvsp[-1].codigo));  
        }
        liberar_estructuras();
      }
#line 1224 "sintaxis.tab.c"
    break;

  case 4: /* $@2: %empty  */
#line 98 "sintaxis.y"
                                   { tipo_actual = VARIABLE; }
#line 1230 "sintaxis.tab.c"
    break;

  case 5: /* declarations: declarations VAR_DECL tipo $@2 var_list SEMIC  */
#line 99 "sintaxis.y"
        {
          (yyval.codigo) = (yyvsp[-5].codigo);
        }
#line 1238 "sintaxis.tab.c"
    break;

  case 6: /* $@3: %empty  */
#line 102 "sintaxis.y"
                                     { tipo_actual = CONSTANTE; }
#line 1244 "sintaxis.tab.c"
    break;

  case 7: /* declarations: declarations CONST_DECL tipo $@3 const_list SEMIC  */
#line 103 "sintaxis.y"
        {
        if (!error_encontrado) {
            concatenaLC((yyvsp[-5].codigo), (yyvsp[-1].codigo)); 
        }
        (yyval.codigo) = (yyvsp[-5].codigo); 
      }
#line 1255 "sintaxis.tab.c"
    break;

  case 8: /* declarations: %empty  */
#line 110 "sintaxis.y"
        {
          (yyval.codigo) = creaLC();
        }
#line 1263 "sintaxis.tab.c"
    break;

  case 9: /* tipo: INT_TYPE  */
#line 117 "sintaxis.y"
      { }
#line 1269 "sintaxis.tab.c"
    break;

  case 10: /* var_list: ID  */
#line 123 "sintaxis.y"
      { declarar_identificador((yyvsp[0].str)); }
#line 1275 "sintaxis.tab.c"
    break;

  case 11: /* var_list: var_list COMMA ID  */
#line 125 "sintaxis.y"
      { declarar_identificador((yyvsp[0].str)); }
#line 1281 "sintaxis.tab.c"
    break;

  case 12: /* const_list: ID ASSIGN expression  */
#line 130 "sintaxis.y"
      {
        (yyval.codigo) = reduccion_const_asignacion((yyvsp[-2].str), (yyvsp[0].codigo));
      }
#line 1289 "sintaxis.tab.c"
    break;

  case 13: /* const_list: const_list COMMA ID ASSIGN expression  */
#line 134 "sintaxis.y"
      {
        ListaC nuevo = reduccion_const_asignacion((yyvsp[-2].str), (yyvsp[0].codigo));
        if (!error_encontrado){
          concatenaLC((yyvsp[-4].codigo), nuevo);
        }
        (yyval.codigo) = (yyvsp[-4].codigo);
      }
#line 1301 "sintaxis.tab.c"
    break;

  case 14: /* statement_list: statement_list statement  */
#line 145 "sintaxis.y"
      { 
        (yyval.codigo) = reduccion_statment_list((yyvsp[-1].codigo), (yyvsp[0].codigo)); 
      }
#line 1309 "sintaxis.tab.c"
    break;

  case 15: /* statement_list: %empty  */
#line 149 "sintaxis.y"
      { 
        (yyval.codigo) = creaLC();
      }
#line 1317 "sintaxis.tab.c"
    break;

  case 16: /* statement: ID ASSIGN asig SEMIC  */
#line 156 "sintaxis.y"
      {
        (yyval.codigo) = reduccion_asignacion((yyvsp[-3].str), (yyvsp[-1].codigo));
      }
#line 1325 "sintaxis.tab.c"
    break;

  case 17: /* statement: LBRACE statement_list RBRACE  */
#line 160 "sintaxis.y"
      { (yyval.codigo) = (yyvsp[-1].codigo); }
#line 1331 "sintaxis.tab.c"
    break;

  case 18: /* statement: IF_ST LPAREN expression RPAREN statement ELSE_ST statement  */
#line 162 "sintaxis.y"
      { (yyval.codigo) = genera_if_else((yyvsp[-4].codigo), (yyvsp[-2].codigo), (yyvsp[0].codigo)); }
#line 1337 "sintaxis.tab.c"
    break;

  case 19: /* statement: IF_ST LPAREN expression RPAREN statement  */
#line 164 "sintaxis.y"
      { (yyval.codigo) = genera_if((yyvsp[-2].codigo), (yyvsp[0].codigo)); }
#line 1343 "sintaxis.tab.c"
    break;

  case 20: /* statement: WHILE_ST LPAREN expression RPAREN statement  */
#line 166 "sintaxis.y"
      { (yyval.codigo) = genera_while((yyvsp[-2].codigo), (yyvsp[0].codigo)); }
#line 1349 "sintaxis.tab.c"
    break;

  case 21: /* statement: PRINT_ST LPAREN print_list RPAREN SEMIC  */
#line 168 "sintaxis.y"
      { (yyval.codigo) = (yyvsp[-2].codigo); }
#line 1355 "sintaxis.tab.c"
    break;

  case 22: /* statement: READ_ST LPAREN read_list RPAREN SEMIC  */
#line 170 "sintaxis.y"
      { (yyval.codigo) = (yyvsp[-2].codigo); }
#line 1361 "sintaxis.tab.c"
    break;

  case 23: /* asig: ID ASSIGN asig  */
#line 175 "sintaxis.y"
      {
        (yyval.codigo) = reduccion_asignacion_multiple((yyvsp[-2].str), (yyvsp[0].codigo));
      }
#line 1369 "sintaxis.tab.c"
    break;

  case 24: /* asig: expression  */
#line 179 "sintaxis.y"
      {
        (yyval.codigo) = (yyvsp[0].codigo);
      }
#line 1377 "sintaxis.tab.c"
    break;

  case 25: /* print_list: print_item  */
#line 186 "sintaxis.y"
      { (yyval.codigo) = (yyvsp[0].codigo); }
#line 1383 "sintaxis.tab.c"
    break;

  case 26: /* print_list: print_list COMMA print_item  */
#line 188 "sintaxis.y"
      { if (!error_encontrado){
            concatenaLC((yyvsp[-2].codigo), (yyvsp[0].codigo)); 
        }
        (yyval.codigo) = (yyvsp[-2].codigo); 
      }
#line 1393 "sintaxis.tab.c"
    break;

  case 27: /* print_item: expression  */
#line 197 "sintaxis.y"
      { (yyval.codigo) = reduccion_print_item_expresion((yyvsp[0].codigo)); }
#line 1399 "sintaxis.tab.c"
    break;

  case 28: /* print_item: STRING  */
#line 199 "sintaxis.y"
      { 
        (yyval.codigo) = reduccion_print_item_string((yyvsp[0].str));
      }
#line 1407 "sintaxis.tab.c"
    break;

  case 29: /* read_list: ID  */
#line 206 "sintaxis.y"
      { (yyval.codigo) = reduccion_read_id((yyvsp[0].str)); }
#line 1413 "sintaxis.tab.c"
    break;

  case 30: /* read_list: read_list COMMA ID  */
#line 208 "sintaxis.y"
      {
        ListaC nuevo = reduccion_read_id((yyvsp[0].str));
        if (!error_encontrado) {
            concatenaLC((yyvsp[-2].codigo), nuevo);
        }
        (yyval.codigo) = (yyvsp[-2].codigo);
      }
#line 1425 "sintaxis.tab.c"
    break;

  case 31: /* expression: expression ADD expression  */
#line 219 "sintaxis.y"
      { (yyval.codigo) = sumar_expresiones((yyvsp[-2].codigo), (yyvsp[0].codigo)); }
#line 1431 "sintaxis.tab.c"
    break;

  case 32: /* expression: expression SUB expression  */
#line 221 "sintaxis.y"
      { (yyval.codigo) = restar_expresiones((yyvsp[-2].codigo), (yyvsp[0].codigo)); }
#line 1437 "sintaxis.tab.c"
    break;

  case 33: /* expression: expression MUL expression  */
#line 223 "sintaxis.y"
      { (yyval.codigo) = multiplicar_expresiones((yyvsp[-2].codigo), (yyvsp[0].codigo)); }
#line 1443 "sintaxis.tab.c"
    break;

  case 34: /* expression: expression DIV expression  */
#line 225 "sintaxis.y"
      { (yyval.codigo) = dividir_expresiones((yyvsp[-2].codigo), (yyvsp[0].codigo)); }
#line 1449 "sintaxis.tab.c"
    break;

  case 35: /* expression: LPAREN expression QMARK expression COLON expression RPAREN  */
#line 228 "sintaxis.y"
      { (yyval.codigo) = genera_expr_condicional((yyvsp[-5].codigo), (yyvsp[-3].codigo), (yyvsp[-1].codigo)); }
#line 1455 "sintaxis.tab.c"
    break;

  case 36: /* expression: SUB expression  */
#line 230 "sintaxis.y"
      { (yyval.codigo) = genera_expresion_negada((yyvsp[0].codigo)); }
#line 1461 "sintaxis.tab.c"
    break;

  case 37: /* expression: LPAREN expression RPAREN  */
#line 232 "sintaxis.y"
      { (yyval.codigo) = (yyvsp[-1].codigo); }
#line 1467 "sintaxis.tab.c"
    break;

  case 38: /* expression: ID  */
#line 234 "sintaxis.y"
      { (yyval.codigo) = genera_expr_ident((yyvsp[0].str)); }
#line 1473 "sintaxis.tab.c"
    break;

  case 39: /* expression: NUM  */
#line 236 "sintaxis.y"
      { (yyval.codigo) = genera_expr_numero((yyvsp[0].str)); }
#line 1479 "sintaxis.tab.c"
    break;


#line 1483 "sintaxis.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      yyerror (YY_("syntax error"));
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 239 "sintaxis.y"


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
