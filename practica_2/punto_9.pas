program punto_9;

const
valor_alto = 999;

type
mesa = record
    codigo_provincia: integer;
    codigo_localidad: integer;
    numero_mesa: integer;
    cant_votos: integer;

end;


procedure leer(var archivo: text; var dato: reg_arch_maestro);
begin
    if not eof(archivo) then begin
        readln(archivo, dato.codigo_provincia,
                dato.codigo_localidad, numero_mesa, cant_votos);
    end
    else
        dato.cli.codigo:= valor_alto;
end;


var
    archivo: text;
    reg: mesa;
    provincia_actual, localidad_actual: integer;
    total_general, total_provincia, total_localidad: integer;
BEGIN
    assign(archivo, 'arcivo_mesas.txt');
    reset(archivo);

    leer(archivo, reg);
    total_general:= 0;

    while (reg.codigo_provincia <> valor_alto) do begin
        writeln('provincia: ', reg.codigo_provincia);
        provincia_actual:= reg.codigo_provincia;
        total_provincia:= 0;

        while (reg.codigo_provincia = provincia_actual) do begin
            writeln('localidad: ', reg.codigo_localidad);
            localidad_actual:= reg.codigo_localidad;
            total_localidad:= 0;

            while (reg.codigo_localidad = localidad_actual) do begin
                total_localidad:= reg.cant_votos;
                leer(archivo, reg);
            end;
            writeln('total de votos por localidad: ', total_localidad);
            total_provincia:= total_provincia + total_localidad;
        end;
        writeln('total de votos por provincia: ', total_provincia);
        total_general:= total_general + total_provincia;
    end;
    writeln('el total de votos: ', total_general);
    close(archivo);
END.
