program punto_3;

const
valor_alto = 999;

type
producto = record
    codigo: integer;
    stock_dispo: integer;
    stock_min: integer;
    precio: real;
    nombre: String[30];
    descripcion: String[30];
end;

venta = record
    codigo: integer;
    cant_vendida: integer;
end;

archivo_binario = file of producto;


// crear el archivo de texto *maestro* que pide el ejercicio
procedure generarNombre1(var nombre: String);
var num: integer;
begin
    num:= random(5);
    case num of
        0: nombre:= 'papa';
        1: nombre:= 'nutella';
        2: nombre:= 'fideos';
        3: nombre:= 'carne';
        4: nombre:= 'cebolla';
    end;
end;
procedure leerRandom(var n: producto; i: integer);
var
    nom: String;
begin
    with n do begin
        codigo:= i;
        stock_dispo:= random(60);
        stock_min:= random(60);
        precio:= random(10400);
        generarNombre1(nom);
        nombre:= nom;
        descripcion:= 'esto es la descripcion del producto.';
    end;
end;
procedure cargar_maestro(var arch_texto: text);
var
    n: producto;
    i: integer;
begin
    rewrite(arch_texto);

    randomize;
    for i:= 1 to 30 do begin
        leerRandom(n, i);
        writeln(arch_texto, n.codigo, ' ', n.stock_dispo, ' ',
                            n.stock_min, ' ', n.precio);
        writeln(arch_texto, n.nombre);
        writeln(arch_texto, n.descripcion);
    end;
    close(arch_texto);
end; // fin de creacion del archivo de texto *maestro*


// crear el archivo de texto *detalle* que pide el ejercicio
procedure leerOtroDetalle(var n: venta; i: integer);
begin
    with n do begin
        codigo:= i;
        cant_vendida:= random(60);
    end;
end;
procedure cargar_detalle(var arch_texto: text);
var
    n: venta;
    i: integer;
begin
    rewrite(arch_texto);

    randomize;
    for i:= 1 to 10 do begin
        leerOtroDetalle(n, i);
        writeln(arch_texto, n.codigo, ' ', n.cant_vendida);
    end;
    close(arch_texto);
end; // fin de creacion del archivo de texto *detalle*


// llevar los datos del archivo de texto del maestro a un archivo binario
procedure leer_arch_maestro(var arch_bin_maestro: archivo_binario;
                            var arch_text_maestro: text);
var
    prod: producto;
begin
    rewrite(arch_bin_maestro);
    reset(arch_text_maestro);
    
    while not eof(arch_text_maestro) do begin
        readln(arch_text_maestro, prod.codigo, prod.stock_dispo,
                prod.stock_min, prod.precio);
        readln(arch_text_maestro, prod.nombre);
        readln(arch_text_maestro, prod.descripcion);
        write(arch_bin_maestro, prod);
    end;

    close(arch_bin_maestro);
    close(arch_text_maestro);
end;


// actualizar el maestro
procedure leer(var arch: text; var dato: producto);
begin
    if not eof(arch) then
        readln(arch, dato.codigo, dato.cant_vendida)
    else
        dato.codigo:= valor_alto;
end;
procedure minimo(var r1, r2, r3, r4, r5, min: producto;
                 var d1, d2, d3, d4, d5: text);
begin
    if (r1.codigo <= r2.codigo) and (r1.codigo <= r3.codigo)
            and (r1.codigo <= r4.codigo) and (r1.codigo <= r5.codigo) then begin
        min:= r1;
        leer(d1, r1);
    end
    else begin
        if (r2.codigo <= r1.codigo) and (r2.codigo <= r3.codigo)
            and (r2.codigo <= r4.codigo) and (r2.codigo <= r5.codigo) then begin
            min:= r2;
            leer(d2, r2);
        end
        else begin
            if (r3.codigo <= r2.codigo) and (r3.codigo <= r1.codigo)
            and (r3.codigo <= r4.codigo) and (r3.codigo <= r5.codigo) then begin
                min:= r3;
                leer(d3, r3);
            end
            else begin
                if (r4.codigo <= r2.codigo) and (r4.codigo <= r3.codigo)
            and (r4.codigo <= r1.codigo) and (r4.codigo <= r5.codigo) then begin
                    min:= r4;
                    leer(d4, r4);
                end
                else begin
                    min:= r5;
                    leer(d5, r5);
                end;
            end;
        end;
    end;
