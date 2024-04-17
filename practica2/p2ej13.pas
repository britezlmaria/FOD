program p2ej13;
const
	valor='ZZZ';
type
	vuelo=record
		asientosDisp:integer;
		fecha,hora,destino:string;
	end;
	infoDet=record
		destino,fecha,hora:string;
		asientosComp:integer;
	end;
	
	maestro=file of vuelo;
	detalle=file of infoDet;
	
	lista=^nodo;
	nodo=record
		dato:vuelo;
		sig:lista;
	end;
	
procedure cargarMaestro(var mae:maestro);
var
	v:vuelo;txt:Text;nombre:string[12];
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo maestro:');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	while not eof(txt) do begin
		read(txt,v.destino,v.asientosDisp,v.fecha,v.hora);
		write(mae,v);
	end;
	close(txt);
	close(mae);
end;

procedure cargarDetalle(var det:detalle);
var
	txt:Text;nombre:string[12];i:infoDet;
begin
	writeln('ingrese un ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo detalle:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	while not eof(txt) do  begin
		read(txt,i.destino,i.fecha,i.hora,i.asientosComp);
		write(det,i);
	end;
	close(txt);
	close(det);
end;
procedure agregarAdelante(var l:lista;var v:vuelo);
var
	nue:lista;
begin
	new(nue);
	nue^.dato:=v;
	nue^.sig:=l;
	l:=nue;
end;

procedure leer(var det:detalle;var i:infoDet);
begin
	if not eof(det) then 
		read(det,i)
	else
		i.destino:=valor;
end;

procedure minimo(var det1,det2:detalle;var i1,i2,min:infoDet);
begin
	if(i1.destino<i2.destino) then begin
		min:=i1;
		leer(det1,i1);
	end
	else begin
		min:=i2;
		leer(det2,i2);
	end;
end;

procedure actualizar(var mae:maestro;var det1,det2:detalle;var l:lista);
var
	i1,i2,min:infoDet;
	v:vuelo;
	cant:integer;
begin
	writeln('ingrese la cantidad de asientos disponibles:');
	readln(cant);
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1,i1);
	leer(det2,i2);
	minimo(det1,det2,i1,i2,min);
	while(min.destino<>valor) do begin
		read(mae,v);
		while(v.destino<>min.destino) do 
			read(mae,v);
		while(v.destino=min.destino) do begin
			while(v.fecha<>min.fecha) do 
				read(mae,v);
			while(v.destino=min.destino) and (v.fecha=min.fecha) do begin
				while(v.hora<>min.hora) do 
					read(mae,v);
				while (v.destino=min.destino) and (v.fecha=min.fecha) and (v.hora=min.hora) do begin
					v.asientosDisp:=v.asientosDisp-min.asientosComp;
					minimo(det1,det2,i1,i2,min);
				end;
				if(v.asientosDisp<cant) then 
					agregarAdelante(l,v);
				seek(mae,filePos(mae)-1);
				write(mae,v);
			end;
		end;
	end;
	close(mae);
	close(det1);
	close(det2);
end;

var
	mae:maestro;
	det1,det2:detalle;
	l:lista;
begin
	l:=nil;
	cargarMaestro(mae);
	cargarDetalle(det1);
	cargarDetalle(det2);
	actualizar(mae,det1,det2,l);
end.
