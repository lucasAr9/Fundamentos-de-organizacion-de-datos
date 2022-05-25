{
1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y
* permita incorporar datos al archivo. Los números son ingresados desde teclado.
* El nombre del archivo debe ser proporcionado por el usuario desde teclado.
* La carga finaliza cuando se ingrese el número 30000, que no debe incorporarse
* al archivo.
}

program punto_1;

type
arch = file of integer;


procedure cargar(var n_logico: arch);
var
	num: integer;
begin
	rewrite(n_logico);
	writeln('secuencia de numeros:');
	readln(num);
	while (num <> 30) do begin
		write(n_logico, num);
		readln(num);
	end;
	close(n_logico);
end;


procedure imprimir(var n_logico: arch);
var
	num: integer;
begin
	reset(n_logico);
	while not eof(n_logico) do begin
		read(n_logico, num);
		write(num, ', ');
	end;
	close(n_logico);
end;


var
	n_logico: arch;
	nombre_archivo: String;
BEGIN
	write('nombre del archivo: '); readln(nombre_archivo);
	assign(n_logico, nombre_archivo);
	
	cargar(n_logico);
	imprimir(n_logico);
END.
