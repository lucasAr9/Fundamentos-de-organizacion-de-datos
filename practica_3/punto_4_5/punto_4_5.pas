program punto_4;

uses crt;

const
valor_alto = 999;

type
reg_flor = record
    codigo: integer;
    nombre: String[45];
end;

tArchFlores = file of reg_flor;


procedure leer(var archivo: tArchFlores; var dato: reg_flor);
begin
    if not eof(archivo) then
        read(archivo, dato)
    else
        dato.codigo:= valor_alto;
end;


procedure crear(var arch_bin: tArchFlores);
var r: reg_flor;
begin
    rewrite(arch_bin);
    r.codigo:= 0;
    write(arch_bin, r);
    close(arch_bin);
end;


procedure agregarFlor(var arch_bin: tArchFlores; nombre: String; codigo: integer);
var r, indice: reg_flor;
begin
    reset(arch_bin);

    leer(arch_bin, r);
    if (r.codigo < 0) then begin
        seek(arch_bin, abs(r.codigo));
        read(arch_bin, indice);
        seek(arch_bin, filePos(arch_bin) -1);
        r.codigo:= codigo;
        r.nombre:= nombre;
        write(arch_bin, r);
        seek(arch_bin, 0);
        write(arch_bin, indice);
    end
    else begin
        seek(arch_bin, fileSize(arch_bin));
        r.codigo:= codigo;
        r.nombre:= nombre;
        write(arch_bin, r);
    end;

    close(arch_bin);
end;


procedure baja(var arch_bin: tArchFlores);
var
    f, indice: reg_flor;
    numero: integer;
    ok: boolean;
begin
    reset(arch_bin);
    ok:= false;
    write('codigo de flor a eliminar: '); readln(numero);
    
    leer(arch_bin, indice);
    leer(arch_bin, f);

    while (f.codigo <> valor_alto) and not(ok) do begin
        if (f.codigo = numero) then begin
            ok:= true;
            f.codigo:= indice.codigo;
            seek(arch_bin, filePos(arch_bin) -1);
            indice.codigo:= filePos(arch_bin) * -1;
            write(arch_bin, f);
            seek(arch_bin, 0);
            write(arch_bin, indice);
        end
        else
            leer(arch_bin, f);
    end;
    if (ok) then
        writeln('se elimino con exito.')
    else
        writeln('no se encontro ese codigo.');
    close(arch_bin);
end;


procedure mostrar_pantalla(var arch_bin: tArchFlores);
var f: reg_flor;
begin
    reset(arch_bin);
    while not eof(arch_bin) do begin
        read(arch_bin, f);
        writeln('codigo: ', f.codigo, ' nombre: ', f.nombre);
    end;
    close(arch_bin);
end;


var
    arch_bin: tArchFlores;
BEGIN
    assign(arch_bin, 'flores.dat');

    crear(arch_bin);
    agregarFlor(arch_bin, 'una_flor', 10);
    agregarFlor(arch_bin, 'otra_flor', 20);
    baja(arch_bin);
    mostrar_pantalla(arch_bin);
END.
