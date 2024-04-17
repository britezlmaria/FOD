program p2ej8;
const
	valor=999;
type
	cliente=record
		cod,anio,mes,dia:integer;
		apellido,nombre:string[12];
		monto:real;
	end;
	
	maestro=file of cliente;
	
procedure crearMaestro(var mae:maestro);
var
	txt:Text;
	nombre:string[12];
	c:cliente;
begin
	writeln('ingrese una referencia:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo binario:');
	readln(nombre);
	assign(mae,nombre);
	while not eof(txt) do begin
		readln(txt,c.cod);
		readln(txt,c.apellido);
		readln(txt,c.nombre);
		readln(txt,c.anio);
		readln(txt,c.dia);
		readln(txt,c.mes);
		readln(txt,c.monto);
		write(mae,c);
	end;
	close(mae);
	close(txt);
end;

procedure leer(var mae:maestro;var c:cliente);
begin
	if not eof(mae) then 
		read(mae,c)
	else
		c.cod:=valor;
end;

procedure recorrer(Var mae:maestro);
var
	totalMes,totalAnio,montoEmp:real;
	c:cliente;
	codAct,anioAct,mesAct:integer;
begin
	reset(mae);
	leer(mae,c);
	montoEmp:=0;
	while(c.cod<>valor) do begin
		codAct:=c.cod;
		writeln('codigo:',c.cod,'apellido:',c.apellido,'nombre:',c.nombre);
		while(c.cod=codAct) do begin
			anioAct:=c.anio;
			totalAnio:=0;
			writeln('anio:',c.anio);
			while(c.cod=codAct) and (c.anio=anioAct) do begin
				mesAct:=c.mes;
				totalMes:=0;
				while(c.cod=codAct) and (c.anio=anioAct) and (c.mes=mesAct) do begin
					totalMes:=totalMes+c.monto;
					leer(mae,c);
				end;
				if(mesAct<>0) then begin
					writeln('recaudado en el mes:',mesAct);
					totalAnio:=totalAnio+totalMes;
				end;
			writeln('recaudado en el anio:');
			montoEmp:=montoEmp+totalAnio;
		end;
		end;
	end;
	writeln('el total recaudado por la empresa es:',montoEmp);
	close(mae);
end;

var
	mae:maestro;
begin
	crearMaestro(mae);
	recorrer(mae);
end.

				
	
	

