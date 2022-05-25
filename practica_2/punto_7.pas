program punto_7;

const
valor_alto = 999;

type
producto = record
    codigo_prod: integer;
    nombre_comercio: String[20];
    precio_venta: real;
    stock_actual: integer;
    stock_minimo: integer;
end;

venta = record
    codigo_prod: integer;
    cant_uni_vendidas: integer;
end;

binario_detalle = file of venta;
binario_maestro = file of producto;


// leer los archivos de texto
procedure leer_maestro(var arch_maestro_txt: text;
                       var arch_maestro_bin: binario_maestro);
var
    reg: producto;
begin
    reset(arch_maestro_txt);
    rewrite(arch_maestro_bin);
    while not eof(arch_maestro_txt) do begin
        with reg do begin
            readln(arch_maestro_txt, codigo_prod, nombre_comercio);
            readln(arch_maestro_txt, precio, stock_actual, stock_minimo);
        end;
        write(arch_maestro_bin, reg);
    end;
    close(arch_maestro_txt);
    close(arch_maestro_bin);
end;

procedure leer_detalle(var arch_detalle_txt: text;
                       var arch_detalle_bin: binario_detalle);
var
    reg: venta;
begin
    reset(arch_detalle_txt);
    rewrite(arch_detalle_bin);
    while not eof(arch_detalle_txt) do begin
        with red do begin
            readln(arch_detalle_txt, codigo_prod, cant_uni_vendidas);
        end;
        write(arch_detalle_bin, reg);
    end;
    close(arch_detalle_txt);
    close(arch_detalle_bin);
end;


// actualizar el maestro con el detalle
procedure leer(var archivo: binario_detalle; var dato: venta);
begin
    if not eof(archivo) then
        read(archivo, dato)
    else
        dato.codigo_prod:= valor_alto;
end;

procedure actualizar_maestro(var arch_maestro_bin: binario_maestro;
                             var arch_detalle_bin: binario_detalle);
var
    reg_mae: producto;
    reg_det: venta;
begin
    reset(arch_maestro_bin);
    reset(arch_detalle_bin);

    leer(arch_detalle_bin, reg_det);

    while (reg_det.codigo_prod <> valor_alto) do begin
        read(arch_maestro_bin, reg_mae);

        while (reg_mae.codigo_prod <> reg_det.codigo_prod) do
            read(arch_maestro_bin, reg_mae);

        while (reg_mae.codigo_prod = reg_det) do begin
            reg_mae.stock_actual:= reg_mae.stock_actual - reg_det.cant_uni_vendidas;
            leer(arch_detalle_bin, reg_det);
        end;
        seek(arch_maestro_bin, filePos(arch_maestro_bin) -1);
        write(arch_maestro_bin, reg_mae);
    end;

    close(arch_maestro_bin);
    close(arch_detalle_bin);
end;


var
    arch_maestro_txt: text;
    arch_maestro_bin: binario_maestro;
    arch_detalle_txt: text;
    arch_detalle_bin: binario_detalle;
    calcular: text;
BEGIN
    assign(arch_maestro_txt, 'archivo_maestro_texto.txt');
    assign(arch_maestro_bin, 'archivo_maestro_binario.dat');
    assign(arch_detalle_txt, 'archivo_detalle_texto.txt');
    assign(arch_detalle_bin, 'archivo_detalle_binario.dat');

    leer_maestro(arch_maestro_txt, arch_maestro_bin);
    leer_detalle(arch_detalle_txt, arch_detalle_bin);

    actualizar_maestro(arch_maestro_bin, arch_detalle_bin);
    escribir_los_cambios(arch_maestro_txt, arch_maestro_bin);

    stock_minimo(arch_maestro_txt, calcular);
END.
