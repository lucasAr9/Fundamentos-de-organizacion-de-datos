procedure leer(var archivo: arch_bin; var dato: registro);
begin
	if not eof(archivo) then
		read(archivo, dato);
	else
		dato.codigo:= valor_alto;
end;

{ baja fisica }
BEGIN {se sabe que existe Carlos Garcia}
  	assign(archivo, 'arch_empleados');
  	assign(archivo_nuevo, 'arch_nuevo');

  	reset(archivo);
  	rewrite(archivo_nuevo);

  	leer(archivo, reg);
	{se copian los registros previos a Carlos Garcia}
  	while (reg.nombre <> 'Carlos Garcia') do begin
		write(archivo_nuevo, reg);
		leer(archivo, reg);
    end;

	{se descarta a Carlos Garcia}
	leer(archivo, reg);

	{se copian los registros restantes}
	while (reg.nombre <> valoralto) do begin	    
		write(archivo_nuevo, reg);
		leer(archivo, reg);
	end;

	close(archivo_nuevo);
	close(archivo);
END.




{ baja logica }
BEGIN {se sabe que existe Carlos Garcia}
	assign(archivo, 'arch_empleados');

	reset(archivo);

	leer(archivo, reg);
	{Se avanza hasta Carlos Garcia}
	while (reg.nombre <> 'Carlos Garcia') do	    
	    leer(archivo, reg);
        
	{Se genera una marca de borrado}
	reg.nombre:= '***';

	{Se borra lógicamente a Carlos Garcia}
	seek(archivo, filePos(archivo) -1);
	write(archivo, reg);
	close(archivo);
END.




{ baja logica con lista invertida }
procedure baja(var archivo: arch);
var
	reg, indice: registro;
	numero: integer;
	ok: boolean;
begin
	reset(arch_bin);
	ok:= false;
	write('INGRESE CODIGO DEL REGISTRO A ELIMINAR: '); readln(numero);
	writeln('');

	leer(arch_bin, indice);  // leo primero el indice que esta en la pos 0
	leer(arch_bin, reg); // luego el siguiente hasta encontrar el correcto a eliminar
	while (reg.codigo <> valorAlto) and not(ok) do begin
		if (reg.codigo = numero) then begin
			ok:= true;
			// copio el indice que estaba en la pos 0 en el que elimino para
			reg.codigo:= indice.codigo;         // tener la lista invertida
			seek(arch_bin, filePos(arch_bin) -1);  // retrocedo para tener nrr
			indice.codigo:= filePos(arch_bin) * -1;// paso el indice a negativo
			write(arch_bin, reg);  // escribo el indice que estaba en la pos 0
			seek(arch_bin, 0);     // voy a la pos 0
			// el indice que esta en el registro cabecera lo remplazo con el
			write(arch_bin, indice);       // del reg que acabo de eliminar
		end
		else
			leer(arch_bin, reg);
	end;
	if (ok) then 
		writeln('REGISTRO ELIMINADA')
	else
		writeln('NO SE ENCONTRO EL REGISTRO');

	close(arch_bin);
end;
{ la manera de crear el archivo con lista invertida (con 0 en la primer pos) }
procedure crear(var arch_bin: archivo);
var
	reg: registro;
begin
	rewrite(arch_bin);
	
	reg.codigo:= 0;
	write(arch_bin,reg);

	// opcional
	pedir_datos(reg);
	while (reg.codigo <> -1) do begin
		write (arch_bin,reg);
		pedir_datos(reg);
	end;

	close (arch_bin);
end;
{ la manera de agregar registros al archivo con lista invertida (alta) }
procedure alta(var arch_bin: archivo);
var
	reg, indice: registro;
begin
	reset(arch_bin);

    leer(arch_bin, n); // leo la primera posicion
    if n.codigo < 0 then begin // si el codigo es negativo
        seek(arch_bin, abs(n.codigo)); // voy a esa posicion (positiva)
        read(arch_bin, indice);        // leo esa posicion y
        seek(arch_bin, filePos(arch_bin) -1); // retrocedo para
        pedir_datos(n);
        write(arch_bin, n); // escribir los nuevos datos
        seek(arch_bin, 0);  // vuelvo a la primera posicion y
        write(arch_bin, indice); // escribo en la pos 0 el proximo lugar vasio
	end
	else begin
		seek(arch_bin, fileSize(arch_bin));
		pedir_datos(reg);
		write(arch_bin, reg);
	end;

	close(arch_bin);
end;
