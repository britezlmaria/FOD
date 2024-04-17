program p2ej16;
const
	dimF=10;
	valor=9999;
type
	moto=record
		cod,stock:integer;
		nombre,desc,modelo,marca:string[12];
	end;
	
	info=record
		cod:integer;
		precio:real;
		fecha:string;
	end;
	
	maestro=file of moto;
	detalle=file of infoDet;
	vecDet=array[1..dimF] of detalle;
	vecReg=array[1..dimF] of infoDet;
	
procedure cargarMaestro(var mae:maestro);
var
	txt:Text;
	nombre:string[12];
	m:moto;
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
		readln(txt, m.cod, m.stock, m.nombre);
        readln(txt, m.modelo);
        readln(txt, m.marca);
        readln(txt, m.desc);
        write(mae, m);
    end;
    close(mae);
    close(txt);
end;

procedure cargarDetalle(var det:detalle);
var
	txt:Text;
	nombre:string[12];
	i:info;
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
		readln(txt,i.cod,i.precio,i.fecha);
		write(det,i);
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

procedure leer(var det:detalle;var i:info);
begin
	if not eof(det) then 
		read(det,i)
	else
		i.cod:=valor;
end;

procedure minimo(var vd:vecDet;var vr:vecReg;var min:venta);
var
	i,pos:integer;
begin
	min.cod:=valor;
	for i:=1 to dimf do begin
		if(vr[i].cod<min.cod) do begin
			min:=vr[i];
			pos:=i;
		end;
	end;
	if(min.cod<>valor) then 
		leer(vd[pos],vr[pos]);
end;
	
procedure actualizar(var mae:maestro;var v:vecDet);
var
	cant,codMax,max,i:integer;
	vr:vecReg;
	m:moto;min:info;
begin
	max:=-1;
	codMax:=-1;
	for i:=1 to dimF do begin
		reset(v[i]);
		leer(v[i],vr[i]);
	end;
	minimo(v,vr,min);
	read(mae,m);
	while(min.cod<>valor) do begin
		while(m.cod<>min.cod) do 
			read(mae,m);
		cant:=0;
		while(m.cod=min.cod) do begin
			m.stock:=m.stock-1;
			cant:=cant+1;
			minimo(v,vr,min);
		end;
		if(cant>max) then begin
			max:=cant;
			codMax:=m.cod;
		end;
		seek(mae,filePos(mae)-1);
		write(mae,m);
	end;
	writeln('el codigo de la moto mas vendida es:',codMax);
	close(mae);
	for i:= 1 to dimF do 
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
	end;
	
