{ ejemplo de la sintaxis para el manejo de archivos }

program sintaxis;

type
persona = record
    nombre: String[20];
    apellido: String[20];
    edad: integer;
end;

arch = file of persona;



var
    n_logico, p: arch;
BEGIN
    //     n_logico, n_fisico
    assign(n_logico, 'hola.dat');

    rewrite(n_logico);  //crear y escribir el archivo (creacion).
    reset(n_logico);    //lectura y escritura del archivo (apertura).
    close(n_logico);    //cerrar el archivo.

    read(n_logico, p);  //leer del archivo.
    write(n_logico, p); //escribir en el archivo.

    { funciones }
    eof(n_logico);//fin de archivo, boolean, verdadero si es el fin de archivo.
    fileSize(n_logico);//tamaño del archivo.
    filePos(n_logico);//posicion del indice dentro del archivo.
    { proceso }
    seek(n_logico, posicion);//ir a una posicion del archivo, de 0 al final.
END.
