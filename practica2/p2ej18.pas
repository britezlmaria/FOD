program p2ej18;
const
	dimf=50;
	valor=9999;
type
	nacimiento=record
		partida,dniMadre,dniPadre:integer;
		nombre,apellido,direccion,matricula,nombreMadre,apellidoMadre,nombrePadre,apellidoPadre:string;
	end;
	
	fallecimiento=record
		partida,dni:integer;
		nombre,apellido,mat,fecha,hora,lugar:string;
	end;
	
	infoMae=record
		partida,dniMadre,dniPadre:integer;
		nombre,apellido,direccion,mat,nombreMadre,nombrePadre,apellidoMadre,apellidoPadre,matFirmaDeceso,fecha,hora,lugar:string;
		fallecio:boolean;
	end;

	detalleNac=file of nacimiento;
	detalleFac=file of fallecimiento;
	maestro=file of infoMae;
	vecDetNac=array[1..dimF] of detalleNac;
	vecDetFac=array[1..dimF]of detalleFac;
	vecNac=array[1..dimF] of nacimiento;
	vecFac=array[1..dimF] of fallecimiento;
	
procedure leerNac(var n:nacimiento);
begin
	writeln('Ingrese el numero de partida:');
    readln(n.partida);
    if(n.partida <> -1) then
        begin
            writeln('Ingrese el nombre del nacido:');
            readln(n.nombre);
            writeln('Ingrese el apellido del nacido:');
            readln(n.apellido);
            writeln('Ingrese la direccion:');
            readln(n.direccion);
            writeln('Ingrese la matricula de nacimiento:');
            readln(n.matricula);
            writeln('Ingrese el nombre y apellido de la madre:');
            readln(n.nombreMadre);
            readln(n.apellidoMadre);
            writeln('Ingrese el DNI de la madre:');
            readln(n.dniMadre);
            writeln('Ingrese el nombre y apellido del padre:');
            readln(n.nombrePadre);
            readln(n.apellidoPadre);
            writeln('Ingrese el DNI del padre:');
            readln(n.dniPadre);
        end;
end;
procedure leerFac(var f:fallecimiento);
begin
	writeln('Ingrese el numero de partida:');
    readln(f.partida);
    if(infoDetalle.partida <> -1) then
        begin
            writeln('Ingrese el dni del fallecido:');
            readln(f.dni);
            writeln('Ingrese el nombre del fallecido:');
            readln(f.nombre);
            writeln('Ingrese el apellido del fallecido:');
            readln(f.apellido);
            writeln('Ingrese la matricula de deceso:');
            readln(f.mat);
            writeln('Ingrese la fecha y hora de deceso:');
            readln(f.fecha);
            readln(f.hora);
            writeln('Ingrese el lugar de deceso:');
            readln(f.lugar);
        end;
end;

procedure crearDetNac(var det:detalleNac);
var
	n:nacimiento;
	nombre:string[12];
begin
	writeln('ingrese un nombre para el archivo detalle de nacimiento:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	leerNac(n);
	while(n.partida<>-1) do begin
		write(det,n);
		leerNac(n);
	end;
	close(det);
end;
procedure crearDetFac(var det:detalleFac);
var
	f:fallecimiento;
	nombre:string[12];
begin
	writeln('ingrese un nombre para el archivo detalle de nacimiento:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	leerFac(f);
	while(f.partida<>-1) do begin
		write(det,f);
		leerFac(f);
	end;
	close(det);
end;

procedure crearDetalles1(var v:vecDetNac);
var
	i:integer;
begin
	for i:=1 to dimF do 
		crearDetNac(v[i]);
end;

procedure cargarDetalles2(var v:vecDetFac);
var
	i:integer;
begin
	for i:=1 to dimF do
		crearDetFac(v[i]);
end;

procedure leerN(var det:detalleNac;var n:nacimiento);
begin
	if not eof(det) then 
		read(det,n)
	else
		n.partida:=valor;
end;

procedure leerF(var det:detalleFac;var f:fallecimiento);
begin
	if not eof(det) then 
		read(det,f)
	else
		f.partida:=valor;
end;

procedure minimoN(var vd:vecDetNac;var vn:vecNac;var min:nacimiento);
var
	i,pos:integer;
begin
	min.partida:=valor;
	for i:=1 to dimF do begin
		if(vn[i].partida<min.partida) then begin
			min:=vn[i];
			pos:=i;
		end;
	end;
	if(min.partida<>valor) then 
		leer(vd[pos],vn[pos]);
end;

procedure minimoF(var vd:vecDetFac;var vf:vecFac;var min:fallecimiento);
var
	i,pos:integer;
begin
	min.partida:=valor;
	for i:=1 to dimF do begin
		if(vf[i].partida<min.partida) then begin
			min:=vf[i];
			pos:=i;
		end;
	end;
	if(min.partida<>valor) then 
		leer(vd[pos],vf[pos]);
end;

procedure merge(var mae:maestro;var vdn:vecDetNac;var vdf:vecDetFac);
var
	nombre:string[12];
	vn:vecNac;
	vf:vecFac;
	act:infoMae;
	minNac:nacimiento;minFac:fallecimiento;
	i:integer;
begin
	for i:=1 to dimF do begin
		reset(vdn[i]);
		reset(dvf[i]);
		leerN(vdn[i],vn[i]);
		leerF(vdf[i],vf[i]);
	end;
	writeln('ingrese un nombre para el archivo maestro:');
	readln(nombre);
	assign(mae,nombre);
	minimoN(vdn,vn,minNac);
	minimoF(vdf,vf,minFac);
	while(minimoN.partida<>valor) do begin
		act.partida:=minNac.partida;
		act.nombre:=minNac.nombre;
		act.apellido:=minNac.apellido;
		act.direccion:=minNac.direccion;
		act.mat:=minNac.matricula;
		act.nombreMadre:=minNac.nombreMadre;
		act.apellidoMadre:=minNac.apellidoMadre;
		act.dniMadre:=minNac.dniMadre;
		act.nombrePadre:=minNac.nombrePadre;
		act.apellidoPadre:=minNac.apellidoPadre;
		act.dniPadre:=minNac.dniPadre;
		if(minimoN.partida=minNac.partida) then begin
			act.fallecio:=true;
			act.matFirmaDeceso:=minFac.mat;
			act.fecha:=minFac.fecha;
			act.hora:=minFac.hora;
			act.lugar:=minFac.lugar;
		end
		else
			act.fallecio:=false;
		write(mae,act);
		minimoN(vdn,vn,minNac);
		if(act.fallecio) then 
			minimoF(vdf,vf,minFac);
	end;
	for i:=1 to dimF do begin
		close(vdf[i]);
		close(vdn[i]);
	end;
	close(mae);
end;
var
	mae:maestro;
	vdn:vecDetNac;
	vdf:vecDetFac;
begin
	crearDetalles1(vdn);
	crearDetalles2(vdf);
	merge(mae,vdn,vdf);
end.
			
		
