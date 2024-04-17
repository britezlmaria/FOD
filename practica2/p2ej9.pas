program p2ej9;
const
	valor=9999;
type
	info=record
		prov,loc,mesa,votos:integer;
	end;
	
	maestro=file of info;

procedure leer(var i:info);
begin
	writeln('ingrese el codigo de provincia:');
	readln(i.prov);
	if(i.prov<>-1) then begin
		writeln('ingrese el codigo de localidad:');
		readln(i.loc);
		writeln('ingrese el numero de mesa:');
		readln(i.mesa);
		writeln('ingrese la cantidad de votos:');
		readln(i.votos);
	end;
end;

procedure crearMaestro(var mae:maestro);
var
	i:info;
	nombre:string[12];
begin
	writeln('ingrese un nombre para el archivo:');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	leer(i);
	while i.prov<> -1 do begin
		write(mae,i);
		leer(i);
	end;
	close(mae);
end;
procedure leer(var mae:maestro;var i:info);
begin
	if not eof(mae) then 
		read(mae,i)
	else
		i.prov:=valor;
end;

procedure contar(var mae:maestro);
var
	provAct,locAct,votosProv,votosLoc,totalVotos:integer;
	i:info;
begin
	leer(mae,i);
	totalVotos:=0;
	while(i.prov<>valor) do begin
		provAct:=i.prov;
		votosProv:=0;
		while(i.prov=provAct) do begin
			locAct:=i.loc;
			votosLoc:=0;
			while(i.prov=provAct) and (i.loc=locAct) do begin
				votosLoc:=votosLoc+i.votos;
				leer(mae,i);
			end;
			writeln('la cantidad de votos de la localidad:',locAct,'es:',votosLoc);
			votosProv:=votosProv+votosLoc;
		end;
		writeln('la cantidad de votos de la provincia:',provAct,'es:',votosProv);
		totalVotos:=totalVotos+votosProv;
	end;
	writeln('el total general de votos es: ',totalVotos);
	close(mae);
end;

var
	mae:maestro;
begin
	crearMaestro(mae);
	contar(mae);
end.

	
	
