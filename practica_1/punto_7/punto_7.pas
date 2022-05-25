program punto7;

type
novela = record
    codigo: integer;
    precio: real;
    genero: String[20];
    nombre: String[30];
end;

archivo = file of novela;


// crear el archivo de texto que pide el ejercicio
procedure generarGenero(var genero: String);
var num: integer;
begin
    num:= random(5);
    case num of
        0: genero:= 'terror';
        1: genero:= 'amor';
        2: genero:= 'ciencia ficcion';
        3: genero:= 'epicas';
        4: genero:= 'trilers';
    end;
end;
procedure generarNombre(var nombre: String);
var num: integer;
begin
    num:= random(6);
    case num of
        0: nombre:= 'matrix';
        1: nombre:= 'piratas del caribe';
        2: nombre:= 'the lord of the rings';
        3: nombre:= 'ñarña';
        4: nombre:= 'interstellar';
        5: nombre:= 'star wars';
    end;
end;
procedure leerRandom(var n: novela; i: integer);
var
    nom: String;
begin
    with n do begin
        codigo:= i;
        precio:= random(60);
        generarGenero(nom);
        genero:= nom;
        generarNombre(nom);
        nombre:= nom;
    end;
end;
procedure cargar(var archTexto: text);
var
    n: novela;
    i: integer;
begin
    rewrite(archTexto);

    randomize;
    for i:= 1 to 10 do begin
        leerRandom(n, i);
        writeln(archTexto, n.codigo, ' ', n.precio:2:2);
        writeln(archTexto, n.genero);
        writeln(archTexto, n.nombre);
    end;
    close(archTexto);
end; // fin de creacion del archivo de texto


procedure leerDeArchTexto(var arch_bin: archivo; var arch_text: text);
var
    n: novela;
begin
    reset(arch_text);
    rewrite(arch_bin);

    while not eof(arch_text) do begin
        readln(arch_text, n.codigo, n.precio);
        readln(arch_text, n.genero);
        readln(arch_text, n.nombre);
        write(arch_bin, n);
    end;
    close(arch_text);
    close(arch_bin);
end;


procedure agregar(var arch_bin: archivo);
var
    n: novela;
begin
    reset(arch_bin);

    writeln('Novelas a agregar, hasta una novela con codigo 0.');
    write('codigo: ');
    readln(n.codigo);
    while (n.codigo <> 0) do begin
        write('precio: '); readln(n.precio);
        write('genero: '); readln(n.genero);
        write('nombre: '); readln(n.nombre);

        seek(arch_bin, fileSize(arch_bin));
        write(arch_bin, n);

        write('codigo: ');
        readln(n.codigo);
    end;
    reset(arch_bin);
end;


procedure leer(var arch: archivo; var dato: novela);
begin
    if not eof(arch) then
        read(arch, dato)
    else
        dato.codigo:= 999;
end;
procedure modificar(var arch_bin: archivo);
var
    n: novela;
    codigoModif: integer;
    precioNuevo: real;
begin
    reset(arch_bin);

    write('codigo: '); readln(codigoModif);
    write('nuevo precio: '); readln(precioNuevo);

    leer(arch_bin, n);
    while (n.codigo <> 999) and (n.codigo <> codigoModif) do
        leer(arch_bin, n);        
    
    if (n.codigo <> 999) then begin
        n.precio:= precioNuevo;
        seek(arch_bin, filePos(arch_bin) -1);
        write(arch_bin, n);
    end
    else
        writeln('el codigo no se encontro.');

    close(arch_bin);
end;


procedure exportarATexto(var arch_bin: archivo; var arch_text: text);
var
    n: novela;
begin
    reset(arch_bin);
    rewrite(arch_text);

    while not eof(arch_bin) do begin
        read(arch_bin, n);
        writeln(arch_text, n.codigo, ' ', n.precio:2:2);
        writeln(arch_text, n.genero);
        writeln(arch_text, n.nombre);
    end;
    close(arch_bin);
    close(arch_text);
end;


var
    arch_bin: archivo;
    arch_text: text;
    opcion: integer;
BEGIN
    assign(arch_bin, 'novelasBin.dat');
    assign(arch_text, 'novelasText.txt');
    cargar(arch_text);

    repeat
        writeln('--> Opciones para elegir <--');
        writeln('1. crear un archivo bin a partir de la info de novelas.txt');
        writeln('2. agregar una novela');
        writeln('3. modificar una novela');
        writeln('4. exportar a texto las novelas nuevas/modificadas');
        writeln('0. salir');
        writeln('*******************************************************');
        readln(opcion);
        case opcion of
            1: leerDeArchTexto(arch_bin, arch_text);
            2: agregar(arch_bin);
            3: modificar(arch_bin);
            4: exportarATexto(arch_bin, arch_text);
        else
            writeln('opcion incorrecta, vuelve a intentar');
        end;
    until(opcion = 0);
END.
