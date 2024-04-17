program p2ej7; 
const
	dimF=2;
	valor=9999;
type
	infoDet=record
		loc,cepa,activos,nuevos,recuperados,fallecidos:integer;
	end;
	
	infoMae=record
		loc,cepa,activos,nuevos,recuperados,fallecidos:integer;
		nombreLoc,nombreCepa:string;
	end;
	
	maestro=file of infoMae;
	detalle=file of infoDet;
	vecReg=array[1..dimF] of infoDet;
	vecDet=array [1..dimF] of detalle;
	
procedure cargarDet(var det:detalle);
var
	nombre:string[12];
	i:infoDet;
	txt:Text;
begin
	writeln('ingrese una referencia:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo binario detalle:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	while not eof(txt) do begin
		read(txt,i.loc,i.cepa,i.activos,i.nuevos,i.recuperados,i.fallecidos);
		write(det,i);
	end;
	close(txt);
	close(det);
end;

procedure crearDetalles(var v:vecDet);
var
	i:integer;
begin
	for i:= 1 to dimF do 
		cargarDet(v[i]);
end;

procedure crearMaestro(var mae:maestro);
var
	txt:Text;
	nombre:string[12];
	i:infoMae;
begin
	writeln('ingrese una referencia:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo binario maestro:');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	while not eof(txt) do begin
		readln(txt,i.loc,i.cepa,i.activos,i.nuevos,i.recuperados,i.fallecidos,i.nombreLoc,i.nombreCepa);
		write(mae,i);
	end;
	close(txt);
	close(mae);
end;

procedure leer(var det:detalle;var i:infoDet);
begin
	if not eof(det) then 
		read(det,i)
	else
		i.loc:=valor;
end;
	
procedure minimo(var v:vecDet;var vr:vecReg;min:infoDet);
var
	i,pos:integer;
begin
	min.loc:=valor;
	for i:= 1 to dimF do begin
		if(vr[i].loc<min.loc) or ((vr[i].loc=min.loc) and (vr[i].cepa<min.cepa)) then begin
			min:=vr[i];
			pos:=i;
		end;
	end;
	if(min.loc<>valor) then 
		leer(v[pos],vr[pos]);
end;

procedure actualizar(var mae:maestro;var v:vecDet);
var
	vr:vecReg;
	i:integer;
	cantLoc,cant:integer;
	inf:infoMae;
	min:infoDet;
begin
	reset(mae);
	for i:=1 to dimF do begin
		reset(v[i]);
		leer(v[i],vr[i]);
	end;
	cantLoc:=0;
	minimo(v,vr,min);
	read(mae,inf);
	while(min.loc<>valor) do begin
		cant:=0
		while(inf.loc<>min.loc) do 
			read(mae,inf);
		while(inf.loc=min.loc) do begin
			while(inf.cepa<>min.cepa) do begin
				read(mae,inf);
			while(inf.loc=min.loc) and (inf.cepa=min.cepa) do begin
				inf.fallecidos:=inf.fallecidos+min.fallecidos;
				inf.recuperados:=inf.recuperados+min.recuperados;
				inf.activos:=inf.activos+min.activos;
				inf.nuevos:=inf.nuevos+min.nuevos;
				cant:=cant + 1;
				minimo(v,vr,min);
			end;
			seek(mae,filePos(mae)-1);
			write(mae,inf);
		end;
		writeln('la cantidad de cados de la localidad es:',cant);
		if(cant>50) then 
			cantLoc:=cantLoc+1;
	end;
	writeln('la cantidad de localidades con mas de 50 casos activos es:',cantLoc);
	close(mae);
	for i:=1 to dimF do 
		close(v[i]);
end;
	
procedure imprimirMaestro(var mae:maestro);
var
	i:infoMae;
begin
	reset(mae);
	while not eof(mae) do begin
		read(mae,i);
		writeln('codigo de localidad:',i.loc,'codigo de cepa:',i.cepa,'cantidad de casos activos:',i.activos,'cantidad de casos nuevos:',i.nuevos,'cantidad de casos recuperados:',i.recuperados,'fallecidos:',i.fallecidos,'nombre de loc:',i.nombreLoc,'nombre de cepa:',i.nombreCepa);
	end;
	close(mae);
end;

var
	mae:maestro;
	v:vecDet;
begin
	crearMaestro(mae);
	crearDetalles(v);
	actualizar(mae,v);
	imprimirMaestro(mae);
end.
