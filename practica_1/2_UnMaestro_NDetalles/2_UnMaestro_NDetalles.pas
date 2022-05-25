{ queremos actualizar las ventas de un producot con un maestro y N detalle }
program maestro_detalle;

const
valorAlto = 999;

type
producto = record
    codigo: integer;
    cant: integer;
    precio: real;
end;

ventaPdoructo = record
    codigo: integer;
    cant: integer;
end;

maestroArch = file of producto;
detalleArch = file of ventaPdoructo;


procedure cargarMaestro(var maestro: maestroArch);
var
    p: producto;
    i: integer;
begin
    rewrite(maestro);
    randomize;
    for i:= 1 to 10 do begin
        p.codigo:= i;
        p.cant:= random(200) + 100;
        p.precio:= random(30300);
        write(maestro, p);
    end;
    close(maestro);
end;


procedure cargarDetalle(var detalle: detalleArch);
var
    p: ventaPdoructo;
    i: integer;
begin
    rewrite(detalle);
    randomize;
    for i:= 1 to 3 do begin
        p.codigo:= i + 2;
        p.cant:= random(100);
        write(detalle, p);
    end;
    close(detalle);
end;


procedure imprimirMaestro(var maestro: maestroArch);
var
    p: producto;
begin
    reset(maestro);
    while not eof(maestro) do begin
        read(maestro, p);
        write('*** codigo: ', p.codigo, ' CANT: ', p.cant,
                ' precio: ', p.precio:2:2);
        writeln('');
    end;
    close(maestro);
end;


procedure imprimirDetalle(var detalle: detalleArch);
var
    p: ventaPdoructo;
begin
    reset(detalle);
    while not eof(detalle) do begin
        read(detalle, p);
        write('*** codigo: ', p.codigo, ' CANT: ', p.cant);
        writeln('');
    end;
    close(detalle);
end;


procedure leer(var archivo: detalleArch; var dato: ventaPdoructo);
begin
    if (not eof(archivo)) then
        read(archivo, dato)
    else
        dato.codigo:= valorAlto;
end;


procedure minimo(var r1, r2, r3: ventaPdoructo; var min: ventaPdoructo;
                    var detalle1, detalle2, detalle3: detalleArch);
begin
    if (r1.codigo <= r2.codigo) and (r1.codigo <= r3.codigo) then begin
        min:= r1;
        leer(detalle1, r1);
    end
    else begin
        if (r2.codigo <= r3.codigo) then begin
            min:= r2;
            leer(detalle2, r2);
        end
        else begin
            min:= r3;
            leer(detalle3, r3);
        end;
    end;
end;


var
    maestro: maestroArch;
    regMaestro: producto;
    detalle1, detalle2, detalle3: detalleArch;
    regDetalle1, regDetalle2, regDetalle3: ventaPdoructo;
    min: ventaPdoructo;
BEGIN
    assign(maestro, 'maestro.dat');
    assign(detalle1, 'detalle1.dat');
    assign(detalle2, 'detalle2.dat');
    assign(detalle3, 'detalle3.dat');

    cargarMaestro(maestro);
    writeln('*****************se imprime el meestro*****************');
    imprimirMaestro(maestro);

    cargarDetalle(detalle1); // 1
    writeln('*****************se imprime el detalle*****************');
    imprimirDetalle(detalle1);
    cargarDetalle(detalle2); // 2
    writeln('*****************se imprime el detalle*****************');
    imprimirDetalle(detalle2);
    cargarDetalle(detalle3); // 3
    writeln('*****************se imprime el detalle*****************');
    imprimirDetalle(detalle3);

    reset(maestro);
    reset(detalle1);
    reset(detalle2);
    reset(detalle3);

    leer(detalle1, regDetalle1); // 1.
    leer(detalle2, regDetalle2); // 1.
    leer(detalle3, regDetalle3); // 1.

    // calcular el minimo entre los tres detalles
    minimo(regDetalle1, regDetalle2, regDetalle3, min,
            detalle1, detalle2, detalle3); // 1.bis.

    while (min.codigo <> valorAlto) do begin // 2.
        read(maestro, regMaestro); // 3.
        
        while (regMaestro.codigo <> min.codigo) do // 4.
            read(maestro, regMaestro); // idem 3.
        
        while(regMaestro.codigo = min.codigo) do begin // 5.
            // actualizar
            regMaestro.cant:= regMaestro.cant - min.cant;
            // seguir hasta que sea !=
	        minimo(regDetalle1, regDetalle2, regDetalle3, min,
                    detalle1, detalle2, detalle3); // 1.bis.
        end;
        
        seek(maestro, filePos(maestro) - 1); // 6.
        write(maestro, regMaestro); // 7.
    end;

    close(maestro);
    close(detalle1);
    close(detalle2);
    close(detalle3);

    writeln('*****************se imprime el NUEVO meestro*****************');
    imprimirMaestro(maestro);
END.

{
1. leo el detalle y lo guardo en un registro con los campos del detalle
1.bis. busco el minimo entre los tres arahcivos, porque un mismo archivo puede
    que tenga varios detalles del mismo "codigo" que se requieran actualizar.
2. miestras que el detalle sea distinto a un valor que no es del detalle
3. leo el maestro y si es distinto al del detalle voy a 4. si no, 5.
4. sigo leyendo del maestro hasta encontrar el que sea igual al detalle
5. si no, entonces es igual y entro al 3er while que va a seguir ahi dentro
    hasta que el detalle sea distinto del maestro //seguir hasta que sea !=, por
    mientras hago la actualizacion, que en este caso es restar la cantidad de
    ventas de ese producto. //actualizar
6. por ultimo, retrocedo una pos ya que el leer del maestro me deja en las
    siguiente posicion
7. y escribo en el maestro la actualizacion
}
