program p2ej14;
const
	dimF=10;
	valor=999;
type
	asistencia=record
		codProv,codLoc,sinLuz,sinGas,sinChapa,sinAgua,sinSan:integer;
		nombreProv,nombreLoc:string[12];
	end;
	infoDet=record
		codProv,codLoc,conLuz,construidas,conAgua,conGas,entregaSan:integer;
	end;
	
	maestro=file of asistencia;
	detalle=file of infoDet;
	vecDet=array[1..dimF] of detalle;
	vecReg=array[1..dimF] of infoDet;
	
procedure cargarMaestro(var mae:maestro);
var
	txt:Text;
	nombre:string[12];
	a:asistencia;
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
		readln(txt,a.codProv,a.codLoc,a.sinLuz,a.sinGas,a.sinChapa,a.sinAgua,a.sinSan);
		readln(txt,a.nombreProv,a.nombreLoc);
		write(mae,a);
	end;
	close(mae);
	close(txt);
end;

procedure cargarDetalle(var det:detalle);
var
	txt:Text;
	nombre:string[12];
	i:infoDet;
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo detalle:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	while not eof(txt) do begin
		readln(txt,a.codProv,a.codLoc,a.conLuz,a.conGas,a.construidas,a.conAgua,a.entregaSan);
		write(mae,a);
	end;
	close(det);
	close(txt);
end;

procedure cargarDetalles(var v:vecDet);
var
	i:integer;
begin
	for i:=1 to dimF do 
		cargarDetalle(v[i]);
end;
procedure leer(var det:detalle;var i:infoDet);
begin
	if not eof(det) then 
		read(det,i)
	else
		i.codProv:=valor;
end;

procedure minimo(var vd:vecDet;var vr:vecReg;var min:infoDet);
var
	i,pos:integer;
begin
	min.codProv:=valor;
	for i:=1 to dimF do begin
		if(vr[i].codProv<min.codProv) or ((vr[i].codProc=min.codProv and vr[i].codLoc<min.codLoc)) then begin
			min:=vr[i];
			pos:i;
		end;
	end;
	if(min.codProv<>Valor) then 
		leer(vd[pos],vr[pos]);
end;

procedure actualizar(var mae:maestro;var v:vecDet);
var
	a:asistencia;
	i,min:infoDet;
	cant:integer;
	vr:vecReg;
	i:integer;
begin
	cant:=0;
	for i:=1 to dimF do begin
		reset(v[i]);
		leer(v[i],vr[i]);
	end;
	minimo(v,vr,min);
	read(mae,a);
	while(min.codProv<>valor) do begin
		while(a.codProv<>min.codProv) do 
			read(mae,a);
		while(a.codProv=min.codProv) do begin
			while(a.codLoc<>min.codLoc) do 
				read(mae,a);
			while (a.codProv=min.codProv) and(a.codLoc=min.codLoc) do begin
				a.sinLuz:=a.sinLuz-min.conLuz;
				a.sinAgua:=a.sinAgua-min.conAgua;
				a.sinGas:=a.sinGas-min.conGas;
				a.sinSan:=a.sinSan-min.entregaSan;
				a.sinChapa:=a.sinChapa-min.construidas;
				minimo(v,vr,min);
			end;
			if(a.sinChapa=0) then 
				cant:=cant+1;
			seek(mae,filePos(mae)-1);
			write(mae,a);
		end;
	end;
	writeln('la cantidad de localidades sin viviendas de chapa es de: ',cant);
	close(mae);
	for i:=1 to dimF do
		close(v[i]);
end;

var
	mae:maestro;
	v:vecDet;
begin
	cargarMaestro(mae);
	cargarDetalles(v);
	actualizar(mae,v);
end.

