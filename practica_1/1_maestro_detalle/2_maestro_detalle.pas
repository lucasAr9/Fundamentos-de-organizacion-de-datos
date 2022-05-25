{ queremos actualizar las ventas de un producot con un maestro y un detalle }
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
    for i:= 1 to 15 do begin
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
    for i:= 1 to 4 do begin
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


var
    maestro: maestroArch;
    detalle: detalleArch;
    regMaestro: producto;
    regDetalle: ventaPdoructo;
BEGIN
    assign(maestro, 'maestro.dat');  
    assign(detalle, 'detalle.dat');

    cargarMaestro(maestro);
    cargarDetalle(detalle);
    writeln('*****************se imprime el meestro*****************');
    imprimirMaestro(maestro);
    writeln('*****************se imprime el detalle*****************');
    imprimirDetalle(detalle);

    reset(maestro);
    reset(detalle);
    leer(detalle, regDetalle); // 1.

    while (regDetalle.codigo <> valorAlto) do begin // 2.
        read(maestro, regMaestro); // 3.
        
        while (regMaestro.codigo <> regDetalle.codigo) do // 4.
            read(maestro, regMaestro); // idem 3.
        
        while(regMaestro.codigo = regDetalle.codigo) do begin // 5.
            regMaestro.cant:= regMaestro.cant - regDetalle.cant; // actualizar
	        leer(detalle, regDetalle); // seguir hasta que sea !=
        end;
        
        seek(maestro, filePos(maestro) - 1); // 6.
        write(maestro, regMaestro); // 7.
    end;

    close(maestro);
    close(detalle);

    writeln('*****************se imprime el NUEVO meestro*****************');
    imprimirMaestro(maestro);
END.

{
1. leo el detalle y lo guardo en un registro con los campos del detalle
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
