{ con tres detalles }
program union_de_archivos;

const
valoralto = 'zzzz';

type
str30 = string[30];
str10 = string[10];

alumno = record
    nombre: str30;
    dni: str10;
    direccion: str30;
    carrera: str10;
end;

detalle = file of alumno;       


procedure leer (var archivo: detalle; var dato: alumno);
begin
    if (not eof( archivo )) then
        read (archivo, dato)
    else
        dato.nombre:= valoralto;
end;


procedure minimo(var r1, r2, r3: alumno; var min: alumno);
begin
    if (r1.nombre<r2.nombre) and (r1.nombre<r3.nombre) then begin
        min := r1;
        leer(det1,r1)
    end
    else begin
        if (r2.nombre<r3.nombre) then begin
            min := r2;
            leer(det2,r2)
        end
        else begin
            min := r3;
            leer(det3,r3)
        end;
    end;
end;


var
    min, regd1, regd2, regd3: alumno;
    det1, det2, det3, maestro: detalle;
begin
    assign(det1, 'det1.txt');
    assign(det2, 'det2.txt');
    assign(det3, 'det3.txt');
    assign(maestro, 'maestro.dat');

    reset(det1);
    reset(det2);
    reset(det3);
    rewrite(maestro);

    leer(det1, regd1);
    leer(det2, regd2);
    leer(det3, regd3);
    
    minimo(regd1, regd2, regd3, min);
    
    while (min.nombre <> valoralto) do begin
        write (maestro, min);
        minimo(regd1, regd2, regd3, min);
    end;

    close(maestro);
end.
