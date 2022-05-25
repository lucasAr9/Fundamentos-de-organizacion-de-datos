{ crear un archivo binario }
program crear_Archivo;

type
archivo = file of integer; { definición del tipo de dato para el archivo }

procedure escribirArchivo(var arc_logico: archivo);
var
    num: integer;
begin
    rewrite(arc_logico); { se crea el archivo }

    writeln('Ingrese los numeros:');

    read(num); { se obtiene de teclado el primer valor }
    while (num <> 0) do begin
        write(arc_logico, num); { se escribe en el archivo cada número }
        read(num);
    end;
end;

procedure leerArchivo(var arc_logico: archivo);
var
    nro: integer;  { para leer elemento del archivo que es de tipo entero }
begin
    reset(arc_logico); { archivo ya creado, para operar debe abrirse como de lectura/escritura } 
    while not eof(arc_logico) do begin
        read(arc_logico, nro);   { se obtiene elemento desde archivo }
        write(nro, ', ');        { se presenta cada valor en pantalla }
    end;
end;

var
    arc_logico: archivo;    { variable que define el nombre lógico del archivo }
BEGIN
    assign(arc_logico, 'eje1.dat');

    escribirArchivo(arc_logico);
    leerArchivo(arc_logico);

    close( arc_logico );{ se cierra el archivo abierto oportunamente con la instrucción rewrite }
END. 




{ crear un archivo de texto }
procedure leerDeArchTexto(var arch_binario: archivo; var arch_texto: text);
var
    c: celulares;
begin
    reset(arch_texto);
    rewrite(arch_binario);

    while not eof(arch_texto) do begin
        readln(arch_texto, c.codigo, c.stock);
        readln(arch_texto, c.marca);
        readln(arch_texto, c.nombre);
        write(arch_binario, c);
    end;
    close(arch_binario);
    close(arch_texto);
end;

procedure cargarArchTexto(var arch_texto: text);
var
    c: celulares;
begin
    rewrite(arch_texto);

    leerRegistro(c, i);
    while (c.cidugo <> 0) do begin
        writeln(arch_texto, c.codigo, ' ', c.stock);
        writeln(arch_texto, c.marca);
        writeln(arch_texto, c.nombre);
        leerRegistro(c, i);
    end;
    close(arch_texto);
end;

var
    arch_binario: arch;
    arch_texto: text;
BEGIN
    assign(arch_binario, 'arch_binario.dat')
    assign(arch_texto, 'arch_texto.txt')

    cargarArchTexto(arch_texto);
    leerDeArchTexto(arch_binario, arch_texto);
END.
