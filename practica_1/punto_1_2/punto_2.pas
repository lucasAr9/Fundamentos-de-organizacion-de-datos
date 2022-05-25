{
* 2. Realizar un algoritmo, que utilizando el archivo de números enteros no
* ordenados creados en el ejercicio 1, informe por pantalla cantidad de números
* menores a 1500 y el promedio de los números ingresados. El nombre del archivo
* a procesar debe ser proporcionado por el usuario una única vez. Además, el
* algoritmo deberá listar el contenido del archivo en pantalla.
}

program punto_2;

type
arch = file of integer;


var
    n_logico: arch;
    num, cantMenores, cantTotal, sumar: integer;
BEGIN   
    assign(n_logico, 'hola.dat');

    reset(n_logico);

    sumar:= 0;
    cantMenores:= 0;
    cantTotal:= 0;

    while not eof(n_logico) do begin
        read(n_logico, num);
        cantTotal:= cantTotal + 1;
        
        if num <= 1500 then
            cantMenores:= cantMenores + 1;
        sumar:= sumar + num;
        
        write(num, ', ');
    end;

    writeln('');
    writeln('la cantidad que son menores a 1500 son: ', cantMenores);
    writeln('el promedio de los numeros es: ', sumar / cantTotal:2:2);
    
    close(n_logico);
END.
