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
      * **(Done)** Cambiar el tipo context.global = (name,term,type,constr) list
      * val dom : context -> name list
      * **(Done)** val addGlobal : context -> name -> term -> type -> constraints -> context
      * **(Done)** val getType : context -> name -> type * constraints
      * **(Done)** val getDef : context -> name -> term
      
   * ¿Comó definir?. Def x := t
      * **(Done)** x no esta en dom(contexto)
      * ¿Es necesario delta-expandir todo 't' hasta que FV(t) = {}. (Ver paper Harper)
      * **(Done)** well-typed (t) en el contexto <- (Con esto también sabemos que FV(t) c dom(Contexto) ('c' incluido)
      * **(Done)** Contexto <- (name, term, type, constr) :: Contexto
      
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
  * (b) Ambiguamos los universos.
  * (c) Vemos que hay que hacer para agregar definiciones (Assume es unsafe)
  * (d) Definimos un lenguaje (el formato del script)
  * (e) Pensamos como definir una lógica
  * (f) Vemos como se agregaría tacticas.
  * (g) Otras
      * G: Podría ser definiciones recursivas.
      * E: 

G: Mi prioridad sería, (c) para empezar a crear algunos tipos y poder probar un poco y (b) porque type/n es un garron (aunque no se si lo usariamos, no se ni para que usarlo).
   Podría cambiar el orden por (b) por (c) para seguir el paper. Pero estaría bueno **usarlo** de alguna manera (aunque no se como)

E: Coincido en empezar con (c), y pulir un poco usando (d).  Una vez que tengamos lo mismo, pero más prolijito, ahí me parece bien ir por (b) y (e).


**Limpieza**
***
   * A varios archivos le agregué su *.mli porque quiero empezar a limpiar y abstraer un poco. Dado que en las reglas usaba muchas cosas de otros modulos tuve varios problemas y por eso separe las cosas un poco.

