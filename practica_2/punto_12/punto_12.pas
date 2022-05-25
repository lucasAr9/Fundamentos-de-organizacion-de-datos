program punto_12;

const
valor_alto = 999;

type
acceso = record
    anio: integer;
    mes: 1..12;
    dia: 1..31;
    id: integer;
    tiempo: real;
end;


procedure leer(var archivo: text; var dato: acceso);
begin
    if not eof(archivo) then
        with dato do begin
            readln(archivo, anio, mes, dia, id, tiempo);
        end
    else
        dato.anio:= valor_alto;
end;


var
    anio_elegir, mes, dia: integer;
    tiempo_anio, tiempo_mes, tiempo_dia: real;
    archivo: text;
    reg: acceso;
BEGIN
    assign(archivo, 'accesos.txt');
    reset(archivo);

    writeln();
    write('año a mostrar en pantalla: '); readln(anio_elegir);
    while (anio_elegir <> 0) do begin

        leer(archivo, reg);
        while (reg.anio <> valor_alto) and (reg.anio < anio_elegir) do
            leer(archivo, reg);

        if (reg.anio = anio_elegir) then begin

            while (reg.anio <> valor_alto) and (reg.anio = anio_elegir) do begin
                writeln('año: ', reg.anio);
                tiempo_anio:= 0;

                while (reg.anio = anio_elegir) do begin
                    writeln('mes: ', reg.mes);
                    mes:= reg.mes;
                    tiempo_mes:= 0;

                    while (reg.anio = anio_elegir) and (reg.mes = mes) do begin
                        writeln('dia: ', reg.dia);
                        dia:= reg.dia;
                        tiempo_dia:= 0;

                        while (reg.anio = anio_elegir) and (reg.mes = mes)
                                and (reg.dia = dia) do begin
                            writeln('usuario: ', reg.id,
                                    'con un tiempo de: ', reg.tiempo:2:2);
                            tiempo_dia:= tiempo_dia + reg.tiempo;
                            leer(archivo, reg);
                        end;
                        writeln('tiempo total en el dia: ', dia,
                                ' con: ', tiempo_dia:2:2);
                        tiempo_mes:= tiempo_mes + tiempo_dia;
                    end;
                    writeln('tiempo total en el mes: ', mes,
                            ' con: ', tiempo_mes:2:2);
                    tiempo_anio:= tiempo_anio + tiempo_mes;
                end;
                writeln('tiempo total en el año: ', anio_elegir,
                        ' con: ', tiempo_anio:2:2);
            end;
        end
        else
            writeln('el año no se encontro.');

        writeln('************************************************************');
        writeln();
        write('año a mostrar en pantalla: '); readln(anio_elegir);
    end;

    close(archivo);
END.
