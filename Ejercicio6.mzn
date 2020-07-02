include "globals.mzn";

set of int: POS = 1..5;
array [POS] of string: strAnimales = ["Cebra", "Perro", "Caracoles", "Zorro", "Caballo"];
%                                        1        2          3          4         5

array [POS] of string: strBebida = ["Te", "Cafe", "Leche", "Zumo", "Agua"];
%                                    1       2       3       4        5

array [POS] of string: strRegiones = ["Vasco", "Catalan", "Gallego", "Navarro", "Andaluz"];
%                                        1         2          3          4          5

array [POS] of string: strColorCasa = ["Rojo", "Verde", "Blanco", "Amarillo", "Azul"];
%                                         1       2         3         4          5     

array [POS] of string: strProfesion = ["Pintor", "Escultor", "Diplomatico", "Violinista", "Medico"];
%                                         1          2             3             4            5     

% Combinacion[Region,Profesion,Casa,Bebida,Animal,numeroCasa]
%Este ejercicio lo resolveremos tratando la combinacion de los siguientes arrays, como una matriz.
%Y cada una de las asignaciones finales corresponde a la lectura de una "columna" de dicha "matriz".

array [POS] of var POS: Regiones; 
array [POS] of var POS: Profesiones; 
array [POS] of var POS: ColorCasas; 
array [POS] of var POS: Bebidas; 
array [POS] of var POS: Animales; 
array [POS] of var POS: numeroCasa;

%Rellenamos las regiones
constraint(forall(i in POS)(Regiones[i] == i));

%Ahora vamos a restringir los valores de los arrays dependiendo de lo que nos digan en cada
%apartado del enunciado.

% a b c d e
constraint (ColorCasas[1] == 1);
constraint (Animales[2] == 2);
constraint (Profesiones[3] == 1);
constraint (Bebidas[4] == 1);
constraint (numeroCasa[5] == 1);

%f
constraint (forall(i in POS)(ColorCasas[i] == 2 -> Bebidas[i] == 2));

%g
var int: num_casa_blanca;
constraint (forall(i in POS)(ColorCasas[i] == 3 -> num_casa_blanca == numeroCasa[i]));
constraint (forall(i in POS)(ColorCasas[i] == 2 -> numeroCasa[i] == num_casa_blanca+1));

%h
constraint (forall(i in POS)(Profesiones[i] == 2 -> Animales[i] == 3));

%i
constraint (forall(i in POS)(Profesiones[i] == 3 -> ColorCasas[i] == 4));

%j
constraint (forall(i in POS)(numeroCasa[i] == 3 -> Bebidas[i] == 3));

%k
var int: num_casa_azul;
constraint (forall(i in POS)(ColorCasas[i] == 5 -> num_casa_azul == numeroCasa[i]));
constraint (forall(i in POS)(Regiones[i] == 5 -> (numeroCasa[i] == num_casa_azul-1 \/ numeroCasa[i] == num_casa_azul+1)));

%l
constraint (forall(i in POS)(Profesiones[i] == 4 -> Bebidas[i] == 4));

%m

var int: num_casa_zorro;
constraint (forall(i in POS)(Profesiones[i] == 5 -> num_casa_zorro == numeroCasa[i]));
constraint (forall(i in POS)(Animales[i] == 4 -> (numeroCasa[i] == num_casa_zorro-1 \/ numeroCasa[i] == num_casa_zorro+1)));

%n

var int: num_casa_diplomatico;
constraint (forall(i in POS)(Profesiones[i] == 3 -> num_casa_diplomatico == numeroCasa[i]));
constraint (forall(i in POS)(Animales[i] == 5 -> (numeroCasa[i] == num_casa_diplomatico-1 \/ numeroCasa[i] == num_casa_diplomatico+1)));

%Hacemos que todos los valores sean diferentes entre ellos, ya que cada asignacion es única.
constraint (all_different(Regiones));
constraint (all_different(ColorCasas));
constraint (all_different(Profesiones));
constraint (all_different(Bebidas));
constraint (all_different(numeroCasa));
constraint (all_different(Animales));

solve satisfy;
output ["Regiones:    "];
output ["\(Regiones[i]) " | i in POS]; 
output ["\n"];
output ["Profesiones: "];
output ["\(Profesiones[i]) " | i in POS]; 
output ["\n"];
output ["Color Casas: "];
output ["\(ColorCasas[i]) " | i in POS]; 
output ["\n"];
output ["Bebidas:     "];
output ["\(Bebidas[i]) " | i in POS]; 
output ["\n"];
output ["Animales:    "];
output ["\(Animales[i]) " | i in POS]; 
output ["\n"];
output ["Numero Casa: "];
output ["\(numeroCasa[i]) " | i in POS]; 
output ["\n"];

%La cebra es el animal 1. Por lo que podemos decir que esta en la casa 5 con el pintor Gallego
%El agua es la bebida 5. Por lo que podemos decir que el que bebe agua es el diplomático Andaluz.
