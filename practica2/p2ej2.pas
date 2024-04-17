program p2ej1;
const
	valor_alto=9999;
type
	alumno=record
		cod,sinFinal,conFinal:integer;
		apellido,nombre:string;
	end;
	
	aDet=record
		cod:integer;
		finalAp:integer;
	end;
	
	maestro=file of alumno;
	detalle=file of aDet;
	
procedure cargarMestro(var mae:maestro);  //no necesito hacerlo ya que se dispone pero para que compile
var
	txt:Text;
	nombre:string[12];
	a:alumno;
begin
	writeln('ingrese un nombre para el archivo binario de maestro:');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	assign(txt,'maestro.txt');
	reset(txt);
	while not eof(txt) do begin
		readln(txt,a.cod);
		readln(txt,a.sinFinal);
		readln(txt,a.conFinal);
		readln(txt,a.apellido);
		readln(txt,a.nombre);
		write(mae,a);
	end;
	close(mae);
	close(txt);
end;


procedure cargarDetalle(var det:detalle);
var
	txt:Text;
	nombre:string[12];
	d:aDet;
begin
	writeln('ingrese un nombre para el archivo binario de maestro:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	assign(txt,'detalle.txt');
	reset(txt);
	while not eof(txt) do begin
		readln(txt,d.cod);
		readln(txt,d.finalAp);
		write(det,d);
	end;
	close(det);
	close(txt);
end;

procedure leer(var det:detalle;var d:aDet);
begin
	if not eof(det) then  
		read(det,d)
	else
		d.cod:=valor_alto;
end;

procedure actualizar(var mae:maestro;var det:detalle);
var
	d:aDet; 
	a:alumno;
begin
	reset(mae);
	reset(det);
	leer(det,d);
	while(d.cod<>valor_alto) do begin
		read(mae,a);
		while(a.cod<>d.cod) do 
			read(mae,a);
		while (a.cod=d.cod) do begin
			if(d.finalAp>=6) then begin	
				a.conFinal:=a.conFinal+1;
				a.sinFInal:=a.sinFinal-1;
			end
			else
				a.sinFinal:=a.conFinal+1;
			leer(det,d);
		end;
		seek(mae,filePos(mae)-1);
		write(mae,a);
	end;
	close(mae);
	close(det);
end;

procedure exportar(var mae:maestro);
var
	txt:Text;
	a:alumno;
begin
	reset(mae);
	assign(txt,'maestro.txt');
	reset(txt);
	read(mae,a);
	while not eof(mae) do begin
		if(a.conFinal>a.sinFinal) then 
			write(txt,'codigo:',a.cod,'materias aprobadas sin final:',a.sinFinal,'materias aprobadas con final:',a.conFInal,'apellido:',a.apellido,'nombre:',a.nombre);
		read(mae,a);
	end;
	close(mae);
	close(txt);
end;

procedure runMenu(var mae:maestro;var det:detalle);
var
	opcion:integer;
	ok:boolean;
begin	
	ok:=false;
	while not ok do begin
		writeln('ingrese una opcion:');
		writeln('1-actualizar archivo');
		writeln('2-exportar archivo');
		writeln('3-finalizar programa');
		readln(opcion);
		case opcion of
			1: actualizar(mae,det);
			2: exportar(mae);
			3: ok:=true;
		end;
	end;
end;

var
	mae:maestro;
	det:detalle;
begin
	cargarMestro(mae);
	cargarDetalle(det);
	actualizar(mae,det);
	exportar(mae);
end.
	

