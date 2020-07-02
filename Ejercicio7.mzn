include "globals.mzn";

set of int: POS = 1..9;

%En el array asignaciones, pondremos en cada posicion i, el instante de tiempo en que comienza
%la tarea i. Ejemplo -> Si i == 0, tarea == A.
array [POS] of var int: Asignaciones; % A   B   C   D   E   F   G   H   I
array [POS] of var int: tiempos_totales;

%En esta matriz pondremos para cada tarea cuales serian sus tareas predecesoras. Observando la tabla del enunciado.
array [POS,1..2] of var int: Predecesores = array2d(POS,1..2,
 [0,0,
  1,1,
  2,2,
  1,1,
  3,4,
  3,4,
  3,4, 
  1,1,
  6,8]);

%Este es el array de tiempos de cada tarea. Esta sacado de la tabla del enunciado.                                   
array [POS] of int: tiempos = [7,3,1,8,2,1,1,3,2];
%                              A B C D E F G H I
var int: tiempo_total;

%En el array de tiempos totales, pondremos el instante de tiempo en que terminaría cada tarea.
%La tarea A terminaría en el instante 7 ya que no tiene predecesores y dura 7 dias.
constraint(tiempos_totales[1] == 7);

%Para cada tarea, le asignamos su tiempo de fin, como el tiempo maximo de fin de sus predecesores + el tiempo que tarda dicha tarea.
constraint(forall(i in 2..9)(tiempos_totales[i] == max(tiempos_totales[Predecesores[i,1]], tiempos_totales[Predecesores[i,2]]) + tiempos[i]));

%Ahora, simplemente, para saber el tiempo en que comienza, le restamos a los tiempos de fin de cada tarea, su tiempo de duración.
%Así nos quedamos solamente con el tiempo de inicio.
constraint(forall(i in POS)(Asignaciones[i] == tiempos_totales[i] - tiempos[i]));


constraint (tiempo_total = max(tiempos_totales));

%Lo que queremos es que la casa se construya en el menor tiempo posible, por lo que vamos a minimizar el tiempo de fin de la ultima tarea que se realice.
solve minimize tiempo_total;

output ["[\(Asignaciones[i]) - \(Asignaciones[i] + tiempos[i])] \n" | i in POS];