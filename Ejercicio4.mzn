include "globals.mzn";

%Para codificar este ejercicio, he decidido dividir cada franja horaria (9:00-10:00, 10:00-11:00...) en una matriz que contenga lo siguiente por cada fila:
%  -1º Un numero correspondiente al profesor que imparte la clase (entre 1 y 4)
%  -2º La asignatura que imparte el profesor en ese momento (entre 1 y 3). Si aparece el valor 5 es que en esa franja horaria, 
%el profesor no va a dar clase.
%  -3º El grupo al que el profesor va a impartir la asignatura (entre 1 y 4)
%  -4º El aula donde el profesor va a impartir la clase (entre 1 y 4)

array [1..4] of string: strHorarios = [" 9:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00", "12:00 - 13:00"];
%                                             1                2                3                4      
array [1..3] of string: strAsignaturas = ["IA", "TSI", "FBD"];
%                                           1     2      3               
array [1..4] of string: strGrupos = ["G1", "G2", "G3", "G4"];
%                                      1     2     3     4       
array [1..4] of string: strProf = ["P1", "P2", "P3", "P4"];
%                                    1     2     3     4                                                    

%Aqui se definen las matrices correspondientes a cada franja horaria. Cuando pone NueveAM se refiere a la franja de las 9:00 a las 10:00
%Las dos primeras matrices solo tienen 3 filas en vez de 4, porque en la tabla que se adjunta en el enunciado, nos dicen que de 9:00
%a 10:00 el profesor 4 no puede dar clase. Y de 10:00 a 11:00 no puede dar clase el profesor 2. 

array [1..3,1..4] of var 1..5: NueveAM;
array [1..3,1..4] of var 1..5: DiezAM;
array [1..4,1..4] of var 1..5: OnceAM;
array [1..4,1..4] of var 1..5: DoceAM;


%DE LAS 9:00 A LAS 10:00

%Añadimos la restriccion de que en ningun momento el profesor sea el 4, ya que segun la tabla, no puede dar clase de 9:00 a 10:00
constraint(forall(i in 1..3)(NueveAM[i,1] != 4));

%Hacemos que no se repitan tanto los profesores, como los grupos, como las aulas.
%Ya que tienen que ser diferentes para una misma franja horaria.

constraint((alldifferent([ NueveAM[i,1] | i in 1..3])));
constraint((alldifferent([ NueveAM[i,4] | i in 1..3])));
constraint((alldifferent([ NueveAM[i,3] | i in 1..3])));

%PROF1: Dependiendo de la asignatura que esté impartiendo, hacemos que los valores de los grupos se restrinjan a los de la tabla.
%Se da la posibilidad de que la asignatura que imparta tenga el valor 5, porque hay que contemplar que el profesor no de clase
%en ese momento,o porque todos los grupos esten ocupados o porque ya vaya a impartir todas sus asignaturas en las siguientes franjas
%horarias.

constraint(forall(i in 1..3)(NueveAM[i,1] == 1 -> NueveAM[i,2] == 1 \/ NueveAM[i,2] == 2 \/ NueveAM[i,2] == 5));
constraint(forall(i in 1..3)((NueveAM[i,1] == 1 /\ NueveAM[i,2] == 1) -> NueveAM[i,3] == 1 \/ NueveAM[i,3] == 2));
constraint(forall(i in 1..3)((NueveAM[i,1] == 1 /\ NueveAM[i,2] == 2) -> NueveAM[i,3] == 1 \/ NueveAM[i,3] == 2));

%PROF2: Dependiendo de la asignatura que este impartiendo, hacemos que los valores de los grupos se restrinjan a los de la tabla
constraint(forall(i in 1..3)(NueveAM[i,1] == 2 -> NueveAM[i,2] == 3 \/ NueveAM[i,2] == 5));
constraint(forall(i in 1..3)((NueveAM[i,1] == 2 /\ NueveAM[i,2] == 3) -> NueveAM[i,3] == 1 \/ NueveAM[i,3] == 2));

