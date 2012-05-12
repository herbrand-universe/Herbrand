
**Complete tasks (a revisar)**
--------------------------------
   * El tipo (**astTerm**) de los terminos de entradas acepta variables para abstraciones y dependent products.
   * En term.ml(i) hay otra defición de termino debido a que internamente usamos indices de (de Bruijn). Las variables se preservan pero son solo para variables globales.
   * Cree **val subs : name -> term -> term -> term**. No se si tiene sentido porque sobre este tipo las variables son solo globales.
   * Sustitución de indices deBrujin **val dBsubs : int -> term -> term -> term**.(Tengo algunas dudas, cuando pueda generare pruebas)
   * Función que transforme los terminos de entrada **astTerms** con variables dummies en **term** que usan indices de (de Bruijn).
   * Algunos tipos de datos: **LVars**, **LConstraints**, **lassignment**, etc.
   * **val termLV : term -> LVars**, retorna las *level variables* en un **term**.
   * **val constrLV : LConstraints -> LVars**, retorna las *level variables* en un conjunto de restricciones.
   * **val domLA : lassignment -> LVars**, retorna las *level variables* en el dominio de la asignación.

**To Do** 
---------
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
