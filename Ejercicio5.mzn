include "globals.mzn";

%Para codificar este ejercicio, he decidido dividir cada dia (Lunes,Martes...) en una matriz que contenga lo siguiente por cada fila:
%  -1º Un numero correspondiente a la franja horaria (entre 1 y 6). Donde 1 corresponde a 8:00-9:00, 2 corresponde a 9:00-10:00...
%  -2º El profesor que esta impartiendo clase en ese momento (entre 1 y 4). En la 4 franja siempre aparece 9, ese numero simboliza el recreo, ya que está fuera del dominio de profesores.
%  -3º La asignatura que se esta impartiendo (entre 1 y 9). En el caso del recreo aparecerá siempre la asignatura 0, que está fuera del dominio.

array [1..6] of string: strHorarios = [" 8:00 - 9:00", "9:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00", "12:00 - 13:00", "13:00 - 14:00"];
%                                             1              2                3                4                5                6

array [1..4] of string: strProf = ["P1", "P2", "P3", "P4"];
%                                    1     2     3     4   

array [1..9] of string: strAsignaturas = ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9"];
%                                           1     2     3     4     5     6     7     8     9

array [1..6,1..3] of var 0..9: Lunes;
array [1..6,1..3] of var 0..9: Martes;
array [1..6,1..3] of var 0..9: Miercoles;
array [1..6,1..3] of var 0..9: Jueves;
array [1..6,1..3] of var 0..9: Viernes;

%---------------------------------------LUNES---------------------------------------

%Hacemos que el valor que pueda adoptar la columna de profesores sea entre 1 y 4.
%A excepción del 9 que es el recreo.
constraint(forall(i in 1..6)(Lunes[i,2] != 9 -> Lunes[i,2] <= 4));

%Hacemos que las franjas horarias vayan ordenadas de menor a mayor.
constraint(forall(i in 1..6)(Lunes[i,1] == i));

constraint(Lunes[4,2] == 9 /\ Lunes[4,3] == 0); %RECREO

%Restringimos que asignaturas puede dar cada profesor con los valores de la tabla del enunciado.
constraint(forall(i in 1..6)(Lunes[i,2] == 1 -> Lunes[i,3] == 1 \/ Lunes[i,3] == 3));
constraint(forall(i in 1..6)(Lunes[i,2] == 2 -> Lunes[i,3] == 4 \/ Lunes[i,3] == 5));
constraint(forall(i in 1..6)(Lunes[i,2] == 3 -> Lunes[i,3] == 6 \/ Lunes[i,3] == 9));
constraint(forall(i in 1..6)(Lunes[i,2] == 4 -> Lunes[i,3] == 2 \/ Lunes[i,3] == 7 \/ Lunes[i,3] == 8));
 
%LOS QUE VAN EN BLOQUES DE 2 HORAS
%Ahora hacemos que los que tienen que ir en bloques de dos horas vayan si o si de dos en dos.
%Esto lo hacemos diciendole que o su posicion anterior o posterior sea igual a la actual, pero no las dos.

constraint(forall(i in 2..5)(Lunes[i,3] == 1 -> Lunes[i+1,3] == 1 \/ Lunes[i-1,3] == 1));
constraint(Lunes[6,3] == 1 -> Lunes[5,3] == 1);

constraint(forall(i in 2..5)(Lunes[i,3] == 3 -> Lunes[i+1,3] == 3 \/ Lunes[i-1,3] == 3));
constraint(Lunes[6,3] == 3 -> Lunes[5,3] == 3);

constraint(forall(i in 2..5)(Lunes[i,3] == 4 -> Lunes[i+1,3] == 4 \/ Lunes[i-1,3] == 4));
constraint(Lunes[6,3] == 4 -> Lunes[5,3] == 4);

constraint(forall(i in 2..5)(Lunes[i,3] == 5 -> Lunes[i+1,3] == 5 \/ Lunes[i-1,3] == 5));
constraint(Lunes[6,3] == 5 -> Lunes[5,3] == 5);

constraint(forall(i in 2..5)(Lunes[i,3] == 8 -> Lunes[i+1,3] == 8 \/ Lunes[i-1,3] == 8));
constraint(Lunes[6,3] == 8 -> Lunes[5,3] == 8);