%PROF3: Dependiendo de la asignatura que este impartiendo, hacemos que los valores de los grupos se restrinjan a los de la tabla
constraint(forall(i in 1..3)(NueveAM[i,1] == 3 -> NueveAM[i,2] == 2 \/ NueveAM[i,2] == 3 \/ NueveAM[i,2] == 5));
constraint(forall(i in 1..3)((NueveAM[i,1] == 3 /\ NueveAM[i,2] == 2) -> NueveAM[i,3] == 3 \/ NueveAM[i,3] == 4));
constraint(forall(i in 1..3)((NueveAM[i,1] == 3 /\ NueveAM[i,2] == 3) -> NueveAM[i,3] == 3 \/ NueveAM[i,3] == 4));


%A continuación haremos exactamente lo mismo para las matrices de las sucesivas franjas horarias.
%Para que esten todas en igualdad de condiciones.

%DE LAS 10:00 A LAS 11:00

constraint(forall(i in 1..3)(DiezAM[i,1] != 2));
constraint((alldifferent([ DiezAM[i,1] | i in 1..3])));
constraint((alldifferent([ DiezAM[i,4] | i in 1..3])));
constraint((alldifferent([ DiezAM[i,3] | i in 1..3])));

%PROF1
constraint(forall(i in 1..3)(DiezAM[i,1] == 1 -> DiezAM[i,2] == 1 \/ DiezAM[i,2] == 2 \/ DiezAM[i,2] == 5));
constraint(forall(i in 1..3)((DiezAM[i,1] == 1 /\ DiezAM[i,2] == 1) -> DiezAM[i,3] == 1 \/ DiezAM[i,3] == 2));
constraint(forall(i in 1..3)((DiezAM[i,1] == 1 /\ DiezAM[i,2] == 2) -> DiezAM[i,3] == 1 \/ DiezAM[i,3] == 2));

%PROF3
constraint(forall(i in 1..3)(DiezAM[i,1] == 3 -> DiezAM[i,2] == 2 \/ DiezAM[i,2] == 3 \/ DiezAM[i,2] == 5));
constraint(forall(i in 1..3)((DiezAM[i,1] == 3 /\ DiezAM[i,2] == 2) -> DiezAM[i,3] == 3 \/ DiezAM[i,3] == 4));
constraint(forall(i in 1..3)((DiezAM[i,1] == 3 /\ DiezAM[i,2] == 3) -> DiezAM[i,3] == 3 \/ DiezAM[i,3] == 4));

%PROF4
constraint(forall(i in 1..3)(DiezAM[i,1] == 4 -> DiezAM[i,2] == 1 \/ DiezAM[i,2] == 5));
constraint(forall(i in 1..3)((DiezAM[i,1] == 4 /\ DiezAM[i,2] == 1) -> DiezAM[i,3] == 3 \/ DiezAM[i,3] == 4));


%DE LAS 11:00 A LAS 12:00

constraint((alldifferent([ OnceAM[i,1] | i in 1..4])));
constraint((alldifferent([ OnceAM[i,4] | i in 1..4])));
constraint((alldifferent([ OnceAM[i,3] | i in 1..4])));

%PROF1
constraint(forall(i in 1..4)(OnceAM[i,1] == 1 -> OnceAM[i,2] == 1 \/ OnceAM[i,2] == 2 \/ OnceAM[i,2] == 5));
constraint(forall(i in 1..4)((OnceAM[i,1] == 1 /\ OnceAM[i,2] == 1) -> OnceAM[i,3] == 1 \/ OnceAM[i,3] == 2));
constraint(forall(i in 1..4)((OnceAM[i,1] == 1 /\ OnceAM[i,2] == 2) -> OnceAM[i,3] == 1 \/ OnceAM[i,3] == 2));

%PROF2
constraint(forall(i in 1..4)(OnceAM[i,1] == 2 -> OnceAM[i,2] == 3 \/ OnceAM[i,2] == 5));
constraint(forall(i in 1..4)((OnceAM[i,1] == 2 /\ OnceAM[i,2] == 3) -> OnceAM[i,3] == 1 \/ OnceAM[i,3] == 2));

%PROF3
constraint(forall(i in 1..4)(OnceAM[i,1] == 3 -> OnceAM[i,2] == 2 \/ OnceAM[i,2] == 3 \/ OnceAM[i,2] == 5));
constraint(forall(i in 1..4)((OnceAM[i,1] == 3 /\ OnceAM[i,2] == 2) -> OnceAM[i,3] == 3 \/ OnceAM[i,3] == 4));
constraint(forall(i in 1..4)((OnceAM[i,1] == 3 /\ OnceAM[i,2] == 3) -> OnceAM[i,3] == 3 \/ OnceAM[i,3] == 4));

