include "globals.mzn";

set of int: POS = 1..6;

%Este array va a contener la asignacion en intervalos de tiempo de la solucion, es decir cada posicion i va a contener el intervalo
%en que va a impartir clase el profesor i. Si para el profesor i obtenemos el valor 1, quiere decir que impartirá clase de las 9:00 a las
%10:00.
array [POS] of var POS: Asignacion;
array [POS] of string: horarios = [" 9:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00", "12:00 - 13:00", "13:00 - 14:00", "14:00 - 15:00"];
%                                         1                2                3                4                5                6

%Estas restricciones las rellenamos teniendo en cuenta la tabla que se adjunta en el enunciado.
%Si ponemos que los valores que puede adoptar restr1 son 3..6, quiere decir que el profesor 1 esta disponible de
%las 11:00 a las 15:00.
var 3..6: restr1;
var 3..4: restr2;
var 2..5: restr3;
var 2..4: restr4;
var 3..4: restr5;
var 1..6: restr6;

array[POS] of var int: restricciones = [restr1, restr2, restr3, restr4, restr5, restr6];   
  
%La clave de este ejercicio es que le asignemos a cada posicion i de asignacion, la correspondiente
%posicion i de restricciones (para tener en cuenta que horarios tiene disponible cada profesor)
%Y sobre todo que hagamos que todos los valores de asignacion sean diferentes entre ellos.
%Ya que dos profesores no pueden dar clase en la misma franja horaria.
       
constraint (forall(i in POS)(Asignacion[i] == restricciones[i]));
constraint all_different(Asignacion);

solve satisfy;

output ["\(Asignacion[i])\n" | i in POS];

