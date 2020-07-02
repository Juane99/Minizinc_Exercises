%X=6210001000 6 ceros 2 unos 1 dos 1 seis
include "globals.mzn";

set of int: dominio = 0..9;
set of int: POS = 1..10;

%Creacion del array que va a representar nuestra solución
array [POS] of var dominio: X;

%La unica restriccion es que el numero de veces que aparezca cada elemento de nuestro array X sea igual al valor en esa posicion del array.
%Tenemos que hacer que sea igual a la posicion i+1 porque i empieza en 0, y los indices empiezan en el 1
constraint (forall(i in dominio)(count(X,i) == X[i+1]));

solve satisfy;

output ["\(X[i])" | i in POS];