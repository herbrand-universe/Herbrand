**Comandos**
***
   * **assume** agrega (x:A) al contexto global.
   * **infer** dado un **astTerm** retorna el tipo y el conjunto de restricciones.
   * **check** dado dos **astTerm** chequea si son equivalentes y bajo que restricciones.
   * **show** dado un **astTerm** muestra su **term** equivalente.
   * **quit**
   
**Agregar definiciones (delta)**
***
   * Contextos globales :
      * Cambiar el tipo context.global = (name,term,type,constr) list
      * val dom : context -> name list
      * val addGlobal : context -> name -> term -> type -> constraints -> context
      * val getType : context -> name -> type * constraints
      * val getDef : context -> name -> term
      
   * ¿Comó definir?. Def x := t
      * x no esta en dom(contexto)
      * well-typed (t) en el contexto <- (Con esto también sabemos que FV(t) c dom(Contexto) ('c' incluido)
      * ¿Es necesario delta-expandir todo 't' hasta que FV(t) = {}. (Ver paper Harper)
      * Contexto <- (name, term, type, constr) :: Contexto
      
   * Modificaciones de las reglas (lo estoy pensando :P)
      * Subs: ¿Necesito delta expandir? (creo que no)
      * whnf: ¿Delta expandir?
      * conv (downArr) : Delta expandir, ¿excepto (Var x) 'downArr' (Var y) cuando x = y?
      * typeof (Var x) : Como esta ahora esta mal, pero como no la usamos no importo. 
                

**To Do** 
***
   * Agregar un chequeo de que el constraint final son satisfacibles..

**¿Ahora que hacemos?**
***

  * (a) Ordenamos
      * G: Si no te jode que cambie el código cada tanto, lo voy haciendo mientras hacemos otras cosas. 
      * E: Sí, me parece bien, yo voy a hacer lo propio.

  * (b) Ambiguamos los universos.
      * G: Es lo más simple de continua, pero es como que no lo vemos funcionar (ni siquiera se como chequear que esta bien). No tengo muchos ejemplos.
      * E: Podemos jugar un poco más con esto antes creo.

  * (c) Vemos que hay que hacer para agregar definiciones (Assume es unsafe)
      * G: Por ahora **assume** agrega cosas, quizás solo tengamos que tiparlas antes de meterlas en el contexto.
      * E: Si, ¿por qué generaría problemas?
        * G: Si no las tipas es obvio que podes meter falso. Además de tipar quizás haya que hacer algo más (no se). (siempre hablando sin recursion)

  * (d) Definimos un lenguaje (el formato del script)
      * G: La sintaxis es cualquiera, todavía no se porque puse **with** en lugar de **=**. Si definimos un poco la sintaxis, le puedo hacer el modo de PG.
         Y más allá de eso, si definimos la sintaxis estamos obligados a definir para que vamos usar el typechecker. Existen proof assistants sin *tacticas* ?...
      * E: Sí, hay que fijar eso.

  * (e) Pensamos como definir una lógica
      * G: En el contexto usando la idea de **Logical framework** podes usar **shallow embedding** para definir la lógica que te de la gana. O podes agregar al lenguaje
      algunas funciones /\, \/ .... y definirlas de manera 'fija' usando teoria de tipo
      * E: ¿Dónde puedo leer sobre eso del **shallow embedding**? Creo que sería lo más divertido (aún sin saber qué es) poder definir lógicas que se nos canten.
         * G: Es lo que se hace habitualmente creo, Coq se que puede cambiar el significado de el 'and', 'or' y demás.

  * (f) Vemos como se agregaría tacticas.
      * G: Si nos ponemos con esto, esta bueno porque vamos podiendo **usar** el typechecker, aunque hay que pensar bien esto ... 
      * E: No me parece trivial, ¿haríamos un lenguaje para escribit tácticas después? ¿O qué?

        * G : Las únicas tácticas que vi son las de EasyCrypt, jamás use Coq. 
        En EC las tienen codiadas en ocaml, pero hay dos clases de tácticas 
        las básicas y la que son composiciones de tácticas, esas estimo que 
        es fácil permitir que el usuario las cree pero ni idea. Se que el 
        tipo de Matita (Asperi, creo) tiene slides o un paper criticando 
        las tácticas de Coq, y explica algunas cosas ... pero no lo lei bien.
           Asi que lo más fácil es agregar tácticas y definirlas en OCaml.

  * (g) Otras
      * G: Podría ser definiciones recursivas.
      * E: 

G: Mi prioridad sería, (c) para empezar a crear algunos tipos y poder probar un poco y (b) porque type/n es un garron (aunque no se si lo usariamos, no se ni para que usarlo).
   Podría cambiar el orden por (b) por (c) para seguir el paper. Pero estaría bueno **usarlo** de alguna manera (aunque no se como)

E: Coincido en empezar con (c), y pulir un poco usando (d).  Una vez que tengamos lo mismo, pero más prolijito, ahí me parece bien ir por (b) y (e).


**Limpieza**
***
   * A varios archivos le agregué su *.mli porque quiero empezar a limpiar y abstraer un poco. Dado que en las reglas usaba muchas cosas de otros modulos tuve varios problemas y por eso separe las cosas un poco.

