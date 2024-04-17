program ejercicio6;
const
    valor= 999;
    DF = 3;
type
    subRango = 1..DF;
    sesion = record
        cod: integer;
        tiempo: real;
        fecha: string;
    end;
    maestro = file of sesion;
    detalle = file of sesion;
    vecDet = array [subRango] of detalle;
    vecReg = array [subRango] of sesion;
procedure crearUnSoloDetalle(var det: detalle);
var
    carga: text;
    nombre: string;
    s: sesion;
begin
    writeln('Ingrese la ruta del detalle');
    readln(nombre);
    assign(carga, nombre);
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do begin
		readln(carga,s.cod);
		readln(carga,s.tiempo);
		readln(carga,s.fecha);
		write(det,s);
	end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure crearDetalles(var vec: vecDet);
var
    i: subrango;
begin
    for i:= 1 to DF do
        crearUnSoloDetalle(vec[i]);
end;

procedure leer(var det:detalle;var s:sesion);
begin
	if not eof(det) then 
		read(det,s)
	else
		s.cod:=valor;
end;

procedure minimo(var vr:vecReg;var v:vecDet;var min:sesion);
var
	i,pos:integer;
begin
	min.cod:=valor;
	min.fecha:='ZZZ';
	for i :=1 to DF do begin
		if(vr[i].cod<min.cod) or (vr[i].cod=min.cod) and (vr[i].fecha<min.fecha) then begin
			min:=vr[i];
			pos:=i;
		end;
	if(min.cod<>valor) then
		leer(v[pos],vr[pos]);
	end;
end;

procedure crearMaestro(var mae:maestro;var v:vecDet);
var
	i:integer;
	vr:vecReg;
	min,aux:sesion;
begin
	assign(mae,'archmae');
	rewrite(mae);
	for i:=1 to DF do begin
		reset(v[i]);
		leer(v[i],vr[i]);
	end;
	minimo(vr,v,min);
	while(min.cod<>valor) do begin
		aux.cod:=min.cod;
		while(min.cod=aux.cod) do begin
			aux.fecha:=min.fecha;
			aux.tiempo:=0;
			while(aux.cod=min.cod) and (aux.fecha=min.fecha) do begin
				aux.tiempo:=aux.tiempo+min.tiempo;
				minimo(vr,v,min);
			end;
			write(mae,aux);
		end;
	end;
	close(mae);
	for i:=1 to DF do
		close(v[i]);
end;

procedure imprimirMaestro(var mae:maestro);
var
	s:sesion;
begin
	while not eof(mae) do begin
		read(mae,s);
		writeln('codigo:',s.cod,'tiempo:',s.tiempo,'fecha:',s.fecha);
	end;
end;

var
	mae:maestro;
	v:vecDet;
begin
	crearDetalles(v);
	crearMaestro(mae,v);
	imprimirMaestro(mae);
end.
