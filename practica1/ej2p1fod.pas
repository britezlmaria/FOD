program ej2p1;

type
	archivo=file of integer;

procedure recorrer(var arc_logico:archivo;var promedio:real;var cant:integer);
var
	suma,c,nro:integer;
begin
	suma:=0;
	c:=0;
	while not eof(arc_logico) do begin
		read(arc_logico,nro);
		if(nro<1500) then 
			cant:=cant+1;
		c:=c+1;
		suma:=suma+nro;
	end;
	promedio:=suma/c;
	close(arc_logico);
end;

var
	arc_logico:archivo;
	arc_fisico:string[12];
	promedio:real;
	cant:integer;
begin
	promedio:=0;
	cant:=0;
	write('ingrese el nombre del archivo:');
	read(arc_fisico);
	assign(arc_logico,arc_fisico);
	reset(arc_logico);
	recorrer(arc_logico,promedio,cant);
	writeln('la cantidad de numeros menores a 1500 es:',cant,'el promedio de los numeros ingresados es:',promedio:2:2);
end.
