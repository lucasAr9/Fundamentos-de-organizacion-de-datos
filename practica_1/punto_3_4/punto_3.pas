{
3. Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con
    datos ingresados desde teclado. De cada empleado se registra: número de
    empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
    DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y
    i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
    determinado.
    ii. Listar en pantalla los empleados de a uno por línea.
    iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el
usuario una única vez.
}
{
4. Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir una o más empleados al final del archivo con sus datos ingresados
    por teclado.

b. Modificar edad a una o más empleados.

c. Exportar el contenido del archivo a un archivo de texto llamado
    “todos_empleados.txt”.

d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
    que no tengan cargado el DNI (DNI en 00).

NOTA: Las búsquedas deben realizarse por número de empleado.
}

program punto_3_y_4;

type
empleado = record
    numero_emple: integer;
    edad: integer;
    dni: integer;
end;

arch = file of empleado;


// punto 3 <-----------------------------
procedure leerRandom(var e: empleado; i: integer);
begin
    with e do begin
        numero_emple:= i;
        edad:= random(60) + 25;
        dni:= random(30300);
    end;
end;


procedure cargar(var n_logico: arch);
var
    e: empleado;
    i: integer;
begin
    assign(n_logico, 'empleados.dat');

    randomize;
    rewrite(n_logico);
    
    for i:= 1 to 20 do begin
        leerRandom(e, i);
        write(n_logico, e);
    end;
    writeln('se cargo el archivo empleados.dat con 100 empleados');
    writeln('');
    close(n_logico);
end;


procedure imprimirTodo(var n_logico: arch);
var e: empleado;
begin
    reset(n_logico);
    
    while not eof(n_logico) do begin
        read(n_logico, e);
        writeln('Numero empleado: ', e.numero_emple,
                ' edad: ', e.edad,
                ' DNI: ', e.dni);
    end;
    writeln('');
    close(n_logico);
end;


procedure impLosDe(var n_logico: arch; edad: integer);
var e: empleado;
begin
    reset(n_logico);
    
    while not eof(n_logico) do begin
        read(n_logico, e);
        if e.edad = edad then begin
            writeln('Numero empleado: ', e.numero_emple,
                    ' edad: ', e.edad,
                    ' DNI: ', e.dni);
        end;
    end;
    writeln('');
    close(n_logico);
end;


procedure impLosMayores70(var n_logico: arch);
var e: empleado;
begin
    reset(n_logico);
    
    while not eof(n_logico) do begin
        read(n_logico, e);
        if e.edad >= 70 then begin
            writeln('Numero empleado: ', e.numero_emple,
                    ' edad: ', e.edad,
                    ' DNI: ', e.dni);
        end;
    end;
    writeln('');
    close(n_logico);
end;


// punto 4 <-----------------------------
procedure leer(var e: empleado);
begin
    write('numero de empleado: '); readln(e.numero_emple);
    if e.numero_emple <> 0 then begin
        write('edad: '); readln(e.edad);
        write('DNI: '); readln(e.dni);
    end;
end;


procedure agregar(var n_logico: arch);
var
    e: empleado;
begin
    reset(n_logico);
    seek(n_logico, fileSize(n_logico));
    
    leer(e);
    while e.numero_emple <> 0 do begin
        write(n_logico, e);
        writeln('agregado con exito.');
        leer(e);
    end;
    writeln('');
    close(n_logico);
end;


//una manera de agregar detalles a maestro
procedure detalleMaestro(var n_logico: arch; num: integer);
var
    otroE: empleado;
begin
    reset(n_logico);
    
    read(n_logico, otroE);
    while (not eof(n_logico)) and (otroE.numero_emple <> num) do
        read(n_logico, otroE);

    if (not eof(n_logico)) and (otroE.numero_emple = num) then begin
        otroE.edad:= otroE.edad + 1;
        seek(n_logico, filePos(n_logico) - 1);
        write(n_logico, otroE);
        writeln('edad aumentada con exito.');
    end
    else
        writeln('NO se encontro.');
    close(n_logico);
end;


procedure cambiarEdades(var n_logico: arch);
var
    num: integer;
begin
    write('numero de empleado a sumarle un anio: '); readln(num);
    while num <> 0 do begin
        detalleMaestro(n_logico, num);
        write('numero de empleado a sumarle un anio: '); readln(num);
    end;
end;

// crear un archivo de txt desde un binario
procedure exportar(var n_logico: arch; var carga: text); // c y d
var
    e: empleado;
begin
    reset(n_logico);

    assign(carga, 'archivoTextoPosta.txt');
    rewrite(carga);
 
    while not eof(n_logico) do begin
        read(n_logico, e);
        writeln(carga, ' ', e.numero_emple, ' ', e.edad, ' ', e.dni);
    end;
    close(n_logico);
    close(carga);
end;

// crear un archivo binario desde un txt
procedure crearBinarioDeText(var otro_arch: arch; var carga: text);
var
    e: empleado;
begin
    assign(otro_arch, 'otro_arch.dat');
    rewrite(otro_arch);

    reset(carga);

    while not eof(carga) do begin
        readln(carga, e.numero_emple, e.edad, e.dni);
        write(otro_arch, e);
    end;
    close(otro_arch);
    close(carga);
end;


procedure imprimirTodoTxt(var carga: text);
var
    e: empleado;
begin
    reset(carga);

    while not eof(carga) do begin
        readln(carga, e.numero_emple, e.edad, e.dni);
        writeln('numero empleado: ', e.numero_emple,
                ' edad: ', e.edad, ' dni: ', e.dni);
    end;
    close(carga);
end;


var
    n_logico: arch;
    opcion: integer;
    carga: text;
BEGIN
    repeat
        writeln('--> Opciones para elegir <--');
        writeln('1. Crear un archivo con empleados.');
        writeln('2. Imprimir todos los empleados.');
        writeln('3. Imprimir los de 25 anios.');
        writeln('4. Imprimir los de mas de 70.');
        writeln('');
        writeln('5. Agregar uno o mas empleados.');
        writeln('6. Cambiar edades de empleados.');
        writeln('7. exportar los datos a todos_empleados.txt');
        writeln('8. imprimir el archivo imprimirTodoTxt.txt NO FUNCA');
        writeln('0. salir');
        writeln('*******************************************************');
        readln(opcion);
        case opcion of
            1: cargar(n_logico);
            2: imprimirTodo(n_logico);
            3: impLosDe(n_logico, 25);
            4: impLosMayores70(n_logico);
            5: agregar(n_logico);
            6: cambiarEdades(n_logico);
            7: exportar(n_logico, carga);
            8: imprimirTodoTxt(carga);
        else
            writeln('opcion incorrecta, vuelve a intentar');
        end;
    until(opcion = 0);
END.