%LOS QUE VAN EN BLOQUES DE 1 HORA
%Ahora hacemos que los que tienen que ir en bloques de una horas vayan si o si de una en una.
%Esto lo hacemos diciendole que su posicion anterior y posterior sea diferente a la actual.
constraint(forall(i in 2..5)(Lunes[i,3] == 2 -> Lunes[i+1,3] != 2 /\ Lunes[i-1,3] != 2));
constraint(forall(i in 2..5)(Lunes[i,3] == 6 -> Lunes[i+1,3] != 6 /\ Lunes[i-1,3] != 6));
constraint(forall(i in 2..5)(Lunes[i,3] == 7 -> Lunes[i+1,3] != 7 /\ Lunes[i-1,3] != 7));
constraint(forall(i in 2..5)(Lunes[i,3] == 9 -> Lunes[i+1,3] != 9 /\ Lunes[i-1,3] != 9));

%Controlar que se den el numero correcto de bloques de asignaturas
%Para asegurarnos de que cada asignatura no se pase de los bloques que vienen en el enunciado,
%pasamos la columna de las asignaturas a un vector, y vemos que el count de cada asignatura corresponda
%a 2, 1 o 0. Dependiendo de lo que nos digan en el enunciado. Se da la posibilidad de que aparezca 0 veces
%porque es imposible que todas las asignaturas se impartan el mismo dia. Por falta de horas.

array [1..6] of var 0..9: Asig_Lunes_Array;
constraint(forall(i in 1..6)(Asig_Lunes_Array[i] == Lunes[i,3]));
constraint(count(Asig_Lunes_Array,1) == 2 \/ count(Asig_Lunes_Array,1) == 0 );
constraint(count(Asig_Lunes_Array,3) == 2 \/ count(Asig_Lunes_Array,3) == 0 );
constraint(count(Asig_Lunes_Array,4) == 2 \/ count(Asig_Lunes_Array,4) == 0 );
constraint(count(Asig_Lunes_Array,5) == 2 \/ count(Asig_Lunes_Array,5) == 0 );
constraint(count(Asig_Lunes_Array,8) == 2 \/ count(Asig_Lunes_Array,8) == 0 );

constraint(count(Asig_Lunes_Array,2) == 1 \/ count(Asig_Lunes_Array,2) == 0 );
constraint(count(Asig_Lunes_Array,6) == 1 \/ count(Asig_Lunes_Array,6) == 0 );
constraint(count(Asig_Lunes_Array,7) == 1 \/ count(Asig_Lunes_Array,7) == 0 );
constraint(count(Asig_Lunes_Array,9) == 1 \/ count(Asig_Lunes_Array,9) == 0 );

%Controlar que los profesores no den mas de un bloque, menos el 4
%Ahora nos aseguramos de que un profesor no aparezca mas veces que el bloque
%de horas de la asignatura que imparte.
%A excepción del profesor 4, que puede aparecer las veces que quiera.

array [1..6] of var 1..9: Prof_Lunes_Array;
constraint(forall(i in 1..6)(Prof_Lunes_Array[i] == Lunes[i,2]));
constraint(count(Prof_Lunes_Array,1) < 3 );
constraint(count(Prof_Lunes_Array,2) < 3 );
constraint(count(Prof_Lunes_Array,3) < 2 );
constraint(count(Prof_Lunes_Array,9) == 1 );

%Ahora hacemos exactamente lo mismo en las sucesivas matrices. Para estar en igualdad de condiciones.

%---------------------------------------Martes---------------------------------------

constraint(forall(i in 1..6)(Martes[i,2] != 9 -> Martes[i,2] <= 4));
constraint(forall(i in 1..6)(Martes[i,1] == i));

constraint(Martes[4,2] == 9 /\ Martes[4,3] == 0); %RECREO

constraint(forall(i in 1..6)(Martes[i,2] == 1 -> Martes[i,3] == 1 \/ Martes[i,3] == 3));
constraint(forall(i in 1..6)(Martes[i,2] == 2 -> Martes[i,3] == 4 \/ Martes[i,3] == 5));
constraint(forall(i in 1..6)(Martes[i,2] == 3 -> Martes[i,3] == 6 \/ Martes[i,3] == 9));
constraint(forall(i in 1..6)(Martes[i,2] == 4 -> Martes[i,3] == 2 \/ Martes[i,3] == 7 \/ Martes[i,3] == 8));
 
