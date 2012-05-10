Herbrand Universe
=================

Herbrand Universe

*Agregar funciones*
   * Sustitucion de variables 'val subs : name -> term -> term -> term'
   * Sustitucion de indices deBrujin 'val subsDB : term -> term -> term'. (Los indices de deBrujin son relativos a la posición, hay un par de maneras posibles de hacer esto)
   * Agregar funcion 'val whnf : term -> term' que lleve un termino a Weak Head Normal Form.

*To Do* 
   * Function to translate terms with variables in terms with DeBrujin index.

*Estructura de archivos*
   * term.ml 
     * a
     * b
   * main.ml ....
   * parser.mly ....
   * lexer.mll  ....
   * pretty.ml  ....

*Papers*
   * Type Checking with Universes (R. Harper, R. Pollack)
   *
