include "globals.mzn";

set of int: dominio = 0..9;
set of int: POS = 1..10;

%Creacion de array de valores
array [POS] of var dominio: valores;
array [POS] of string: strvalores = ["T","E", "S", "F", "D", "I", "N", "K", "R", "A"];
%                                    1   2    3    4    5    6    7    8    9    10

%A cada variable Miembro se le asigna el valor numerico que tendria la combinacion de cada uno de los valores que lo forman
var int:MIEMBRO1 = valores[1]*10000 + valores[2]*1000 + valores[3]*100 + valores[1]*10+ valores[2];
var int:MIEMBRO2 = valores[4]*10000 + valores[2]*1000 + valores[3]*100 + valores[1]*10+ valores[2];
var int:MIEMBRO3 = valores[5]*10000 + valores[2]*1000 + valores[6]*100 + valores[7]*10+ valores[2];
var int:SOLUCION = valores[8]*100000 + valores[9]*10000 + valores[10]*1000 + valores[4]*100 + valores[1]*10+ valores[2];

%Ponemos como restriccion que la suma de cada miembro de como resultado la solucion
constraint ((MIEMBRO1 + MIEMBRO2 + MIEMBRO3 == SOLUCION) /\ (all_different(valores))) ;


solve satisfy;

output ["\(strvalores[i]) = \(valores[i])\n" | i in POS];