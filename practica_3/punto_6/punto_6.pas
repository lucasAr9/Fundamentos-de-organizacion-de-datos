program punto_6;

const
valor_alto = 999;

type
prenda = record
    codigo: integer;
    stock: integer;
    precio_unidad: real;
    descripcion: String[20];
    colores: String[20];
    tipo_prenda: String[20];
end;

bin = file of prenda;


procedure leer(var arch_bin: bin; var dato: prenda);
begin
    if not eof(arch_bin) then
        read(arch_bin, dato)
    else
        dato.codigo:= valor_alto;
end;


procedure texto_a_binario(var arch_text: text; var arch_bin: bin);
var p: prenda;
begin
    assign(arch_text, 'prendas.txt');
    reset(arch_text);
    rewrite(arch_bin);

    while not eof(arch_text) do begin
        with p do begin
            readln(arch_text, codigo, stock, precio_unidad);
            readln(arch_text, descripcion);
            readln(arch_text, colores);
            readln(arch_text, tipo_prenda);
        end;
        write(arch_bin, p);
    end;

    close(arch_text);
    close(arch_bin);
end;


procedure binario_a_texto(var arch_bin: bin; var arch_text: text);
var p: prenda;
begin
    assign(arch_text, 'prendas_actualizadas.txt');
    reset(arch_bin);
    rewrite(arch_text);

    while not eof(arch_bin) do begin
        read(arch_bin, p);
        with p do begin
            if p.stock <> -1 then begin
                writeln(arch_text, codigo, ' ', stock, ' ', precio_unidad:2:2);
                writeln(arch_text, descripcion);
                writeln(arch_text, colores);
                writeln(arch_text, tipo_prenda);
            end;
        end;
    end;

    close(arch_bin);
    close(arch_text);
end;


procedure leer_codigos(var arch: text; var dato: integer);
begin
    if not eof(arch) then
        readln(arch, dato)
    else
        dato:= valor_alto;
end;

procedure bajas(var arch_bin: bin; var arch_cod: text);
var
    p: prenda;
    cod: integer;
begin
    reset(arch_bin);
    reset(arch_cod);

    leer_codigos(arch_cod, cod);  // leer archivo de texto con codigos a eliminar

    while (cod <> valor_alto) do begin
        seek(arch_bin, 0);
        read(arch_bin, p);

        while (p.codigo <> cod) do
            read(arch_bin, p);
        
        p.stock:= -1;

        seek(arch_bin, filePos(arch_bin) -1);
        write(arch_bin, p);

        leer_codigos(arch_cod, cod);  // leer archivo de texto con codigos a eliminar
    end;

    close(arch_bin);
    close(arch_cod);
end;


var
    arch_text: text;
    arch_bin: bin;
    arch_cod: text;
BEGIN
    assign(arch_bin, 'prendas.dat');
    assign(arch_cod, 'prendas_obsoletas.txt');

    texto_a_binario(arch_text, arch_bin);
    bajas(arch_bin, arch_cod);
    binario_a_texto(arch_bin, arch_text);
END.