%LOS QUE VAN EN BLOQUES DE 2 HORAS
constraint(forall(i in 2..5)(Martes[i,3] == 1 -> Martes[i+1,3] == 1 \/ Martes[i-1,3] == 1));
constraint(Martes[6,3] == 1 -> Martes[5,3] == 1);

constraint(forall(i in 2..5)(Martes[i,3] == 3 -> Martes[i+1,3] == 3 \/ Martes[i-1,3] == 3));
constraint(Martes[6,3] == 3 -> Martes[5,3] == 3);

constraint(forall(i in 2..5)(Martes[i,3] == 4 -> Martes[i+1,3] == 4 \/ Martes[i-1,3] == 4));
constraint(Martes[6,3] == 4 -> Martes[5,3] == 4);

constraint(forall(i in 2..5)(Martes[i,3] == 5 -> Martes[i+1,3] == 5 \/ Martes[i-1,3] == 5));
constraint(Martes[6,3] == 5 -> Martes[5,3] == 5);

constraint(forall(i in 2..5)(Martes[i,3] == 8 -> Martes[i+1,3] == 8 \/ Martes[i-1,3] == 8));
constraint(Martes[6,3] == 8 -> Martes[5,3] == 8);

%Controlar que se den el numero correcto de bloques de asignaturas
array [1..6] of var 0..9: Asig_Martes_Array;
constraint(forall(i in 1..6)(Asig_Martes_Array[i] == Martes[i,3]));
constraint(count(Asig_Martes_Array,1) == 2 \/ count(Asig_Martes_Array,1) == 0 );
constraint(count(Asig_Martes_Array,3) == 2 \/ count(Asig_Martes_Array,3) == 0 );
constraint(count(Asig_Martes_Array,4) == 2 \/ count(Asig_Martes_Array,4) == 0 );
constraint(count(Asig_Martes_Array,5) == 2 \/ count(Asig_Martes_Array,5) == 0 );
constraint(count(Asig_Martes_Array,8) == 2 \/ count(Asig_Martes_Array,8) == 0 );

constraint(count(Asig_Martes_Array,2) == 1 \/ count(Asig_Martes_Array,2) == 0 );
constraint(count(Asig_Martes_Array,6) == 1 \/ count(Asig_Martes_Array,6) == 0 );
constraint(count(Asig_Martes_Array,7) == 1 \/ count(Asig_Martes_Array,7) == 0 );
constraint(count(Asig_Martes_Array,9) == 1 \/ count(Asig_Martes_Array,9) == 0 );


%LOS QUE VAN EN BLOQUES DE 1 HORA
constraint(forall(i in 2..5)(Martes[i,3] == 2 -> Martes[i+1,3] != 2 /\ Martes[i-1,3] != 2));
constraint(forall(i in 2..5)(Martes[i,3] == 6 -> Martes[i+1,3] != 6 /\ Martes[i-1,3] != 6));
constraint(forall(i in 2..5)(Martes[i,3] == 7 -> Martes[i+1,3] != 7 /\ Martes[i-1,3] != 7));
constraint(forall(i in 2..5)(Martes[i,3] == 9 -> Martes[i+1,3] != 9 /\ Martes[i-1,3] != 9));

%Controlar que los profesores no den mas de un bloque, menos el 4
array [1..6] of var 1..9: Prof_Martes_Array;
constraint(forall(i in 1..6)(Prof_Martes_Array[i] == Martes[i,2]));
constraint(count(Prof_Martes_Array,1) < 3 );
constraint(count(Prof_Martes_Array,2) < 3 );
constraint(count(Prof_Martes_Array,3) < 2 );
constraint(count(Prof_Martes_Array,9) == 1 );

%---------------------------------------Miercoles---------------------------------------

constraint(forall(i in 1..6)(Miercoles[i,2] != 9 -> Miercoles[i,2] <= 4));
constraint(forall(i in 1..6)(Miercoles[i,1] == i));

constraint(Miercoles[4,2] == 9 /\ Miercoles[4,3] == 0); %RECREO

