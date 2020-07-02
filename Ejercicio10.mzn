include "globals.mzn";

set of int: POS = 1..12;
array [POS] of var int: Pesos = [9,13,153,50,15,68,27,39,23,52,11,32];
array [POS] of var int: Preferencias = [150,35,200,160,60,45,60,40,30,10,70,30];
int: TAM_MAXIMO = 275;

%En el array solucion meteremos en la posicion i un 1 o un 0 dependiendo de si escogemos el objeto i del vector de pesos.
array [POS] of var 0..1: Solucion;

%Preferencias elegidas contendra el valor numerico de las preferencias que se cojan. Y si no se coge alguna de las preferencias,
%se mete un 0.
array [POS] of var int: pref_elegidas;

%Pesos elegidos contendrá el valor numerico de los pesos que se cojan. Y si no se coge alguno de los pesos, se mete un 0.
array [POS] of var int: pesos_elegidos;

var int: Suma_pref;

%Ponemos la restricción de que la suma de los pesos elegidos sea menor que el tamaño maximo
constraint(sum(i in POS)(pesos_elegidos[i]) <= TAM_MAXIMO);

constraint(forall(i in POS)(Solucion[i] == 1 -> (pref_elegidas[i] == Preferencias[i] /\ pesos_elegidos[i] == Pesos[i])));
constraint(forall(i in POS)(Solucion[i] == 0 -> (pref_elegidas[i] == 0 /\ pesos_elegidos[i] == 0)));

constraint(Suma_pref == sum(pref_elegidas));

%Resolvemos este problema maximizando la suma de preferencias y teniendo en cuenta todo lo anterior.
solve maximize Suma_pref;

output ["\(Solucion[i]) " | i in POS]; 
output ["\n"];
output ["Peso alcanzado: \(Suma_pref)"]; 
output ["\n"];
output ["\(sum(i in POS)(pesos_elegidos[i]))"];