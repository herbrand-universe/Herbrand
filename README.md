**To Do** 
***
   * Para las reglas interesante vamos a necesitar una noción de contexto.
   Un **contexto** puede ser vacio, tener (x : A) (x son variables globales) o solo un tipo (para los indices de De Bruijn).
   No se si lo mejor es tener 1 o 2 contextos (uno global, y otro local solo para indices)

   * Assumamos que existe una función **val consistent : LConstraints -> bool**