constraint(forall(i in 1..6)(Miercoles[i,2] == 1 -> Miercoles[i,3] == 1 \/ Miercoles[i,3] == 3));
constraint(forall(i in 1..6)(Miercoles[i,2] == 2 -> Miercoles[i,3] == 4 \/ Miercoles[i,3] == 5));
constraint(forall(i in 1..6)(Miercoles[i,2] == 3 -> Miercoles[i,3] == 6 \/ Miercoles[i,3] == 9));
constraint(forall(i in 1..6)(Miercoles[i,2] == 4 -> Miercoles[i,3] == 2 \/ Miercoles[i,3] == 7 \/ Miercoles[i,3] == 8));
 
%LOS QUE VAN EN BLOQUES DE 2 HORAS
constraint(forall(i in 2..5)(Miercoles[i,3] == 1 -> Miercoles[i+1,3] == 1 \/ Miercoles[i-1,3] == 1));
constraint(Miercoles[6,3] == 1 -> Miercoles[5,3] == 1);

constraint(forall(i in 2..5)(Miercoles[i,3] == 3 -> Miercoles[i+1,3] == 3 \/ Miercoles[i-1,3] == 3));
constraint(Miercoles[6,3] == 3 -> Miercoles[5,3] == 3);

constraint(forall(i in 2..5)(Miercoles[i,3] == 4 -> Miercoles[i+1,3] == 4 \/ Miercoles[i-1,3] == 4));
constraint(Miercoles[6,3] == 4 -> Miercoles[5,3] == 4);

constraint(forall(i in 2..5)(Miercoles[i,3] == 5 -> Miercoles[i+1,3] == 5 \/ Miercoles[i-1,3] == 5));
constraint(Miercoles[6,3] == 5 -> Miercoles[5,3] == 5);

constraint(forall(i in 2..5)(Miercoles[i,3] == 8 -> Miercoles[i+1,3] == 8 \/ Miercoles[i-1,3] == 8));
constraint(Miercoles[6,3] == 8 -> Miercoles[5,3] == 8);

%Controlar que se den el numero correcto de bloques de asignaturas
array [1..6] of var 0..9: Asig_Miercoles_Array;
constraint(forall(i in 1..6)(Asig_Miercoles_Array[i] == Miercoles[i,3]));
constraint(count(Asig_Miercoles_Array,1) == 2 \/ count(Asig_Miercoles_Array,1) == 0 );
constraint(count(Asig_Miercoles_Array,3) == 2 \/ count(Asig_Miercoles_Array,3) == 0 );
constraint(count(Asig_Miercoles_Array,4) == 2 \/ count(Asig_Miercoles_Array,4) == 0 );
constraint(count(Asig_Miercoles_Array,5) == 2 \/ count(Asig_Miercoles_Array,5) == 0 );
constraint(count(Asig_Miercoles_Array,8) == 2 \/ count(Asig_Miercoles_Array,8) == 0 );

constraint(count(Asig_Miercoles_Array,2) == 1 \/ count(Asig_Miercoles_Array,2) == 0 );
constraint(count(Asig_Miercoles_Array,6) == 1 \/ count(Asig_Miercoles_Array,6) == 0 );
constraint(count(Asig_Miercoles_Array,7) == 1 \/ count(Asig_Miercoles_Array,7) == 0 );
constraint(count(Asig_Miercoles_Array,9) == 1 \/ count(Asig_Miercoles_Array,9) == 0 );


%LOS QUE VAN EN BLOQUES DE 1 HORA
constraint(forall(i in 2..5)(Miercoles[i,3] == 2 -> Miercoles[i+1,3] != 2 /\ Miercoles[i-1,3] != 2));
constraint(forall(i in 2..5)(Miercoles[i,3] == 6 -> Miercoles[i+1,3] != 6 /\ Miercoles[i-1,3] != 6));
constraint(forall(i in 2..5)(Miercoles[i,3] == 7 -> Miercoles[i+1,3] != 7 /\ Miercoles[i-1,3] != 7));
constraint(forall(i in 2..5)(Miercoles[i,3] == 9 -> Miercoles[i+1,3] != 9 /\ Miercoles[i-1,3] != 9));

%Controlar que los profesores no den mas de un bloque, menos el 4
array [1..6] of var 1..9: Prof_Miercoles_Array;
constraint(forall(i in 1..6)(Prof_Miercoles_Array[i] == Miercoles[i,2]));
constraint(count(Prof_Miercoles_Array,1) < 3 );
constraint(count(Prof_Miercoles_Array,2) < 3 );
constraint(count(Prof_Miercoles_Array,3) < 2 );
constraint(count(Prof_Miercoles_Array,9) == 1 );

