program union_de_archivos_III;

const
valoralto = 9999;
dimF = 100;

type
vendedor = record
    cod: string[4];               
    producto: string[10];         
    montoVenta: real;        
end;

ventas = record
    cod: string[4];                
    total: real;              
end;

maestro = file of ventas;   

arch_detalle = array [1..100] of file of vendedor;
reg_detalle = array [1..100] of vendedor;


procedure leer(var archivo: detalle; var dato: vendedor);
begin
    if (not eof( archivo )) then
        read (archivo, dato)
    else
        dato.cod:= valoralto;
end;


procedure minimo (var reg_det: reg_detalle; var arch_det: arch_detalle;
                                            var min: vendedor);
var
    i, pos: integer;
begin
	min:= 999;
    pos:= -1;
    // busco y guardo el minimo en la variable min
	for i:= 1 to dimF do begin
		if (reg_det[i]^.cod <= min) then begin
            min:= reg_det[i];
            pos:= i;
		end;
    end;
    // actualizar el vector de registros leyendo el vec de archivos
    if (pos <> -1) then
        leer(arch_det[pos], reg_det[pos]);
end;


var
    min: vendedor;
    arch_det: arch_detalle;
    reg_det: reg_detalle;
    mae1: maestro;
    regm: ventas;
    i: integer;
begin
    { crear el assign y abrir cada archivo detalle }
    for i:= 1 to dimF do begin
        assign(arch_det[i], 'det'+i); 
        reset(arch_det[i]);
        leer(arch_det[i], reg_det[i]);
    end;

    { crear el assign del maestro }
    assign(mae1, 'maestro');
    rewrite(mae1);
    minimo(reg_det, arch_det, min);

    while (min.cod <> valoralto) do begin
        regm.cod:= min.cod;
        regm.total:= 0;
        while (regm.cod = min.cod ) do begin
            regm.total:= regm.total + min.montoVenta;
            minimo(reg_det, arch_det, min);
        end;
        write(mae1, regm);
    end;    
end.
