{
3. Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con
    datos ingresados desde teclado. De cada empleado se registra: número de
    empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
    DNI 00. La arch_emple_text finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y listar en pantalla empleados
    mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el
usuario una única vez.
}

{
4. Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir uno o más empleados al final del archivo con sus datos ingresados
    por teclado.

b. Modificar edad a una o más empleados.

c. Exportar el contenido del archivo a un archivo de texto llamado
    “todos_empleados.txt”.

d. Exportar a un archivo de texto llamado: “falta_DNI_empleado.txt”, los empleados
    que no tengan cargado el DNI (DNI en 00).

NOTA: Las búsquedas deben realizarse por número de empleado.
}

{
1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
    agregándole una opción para realizar bajas copiando el último registro del
    archivo en la posición del registro a borrar y luego truncando el archivo
    en la posición del último registro de forma tal de evitar duplicados.
}

program punto_3_y_4_y_1;

const
valor_alto = 999;

type
empleado = record
    numero_emple: integer;
    edad: integer;
    dni: integer;
    nombre: String[20];
    apellido: String[20];
end;

arch = file of empleado;


// punto 3 <-----------------------------
// importar el archivo de texto a binario
procedure importar(var arch_emple_bin: arch; var arch_emple_text: text);
var e: empleado;
begin
    reset(arch_emple_text);
    rewrite(arch_emple_bin);

    while not eof(arch_emple_text) do begin
        readln(arch_emple_text, e.numero_emple, e.edad, e.dni);
        readln(arch_emple_text, e.nombre);
        readln(arch_emple_text, e.apellido);
        
        write(arch_emple_bin, e);
    end;
    close(arch_emple_text);
    close(arch_emple_bin);
end;


// imprimir todos los empleados del archivo
procedure imprimirTodo(var arch_emple_bin: arch);
var e: empleado;
begin
    reset(arch_emple_bin);
    
    while not eof(arch_emple_bin) do begin
        read(arch_emple_bin, e);
        writeln('Numero empleado: ', e.numero_emple,
                ' edad: ', e.edad,
                ' DNI: ', e.dni,
                ' nombre: ', e.nombre,
                ' apellido: ', e.apellido);
    end;
    writeln('');
    close(arch_emple_bin);
end;


// imprimir del archivo, todos los que tengan mayor edad que 70
procedure impLosMayores70(var arch_emple_bin: arch);
var e: empleado;
begin
    reset(arch_emple_bin);
    
    while not eof(arch_emple_bin) do begin
        read(arch_emple_bin, e);
        if e.edad >= 70 then begin
            writeln('Numero empleado: ', e.numero_emple,
                ' edad: ', e.edad,
                ' DNI: ', e.dni,
                ' nombre: ', e.nombre,
                ' apellido: ', e.apellido);
        end;
    end;
    writeln('');
    close(arch_emple_bin);
end;


// punto 4 <-----------------------------
// leer desde teclado los dates del empleado y
procedure leer_datos(var e: empleado);
begin
    write('numero de empleado: '); readln(e.numero_emple);
    if e.numero_emple <> -1 then begin
        write('edad: '); readln(e.edad);
        write('DNI: '); readln(e.dni);
        write('nombre: '); readln(e.nombre);
        write('apellido: '); readln(e.apellido);
    end;
end;
// y agregarlos al archivo logico
procedure agregar(var arch_emple_bin: arch);
var e: empleado;
begin
    reset(arch_emple_bin);
    seek(arch_emple_bin, fileSize(arch_emple_bin));
    
    leer_datos(e);
    while (e.numero_emple <> -1) do begin
        write(arch_emple_bin, e);
        writeln('agregado con exito.');
        leer_datos(e);
    end;
    writeln('');
    close(arch_emple_bin);
end;


// modificar edad del empleado
procedure detalleMaestro(var arch_emple_bin: arch; num: integer);
var otroE: empleado;
begin
    reset(arch_emple_bin);
    
    read(arch_emple_bin, otroE);
    while (not eof(arch_emple_bin)) and (otroE.numero_emple <> num) do
        read(arch_emple_bin, otroE);

    if (not eof(arch_emple_bin)) and (otroE.numero_emple = num) then begin
        otroE.edad:= otroE.edad + 1;
        seek(arch_emple_bin, filePos(arch_emple_bin) - 1);
        write(arch_emple_bin, otroE);
        writeln('edad aumentada con exito.');
    end
    else
        writeln('NO se encontro.');
    close(arch_emple_bin);
end;
// modificar edad del empleado
procedure cambiarEdades(var arch_emple_bin: arch);
var num: integer;
begin
    write('numero de empleado a sumarle un anio: '); readln(num);
    while (num <> 0) do begin
        detalleMaestro(arch_emple_bin, num);
        write('numero de empleado a sumarle un anio: '); readln(num);
    end;
end;