%---------------------------------------Jueves---------------------------------------

constraint(forall(i in 1..6)(Jueves[i,2] != 9 -> Jueves[i,2] <= 4));
constraint(forall(i in 1..6)(Jueves[i,1] == i));

constraint(Jueves[4,2] == 9 /\ Jueves[4,3] == 0); %RECREO

constraint(forall(i in 1..6)(Jueves[i,2] == 1 -> Jueves[i,3] == 1 \/ Jueves[i,3] == 3));
constraint(forall(i in 1..6)(Jueves[i,2] == 2 -> Jueves[i,3] == 4 \/ Jueves[i,3] == 5));
constraint(forall(i in 1..6)(Jueves[i,2] == 3 -> Jueves[i,3] == 6 \/ Jueves[i,3] == 9));
constraint(forall(i in 1..6)(Jueves[i,2] == 4 -> Jueves[i,3] == 2 \/ Jueves[i,3] == 7 \/ Jueves[i,3] == 8));
 
%LOS QUE VAN EN BLOQUES DE 2 HORAS
constraint(forall(i in 2..5)(Jueves[i,3] == 1 -> Jueves[i+1,3] == 1 \/ Jueves[i-1,3] == 1));
constraint(Jueves[6,3] == 1 -> Jueves[5,3] == 1);

constraint(forall(i in 2..5)(Jueves[i,3] == 3 -> Jueves[i+1,3] == 3 \/ Jueves[i-1,3] == 3));
constraint(Jueves[6,3] == 3 -> Jueves[5,3] == 3);

constraint(forall(i in 2..5)(Jueves[i,3] == 4 -> Jueves[i+1,3] == 4 \/ Jueves[i-1,3] == 4));
constraint(Jueves[6,3] == 4 -> Jueves[5,3] == 4);

constraint(forall(i in 2..5)(Jueves[i,3] == 5 -> Jueves[i+1,3] == 5 \/ Jueves[i-1,3] == 5));
constraint(Jueves[6,3] == 5 -> Jueves[5,3] == 5);

constraint(forall(i in 2..5)(Jueves[i,3] == 8 -> Jueves[i+1,3] == 8 \/ Jueves[i-1,3] == 8));
constraint(Jueves[6,3] == 8 -> Jueves[5,3] == 8);

%Controlar que se den el numero correcto de bloques de asignaturas
array [1..6] of var 0..9: Asig_Jueves_Array;
constraint(forall(i in 1..6)(Asig_Jueves_Array[i] == Jueves[i,3]));
constraint(count(Asig_Jueves_Array,1) == 2 \/ count(Asig_Jueves_Array,1) == 0 );
constraint(count(Asig_Jueves_Array,3) == 2 \/ count(Asig_Jueves_Array,3) == 0 );
constraint(count(Asig_Jueves_Array,4) == 2 \/ count(Asig_Jueves_Array,4) == 0 );
constraint(count(Asig_Jueves_Array,5) == 2 \/ count(Asig_Jueves_Array,5) == 0 );
constraint(count(Asig_Jueves_Array,8) == 2 \/ count(Asig_Jueves_Array,8) == 0 );

constraint(count(Asig_Jueves_Array,2) == 1 \/ count(Asig_Jueves_Array,2) == 0 );
constraint(count(Asig_Jueves_Array,6) == 1 \/ count(Asig_Jueves_Array,6) == 0 );
constraint(count(Asig_Jueves_Array,7) == 1 \/ count(Asig_Jueves_Array,7) == 0 );
constraint(count(Asig_Jueves_Array,9) == 1 \/ count(Asig_Jueves_Array,9) == 0 );


%LOS QUE VAN EN BLOQUES DE 1 HORA
constraint(forall(i in 2..5)(Jueves[i,3] == 2 -> Jueves[i+1,3] != 2 /\ Jueves[i-1,3] != 2));
constraint(forall(i in 2..5)(Jueves[i,3] == 6 -> Jueves[i+1,3] != 6 /\ Jueves[i-1,3] != 6));
constraint(forall(i in 2..5)(Jueves[i,3] == 7 -> Jueves[i+1,3] != 7 /\ Jueves[i-1,3] != 7));
constraint(forall(i in 2..5)(Jueves[i,3] == 9 -> Jueves[i+1,3] != 9 /\ Jueves[i-1,3] != 9));

