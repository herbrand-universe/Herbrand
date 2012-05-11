
**Complete tasks (a revisar) **
--------------------------------
   * El tipo (**astTerm**) de los terminos de entradas acepta variables para abstraciones y dependent products.
   * En term.ml(i) hay otra defición de termino debido a que internamente usamos indices de (de Brujin). Las variables se preservan pero son solo para variables globales.
   * Cree **val subs : name -> term -> term -> term**. No se si tiene sentido porque sobre este tipo las variables son solo globales.
   * Sustitución de indices deBrujin **val dBsubs : int -> term -> term -> term**.(Tengo algunas dudas, cuando pueda generare pruebas)


**To Do** 
---------
<<<<<<< HEAD
   * Función que transforme los terminos de entrada **astTerms** con variables dummies en **term** que usan indices de deBrujin.
=======
   * Función que transforme los terminos de entrada **astTerms** con variables dummies en **term** que usan indices de (de Bruijn).
>>>>>>> 439c8a7f430fddfe2cef7f1674b857f9d8bcc36b
   * Agregar funcion **val whnf : term -> term** que lleve un termino a Weak Head Normal Form. (In progress) 


**Estructura de archivos**
--------------------------
   * **term.ml** 
   * **main.ml** ....
   * **parser.mly** ....
   * **lexer.mll**  ....
   * **pretty.ml**  ....

**Papers**
----------
   * Type Checking with Universes (R. Harper, R. Pollack)
   * Proof-assistants using Dependent Type Systems (H. Barendregt, H. Geuvers)
