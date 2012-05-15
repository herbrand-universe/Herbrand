**Comandos**
***
   * **assume** agrega (x:A) al contexto global.
   * **infer** dado un **astTerm** retorna el tipo y el conjunto de restricciones.
   * **check** dado dos **astTerm** chequea si son equivalentes y bajo que restricciones.
   * **show** dado un **astTerm** muestra su **term** equivalente.
   * **quit**


**To Do** 
***
   * Agregar un chequeo de que el constraint final son satisfacibles..

**¿Ahora que haces?**
***

  (a) Ordenamos
      * G: Si no te jode que cambie el código cada tanto, lo voy haciendo mientras hacemos otras cosas. 
      * E:

  (b) Ambiguamos los universos.
      * G: Es lo más simple de continua, pero es como que no lo vemos funcionar (ni siquiera se como chequear que esta bien). No tengo muchos ejemplos.
      * E: 
  (c) Vemos que hay que hacer para agregar definiciones (Assume es unsafe)
      * G: Por ahora **assume** agrega cosas, quizás solo tengamos que tiparlas antes de meterlas en el contexto.
      * E:
  (d) Definimos un lenguaje (el formato del script)
      * G: La sintaxis es cualquiera, todavía no se porque puse **with** en lugar de **=**. Si definimos un poco la sintaxis, le puedo hacer el modo de PG.
         Y más allá de eso, si definimos la sintaxis estamos obligados a definir para que vamos usar el typechecker. Existen proof assistants sin *tacticas* ?...
      * E:
  (e) Pensamos como definir una lógica
      * G: En el contexto usando la idea de **Logical framework** podes usar **shallow embedding** para definir la lógica que te de la gana. O podes agregar al lenguaje
      algunas funciones /\, \/ .... y definirlas de manera 'fija' usando teoria de tipo
      * E:
  (f) Vemos como se agregaría tacticas.
      * G: Si nos ponemos con esto, esta bueno porque vamos podiendo **usar** el typechecker, aunque hay que pensar bien esto ... 
      * E:
  (g) Otras
      * G: Podría ser definiciones recursivas.
      * E:

G: Mi prioridad sería, (c) para empezar a crear algunos tipos y poder probar un poco y (b) porque type/n es un garron (aunque no se si lo usariamos, no se ni para que usarlo).
   Podría cambiar el orden por (b) por (c) para seguir el paper. Pero estaría bueno **usarlo** de alguna manera (aunque no se como)


**Limpieza**
***
   * A varios archivos le agregué su *.mli porque quiero empezar a limpiar y abstraer un poco. Dado que en las reglas usaba muchas cosas de otros modulos tuve varios problemas y por eso separe las cosas un poco.

