program punto_5;

const
valor_alto = 999;
dimF = 50;

type
// nacimiento
direccion = record
    calle: integer;
    nro: integer;
    piso: integer;
    depto: integer;
    ciudad: String[30];
end;

nacimiento = record
    nro_partida_naci: integer;
    nombre: String[30];
    apellido: String[30];
    dir: direccion;
    matricula_medico: String[30];
    nombre_ape_madre: String[30];
    dni_madre: integer;
    nombre_ape_padre: String[30];
    dni_padre: integer;
end;

// fallecimiento
fallecimiento = record
    nro_partida_naci: integer;
    nombre: String[30];
    apellido: String[30];
    matricula_medico: String[30];
    fecha_deceso: String[30];
    lugar: String[30];
end;

// unir los fallecimiento y nacimiento
reg_maestro = record
    nro_partida_naci: integer;
    nombre: String[30];
    apellido: String[30];
    dir: direccion;
    matricula_medico: String[30];
    nombre_ape_madre: String[30];
    dni_madre: integer;
    nombre_ape_padre: String[30];
    dni_padre: integer;
    fallecio: boolean;
    matricula_medico_deceso: String[30];
    fecha_deceso: String[30];
    lugar: String[30];
end;

archivo_maestro = file of reg_maestro;

vec_detalle_arch = array [1..dimF] of text;

vec_detalle_reg_n = array [1..dimF] of nacimiento;
vec_detalle_reg_f = array [1..dimF] of fallecimiento;


// hacer el merge de los archivos de los nacimientos
procedure leer(var arch: text; var reg: nacimiento);
begin
    if not eof(arch) then begin
        with reg do begin
            readln(arch, nro_partida_naci);
            readln(arch, nombre);
            readln(arch, apellido);
            readln(arch, dir.calle, ' ', dir.nro, ' ', dir.piso, ' ',
                        dir.depto, ' ', dir.ciudad);
            readln(arch, matricula_medico);
            readln(arch, nombre_ape_madre);
            readln(arch, dni_madre);
            readln(arch, nombre_ape_padre);
            readln(arch, dni_padre);
        end;
    end;
    else
        reg.nro_partida_naci:= valor_alto;
end;

procedure minimo(var arch: text; var reg: reg_det_n; var min: nacimiento);
var
    i, pos: integer;
begin
    min.nro_partida_naci:= valor_alto; pos:= valor_alto;

    for i:= 1 to dimF do begin
		if (reg[i].nro_partida_naci <= min.nro_partida_naci) then begin
            min:= reg[i];
            pos:= i;
		end;
    end;
    if (pos <> valor_alto) then
        leer(arch[pos], reg[pos]);
end;

procedure merge_nacimiento(var maestro: archivo_maestro; var reg_mae: reg_maestro;
                    var arch_detalle: text; var reg_detalle: vec_detalle_reg_n);
var
    min: nacimiento;
begin
    minimo(arch_detalle, reg_detalle, min);
    while (min.nro_partida_naci <> valor_alto) do begin
        reg_mae:= min.nro_partida_naci;
        while (reg_maestro.nro_partida_naci = min.nro_partida_naci) do begin
            with reg_maestro do begin
                nro_partida_naci:= reg_detalle.nro_partida_naci;
                nombre:= reg_detalle.nombre;
                apellido:= reg_detalle.apellido;
                dir:= reg_detalle.dir;
                matricula_medico:= reg_detalle.matricula_medico;
                nombre_ape_madre:= reg_detalle.nombre_ape_madre;
                dni_madre:= reg_detalle.dni_madre;
                nombre_ape_padre:= reg_detalle.nombre_ape_padre;
                dni_padre:= reg_detalle.dni_padre;
                fallecio:= false;
                matricula_medico_deceso:= 'n';
                fecha_deceso:= 'n';
                lugar:= 'n';
            end;
            minimo(arch_detalle, reg_detalle, min);
        end;
    end;
end;


// hacer el merge de los archivos de los fallecimientos
procedure leer(var arch: text; var reg: fallecimiento);
begin
    if not eof(arch) then begin
        with reg do begin
            readln(arch, nro_partida_naci);
            readln(arch, nombre);
            readln(arch, apellido);
            readln(arch, matricula_medico);
            readln(arch, fecha_deceso);
            readln(arch, lugar);
        end;
    end;
    else
        reg.nro_partida_naci:= valor_alto;
end;

procedure minimo(var arch: text; var reg: reg_det_f; var min: fallecimiento);
var
    i, pos: integer;
begin
    min.nro_partida_naci:= valor_alto;
    pos:= -1;
    // busco y guardo el minimo en la variable min
    for i:= 1 to dimF do begin
        if (reg[i].nro_partida_naci <= min.nro_partida_naci) then begin
            min:= reg[i];
            por:= i;
        end;
    end;
    // actualizar el vector de registros leyendo el vec de archivos
    if (pos <> -1) then
        leer(arch[pos], reg[pos]);
end;

procedure merge_fallecimiento(var maestro: archivo_maestro; var reg_mae: reg_maestro;
                    var arch_detalle: text; var reg_detalle: vec_detalle_reg_f);
var
    min: fallecimiento;
begin
    minimo(arch_detalle, reg_detalle, min);
    while (min.nro_partida_naci <> valor_alto) do begin
        reg_mae:= min.nro_partida_naci;
        while (reg_maestro.nro_partida_naci = min.nro_partida_naci) do begin
            with reg_maestro do begin
                nro_partida_naci:= reg_detalle.nro_partida_naci;
                nombre:= reg_detalle.nombre;
                apellido:= reg_detalle.apellido;
                fallecio:= true;
                matricula_medico_deceso:= reg_detalle.matricula_medico;
                fecha_deceso:= reg_detalle.fecha_deceso;
                lugar:= reg_detalle.lugar;
            end;
            minimo(arch_detalle, reg_detalle, min);
        end;
    end;
end;


var
    arch_detalle_n: vec_detalle_arch;
    arch_detalle_f: vec_detalle_arch;
    reg_det_n: vec_detalle_reg_n;
    reg_det_f: vec_detalle_reg_f;
    maestro: archivo_maestro;
    reg_mae: reg_maestro;
    mae_text: text;
    convertir: String;
    i: integer;
BEGIN
    { cargar los archivos con datos random en otro archivo .pas }
    // crear_archivos_detalle(arch_detalle_n, arch_detalle_f);
    { crear el assign de los 50 archivos detalle de nacimiento y fallecimiento }
    for i:= 1 to dimF do begin
        str(i, convertir);
        assign(arch_detalle_n[i], 'detalle_n' + convertir + '.txt');
        assign(arch_detalle_f[i], 'detalle_f' + convertir + '.txt');
        reset(arch_detalle_n[i]);
        reset(arch_detalle_f[i]);
        leer(arch_detalle_n[i], reg_det_n[i]);
        leer(arch_detalle_f[i], reg_det_f[i]);
    end;

    assign(maestro, 'maestro.dat');
    rewrite(maestro);

    merge_nacimiento(maestro, reg_mae, arch_detalle_n, reg_det_n);
    merge_fallecimiento(maestro, reg_mae, arch_detalle_f, reg_det_f);

    for i:= 1 to dimF do begin
        close(arch_detalle_n[i]);
        close(arch_detalle_f[i]);
    end;

    assign(mae_text, 'maestro_text.txt');
    rewrite(mae_text);

    exportar_a_texto(mae_text, maestro);

    close(maestro);
    close(mae_text);
END;
