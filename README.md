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
  * (d) Agregar sintaxis para *pair*, *right* y *left*
  * (d') (**Done**) fst y snd.
   *(d'') Agregar para *pair*
  * (e) Extender ECC con *A + B*, *inl*, *inr*, *case* (primero pensarlas y agregarlas a reglas.tex)
  * (f) Ver como definir conjuntos enumerados.
  * (g) Tipos de datos inductivos.
  * (h) Definir un tipo *goal* para hacerlo visible al script
  * (i) Definir *intro* y *apply* a nivel de usuario
  * (j) Crea un archivo de definiciones básicas, que se cargue con un pseudo include
  * (k) Instanciar Proof General.


**Limpieza**
***
   * Pensar que nombre les ponemos a los constructores "L" y "R" son una cagada
   * context.ml es un asco, desde los nombres de funciones hasta la forma en que esta escrito el codigo
   * El contexto gloabal, hay que hacerlo global. El que se pasa a las funciones debería ser unicamente el local (el de los indices)
   * downArr es la equivalencia de terminos (beta-delta). Debería tener otro nombre.
   * Las funciones parciales que estan en term y context apestan (además de que dan warnings) quizás las cambie.