// crear un archivo de txt desde un binario con todos los empleados (c)
procedure exportar(var arch_emple_bin: arch; var arch_emple_text: text);
var e: empleado;
begin
    reset(arch_emple_bin);

    assign(arch_emple_text, 'todos_empleados.txt');
    rewrite(arch_emple_text);
 
    while not eof(arch_emple_bin) do begin
        read(arch_emple_bin, e);
        writeln(arch_emple_text, e.numero_emple, ' ', e.edad, ' ', e.dni);
        writeln(arch_emple_text, e.nombre);
        writeln(arch_emple_text, e.apellido);
    end;
    close(arch_emple_bin);
    close(arch_emple_text);
end;


// crear un archivo de txt desde un binario con los dni 00 (d)
procedure exportar_dni_00(var arch_emple_bin: arch; var arch_emple_text: text);
var e: empleado;
begin
    reset(arch_emple_bin);

    assign(arch_emple_text, 'falta_DNI_empleado.txt');
    rewrite(arch_emple_text);
 
    while not eof(arch_emple_bin) do begin
        read(arch_emple_bin, e);
        if (e.dni = 00) then begin
            writeln(arch_emple_text, ' ', e.numero_emple, ' ', e.edad, ' ', e.dni);
            writeln(arch_emple_text, e.nombre);
            writeln(arch_emple_text, e.apellido);
        end;
    end;
    close(arch_emple_bin);
    close(arch_emple_text);
end;


// punto 1 <-----------------------------
procedure leer(var archivo: arch; var dato: empleado);
begin
    if not eof(archivo) then
        read(archivo, dato)
    else
        dato.numero_emple:= valor_alto;
end;
// eliminar un empleado del archivo
procedure baja_fisica(var archivo: arch; num: integer);
var
    e: empleado;
    ok: boolean;
    ultimo_reg: empleado;
begin
    reset(archivo);

    seek(archivo, fileSize(archivo) - 1);
    read(archivo, ultimo_reg);
    // veo si el ultimo reg es que que hay que eliminar, si no, lo busco
    if ultimo_reg.numero_emple = num then begin
        seek(archivo, filePos(archivo) - 1); // retrocedo una pos y
        write(archivo, ultimo_reg);          // escribo el ultimo reg en la pos

        seek(archivo, fileSize(archivo) - 1);// voy a la ultima posicion y pongo
        truncate(archivo);                   // la marca de eof en el ultimo reg
        writeln('registro eliminado con exito.');
    end
    else begin
        seek(archivo, 0);
        leer(archivo, e);
        while (e.numero_emple <> valor_alto) and (e.numero_emple <> num) do
            leer(archivo, e);

        if (e.numero_emple <> valor_alto) and (e.numero_emple = num) then begin
            seek(archivo, filePos(archivo) - 1); // retrocedo una pos y
            write(archivo, ultimo_reg);          // escribo el ultimo reg en la pos

            seek(archivo, fileSize(archivo) - 1);// voy a la ultima posicion y pongo
            truncate(archivo);                   // la marca de eof en el ultimo reg
            writeln('registro eliminado con exito.');
        end
        else
            writeln('no se encontro el numero de empleado: ', num);
    end;

    close(archivo);
end;
// solicitar el empleado o los empleados que se quieren eliminar
procedure baja_fisica_truncando(var archivo: arch);
var num: integer;
begin
    write('numero de empleado a eliminar: '); readln(num);
    while (num <> 0) do begin
        baja_fisica(archivo, num);
        write('numero de empleado a eliminar: '); readln(num);
    end;
end;


var
    arch_emple_bin: arch;
    opcion: integer;
    arch_emple_text: text;
BEGIN
    assign(arch_emple_text, 'empleados.txt');
    assign(arch_emple_bin, 'empleados.dat');

    repeat
        writeln('--> Opciones para elegir <--');
        writeln('1. importar archivo de texto a binario.');
        writeln('2. Imprimir todos los empleados.');
        writeln('3. Imprimir los de mas de 70.');
        writeln('');
        writeln('4. Agregar uno o mas empleados.');
        writeln('5. Cambiar edades de empleados.');
        writeln('6. exportar los datos a todos_empleados.txt');
        writeln('7. exportar los empleados con DNI 00');
        writeln('');
        writeln('8. eliminar un empleado');
        writeln('');
        writeln('0. salir');
        writeln('*******************************************************');
        readln(opcion);
        case opcion of
            1: importar(arch_emple_bin, arch_emple_text);
            2: imprimirTodo(arch_emple_bin);
            3: impLosMayores70(arch_emple_bin);

            4: agregar(arch_emple_bin);
            5: cambiarEdades(arch_emple_bin);
            6: exportar(arch_emple_bin, arch_emple_text);
            7: exportar_dni_00(arch_emple_bin, arch_emple_text);

            8: baja_fisica_truncando(arch_emple_bin);
        else
            writeln('opcion incorrecta, vuelve a intentar');
        end;
    until(opcion = 0);
END.
