program p2ej4;
const
	valor='ZZZ';
type
	info=record
		cant,encuestados:integer;
		prov:string[12];
	end;
	
	censo=record
		cant,cod,encuestados:integer;
		prov:string[12];
	end;
	
	maestro=file of info;
	detalle=file of censo;
	 
procedure leerInfo(var i:info);
begin
	writeln('ingrese el nombre de la provincia:');
	readln(i.prov);
	if(i.prov<>'x') then begin
		writeln('ingrese la cantidad de personas alfabetizadas:');
		readln(i.cant);
		writeln('ingrese la cantidad de encuestados:');
		readln(i.encuestados);
	end;
end;

procedure cargarMaestro(var mae:maestro);
var
	i:info;
	nombre:string[12];
begin
	writeln('ingrese un nombre para el archivo binario:');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	leerInfo(i);
	while(i.prov<>'x') do begin
		write(mae,i);
		leerInfo(i);
	end;
	close(mae);
end;

procedure leerCenso(var c:censo);
begin
	writeln('ingrese el nombre de la provincia:');
	readln(c.prov);
	if(c.prov<>'x') then begin
		writeln('ingrese la cantidad de personas alfabetizadas:');
		readln(c.cant);
		writeln('ingrese la cantidad de encuestados:');
		readln(c.encuestados);
		writeln('ingrese el codigo de la provincia:');
		readln(c.cod);
	end;
end;

procedure cargarDetalle(var det:detalle);
var
	c:censo;
	nombre:string[12];
begin
	writeln('ingrese un nombre para el archivo binario detalle:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	leerCenso(c);;
	while(c.prov<>'x') do begin
		write(det,c);
		leerCenso(c);
	end;
	close(det);
end;
procedure leer(var det:detalle;var c:censo);
begin
	if not eof(det) then
		read(det,c)
	else
		c.prov:=valor;
end;

procedure minimo(var det1,det2:detalle;var r1,r2,min:censo);
begin
	if(r1.prov<=r2.prov) then begin
		min:=r1;
		leer(det1,r1);
	end
	else
		min:=r2;
		leer(det2,r2);
end;

procedure actualizar(var mae:maestro;var det1,det2:detalle);
var
	r1,r2,min:censo;
	i:info;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1,r1);
	leer(det2,r2);
	minimo(det1,det2,r1,r2,min);
	while(min.prov<>valor) do begin
		read(mae,i);
		while(i.prov<>min.prov) do
			read(mae,i);
		while(i.prov=min.prov) do begin
			i.cant:=i.cant+min.cant;
			i.encuestados:=i.encuestados+min.encuestados;
			minimo(det1,det2,r1,r2,min);
		end;
		seek(mae,filepos(mae)-1);
		write(mae,i);
	end;
	close(mae);
	close(det1);
	close(det2);
end;
procedure imprimirMaestro(var mae: maestro);
var
    i:info;
begin
    reset(mae);
    while(not eof(mae)) do begin
            read(mae, i);
            writeln('provincia=', i.prov, ' Alfabetizados=', i.cant, ' Encuestados=', i.encuestados);
        end;
    close(mae);
end;

var
	mae:maestro;
	det1:detalle;
	det2:detalle;
begin
	cargarMaestro(mae);
	cargarDetalle(det1);
	cargarDetalle(det2);
	imprimirMaestro(mae);
	actualizar(mae,det1,det2);
	imprimirMaestro(mae);
end.
