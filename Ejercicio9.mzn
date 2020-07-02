include "globals.mzn";

%La siguiente función la he creado para obtener el indice de un valor en un array.
%Nos será muy util a la hora de comprobar que un trabajador no realice mas de una tarea
%al mismo tiempo.
function var int: getIndice(var int: tiempo, 
                               array[int] of var int: int_array) = 
   sum(  [ if tiempo = int_array[i] 
              then i
           else 0 endif  
          | i in index_set(int_array) ]
   );

set of int: POS = 1..9;

%En el array asignaciones, pondremos en cada posicion i, el instante de tiempo en que comienza
%la tarea i. Ejemplo -> Si i == 0, tarea == A.
array [POS] of var int: Asignaciones; % A   B   C   D   E   F   G   H   I
array [POS] of var int: tiempos_totales;

%En esta matriz pondremos para cada tarea cuales serian sus tareas predecesoras. Observando la tabla del ejercicio 7.
array [POS,1..2] of int: Predecesores = array2d(POS,1..2,
 [0,0,
  1,1,
  2,2,
  1,1,
  3,4,
  3,4,
  3,4, 
  1,1,
  6,8]);
  
%Para cada tarea, creamos un array de tiempos, donde la posicion i del array corresponde al tiempo que tardaria el 
%trabajador i en realizar la tarea.
array [int] of var int: tiemposA = [4,7,10];  
array [int] of var int: tiemposB = [3,5,7];                                    
array [int] of var int: tiemposC = [3,1,4];                                    
array [int] of var int: tiemposD = [2,5,8];                                    
array [int] of var int: tiemposE = [4,2,6];                                    
array [int] of var int: tiemposF = [3,2,1];                                    
array [int] of var int: tiemposG = [1,2,3];                                    
array [int] of var int: tiemposH = [1,3,5];                                    
array [int] of var int: tiemposI = [2,3,4];                                    

%En este array meteremos el tiempo que va a tardar cada tarea, ateniendonos a las siguientes restricciones.
array [POS] of var int: tiempos;

%El tiempo de la tarea A será el minimo de los tres, ya que no hay ninguna tarea que se pueda realizar al mismo tiempo.
constraint(tiempos[1] == min(tiemposA));

%El tiempo de la tarea B tiene que ser uno de los tres que vienen en la tabla. Y tenemos que asegurarnos de que el trabajador que 
%elijamos sea diferente al trabajador de las tareas D y H. Ya que esas dos empiezan al mismo tiempo que la B porque tienen los mismos
%predecesores. Esto lo hacemos comprobando que los indices sean diferentes.
constraint((count(tiemposB,tiempos[2]) > 0) /\ (getIndice(tiempos[2],tiemposB) != getIndice(tiempos[4],tiemposD)) /\ (getIndice(tiempos[2],tiemposB) != getIndice(tiempos[8],tiemposH)));

%El tiempo de la tarea C será el minimo de los tres, ya que no hay ninguna tarea que se pueda realizar al mismo tiempo.
constraint(tiempos[3] == min(tiemposC));


%El tiempo de la tarea D tiene que ser uno de los tres que vienen en la tabla. Y tenemos que asegurarnos de que el trabajador que 
%elijamos sea diferente al trabajador de las tareas B y H. Ya que esas dos empiezan al mismo tiempo que la D porque tienen los mismos
%predecesores. Esto lo hacemos comprobando que los indices sean diferentes.
constraint((count(tiemposD,tiempos[4]) > 0) /\ (getIndice(tiempos[4],tiemposD) != getIndice(tiempos[2],tiemposB)) /\ (getIndice(tiempos[4],tiemposD) != getIndice(tiempos[8],tiemposH)));

