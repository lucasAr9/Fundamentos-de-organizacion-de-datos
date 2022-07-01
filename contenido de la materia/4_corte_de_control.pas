program corte_de_control;

const
valor_alto = 'ZZZ';

type
reg_venta = record
    vendedor: integer;
    monto: real;
    sucursal: String[30];
    ciudad: String[30];
    provincia: String[30];
end;

archivo = file of reg_venta;


procedure leer(var arch_bin: archivo; var dato: reg_venta);
begin
    if (not(EOF(arch_bin))) then 
        read (arch_bin, dato)
    else 
        dato.provincia := valor_alto;
end;


var
    reg: reg_venta;
    arch_bin: archivo;
    total, total_Prov, total_ciudad, total_sucursal: real;
    prov, ciudad, sucursal: String[30];
BEGIN
    assign(arch_bin, 'archivo_ventas.dat');
    reset(arch_bin);
    
    leer(arch_bin, reg);
    total:= 0;

    while (reg.provincia <> valor_alto)do begin
        writeln('Provincia: ', reg.provincia); 
        prov:= reg.provincia;
        total_Prov:= 0;
        while (prov = reg.provincia) do begin
            writeln('Ciudad: ', reg.ciudad); 
            ciudad:= reg.ciudad;
            total_ciudad := 0;
            while (prov = reg.provincia) and (ciudad = reg.ciudad) do begin
                writeln('Sucursal: ', reg.sucursal);
                sucursal:= reg.sucursal;
                total_sucursal:= 0;
                while (prov = reg.provincia) and (ciudad = reg.ciudad) and (sucursal = reg.sucursal) do begin
                    write('Vendedor: ', reg.vendedor);
                    writeln(reg.monto);
                    total_sucursal:= total_sucursal + reg.monto;
                    leer(arch_bin, reg);
                end;
                writeln('Total Sucursal', total_sucursal);
                total_ciudad:= total_ciudad + total_sucursal;
            end;{while (prov = reg.provincia) and (ciudad = reg.ciudad)}
            writeln('Total Ciudad ', total_ciudad);
            total_Prov:= total_Prov + total_ciudad;
        end;{while(prov = reg.provincia)}
        writeln('Total Provincia ', total_Prov);
        total:= total + total_Prov;
    end;{while(reg.provincia <> valor_alto)}
    writeln('Total Empresa ', total);
    close(arch_bin);
END.




{ otro ejemplo escribiendo en archivo }
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