%Controlar que los profesores no den mas de un bloque, menos el 4
array [1..6] of var 1..9: Prof_Jueves_Array;
constraint(forall(i in 1..6)(Prof_Jueves_Array[i] == Jueves[i,2]));
constraint(count(Prof_Jueves_Array,1) < 3 );
constraint(count(Prof_Jueves_Array,2) < 3 );
constraint(count(Prof_Jueves_Array,3) < 2 );
constraint(count(Prof_Jueves_Array,9) == 1 );

%---------------------------------------Viernes---------------------------------------

constraint(forall(i in 1..6)(Viernes[i,2] != 9 -> Viernes[i,2] <= 4));
constraint(forall(i in 1..6)(Viernes[i,1] == i));

constraint(Viernes[4,2] == 9 /\ Viernes[4,3] == 0); %RECREO

constraint(forall(i in 1..6)(Viernes[i,2] == 1 -> Viernes[i,3] == 1 \/ Viernes[i,3] == 3));
constraint(forall(i in 1..6)(Viernes[i,2] == 2 -> Viernes[i,3] == 4 \/ Viernes[i,3] == 5));
constraint(forall(i in 1..6)(Viernes[i,2] == 3 -> Viernes[i,3] == 6 \/ Viernes[i,3] == 9));
constraint(forall(i in 1..6)(Viernes[i,2] == 4 -> Viernes[i,3] == 2 \/ Viernes[i,3] == 7 \/ Viernes[i,3] == 8));
 
%LOS QUE VAN EN BLOQUES DE 2 HORAS
constraint(forall(i in 2..5)(Viernes[i,3] == 1 -> Viernes[i+1,3] == 1 \/ Viernes[i-1,3] == 1));
constraint(Viernes[6,3] == 1 -> Viernes[5,3] == 1);

constraint(forall(i in 2..5)(Viernes[i,3] == 3 -> Viernes[i+1,3] == 3 \/ Viernes[i-1,3] == 3));
constraint(Viernes[6,3] == 3 -> Viernes[5,3] == 3);

constraint(forall(i in 2..5)(Viernes[i,3] == 4 -> Viernes[i+1,3] == 4 \/ Viernes[i-1,3] == 4));
constraint(Viernes[6,3] == 4 -> Viernes[5,3] == 4);

constraint(forall(i in 2..5)(Viernes[i,3] == 5 -> Viernes[i+1,3] == 5 \/ Viernes[i-1,3] == 5));
constraint(Viernes[6,3] == 5 -> Viernes[5,3] == 5);

constraint(forall(i in 2..5)(Viernes[i,3] == 8 -> Viernes[i+1,3] == 8 \/ Viernes[i-1,3] == 8));
constraint(Viernes[6,3] == 8 -> Viernes[5,3] == 8);



%Controlar que se den el numero correcto de bloques de asignaturas
array [1..6] of var 0..9: Asig_Viernes_Array;
constraint(forall(i in 1..6)(Asig_Viernes_Array[i] == Viernes[i,3]));
constraint(count(Asig_Viernes_Array,1) == 2 \/ count(Asig_Viernes_Array,1) == 0 );
constraint(count(Asig_Viernes_Array,3) == 2 \/ count(Asig_Viernes_Array,3) == 0 );
constraint(count(Asig_Viernes_Array,4) == 2 \/ count(Asig_Viernes_Array,4) == 0 );
constraint(count(Asig_Viernes_Array,5) == 2 \/ count(Asig_Viernes_Array,5) == 0 );
constraint(count(Asig_Viernes_Array,8) == 2 \/ count(Asig_Viernes_Array,8) == 0 );

constraint(count(Asig_Viernes_Array,2) == 1 \/ count(Asig_Viernes_Array,2) == 0 );
constraint(count(Asig_Viernes_Array,6) == 1 \/ count(Asig_Viernes_Array,6) == 0 );
constraint(count(Asig_Viernes_Array,7) == 1 \/ count(Asig_Viernes_Array,7) == 0 );
constraint(count(Asig_Viernes_Array,9) == 1 \/ count(Asig_Viernes_Array,9) == 0 );


