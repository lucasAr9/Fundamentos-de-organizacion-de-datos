program punto_2;

const
valor_alto = 999;

type
alumno = record
    codigo: integer;
    cant_materias_ap_sinF: integer;
    cant_materias_ap_conF: integer;
    nombre: String[30];
    apellido: String[30];
end;

archivo_binario = file of alumno;


// crear el archivo de texto *maestro* que pide el ejercicio
procedure generarNombre1(var nombre: String);
var num: integer;
begin
    num:= random(5);
    case num of
        0: nombre:= 'Maria';
        1: nombre:= 'Oto';
        2: nombre:= 'Carlos';
        3: nombre:= 'Juan';
        4: nombre:= 'Jose';
    end;
end;
procedure generarNombre2(var nombre: String);
var num: integer;
begin
    num:= random(5);
    case num of
        0: nombre:= 'Hernandes';
        1: nombre:= 'Pepitos';
        2: nombre:= 'D mari';
        3: nombre:= 'Otos';
        4: nombre:= 'Misk';
    end;
end;
procedure leerRandom(var n: alumno; i: integer);
var
    nom: String;
begin
    with n do begin
        codigo:= i;
        cant_materias_ap_sinF:= random(60);
        cant_materias_ap_conF:= random(60);
        generarNombre1(nom);
        nombre:= nom;
        generarNombre2(nom);
        apellido:= nom;
    end;
end;
procedure cargar_maestro(var arch_texto_m: text);
var
    n: alumno;
    i: integer;
begin
    rewrite(arch_texto_m);

    randomize;
    for i:= 1 to 15 do begin
        leerRandom(n, i);
        writeln(arch_texto_m, n.codigo, ' ',
                n.cant_materias_ap_sinF, ' ',
                n.cant_materias_ap_conF);
        writeln(arch_texto_m, n.nombre);
        writeln(arch_texto_m, n.apellido);
    end;
    close(arch_texto_m);
end; // fin de creacion del archivo de texto *maestro*

// crear el archivo de texto *detalle* que pide el ejercicio
procedure leerOtroR(var n: alumno; i: integer);
begin
    with n do begin
        codigo:= i;
        cant_materias_ap_sinF:= random(60);
        cant_materias_ap_conF:= random(60);
    end;
end;
procedure cargar_detalle(var arch_texto_d: text);
var
    n: alumno;
    i: integer;
begin
    rewrite(arch_texto_d);

    randomize;
    for i:= 1 to 8 do begin
        leerOtroR(n, i);
        writeln(arch_texto_d, n.codigo, ' ',
                n.cant_materias_ap_sinF, ' ',
                n.cant_materias_ap_conF);
    end;
    close(arch_texto_d);
end; // fin de creacion del archivo de texto *detalle*


// llevar los datos del archivo de texto del maestro a un archivo binario
procedure leer_arch_maestro(var arch_bin_maestro: archivo_binario;
                            var arch_text_maestro: text);
var
    alu_maestro: alumno;
begin
    rewrite(arch_bin_maestro);
    reset(arch_text_maestro);
    while not eof(arch_text_maestro) do begin
        readln(arch_text_maestro, alu_maestro.codigo,
                alu_maestro.cant_materias_ap_sinF,
                alu_maestro.cant_materias_ap_conF);
        readln(arch_text_maestro, alu_maestro.nombre);
        readln(arch_text_maestro, alu_maestro.apellido);
        write(arch_bin_maestro, alu_maestro);
    end;
    close(arch_bin_maestro);
    close(arch_text_maestro);
end;


procedure leer_detalle(var arch_text: text; var a: alumno);
begin
    if not eof(arch_text) then
        readln(arch_text, a.codigo,
             a.cant_materias_ap_sinF,
             a.cant_materias_ap_conF)
    else
        a.codigo:= valor_alto;
end;


// actualizar el archivo binario del maestro
procedure maestro_detalle(var arch_bin_maestro: archivo_binario;
                            var arch_text_detalle: text);
var
    alu_maestro: alumno;
    alu_detalle: alumno;
begin
    reset(arch_bin_maestro);
    reset(arch_text_detalle);

    leer_detalle(arch_text_detalle, alu_detalle);

    while (alu_detalle.codigo <> valor_alto) do begin
        read(arch_bin_maestro, alu_maestro);

        while (alu_maestro.codigo <> alu_detalle.codigo) do
            read(arch_bin_maestro, alu_maestro);

        while (alu_maestro.codigo = alu_detalle.codigo) do begin
            alu_maestro.cant_materias_ap_sinF:= alu_maestro.cant_materias_ap_sinF + alu_detalle.cant_materias_ap_sinF;
            alu_maestro.cant_materias_ap_conF:= alu_maestro.cant_materias_ap_conF + alu_detalle.cant_materias_ap_conF;
            leer_detalle(arch_text_detalle, alu_detalle);
        end;

        seek(arch_bin_maestro, filePos(arch_bin_maestro) - 1);
        write(arch_bin_maestro, alu_maestro);
    end;

    close(arch_bin_maestro);
    close(arch_text_detalle);
end;


// escribir el archivo binario de maestro en un archivo de texto
procedure cargar_arch_maestro_actualizado(var arch_text: text;
                                   var arch_bin: archivo_binario);
var
    alu: alumno;
begin
    reset(arch_bin);
    rewrite(arch_text);

    while not eof(arch_bin) do begin
        read(arch_bin, alu);
        writeln(arch_text, alu.codigo, ' ',
                alu.cant_materias_ap_sinF, ' ',
                alu.cant_materias_ap_conF);
        writeln(arch_text, alu.nombre);
        writeln(arch_text, alu.apellido);
    end;

    close(arch_bin);
    close(arch_text);
end;


var
    arch_text_maestro: text;
    arch_text_maestro_desp: text;
    arch_text_detalle: text;
    arch_bin_maestro: archivo_binario;
BEGIN
    assign(arch_text_maestro, 'arch_text_maestro.txt');
    assign(arch_text_maestro_desp, 'arch_text_maestro_desp.txt');
    assign(arch_text_detalle, 'arch_text_detalle.txt');
    assign(arch_bin_maestro, 'arch_bin_maestro.dat');

    cargar_maestro(arch_text_maestro);
    cargar_detalle(arch_text_detalle);

    leer_arch_maestro(arch_bin_maestro, arch_text_maestro);
    maestro_detalle(arch_bin_maestro, arch_text_detalle);
    cargar_arch_maestro_actualizado(arch_text_maestro_desp, arch_bin_maestro);
END.
