program pru;

var
    i: integer;
    estring: string;
begin
    for i:= 1 to 10 do begin
        str(i, estring);
        writeln('hola' + estring + '.txt');
    end;
end.
