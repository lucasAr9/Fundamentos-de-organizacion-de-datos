program punto5;

type
celulares = record
    codigo: integer;
    stock: integer;
    marca: String;
    nombre: String;
end;

archivo = file of celulares;


// crear el archivo de texto celulares.txt que pide el ejercicio inciso a)
procedure generarMarcaRandom(var marc: String);
var num: integer;
begin
    num:= random(4);
    case num of
        0: marc:= 'samsung';
        1: marc:= 'huawei';
        2: marc:= 'motorola';
        3: marc:= 'iphone';
    end;
end;
procedure generarMarcaRandom2(var marc: String);
var num: integer;
begin
    num:= random(5);
    case num of
        0: marc:= 'smartphone';
        1: marc:= 'xiaomi';
        2: marc:= 'apple x 256';
        3: marc:= 'moto g60';
        4: marc:= 'galaxt a32';
    end;
end;
procedure leerRandom(var c: celulares; i: integer);
var
    nom: String;
begin
    with c do begin
        codigo:= i;
        stock:= random(60);
        generarMarcaRandom(nom);
        marca:= nom;
        generarMarcaRandom2(nom);
        nombre:= nom;
    end;
end;
procedure cargar(var archTexto: text);
var
    c: celulares;
    i: integer;
begin
    rewrite(archTexto);

    randomize;
    for i:= 1 to 10 do begin
        leerRandom(c, i);
        writeln(archTexto, c.codigo, ' ', c.stock);
        writeln(archTexto, c.marca);
        writeln(archTexto, c.nombre);
    end;
    close(archTexto);
end; // fin de creacion del archivo de texto celulares.txt


procedure leerDeArchTexto(var archBinario: archivo; var archTexto: text);
var
    c: celulares;
begin
    rewrite(archBinario);
    reset(archTexto);

    while not eof(archTexto) do begin
        readln(archTexto, c.codigo, c.stock);
        readln(archTexto, c.marca);
        readln(archTexto, c.nombre);
        write(archBinario, c);
    end;
    close(archBinario);
    close(archTexto);
end;


procedure stockMenor10(var archBinario: archivo; var archBinMenores: archivo);
var
    c: celulares;
begin
    rewrite(archBinMenores);
    reset(archBinario);
    writeln('');
    while not eof(archBinario) do begin
        read(archBinario, c);
        if (c.stock < 10) then begin
            writeln('*codigo: ', c.codigo, ' STOCK: ', c.stock,
                    ' marca: ', c.marca, ' nombre: ', c.nombre);
            write(archBinMenores, c);
        end;
    end;
    close(archBinario);
    close(archBinMenores);
end;


procedure crearTextConMenores10(var archBinMenores: archivo;
                                var archTextMenores: text);
var
    c: celulares;
begin
    rewrite(archTextMenores);
    reset(archBinMenores);

    while not eof(archBinMenores) do begin
        read(archBinMenores, c);
        writeln(archTextMenores, c.codigo, ' ', c.stock);
        writeln(archTextMenores, c.marca);
        writeln(archTextMenores, c.nombre);
    end;
    close(archTextMenores);
    close(archBinMenores);
end;


procedure agregarCelulare(var archBinario: archivo; var otroTexto: text);
var
    c: celulares;
begin
    reset(archBinario);
    rewrite(otroTexto);

    writeln('');
    write('codigo: '); readln(c.codigo);
    write('stock: '); readln(c.stock);
    write('marca: '); readln(c.marca);
    write('nombre: '); readln(c.nombre);
    writeln('');

    seek(archBinario, fileSize(archBinario));
    write(archBinario, c);

    seek(archBinario, 0);

    while not eof(archBinario) do begin
        read(archBinario, c);
        writeln(otroTexto, c.codigo, ' ', c.stock);
        writeln(otroTexto, c.marca);
        writeln(otroTexto, c.nombre);
    end;

    close(archBinario);
    close(otroTexto);
end;


procedure leer(var arch: archivo; var dato: celulares);
begin
    if not eof(arch) then
        read(arch, dato)
    else
        dato.codigo:= 999;
end;
procedure modificarStock(var archBinario: archivo; var otroTexto: text);
var
    c: celulares;
    cod, newStock: integer;
begin
    reset(archBinario);
    rewrite(otroTexto);

    write('codigo de celular a modificar: '); readln(cod);
    write('stock a restar: '); readln(newStock);

    // recorre el archivo binario buscando el codigo, si no, retorna valorAlto
    leer(archBinario, c);
    while (c.codigo <> 999) and (c.codigo <> cod) do
        leer(archBinario, c);

    if (c.codigo <> 999) then begin
        c.stock:= c.stock - newStock;
        seek(archBinario, filePos(archBinario) -1);
        write(archBinario, c);
    end
    else
        writeln('el codigo no se encontro.');

    // exporta el archivo binario a un archivo de texto para ver los resultados
    seek(archBinario, 0);
    while not eof(archBinario) do begin
        read(archBinario, c);
        writeln(otroTexto, c.codigo, ' ', c.stock);
        writeln(otroTexto, c.marca);
        writeln(otroTexto, c.nombre);
    end;

    close(archBinario);
    close(otroTexto);
end;


var
    archBinario, archBinMenores: archivo;
    archTexto, archTextMenores, otroTexto: text;
    opcion: integer;
BEGIN
    assign(archTexto, 'celulares Texto.txt');
    assign(archBinario, 'celulares Binario.dat');
    assign(archBinMenores, 'celularesMenores10Stock Binario.dat');
    assign(archTextMenores, 'celularesMenores10Stock Texto.txt');
    assign(otroTexto, 'otroTexto.txt');
    // cargar(archTexto);
    repeat
        writeln('--> Opciones para elegir <--');
        writeln('1. Crear un archivo de registros de celulares y cargarlo',
                'con datos ingresados desde un archivo de texto denominado',
                '“celulares.txt”.');
        writeln('2. Listar en pantalla los datos de aquellos celulares que',
                'tengan un stock menor al 10.');
        writeln('3. Exportar el archivo creado en el inciso 2) a un archivo',
                'de texto denominado “celulares.txt” con todos los celulares',
                'del mismo.');
        writeln('4. Agregar celulares desde teclado al archivo',
                '"celulares Texto.txt".');
        writeln('5. Modificar el stock de un celular dado la marca y monto.');
        writeln('0. salir');
        writeln('*******************************************************');
        readln(opcion);
        case opcion of
            1: leerDeArchTexto(archBinario, archTexto);
            2: stockMenor10(archBinario, archBinMenores);
            3: crearTextConMenores10(archBinMenores, archTextMenores);
            4: agregarCelulare(archBinario, otroTexto);
            5: modificarStock(archBinario, otroTexto);
        else
            writeln('opcion incorrecta, vuelve a intentar');
        end;
    until(opcion = 0);
END.
