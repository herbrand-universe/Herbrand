**Comandos**
***
   * **assume** agrega (x:A) al contexto global.
   * **infer** dado un **astTerm** retorna el tipo y el conjunto de restricciones.
   * **check** dado dos **astTerm** chequea si son equivalentes y bajo que restricciones.
   * **show** dado un **astTerm** muestra su **term** equivalente.
   * **quit**


**To Do** 
***
   * Assumamos que existe una función **val consistent : LConstraints -> bool**

**Limpieza**
***
   * A varios archivos le agregué su *.mli porque quiero empezar a limpiar y abstraer un poco. Dado que en las reglas usaba muchas cosas de otros modulos tuve varios problemas y por eso separe las cosas un poco.