%El tiempo de la tarea E tiene que ser uno de los tres que vienen en la tabla. Y tenemos que asegurarnos de que el trabajador que 
%elijamos sea diferente al trabajador de las tareas F y G. Ya que esas dos empiezan al mismo tiempo que la E porque tienen los mismos
%predecesores. Esto lo hacemos comprobando que los indices sean diferentes.
constraint((count(tiemposE,tiempos[5]) > 0) /\ (getIndice(tiempos[5],tiemposE) != getIndice(tiempos[6],tiemposF)) /\ (getIndice(tiempos[5],tiemposE) != getIndice(tiempos[7],tiemposG)));

%El tiempo de la tarea F tiene que ser uno de los tres que vienen en la tabla. Y tenemos que asegurarnos de que el trabajador que 
%elijamos sea diferente al trabajador de las tareas E y G. Ya que esas dos empiezan al mismo tiempo que la F porque tienen los mismos
%predecesores. Esto lo hacemos comprobando que los indices sean diferentes.
constraint((count(tiemposF,tiempos[6]) > 0) /\ (getIndice(tiempos[6],tiemposF) != getIndice(tiempos[5],tiemposE)) /\ (getIndice(tiempos[6],tiemposF) != getIndice(tiempos[7],tiemposG)));

%El tiempo de la tarea G tiene que ser uno de los tres que vienen en la tabla. Y tenemos que asegurarnos de que el trabajador que 
%elijamos sea diferente al trabajador de las tareas E y F. Ya que esas dos empiezan al mismo tiempo que la G porque tienen los mismos
%predecesores. Esto lo hacemos comprobando que los indices sean diferentes.
constraint((count(tiemposG,tiempos[7]) > 0) /\ (getIndice(tiempos[7],tiemposG) != getIndice(tiempos[5],tiemposE)) /\ (getIndice(tiempos[7],tiemposG) != getIndice(tiempos[6],tiemposF)));

%El tiempo de la tarea H tiene que ser uno de los tres que vienen en la tabla. Y tenemos que asegurarnos de que el trabajador que 
%elijamos sea diferente al trabajador de las tareas E y F. Ya que esas dos empiezan al mismo tiempo que la H porque tienen los mismos
%predecesores. Esto lo hacemos comprobando que los indices sean diferentes.
constraint((count(tiemposH,tiempos[8]) > 0) /\ (getIndice(tiempos[8],tiemposH) != getIndice(tiempos[4],tiemposD)) /\ (getIndice(tiempos[8],tiemposH) != getIndice(tiempos[2],tiemposB)));

%El tiempo de la tarea I será el minimo de los tres, ya que no hay ninguna tarea que se pueda realizar al mismo tiempo.
constraint(tiempos[9] == min(tiemposI));
                                                                                                         
var int: tiempo_total;
var int: tiempo_suma;
constraint (tiempo_suma == sum(tiempos));


%En el array de tiempos totales, pondremos el instante de tiempo en que terminaría cada tarea.
%La tarea A terminaría en el instante 7 ya que no tiene predecesores y dura 7 dias.
constraint(tiempos_totales[1] == tiempos[1]);

%Para cada tarea, le asignamos su tiempo de fin, como el tiempo maximo de fin de sus predecesores + el tiempo que tarda dicha tarea.
constraint(forall(i in 2..9)(tiempos_totales[i] == max(tiempos_totales[Predecesores[i,1]], tiempos_totales[Predecesores[i,2]]) + tiempos[i]));

%Ahora, simplemente, para saber el tiempo en que comienza, le restamos a los tiempos de fin de cada tarea, su tiempo de duración.
%Así nos quedamos solamente con el tiempo de inicio.
constraint(forall(i in POS)(Asignaciones[i] == (tiempos_totales[i] - tiempos[i])));

%Lo que queremos es que la casa se construya en el menor tiempo posible, por lo que vamos a minimizar el tiempo de fin de la ultima tarea que se realice.
constraint(tiempo_total == max(tiempos_totales));
solve minimize tiempo_total;

output ["[\(Asignaciones[i]) - \(Asignaciones[i] + tiempos[i])] \n" | i in POS];
