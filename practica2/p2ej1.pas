program p2ej1;
const
	valor_alto=9999;
	
type
	empleado=record
		cod:integer;
		nombre:string[12];
		monto:real;
	end;
	
	archivo=file of empleado;


procedure cargar(var detalle:archivo);
var
	txt:Text;
	e:empleado;
	nombre:string[12];
begin
	writeln('ingrese el nombre para el archivo detalle:');
	readln(nombre);
	assign(detalle,nombre);
	assign(txt,'empleados.txt');
	reset(txt);
	rewrite(detalle);
	while(not eof(txt)) do begin
		readln(txt,e.cod);
		readln(txt,e.nombre);
		readln(txt,e.monto);
		write(detalle,e);
	end;
	close(txt);
	close(detalle);
end;
procedure leer(var arch:archivo;var e:empleado);
begin
	if not eof(arch) then 
		read(arch,e)
	else
		e.cod:=valor_alto;
end;
procedure imprimir(var maestro:archivo);
var
	e:empleado;
begin
	reset(maestro);
	while not eof(maestro) do begin
		read(maestro,e);
		writeln('codigo de empleado:',e.cod,
		'nombre de empleado:',e.nombre,
		'monto total del empleado:',e.monto);
	end;
	close(maestro);
end;
procedure compactar(var detalle:archivo;var maestro:archivo);
var
	e,act:empleado;
	nombre:string[12];
begin
	writeln('ingrese el nombre para el archivo maestro:');
	readln(nombre);
	assign(maestro,nombre);
	rewrite(maestro);
	reset(detalle);
	leer(detalle,e);
	while e.cod<>valor_alto do begin
		act.cod:=e.cod;
		act.nombre:=e.nombre;
		act.monto:=0;
		while(act.cod=e.cod)and (e.cod<>valor_alto) do begin
			act.monto:=act.monto+e.monto;
			leer(detalle,e);
		end;
		write(maestro,act);
	end;
	close(maestro);
	close(detalle);
	imprimir(maestro);
end;

var
	detalle:archivo;
	maestro:archivo;
begin
	cargar(detalle);
	compactar(detalle,maestro);
end.
	

	
	
