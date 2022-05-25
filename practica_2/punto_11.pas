program punto_11;

const
valor_alto = 'zzz';

type
datos = record
    nombre_prov: String[20];
    cant_personas_al: integer;
    total_encuestado: integer;
end;

datos_det = record
    nombre_prov: String[20];
    codigo_localidad: integer;
    cant_personas_al: integer;
    total_encuestado: integer;
end;

archivo_bin = file of datos;


procedure leer_maestro(var arch_bin: archivo_bin; var arch_text: text);
var
    r: datos;
begin
    while not eof(arch_text) do begin
        with r do begin
            readln(arch_text, nombre_prov);
            readln(arch_text, cant_personas_al, ' ', total_encuestado);
        end;
        write(arch_bin, r);
    end;
end;

procedure escribir_texto(var arch_bin: archivo_bin; var arch_text: text);
var
    r: datos;
begin
    while not eof(arch_bin) do begin
        read(arch_bin, r);
        with r do begin
            writeln(arch_text, nombre_prov);
            writeln(arch_text, cant_personas_al, ' ', total_encuestado);
        end;
    end;
end;

procedure leer(var archivo: text; var dato: datos_det);
begin
    if not eof() then begin
        with dato do begin
            readln(archivo, nombre_prov);
            readln(archivo, codigo_localidad, cant_personas_al, total_encuestado);
        end;
    end
    else
        dato.nombre_prov:= valor_alto;
end;


procedure minimo(var arch_detalle1, arch_detalle2: text;
                 var r1, r2, min: datos_det);
begin
    if (r1.nombre_prov <= r2.nombre_prov) then begin
        min:= r1;
        leer(arch_detalle1, r1);
    end
    else
        min:= r2;
        leer(arch_detalle2, r2);
end;


var
    arch_maestro_bin: archivo_bin;
    arch_maestro_text: text;
    reg_mae: datos;
    arch_detalle1, arch_detalle2: text;
    r1, r2, min: datos_det;
BEGIN
    assign(arch_maestro_text, 'alfabetizacion.txt');
    assign(arch_maestro_text, 'binario.dat');
    assign(arch_detalle1, 'detalle1.txt');
    assign(arch_detalle2, 'detalle2.txt');

    reset(arch_maestro_text);
    rewrite(arch_maestro_bin);
    reset(arch_detalle1);
    reset(arch_detalle2);

    leer_maestro(arch_maestro_bin, arch_maestro_text);

    leer(arch_detalle1, r1);
    leer(arch_detalle2, r2);
    minimo(arch_detalle1, arch_detalle2, r1, r2, min);

    while (min.nombre_prov <> valor_alto) do begin
        read(arch_maestro_bin, reg_mae);

        while (min.nombre_prov <> reg_mae.nombre_prov) do
            read(arch_maestro_bin, reg_mae);

        while (min.nombre_prov = reg_mae.nombre_prov) do begin
            while reg_mae do begin
                cant_personas_al:= cant_personas_al + min.cant_personas_al;
                total_encuestado:= total_encuestado + min.total_encuestado;
            end;
            minimo(arch_detalle1, arch_detalle2, r1, r2, min);
        end;

        seek(arch_maestro_bin, filePos(arch_maestro_bin) -1);
        write(arch_maestro_bin, reg_mae);
    end;

    escribir_texto(arch_maestro_bin, arch_maestro_text);

    close(arch_maestro_text);
    close(arch_maestro_bin);
    close(arch_detalle1);
    close(arch_detalle2);
END.
