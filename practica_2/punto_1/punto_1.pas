program punto_1;

const
valor_alto = 999;

type
empleado = record
    codigo_emple: integer;
    monto_comision: integer;
    nombre: String[30];
end;

archivo_binario = file of empleado;


procedure leer_arch_texto(var arch_bin: archivo_binario; var arch_text: text);
var
    e: empleado;
begin
    rewrite(arch_bin);
    reset(arch_text);

    while not eof(arch_text) do begin
        readln(arch_text, e.codigo_emple, e.monto_comision);
        readln(arch_text, e.nombre);
        write(arch_bin, e);
    end;
    close(arch_bin);
    close(arch_text);
end;


procedure leer(var arch_bin: archivo_binario; var dato: empleado);
begin
    if not eof(arch_bin) then
        read(arch_bin, dato)
    else
        dato.codigo_emple:= valor_alto;
end;


procedure corte_de_control(var arch_bin: archivo_binario; var nue_tex: text);
var
    e: empleado;
    cod_actual: integer;
    nom_actual: String[30];
    monto_total: integer;
begin
    reset(arch_bin);
    rewrite(nue_tex);

    leer(arch_bin, e);
    while (e.codigo_emple <> valor_alto) do begin
        cod_actual:= e.codigo_emple;
        nom_actual:= e.nombre;
        monto_total:= 0;
        while (e.codigo_emple = cod_actual) do begin
            monto_total:= monto_total + e.monto_comision;
            leer(arch_bin, e);
        end;
        // guardar en archivo de texto
        writeln(nue_tex, cod_actual, ' ', monto_total);
        writeln(nue_tex, nom_actual);
    end;

    close(arch_bin);
    close(nue_tex);
end;


var
    arch_text: text;
    arch_bin: archivo_binario;
    nuevo_text: text;
BEGIN
    assign(arch_text, 'emple.txt');
    assign(arch_bin, 'emple_bin.dat');
    assign(nuevo_text, 'emple_sin_repe.txt');

    leer_arch_texto(arch_bin, arch_text);
    corte_de_control(arch_bin, nuevo_text);
END.
