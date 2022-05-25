program punto_10;

const
valor_alto = 999;

type
// en un archivo ordenado por departamento, division y num empleado.
empleado = record
    departamento: integer;
    division: integer;
    numero_empleado: integer;
    categoria: integer;
    cant_horas_extra: real;
end;

vec_valor_aumentos = array [1..15] of real;


procedure leer(var archivo: text; var dato: empleado);
begin
    if not eof(archivo) then begin
        with dato do begin
            readln(archivo, departamento, division,
                numero_empleado, categoria, cant_horas_extra);
        end;
    end
    else
        dato.departamento:= valor_alto;
end;


procedure cargar_vector_de_aumentos(var arch_valor_aumentos_txt: text;
                                    var vec_aumentos: vec_valor_aumentos);
var
    aumento: real;
    i: integer;
begin
    reset(arch_valor_aumentos_txt);
    i:= 1;
    while not eof(arch_valor_aumentos_txt) do begin
        readln(arch_valor_aumentos_txt, aumento);
        vec_aumentos[i]:= aumento;
        i:= i + 1;
    end;
    close(arch_valor_aumentos_txt);
end;


var
    reg: empleado;
    vec_aumentos: vec_valor_aumentos;

    arch_empleados_txt: text;
    arch_valor_aumentos_txt: text;

    dep_actual, div_actual: integer;
    horas_dep, horas_div: real;
    total_dep, total_div: real;
BEGIN
    assign(arch_empleados_txt, 'empleados.txt');
    assign(arch_valor_aumentos_txt, 'aumentos.txt');

    // cargar los valores a aumentar por hora extra
    cargar_vector_de_aumentos(arch_valor_aumentos_txt, vec_aumentos);
    
    // corte de control
    reset(arch_empleados_txt);
    leer(arch_empleados_txt, reg);

    while (reg.departamento <> valor_alto) do begin
        writeln('DEPARTEMENTO ------> ', reg.departamento);
        dep_actual:= reg.departamento;
        horas_dep:= 0;
        total_dep:= 0;

        while (reg.departamento = dep_actual) do begin
            writeln('DIVISION ------> ', reg.division);
            div_actual:= reg.division;
            horas_div:= 0;
            total_div:= 0;

            while (reg.departamento = dep_actual) and
                    (reg.division = div_actual) do begin
                horas_div:= horas_div + reg.cant_horas_extra;
                total_div += reg.cant_horas_extra * vec_aumentos[reg.categoria];

                writeln('Total horas del empleado: ', reg.cant_horas_extra:2:2,
                    ' y con un importe a cobrar de: ',
                    (reg.cant_horas_extra * vec_aumentos[reg.categoria]):2:2);
                leer(arch_empleados_txt, reg);
            end;
            writeln('Total de horas division: ', horas_div:2:2,
                    ' monto total por division: ', total_div:2:2);
            horas_dep:= horas_dep + horas_div;
            total_dep:= total_dep + total_div;
        end;
        writeln('total de horas departamento: ', horas_dep:2:2,
                ' monto total departemento: ', total_dep:2:2);
    end;
    close(arch_empleados_txt);
END.
