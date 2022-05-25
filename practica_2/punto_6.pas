program punto_6;

const
valor_alto = 999;
dimF = 10;

type
reg_municipio = record
    cod_localidad: integer;
    cod_cepa: integer;
    cant_casos_activos: integer;
    cant_casos_nuevos: integer;
    cant_casos_recupera: integer;
    cant_casos_fallecidos: integer;
end;

reg_maestro = record
    cod_localidad: integer;
    nombre_localidad: String[20];
    cod_cepa: integer;
    nombre_cepa: String[20];
    cant_casos_activos: integer;
    cant_casos_nuevos: integer;
    cant_casos_recupera: integer;
    cant_casos_fallecidos: integer;
end;

vec_detalle_reg = array [1..dimF] of reg_municipio;

vec_detalles_texto = array [1..dimF] of text;

detalle_bin = file of reg_municipio;

maestro_bin = file of reg_maestro;


// merge de los detalles y guardarlo en un .dat
procedure leer_texto(var archivo: text; var dato: reg_municipio);
begin
    if (not eof( archivo )) then
        with dato do begin
            readln(archivo, cod_localidad,
                    ' ', cod_cepa, cant_casos_activos,
                    ' ', cant_casos_nuevos,
                    ' ', cant_casos_recupera,
                    ' ', cant_casos_fallecidos);
        end;
    else
        dato.cod_localidad:= valor_alto;
end;

procedure minimo(var min: reg_municipio; var reg: vec_detalle_reg;
                                        var arch: vec_detalles_texto);
var
    i, pos: integer;
begin
    pos:= -1;
    min.cod_localidad:= valor_alto;
    // busco y guardo el minimo en la variable min
    for i:= 1 to dimF do begin
        if (reg[i].cod_localidad <> valor_alto) then begin
            if (min.cod_localidad >= reg[i].cod_localidad) then begin
                min:= reg[i];
                pos:= i;
            end;
        end;
    end;
    // actualizar el vector de registros leyendo el vec de archivos
    if (pos <> -1) then
        leer_texto(arch[pos] reg[pos]);
end;

procedure merge_detalles(var arch_detalle_texto: vec_detalles_texto;
        var arch_detalle_bin: detalle_bin; var reg_detalle: vec_detalle_reg);
var
    min: reg_municipio;
    i: integer;
    reg_actual: reg_maestro;
begin
    for i:= 1 to dimF do
        leer_texto(arch_detalle_texto[i], reg_detalle[i]);
    
    minimo(min, reg_detalle, arch_detalle_texto);

    while (min.cod_localidad <> valor_alto) do begin
        with reg_actual do begin
            cod_localidad:= min.cod_localidad;
            cant_casos_activos:= 0;
            cant_casos_nuevos:= 0;
            cant_casos_recupera:= 0;
            cant_casos_fallecidos:= 0;
        end;
        while (reg_actual.cod_localidad = min.cod_localidad) do begin
            reg_actual.cod_cepa:= min.cod_cepa;

            while (reg_actual.cod_localidad = min.cod_localidad)
                    and (reg_actual.cod_cepa = min.cod_cepa) do begin
                with reg_actual do begin
                    cant_casos_activos:= cant_casos_activos + min.cant_casos_activos;
                    cant_casos_nuevos:= cant_casos_nuevos + min.cant_casos_nuevos;
                    cant_casos_recupera:= cant_casos_recupera + min.cant_casos_recupera;
                    cant_casos_fallecidos:= cant_casos_fallecidos + min.cant_casos_fallecidos;
                end;
                minimo(min, reg_detalle, arch_detalle_texto);
            end;
            seek(arch_detalle_bin, filePos(arch_detalle_bin) -1);
            write(arch_detalle_bin, reg_actual);
        end;
    end;
end;


// actualizar el archivo maestro binario con el detalle mergeado binario
procedure leer_bin(var archivo: detalle_bin; var dato: reg_municipio);
begin
    if (not eof(archivo)) then
        read(archivo, dato)
    else
        dato.cod_localidad:= valor_alto;
end;

procedure actualizar_maestro(var arch_maestro_bin: maestro_bin;
                             var arch_detalle_bin: detalle_bin;);
var
    reg_mae: reg_maestro;
    reg_det: reg_municipio;
begin
    leer(arch_detalle_bin, reg_det);

    while not eof(arch_detalle_bin) do begin
        read(arch_maestro_bin, reg_mae);

        while (reg_mae.cod_localidad <> reg_det.cod_localidad)
                and (reg_mae.cod_cepa <> reg_det.cod_cepa) do
            read(arch_maestro_bin, reg_mae);

        while (reg_mae.cod_localidad = reg_det.cod_localidad)
                and (reg_mae.cod_cepa <> reg_det.cod_cepa) do begin
            with reg_mae do begin
                cant_casos_activos:= cant_casos_activos + reg_det.cant_casos_activos;
                cant_casos_activos:= cant_casos_nuevos + reg_det.cant_casos_nuevos;
                cant_casos_activos:= cant_casos_recupera + reg_det.cant_casos_recupera;
                cant_casos_activos:= cant_casos_fallecidos + reg_det.cant_casos_fallecidos;
            end;
            leer(arch_detalle_bin, reg_det);
        end;
        seek(arch_maestro_bin, filePos(arch_maestro_bin) -1);
        write(arch_maestro_bin, reg_mae);
    end;
end;


// exportar los resultados de la actualizacion del maestro en un .txt
procedure exportar_a_texto(var arch_texto: text; var arch_bin: maestro_bin;
                                                    var reg: reg_maestro);
begin
    while not eof(arch_bin) do begin
        read(arch_bin, reg_maestro);
        with reg do begin
            writeln(arch_texto, cod_localidad, ' ', nombre_localidad);
            writeln(arch_texto, cod_cepa, ' ', nombre_cepa);
            writeln(arch_texto, cant_casos_activos, ' ', cant_casos_nuevos, ' ',
                                cant_casos_recupera, ' ', cant_casos_fallecidos);
        end;
    end;
end;


var
    reg_detalle: vec_detalle_reg;
    arch_detalle_texto: vec_detalles_texto;
    arch_detalle_bin: detalle_bin;

    el_reg_maestro: reg_maestro;
    arch_maestro_texto: text;
    arch_maestro_bin: maestro_bin;

    convertir: String;
    i: integer;
BEGIN
    // asignar el nombre logico con los archivos de texto
    for i:= 1 to dimF do begin
        str(i, convertir);
        assign(arch_detalle_texto[i], 'detalle_' + convertir + '.txt');
        reset(arch_detalle_texto[i]);
    end;
    assign(arch_maestro_texto, 'archivo_maestro.txt');

    // punto_6;
    // leer el maestro.txt y crear el maestro.dat
    assign(arch_maestro_bin, 'maestro_bin.dat');
    rewrite(arch_maestro_bin);
    leer_maestro(arch_maestro_bin, arch_maestro_texto, el_reg_maestro);

    // leer y hacer el merge entre los detalles y guardar el merge en un .dat
    merge_detalles(arch_detalle_texto, arch_detalle_bin, reg_detalle);

    // actualizar el archivo maestro binario con el detalle mergeado binario
    actualizar_maestro(arch_maestro_bin, arch_detalle_bin);

    // exportar los resultados de la actualizacion del maestro en un .txt
    exportar_a_texto(arch_maestro_texto, arch_maestro_bin, el_reg_maestro);

    // cerrar los archivos detalles y maestro
    for i:= 1 to dimF do
        close(arch_detalle_texto[i]);
    close(arch_maestro_texto);
    close(arch_detalle_bin);
    close(arch_maestro_bin);
END.