end;

procedure maestro_detalle(var arch_bin_maestro: archivo_binario;
                var detalle1: text; var detalle2: text;
                var detalle3: text; var detalle4: text; var detalle5: text);
var
    prod_detalle1: venta;
    prod_detalle2: venta;
    prod_detalle3: venta;
    prod_detalle4: venta;
    prod_detalle5: venta;
    prod_maestro: producto;
    min: venta;
begin
    reset(arch_bin_maestro);
    reset(detalle1);
    reset(detalle2);
    reset(detalle3);
    reset(detalle4);
    reset(detalle5);

    minimo(prod_detalle1, prod_detalle2, prod_detalle3,
            prod_detalle4, prod_detalle5,
            detalle1, detalle2, detalle3, detalle4, detalle5, min);

    while (min.codigo <> valor_alto) do begin
        read(arch_bin_maestro, prod_maestro);

        while (prod_maestro.codigo <> min.codigo) do
            read(arch_bin_maestro, prod_maestro);

        while (prod_maestro.codigo = min.codigo) do begin
            prod_maestro.stock_dispo:= prod_maestro.stock_dispo - min.cant_vendida;
            minimo(prod_detalle1, prod_detalle2, prod_detalle3,
                    prod_detalle4, prod_detalle5,
                    detalle1, detalle2, detalle3, detalle4, detalle5, min);
        end;

        seek(arch_bin_maestro, filePos(arch_bin_maestro) -1)
        write(arch_bin_maestro, prod_maestro);
    end;

    close(arch_bin_maestro);
    close(detalle1);
    close(detalle2);
    close(detalle3);
    close(detalle4);
    close(detalle5);
end;


// cargar los datos en un archivo de texto
procedure cargar_arch_maestro_actualizado(var arch_text: text;
                                        var arch_bin: archivo_binario);
var
    p: producto;
begin
    rewrite(arch_text);
    reset(arch_bin);

    while not eof(arch_bin) do begin
        read(arch_bin, p);
        writeln(arch_texto, n.codigo, ' ', n.stock_dispo, ' ',
                            n.stock_min, ' ', n.precio);
        writeln(arch_texto, n.nombre);
        writeln(arch_texto, n.descripcion);
    end;

    close(arch_text);
    close(arch_bin);
end;


var
    arch_text_maestro: text;
    arch_text_maestro_desp: text;
    arch_bin_maestro: archivo_binario;
    detalle1, detalle2, detalle3, detalle4, detalle5: text;
BEGIN
    assign(arch_text_maestro, 'arch_text_maestro.txt');
    assign(arch_text_maestro_desp, 'arch_text_maestro_desp.txt');
    assign(arch_bin_maestro, 'arch_bin_maestro.dat');
    assign(detalle1, 'detalle1.dat');
    assign(detalle2, 'detalle2.dat');
    assign(detalle3, 'detalle3.dat');
    assign(detalle4, 'detalle4.dat');
    assign(detalle5, 'detalle5.dat');

    cargar_maestro(arch_text_maestro);    
    cargar_detalle(detalle1);
    cargar_detalle(detalle2);
    cargar_detalle(detalle3);
    cargar_detalle(detalle4);
    cargar_detalle(detalle5);

    leer_arch_maestro(arch_bin_maestro, arch_text_maestro);
    maestro_detalle(arch_bin_maestro, detalle1, detalle2,
                            detalle3, detalle4, detalle5);
    cargar_arch_maestro_actualizado(arch_text_maestro_desp, arch_bin_maestro);
END.