%PROF4
constraint(forall(i in 1..4)(OnceAM[i,1] == 4 -> OnceAM[i,2] == 1 \/ OnceAM[i,2] == 5));
constraint(forall(i in 1..4)(OnceAM[i,1] == 4 /\ OnceAM[i,2] == 1 -> OnceAM[i,3] == 3 \/ OnceAM[1,3] == 4));


%DE LAS 12:00 A LAS 13:00

constraint((alldifferent([ DoceAM[i,1] | i in 1..4])));
constraint((alldifferent([ DoceAM[i,4] | i in 1..4])));
constraint((alldifferent([ DoceAM[i,3] | i in 1..4])));

%PROF1
constraint(forall(i in 1..4)(DoceAM[i,1] == 1 -> DoceAM[i,2] == 1 \/ DoceAM[i,2] == 2 \/ DoceAM[i,2] == 5));
constraint(forall(i in 1..4)((DoceAM[i,1] == 1 /\ DoceAM[i,2] == 1) -> DoceAM[i,3] == 1 \/ DoceAM[i,3] == 2));
constraint(forall(i in 1..4)((DoceAM[i,1] == 1 /\ DoceAM[i,2] == 2) -> DoceAM[i,3] == 1 \/ DoceAM[i,3] == 2));

%PROF2
constraint(forall(i in 1..4)(DoceAM[i,1] == 2 -> DoceAM[i,2] == 3 \/ DoceAM[i,2] == 5));
constraint(forall(i in 1..4)((DoceAM[i,1] == 2 /\ DoceAM[i,2] == 3) -> DoceAM[i,3] == 1 \/ DoceAM[i,3] == 2));

%PROF3
constraint(forall(i in 1..4)(DoceAM[i,1] == 3 -> DoceAM[i,2] == 2 \/ DoceAM[i,2] == 3 \/ DoceAM[i,2] == 5));
constraint(forall(i in 1..4)((DoceAM[i,1] == 3 /\ DoceAM[i,2] == 2) -> DoceAM[i,3] == 3 \/ DoceAM[i,3] == 4));
constraint(forall(i in 1..4)((DoceAM[i,1] == 3 /\ DoceAM[i,2] == 3) -> DoceAM[i,3] == 3 \/ DoceAM[i,3] == 4));

%PROF4
constraint(forall(i in 1..4)(DoceAM[i,1] == 4 -> DoceAM[i,2] == 1 \/ DoceAM[i,2] == 5));
constraint(forall(i in 1..4)(DoceAM[i,1] == 4 /\ DoceAM[i,2] == 1 -> DoceAM[i,3] == 3 \/ DoceAM[1,3] == 4));

%RESTRICCIONES ENTRE HORARIOS
%Ahora vamos a añadir las restricciones entre horarios, en el sentido de que los profesores no impartan la misma asignatura
%al mismo grupo varias veces a lo largo del dia.

%Ordenamos los profesores de menor a mayor en cada matriz
constraint(forall(i in 1..4)(OnceAM[i,1] == i /\ DoceAM[i,1] == i));
constraint(forall(i in 1..3)(NueveAM[i,1] == i));
constraint(DiezAM[1,1] == 1);
constraint(DiezAM[2,1] == 3);
constraint(DiezAM[3,1] == 4);

%Comprobamos entre todas las matrices que si coincide en algun momento el valor de profesor y asignatura, el valor de grupo
%sea diferente si o si. Para que no imparta la misma asignatura al mismo grupo varias veces a lo largo del dia.
%Esta comprobacion la tenemos que hacer entre todas las matrices (9 con 10,11,12; 10 con 11,12; 11 con 12)
constraint(forall(i in 1..3)(NueveAM[i,1] == OnceAM[i,1] /\ NueveAM[i,2] == OnceAM[i,2] -> NueveAM[i,3] != OnceAM[i,3]));
constraint(forall(i in 1..3)(NueveAM[i,1] == DoceAM[i,1] /\ NueveAM[i,2] == DoceAM[i,2] -> NueveAM[i,3] != DoceAM[i,3]));
constraint(forall(i in 1..4)(OnceAM[i,1] == DoceAM[i,1] /\ OnceAM[i,2] == DoceAM[i,2] -> OnceAM[i,3] != DoceAM[i,3]));

