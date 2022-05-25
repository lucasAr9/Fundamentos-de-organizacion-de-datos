program punto_7;

const
valor_alto = 999

type
ave = record
    codigo: integer;
    nombre_especie: String[20];
    familia_de_ave: String[20];
    descripcion: String[20];
    zona_geografica: String[20];
end;

bin = file of ave;


procedure leer(var archivo: bin; var dato: ave);
begin
    if not eof(archivo) then
        read(archivo, dato)
    else
        dato.codigo:= valor_alto;
end;


procedure texto_a_binario(var arch_text: text; var arch_bin: bin);
var a: ave;
begin
    assign(arch_text, 'aves.txt');
    reset(arch_text);
    rewrite(arch_bin);

    while not eof(arch_text) do begin
        with a do begin
            readln(arch_text, codigo);
            readln(arch_text, nombre_especie);
            readln(arch_text, familia_de_ave);
            readln(arch_text, descripcion);
            readln(arch_text, zona_geografica);
        end;
        write(arch_bin, a);
    end;

    close(arch_text);
    close(arch_bin);
end;


procedure marcar_registros(params);
begin
    
end;


procedure compactar_arch();
begin
    
end;


var

BEGIN

END.
