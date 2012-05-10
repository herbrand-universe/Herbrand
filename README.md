
**Complete tasks**
--------------------
   * El tipo (***astTerm***) de los terminos de entradas acepta variables para abstraciones y dependent products.
   * En term.ml(i) hay otra defición de termino debido a que internamente usamos indices de deBrujin. Las variables se preservan pero son solo para variables globales.
   * Cree 'val subs : name -> term -> term -> term'. No se si tiene sentido porque sobre este tipo las variables son solo globales.


**To Do** 
---------
   * Funcion que transforme los terminos de entra ***astTerms*** con variables dummies en ***term*** que usa indices de deBrujin.
   * Sustitucion de indices deBrujin 'val subsDB : term -> term -> term'. (Los indices de deBrujin son relativos a la posición, hay un par de maneras posibles de hacer esto)
   * Agregar funcion 'val whnf : term -> term' que lleve un termino a Weak Head Normal Form.


**Estructura de archivos**
--------------------------
   * term.ml 
   * main.ml ....
   * parser.mly ....
   * lexer.mll  ....
   * pretty.ml  ....

**Papers**
----------
   * Type Checking with Universes (R. Harper, R. Pollack)
