program p2ej15;
const
	dimF=100;
	valor='ZZZ';
type
	emision=record
		fecha,nombre,desc:string[12];
		cod,tot,vendidos:integer;
		precio:real;
	end;
	
	venta=record
		fecha:string[12];
		cod,vendidos:integer;
	end;
	
	maestro=file of emision;
	detalle=file of venta;
	vecDet=array[1..dimF] of detalle;
	vecReg=array[1..dimF] of venta;
	
procedure cargarMaestro(var mae:maestro);
var
	txt:Text;
	nombre:string[12];
	e:emision;
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
		readln(txt,e.cod,e.precio,e.tot,e.vendidos,e.fecha);
		readln(txt,e.nombre);
		readln(txt,e.desc);
		write(mae,e);
	end;
	close(mae);
	close(txt);
end;

procedure cargarDetalle(var det:detalle);
var
	txt:Text;
	nombre:string[12];
	v:venta;
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo maestro:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	while not eof(txt) do begin
		readln(txt,v.cod,v.vendidos,v.fecha);
		write(det,v);
	end;
	close(txt);
	close(det);
end;

procedure cargarDetalles(var v:vecDet);
var
	i:integer;
begin
	for i:=1 to dimF do
		cargarDetalle(v[i]);
end;

procedure leer(var det:detalle;var v:venta);
begin
	if not eof(det) then 
		read(det,v)
	else
		v.fecha:=valor;
end;

procedure minimo(var vd:vecDet;var vr:vecReg;var min:venta);
var
	i,pos:integer;
begin
	min.fecha:=valor;
	for i:=1 to dimf do begin
		if(vr[i].fecha<min.fecha) or ((vr[i].fecha=min.fecha) and (vr[i].cod<min.cod)) do begin
			min:=vr[i];
			pos:=i;
		end;
	end;
	if(min.fecha<>valor) then 
		leer(vd[pos],vr[pos]);
end;

procedure actualizar(var mae:maestro;var v:vecDet);
var
	mini,max,i,cant:integer;
	ven:venta;e:emision;
	vr:vecReg;
	min:venta;
	fechaMax,fechaMin:string[12];
	codMax,codMin:integer;
begin
	max:=-1;
	mini:=9999;
	fechaMin:='';
	fechaMax:='';
	codMax:=-1;
	codMin:=9999;
	for i:=1 to dimF do begin
		reset(v[i]);
		leer(v[i],vr[i]);
	end;
	minimo(v,vr,min);
	read(mae,e);
	while(min.fecha<>valor) do begin
		while(e.fecha<>min.fecha) do 
			read(mae,e);
		while(e.fecha=min.fecha) do begin
			while(e.cod<>min.cod) do 
				read(mae,e);
			cant:=0;
			while (e.fecha=min.fecha) and (e.cod=min.cod) do begin
				e.vendidos:=e.vendidos+min.vendidos;
				e.tot:=e.tot-min.vendidos;
				cant:=cant+min.vendidos;
				minimo(v,vr,min);
			end;
			if(cant>max) then begin
				max:=cant;
				fechaMax:=e.fecha;
				codMax:=e.cod;
			end;
			if(cant<mini) then begin
				mini:=cant;
				fechaMin:=e.fecha;
				codMin:=e.cod;
			end;
			seek(mae,filPos(mae)-1);
			write(mae,e);
		end;
	end;
	writeln('fecha y semanario que tuvo mas ventas:',fechaMax,',',codMax);
	writeln('fecha y semanario que tuvo menos ventas:',fechaMin,',',codMin);
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
			


