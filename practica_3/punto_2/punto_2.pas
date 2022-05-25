program punto_2;

const
valor_alto = 999;

type
asistente = record
    nro_asistente: integer;
    dni: integer;
    nombre: String[20];
    apellido: String[20];
    email: String[20];
end;

archivo = file of asistente;


procedure leer(var archivo: archivo; var dato: asistente);
begin
    if not eof(archivo) then
        read(archivo, dato)
    else
        dato.nro_asistente:= valor_alto;
end;


procedure datos(var reg: asistente);
begin
    write('numero de asistente: '); readln(reg.nro_asistente);
    if reg.nro_asistente <> 0 then begin
        write('numero de DNI: '); readln(reg.dni);
        write('nombre: '); readln(reg.nombre);
        write('apellido: '); readln(reg.apellido);
        reg.email:= reg.nombre + reg.apellido + '@gmail.com'
    end;    
end;

procedure agregar_asistentes(var arch: archivo);
var
    reg: asistente;
begin
    rewrite(arch);

    datos(reg);
    while reg.nro_asistente <> 0 do begin
        write(arch, reg);
        datos(reg);
    end;

    close(arch);
end;


procedure eliminar_asistentes(var arch: archivo; num: integer);
var
    reg: asistente;
begin
    reset(arch);

    leer(arch, reg);
    while reg.nro_asistente <> valor_alto do begin

        if reg.nro_asistente <= num then begin
            reg.nombre:= '@';
            seek(arch, filePos(arch) -1);
            write(arch, reg);
        end;

        leer(arch, reg);
    end;

    close(arch);
end;


procedure imprimir_todos(var arch: archivo);
var reg: asistente;
begin
    reset(arch);
    while not eof(arch) do begin
        leer(arch, reg);
            writeln('nro_asistente: ', reg.nro_asistente, 'dni: ', reg.dni,
                    'nombre : ', reg.nombre, 'apellido : ', reg.apellido,
                    'email : ', reg.email);
            writeln();
    end;
    close(arch);
end;


procedure imprimir(var arch: archivo);
var reg: asistente;
begin
    reset(arch);
    while not eof(arch) do begin
        leer(arch, reg);
        if reg.nombre <> '@' then begin
            writeln('nro_asistente: ', reg.nro_asistente, 'dni: ', reg.dni,
                    'nombre : ', reg.nombre, 'apellido : ', reg.apellido,
                    'email : ', reg.email);
            writeln();
        end;
    end;
    close(arch);
end;


var
    arch_bin: archivo;
BEGIN
    assign(arch_bin, 'asistentes.dat');
    agregar_asistentes(arch_bin);
    eliminar_asistentes(arch_bin, 1000);

    writeln('------------imprimir todos los registros------------');
    imprimir_todos(arch_bin);
    writeln('------------------------imprimir------------------------');
    imprimir(arch_bin);
END.
