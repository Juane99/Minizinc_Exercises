include "globals.mzn";

%Este ejercicio se resuelve exactamente igual que el anterior, con la diferencia de que a algunas de las tareas les añadiremos
%nuevos predecesores dependiendo de los trabajadores asignados a cada una. Las nuevas asignaciones de predecesores se atienen a lo siguiente:
%
%Los predecesores de la tarea A se mantienen, ya que no se ejecuta al mismo tiempo que ninguna otra y le podemos asignar perfectamente
%2 de los 3 trabajadores de los que disponemos.
%
%Los predecesores de la tarea B serian la A,D,H. La primera porque así lo indica la tabla y los otros dos por lo siguiente:
%    - Como la tarea B necesita 3 trabajadores
%    - La tarea D necesita 2 trabajadores
%    - La tarea H necesita 1 trabajador
%    - Las tres tareas comienzan a la vez por lo que le daremos prioridad a que comiencen a la vez la D y H (porque la suma de
%trabajadores necesarios seria 3). Y ya cuando terminen esas dos dejaremos que comience la B, que necesita la totalidad de trabajadores
%para realizarse.
%
%Los predecesores de la tarea C se mantienen, ya que no se ejecuta al mismo tiempo que ninguna otra y le podemos asignar perfectamente
%2 de los 3 trabajadores de los que disponemos.
%
%Los predecesores de la tarea D se mantienen, ya que comienza al mismo tiempo que la B y la H, pero la eligiremos para que se ejecute
%al mismo tiempo que la H, debido a su numero de trabajadores necesarios. Por lo que solo tendrá que esperar al predecesor de la tabla.
%
%Los predecesores de la tarea E se mantienen, ya que comienza al mismo tiempo que la F y la G, pero la eligiremos para que se ejecute
%al mismo tiempo que la F, debido a su numero de trabajadores necesarios. Por lo que solo tendrá que esperar a los predecesores de la
%tabla.
%
%Los predecesores de la tarea F se mantienen, ya que comienza al mismo tiempo que la E y la G, pero la eligiremos para que se ejecute
%al mismo tiempo que la E, debido a su numero de trabajadores necesarios. Por lo que solo tendrá que esperar a los predecesores de la
%tabla.
%
%Los predecesores de la tarea G serian la C,D,F. La primera porque así lo indica la tabla y los otros dos por lo siguiente:
%    - Como la tarea G necesita 1 trabajador
%    - La tarea F necesita 2 trabajadores
%    - Las tareas G,E,F comienzan a la vez por lo que le daremos prioridad a que comiencen a la vez la E y F (porque la suma de
%trabajadores necesarios seria 3). Y ya cuando termine la F (que es la que dura menos) dejaremos que comience la G, que necesita uno de los trabajadores que se han quedado libres.
%
%Los predecesores de la tarea H se mantienen, ya que comienza al mismo tiempo que la B y la D, pero la eligiremos para que se ejecute
%al mismo tiempo que la D, debido a su numero de trabajadores necesarios. Por lo que solo tendrá que esperar a los predecesores de la
%tabla.
%
%Los predecesores de la tarea I se mantienen, ya que no se ejecuta al mismo tiempo que ninguna otra y le podemos asignar perfectamente
%2 de los 3 trabajadores de los que disponemos.

set of int: POS = 1..9;

%En el array asignaciones, pondremos en cada posicion i, el instante de tiempo en que comienza
%la tarea i. Ejemplo -> Si i == 0, tarea == A.
array [POS] of var int: Asignaciones; % A   B   C   D   E   F   G   H   I
array [POS] of var int: tiempos_totales;

%En esta matriz pondremos para cada tarea cuales serian sus tareas predecesoras. Observando la tabla del enunciado y añadiendo las nuevas
%correspondientes a la tabla de trabajadores y lo explicado al principio del fichero.
array [POS,1..3] of var int: Predecesores = array2d(POS,1..3,
 [0,0,0,
  1,4,8,
  2,2,2,
  1,1,1,
  3,4,3,
  3,4,4,
  3,4,6, 
  1,1,1,
  6,8,8]);
         
%Este es el array de tiempos de cada tarea. Esta sacado de la tabla del enunciado.                                                                                                      
array [POS] of int: tiempos = [7,3,1,8,2,1,1,3,2];
%                              A B C D E F G H I
var int: tiempo_total;


%En el array de tiempos totales, pondremos el instante de tiempo en que terminaría cada tarea.
%La tarea A terminaría en el instante 7 ya que no tiene predecesores y dura 7 dias.
constraint(tiempos_totales[1] == 7);

%Para cada tarea, le asignamos su tiempo de fin, como el tiempo maximo de fin de sus predecesores + el tiempo que tarda dicha tarea.
constraint(forall(i in 2..9)(tiempos_totales[i] == max(max(tiempos_totales[Predecesores[i,1]], tiempos_totales[Predecesores[i,2]]), tiempos_totales[Predecesores[i,3]]) + tiempos[i]));

%Ahora, simplemente, para saber el tiempo en que comienza, le restamos a los tiempos de fin de cada tarea, su tiempo de duración.
%Así nos quedamos solamente con el tiempo de inicio.
constraint(forall(i in POS)(Asignaciones[i] == tiempos_totales[i] - tiempos[i]));


constraint (tiempo_total = max(tiempos_totales));

%Lo que queremos es que la casa se construya en el menor tiempo posible, por lo que vamos a minimizar el tiempo de fin de la ultima tarea que se realice.
solve minimize tiempo_total;

output ["[\(Asignaciones[i]) - \(Asignaciones[i] + tiempos[i])] \n" | i in POS];
