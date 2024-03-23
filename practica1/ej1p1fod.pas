program ej1p1;

type
	archivo=file of integer;

procedure leerNros(var arc_logico:archivo);
var
	nro:integer;
begin
	writeln('ingrese un nro:');
	readln(nro);
	while(nro<>3000) do begin
		write(arc_logico,nro);
		writeln('ingrese un nro:');
		read(nro);
	end;
end;

var
	arc_logico:archivo;
	arc_fisico:string[12];
begin
	writeln('ingrese el nombre del archivo:');
	read(arc_fisico);
	assign(arc_logico,arc_fisico);
	rewrite(arc_logico);
	leerNros(arc_logico);
	close(arc_logico);
end.

	