%Comprobamos los restantes
constraint(DiezAM[1,1] == NueveAM[1,1] /\ DiezAM[1,2] == NueveAM[1,2] -> DiezAM[1,3] != NueveAM[1,3]);
constraint(DiezAM[2,1] == NueveAM[3,1] /\ DiezAM[2,2] == NueveAM[3,2] -> DiezAM[2,3] != NueveAM[3,3]);

constraint(DiezAM[1,1] == OnceAM[1,1] /\ DiezAM[1,2] == OnceAM[1,2] -> DiezAM[1,3] != OnceAM[1,3]);
constraint(DiezAM[2,1] == OnceAM[3,1] /\ DiezAM[2,2] == OnceAM[3,2] -> DiezAM[2,3] != OnceAM[3,3]);
constraint(DiezAM[3,1] == OnceAM[4,1] /\ DiezAM[3,2] == OnceAM[4,2] -> DiezAM[3,3] != OnceAM[4,3]);

constraint(DiezAM[1,1] == DoceAM[1,1] /\ DiezAM[1,2] == DoceAM[1,2] -> DiezAM[1,3] != DoceAM[1,3]);
constraint(DiezAM[2,1] == DoceAM[3,1] /\ DiezAM[2,2] == DoceAM[3,2] -> DiezAM[2,3] != DoceAM[3,3]);
constraint(DiezAM[3,1] == DoceAM[4,1] /\ DiezAM[3,2] == DoceAM[4,2] -> DiezAM[3,3] != DoceAM[4,3]);

%Finalmente, a nosotros nos interesa que se maximice el numero de clases que se impartan a lo largo del dia. 
%Y por lo tanto, que se minimice el numero de veces que el profesor no de clase.
%Es por esto que vamos a minimizar el numero de veces que aparezca el 5 como asignatura a lo largo del dia.
%Para ello crearemos un array para cada franja horaria, y cada vez que nos encontremos un 5 pondremos un 1 en esa posicion
%del array, en caso contrario pondremos un 0.

array [1..3] of var int:numero5Nueve;
array [1..3] of var int:numero5Diez;
array [1..4] of var int:numero5Once;
array [1..4] of var int:numero5Doce;

constraint(forall(i in 1..3)(NueveAM[i,2] == 5 -> numero5Nueve[i] == 1));
constraint(forall(i in 1..3)(NueveAM[i,2] != 5 -> numero5Nueve[i] == 0));

constraint(forall(i in 1..3)(DiezAM[i,2] == 5 -> numero5Diez[i] == 1));
constraint(forall(i in 1..3)(DiezAM[i,2] != 5 -> numero5Diez[i] == 0));

constraint(forall(i in 1..4)(OnceAM[i,2] == 5 -> numero5Once[i] == 1));
constraint(forall(i in 1..4)(OnceAM[i,2] != 5 -> numero5Once[i] == 0));

constraint(forall(i in 1..4)(DoceAM[i,2] == 5 -> numero5Doce[i] == 1));
constraint(forall(i in 1..4)(DoceAM[i,2] != 5 -> numero5Doce[i] == 0));

%Resolvemos el problema para que la aparicion de 5 sea mínima entre todas las matrices
solve minimize (sum(numero5Nueve) + sum(numero5Diez) + sum(numero5Once) + sum(numero5Doce));

output ["De las 9:00 a las 10:00\n"];
output ["\(NueveAM[i,j]) " ++
if j == 4 then "\n" else "" endif | i in 1..3, j in 1..4];

output ["-------------------------\n"];

output ["De las 10:00 a las 11:00\n"];
output ["\(DiezAM[i,j]) " ++
if j == 4 then "\n" else "" endif | i in 1..3, j in 1..4];

output ["-------------------------\n"];

output ["De las 11:00 a las 12:00\n"];
output ["\(OnceAM[i,j]) " ++
if j == 4 then "\n" else "" endif | i in 1..4, j in 1..4];

output ["-------------------------\n"];

output ["De las 12:00 a las 13:00\n"];
output ["\(DoceAM[i,j]) " ++
if j == 4 then "\n" else "" endif | i in 1..4, j in 1..4];

output ["------------FIN------------\n"];
 
