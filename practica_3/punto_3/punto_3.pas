program punto_3;

uses crt;

const
valor_alto = 999;

type
novela = record
    codigo: integer;
    duracion: real;
    precio: real;
    genero: String[20];
    nombre: String[20];
    director: String[20];
end;

arch = file of novela;


// leer el archivo de texto de novelas y pasarlo a archivo binario
procedure importar_de_text(var arch_bin: arch; var arch_text: text);
var n: novela;
begin
    reset(arch_text);
    rewrite(arch_bin);

    while not eof(arch_text) do begin
        with n do begin
            readln(arch_text, codigo, duracion, precio);
            readln(arch_text, genero);
            readln(arch_text, nombre);
            readln(arch_text, director);
        end;
        write(arch_bin, n);
    end;

    close(arch_text);
    close(arch_bin);
end;


procedure leer(var archivo: arch; var dato: novela);
begin
    if not eof(archivo) then
        read(archivo, dato)
    else
        dato.codigo:= valor_alto;
end;


// pedir los datos de las novelas hasta la novela 0
procedure pedir_datos(var n: novela);
begin
    with n do begin
        write('codigo: '); readln(codigo);
        if codigo <> 0 then begin
            duracion:= random(120) + 30;
            precio:= random(200) + 100;
            writeln('duracion: ', duracion:2:2, 'precio: ', precio:2:2);
            nombre:= 'un nombre';
            director:= 'un director';
        end;
    end;
end;
// agregar novelas al archivo binario
procedure alta(var arch_bin: arch);
var n, indice: novela;
begin
    reset(arch_bin);
    seek(arch_bin, 0);
    randomize;

    leer(arch_bin, n); // leo la primera posicion
    if n.codigo < 0 then begin // si el codigo es negativo
        seek(arch_bin, abs(n.codigo)); // voy a esa posicion (positiva)
        read(arch_bin, indice);        // leo esa posicion y
        seek(arch_bin, filePos(arch_bin) -1); // retrocedo para
        pedir_datos(n);
        write(arch_bin, n); // escribir los nuevos datos
        seek(arch_bin, 0);  // vuelvo a la primera posicion y
        write(arch_bin, indice); // escribo en la pos 0 el proximo lugar vasio
    end
    else begin
        seek(arch_bin, fileSize(arch_bin));
        pedir_datos(n);
        write(arch_bin, n);
    end;

    close(arch_bin);
end;


// eliminar la novela que ingrese por teclado
procedure baja(var arch_bin: arch);
var
    n, indice: novela;
    numero: integer;
    ok: boolean;
begin
    reset(arch_bin);
    ok:= false;
    write('codigo de novela a eliminar: '); readln(numero);
    seek(arch_bin, 0);

    leer(arch_bin, indice);
    leer(arch_bin, n);
    while (n.codigo <> valor_alto) and not(ok) do begin
        if (n.codigo = numero) then begin
            ok:= true;
            n.codigo:= indice.codigo;
            seek(arch_bin, filePos(arch_bin) -1);
            indice.codigo:= filePos(arch_bin) * (-1);
            write(arch_bin, n);
            seek(arch_bin, 0);
            write(arch_bin, indice);
        end
        else
            leer(arch_bin, n);
    end;
	if (ok) then 
		writeln('REGISTRO ELIMINADA')
	else
		writeln('NO SE ENCONTRO EL REGISTRO');

    close(arch_bin);
end;


// exportar el archivo binario a un txt para ver resultados
procedure exportar(var arch_bin: arch; var arch_text: text);
var n: novela;
begin
    reset(arch_bin);
    assign(arch_text, 'nuevo_novelas.txt');
    rewrite(arch_text);

    while not eof(arch_bin) do begin
        read(arch_bin, n);
        with n do begin
            writeln(arch_text, codigo, ' ', duracion:2:2, ' ', precio:2:2);
            writeln(arch_text, genero);
            writeln(arch_text, nombre);
            writeln(arch_text, director);
        end;
    end;

    close(arch_bin);
    close(arch_text);
end;


var
    arch_bin: arch;
    arch_text: text;
    opcion: integer;
BEGIN
    textcolor(green);
    assign(arch_bin, 'novelas.dat');
    assign(arch_text, 'novelas.txt');
    importar_de_text(arch_bin, arch_text);

    repeat
        writeln('');
        writeln('--> Opciones para elegir <--');
        writeln('1. agregar novelas al archivo.');
        writeln('2. eliminar novelas del archivo.');
        writeln('3. exportar a texto.');
        writeln('');
        writeln('0. salir');
        writeln('*******************************************************');
        readln(opcion);
        case opcion of
            1: alta(arch_bin);
            2: baja(arch_bin);
            3: exportar(arch_bin, arch_text);
        else
            writeln('opcion incorrecta, vuelve a intentar');
        end;
    until(opcion = 0);
END.
