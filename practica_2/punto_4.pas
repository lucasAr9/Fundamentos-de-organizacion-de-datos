program punto_4;

const
valor_alto = 999;

type
usuario = record
    cod_usuario: integer;
    fecha: integer;
    tiempo_sesion: real;
end;

archivo_binario = file of usuario;


{ actualizar el archivo binario del maestro leyendo los detalles }
procedure leer(var arch_text: text; var u: usuario);
begin
    if not eof(arch_text) then
        readln(arch_text, u.cod_usuario, u.fecha, u.tiempo_sesion);
    else
        u.cod_usuario: valor_alto;
end;

procedure minimo(var r1, r2, r3, r4, r5, min: usuario;
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

procedure actualizar_maestro(var arch_bin: archivo_binario;
                             var d1, d2, d3, d4, d5: text);
var
    r1, r2, r3, r4, r5, min, actual: usuario;
    reg_mae: usuario;
begin
    rewrite(arch_bin);
    reset(d1);
    reset(d2);
    reset(d3);
    reset(d4);
    reset(d5);

    minimo(r1, r2, r3, r4, r5, min, d1, d2, d3, d4, d5: text);
    while (min.cod_usuario <> valor_alto) do begin
        actual.cod_actual:= min.cod_actual
        actual.tiempo_sesion:= 0
        while (min.cod_usuario = actual.cod_actual) do begin
            actual.tiempo_sesion:= actual.tiempo_sesion + min.tiempo_sesion;
            minimo(r1, r2, r3, r4, r5, min, d1, d2, d3, d4, d5);
        end;
        write(arch_bin, actual);
    end;

    close(arch_bin);
    close(d1);
    close(d2);
    close(d3);
    close(d4);
    close(d5);
end;


{ escribir el archivo binario del maestro en un archivo de texto }
procedure escribir_maestro_arch_text(var arch_bin: archivo_binario;
                                     var arch_text: text);
var
    u: usuario;
begin
    reset(arch_bin);
    rewrite(arch_text);

    while not eof(arch_bin) do begin
        read(arch_bin, u);
        writeln(arch_text, u.cod_usuario, ' ', u.fecha, ' ', u.tiempo_sesion);
    end;

    close(arch_bin);
    close(arch_text);
end;


var
    arch_bin_maestro: archivo_binario;
    arch_text_maestro: text;
    d1, d2, d3, d4, d5: text; 
BEGIN
    assign(arch_bin_maestro, 'arch_bin_maestro.dat');
    assign(arch_txt_maestro, 'arch_txt_maestro.txt');
    assign(d1, 'detalle1.txt');
    assign(d2, 'detalle2.txt');
    assign(d3, 'detalle3.txt');
    assign(d4, 'detalle4.txt');
    assign(d5, 'detalle5.txt');

    actualizar_maestro(arch_bin_maestro, d1, d2, d3, d4, d5);
    escribir_maestro_arch_text(arch_text_maestro, arch_bin_maestro);
END.