%LOS QUE VAN EN BLOQUES DE 1 HORA
constraint(forall(i in 2..5)(Viernes[i,3] == 2 -> Viernes[i+1,3] != 2 /\ Viernes[i-1,3] != 2));
constraint(forall(i in 2..5)(Viernes[i,3] == 6 -> Viernes[i+1,3] != 6 /\ Viernes[i-1,3] != 6));
constraint(forall(i in 2..5)(Viernes[i,3] == 7 -> Viernes[i+1,3] != 7 /\ Viernes[i-1,3] != 7));
constraint(forall(i in 2..5)(Viernes[i,3] == 9 -> Viernes[i+1,3] != 9 /\ Viernes[i-1,3] != 9));

%Controlar que los profesores no den mas de un bloque, menos el 4
array [1..6] of var 1..9: Prof_Viernes_Array;
constraint(forall(i in 1..6)(Prof_Viernes_Array[i] == Viernes[i,2]));
constraint(count(Prof_Viernes_Array,1) < 3 );
constraint(count(Prof_Viernes_Array,2) < 3 );
constraint(count(Prof_Viernes_Array,3) < 2 );
constraint(count(Prof_Viernes_Array,9) == 1 );

%-----------------------------------------------------------------
%Ahora comprobamos que la horas de las asignaturas coincidan con la tabla
%Finalmente vamos a restringir que la suma de horas de cada asignatura a lo largo de la semana,
%sea igual al valor que nos piden en la tabla del enunciado.

array [1..6] of var 0..9: AsigLunes;
array [1..6] of var 0..9: AsigMartes;
array [1..6] of var 0..9: AsigMiercoles;
array [1..6] of var 0..9: AsigJueves;
array [1..6] of var 0..9: AsigViernes;

constraint(forall(i in 1..6)(Lunes[i,3] == AsigLunes[i] /\ Martes[i,3] == AsigMartes[i] /\ Miercoles[i,3] == AsigMiercoles[i] /\
Jueves[i,3] == AsigJueves[i] /\ Viernes[i,3] == AsigViernes[i]));

constraint(count(AsigLunes,1) + count(AsigMartes,1) + count(AsigMiercoles,1) + count(AsigJueves,1) + count(AsigViernes,1) == 4);
constraint(count(AsigLunes,2) + count(AsigMartes,2) + count(AsigMiercoles,2) + count(AsigJueves,2) + count(AsigViernes,2) == 2);
constraint(count(AsigLunes,3) + count(AsigMartes,3) + count(AsigMiercoles,3) + count(AsigJueves,3) + count(AsigViernes,3) == 4);
constraint(count(AsigLunes,4) + count(AsigMartes,4) + count(AsigMiercoles,4) + count(AsigJueves,4) + count(AsigViernes,4) == 4);
constraint(count(AsigLunes,5) + count(AsigMartes,5) + count(AsigMiercoles,5) + count(AsigJueves,5) + count(AsigViernes,5) == 4);
constraint(count(AsigLunes,6) + count(AsigMartes,6) + count(AsigMiercoles,6) + count(AsigJueves,6) + count(AsigViernes,6) == 2);
constraint(count(AsigLunes,7) + count(AsigMartes,7) + count(AsigMiercoles,7) + count(AsigJueves,7) + count(AsigViernes,7) == 2);
constraint(count(AsigLunes,8) + count(AsigMartes,8) + count(AsigMiercoles,8) + count(AsigJueves,8) + count(AsigViernes,8) == 2);
constraint(count(AsigLunes,9) + count(AsigMartes,9) + count(AsigMiercoles,9) + count(AsigJueves,9) + count(AsigViernes,9) == 1);




solve satisfy;

output ["Lunes\n"];
output ["\(Lunes[i,j]) " ++
if j == 3 then "\n" else "" endif | i in 1..6, j in 1..3];
output ["\n"];
output ["Martes\n"];
output ["\(Martes[i,j]) " ++
if j == 3 then "\n" else "" endif | i in 1..6, j in 1..3];
output ["\n"];
output ["Miercoles\n"];
output ["\(Miercoles[i,j]) " ++
if j == 3 then "\n" else "" endif | i in 1..6, j in 1..3];
output ["\n"];
output ["Jueves\n"];
output ["\(Jueves[i,j]) " ++
if j == 3 then "\n" else "" endif | i in 1..6, j in 1..3];
output ["\n"];
output ["Viernes\n"];
output ["\(Viernes[i,j]) " ++
if j == 3 then "\n" else "" endif | i in 1..6, j in 1..3];