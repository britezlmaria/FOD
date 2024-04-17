program p2ej11;
const
	valor=999;
type
	d=1..31;
	m=1..12;
	acceso=record
		anio,id:integer;
		mes:m;
		dia:d;
		tiempo:real;
	end;
	
	maestro=file of acceso;

procedure cargarMaestro(var mae:maestro);
var
	txt:Text;
	nombre:string[12];
	a:acceso;
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre :');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	while not eof(txt) do begin
		read(txt,a.anio,a.mes,a.id,a.dia,a.tiempo);
		write(mae,a);
	end;
	close(mae);
	close(txt);
end;

procedure leer(var mae:maestro;var a:acceso);
begin
	if not eof(mae) then 
		read(mae,a)
	else
		a.anio:=valor;
end;

procedure imprimir(var mae:maestro);
var
	anio,anioAct,mesAct,diaAct,idAct:integer;ok:boolean;
	tiempoDia,tiempoMes,tiempoAnio:real;
	a:acceso;
begin
	reset(mae);
	ok:=false;
	writeln('ingrese un anio:');
	readln(anio);
	leer(mae,a);
	while not eof(mae) and  not ok do begin
		if(a.anio=anio) then 
			ok:=true
		else
			leer(mae,a);
	end;
	if not ok then 
		writeln('anio no encontrado')
	else begin
		while (a.anio<>valor) do begin
			anioAct:=a.anio;
			tiempoAnio:=0;
			writeln('anio:',anioAct);
			while(a.anio=anioAct) do begin
				mesAct:=a.mes;
				tiempoMes:=0;
				writeln('mes:',mesAct);
				while (a.anio=anioAct) and (a.mes=mesAct) do begin
					diaAct:=a.dia;
					tiempoDia:=0;
					writeln('dia:',diaAct);
					while (a.anio=anioAct) and (a.mes=mesAct) and (a.dia=diaAct) do begin
						idAct:=a.id;
						while (a.anio=anioAct) and (a.mes=mesAct) and (a.dia=diaAct) and (a.id=idAct) do begin
							tiempoDia:=tiempoDia+a.tiempo;
							leer(mae,a);
						end;
						writeln('usuario:',idAct,'tiempo total de acceso en el dia:',diaAct,'mes:',mesAct);
					end;
					writeln('tiempo total acceso dia:',diaAct,'mes ',mesAct,':',tiempoDia);
					tiempoMes:=tiempoMes+tiempoDia;
				end;
				writeln('total tiempo de acceso mes:',mesAct,':',tiempoMes);
				tiempoAnio:=tiempoAnio+tiempoMes;
			end;
			writeln('total tiempo de acceso anio:',tiempoAnio);
		end;
	end;
	close(mae);
end;

var
	mae:maestro;
begin
	cargarMaestro(mae);
	imprimir(mae);
end.
						
		
			
		
