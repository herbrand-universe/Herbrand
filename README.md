**Esto crece fácil ... moví las cosas a la Wiki. Dejé por ahora las cosas pendientes así estan visibles**

**E: Voy a ponerme en estos dias a intentar escribir la tabla 5 'Schematic beta-conversion algorithm', es decir sobre constraint.ml**
Si llegas a ponerte con algo de eso, avisame para no hacer lo mismo los dos ..

**To Do** 
***
   * Agregar funcion **val whnf : term -> term** que lleve un termino a Weak Head Normal Form. (In progress) 
   * Funciones descriptas en el final de la página 14 y el primer parrafo de la página 15 (In progress, constraint.ml)

**Si no encontras que hacer, te tiro un par de cosas que tarde o temprano vamos a necesitar:**
   * Tener una función que genere variables frescas (se va a necesitar para generar 'level variables' en varias reglas (algo que genere x1, x2, x3 .. estimo que basta)
   * Se pueden definir las dos funciones auxiliares CUM y flecha.


Solo para mostrarte un ejemplo de como usar variables globales (robado de EasyCrypt asi no pienso)

**let rhl_cntr = ref 0**

**let fresh_rhl_cntr () = incr rhl_cntr; !rhl_cntr**

rhl_cntr , sería como un puntero con ! te da el valor. Si lo pasas a string y le concatenas "x" tenemos variables frescas.

PD: rhl ... relational hoare logic ): 