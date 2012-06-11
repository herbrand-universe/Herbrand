**Comandos**
***
   * **Show name** debería mostrar la definición de un tipo.
   * **Show all** debería mostrar todas las definiciones en el contexto global.
   * **Def name = term** debería definir una variable en el contexto global.
   * **Proof name = prop** debería ser el comienzo de una prueba de <prop>.
   * **End** debería ser el final de una prueba.

   * **infer** dado un **astTerm** retorna el tipo y el conjunto de restricciones.
   * **check** dado dos **astTerm** chequea si son equivalentes y bajo que restricciones.
   * **show** dado un **astTerm** muestra su **term** equivalente.
   * **quit**              


**Nuevas tareas a realizar**
***

  * (a) Ordenamos
  * (b) (**Done**) Terminar las reglas de ECC
  * (c) Ver que falta para volver a tener definiciones. (esto esta incompleto ahora, *leq* creo que tiene que expandir)
  * (d) Agregar sintaxis para *pair*
  * (e) (**Done**) Agregar sintaxis para *fst* y *snd*
  * (f) Extender ECC con *A + B*, *inl*, *inr*, *case* (primero pensarlas y agregarlas a reglas.tex)
  * (g) Ver como definir conjuntos enumerados.
  * (h) Tipos de datos inductivos.
  * (i) Definir un tipo *goal* para hacerlo visible al script
  * (j) Definir *intro* y *apply* a nivel de usuario
  * (k) Crea un archivo de definiciones básicas, que se cargue con un pseudo include
  * (l) Instanciar Proof General.


**Limpieza**
***
   * (**Done**) Pensar que nombre les ponemos a los constructores "L" y "R" son una cagada (**Fst,Snd**)
   * context.ml es un asco, desde los nombres de funciones hasta la forma en que esta escrito el codigo
   * El contexto gloabal, hay que hacerlo global. El que se pasa a las funciones debería ser unicamente el local (el de los indices)
   * (**Done**) downArr es la equivalencia de terminos (beta-delta). Debería tener otro nombre. (**conv**)
   * Las funciones parciales que estan en term y context apestan (además de que dan warnings) quizás las cambie.
