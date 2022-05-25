program punto_8;

const
valor_alto = 999;

type
cliente = record
    codigo: integer;
    nombre: String[20];
    apellido: String[20];
end;

reg_arch_maestro = record
    cli: cliente;
    anio: integer;
    mes: 1..12;
    dia: 1..31;
    monto_venta: real;
end;


procedure leer(var archivo: text; var dato: reg_arch_maestro);
begin
    if not eof(archivo) then begin
        readln(archivo, dato.cli.codigo, dato.cli.nombre);
        readln(archivo, dato.cli.apellido);
        readln(archivo, dato.anio, dato.mes. dato.dia. dato.monto_venta);
    end
    else
        dato.cli.codigo:= valor_alto;
end;

var
    arch_maestro_txt: text;
    reg_cliente: reg_arch_maestro;

    codigo, anio, mes: integer;
    nombre, ape: String[20];
    total_anio, total_mes, total_cli, total: real;
BEGIN
    assign(arch_maestro_txt, 'archivo.txt');
    reset(arch_maestro_txt);

    leer(arch_maestro_txt, reg_cliente);
    total:= 0;

    while (reg_cliente.cli.codigo <> valor_alto) do begin
        writeln('cliente: ', reg_cliente.cli.codigo,
                ' nombre: ', reg_cliente.cli.nombre,
                ' apellido: ', reg_cliente.cli.apellido);
        codigo:= reg_cliente.cli.codigo;
        nombre:= reg_cliente.cli.nombre;
        apellido:= reg_cliente.cli.apellido;
        total_cli:= 0;

        while (codigo = reg_cliente.cli.codigo) do begin
            writeln('anio: ', reg_cliente.anio);
            anio:= reg_cliente.anio;
            total_anio:= 0;

            while (codigo = reg_cliente.cli.codigo)
                    and (anio = reg_cliente.anio) do begin
                writeln('mes: ', reg_cliente.mes);
                mes:= reg_cliente.mes;
                total_mes:= 0;

                while (codigo = reg_cliente.cli.codigo)
                        and (anio = reg_cliente.anio)
                        and (mes = reg_cliente.mes) do begin
                    total_mes:= reg_cliente.monto_venta;
                    leer(arch_maestro_txt, reg_cliente);
                end;

                writeln('el total por mes: ', total_mes);
                total_anio:= total_anio + total_mes;
            end;
            writeln('el total por anio: ', total_anio);
            total_cli:= total_cli + total_anio;
        end;
        writeln('el total por cliente: ', total_cli);
        total:= total + total_cli;
    end;
    writeln('el total de la empresa: ', total);

    close(arch_maestro_txt);
END.
