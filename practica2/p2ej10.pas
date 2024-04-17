program p2ej10;
const
	dimF=15;
	valor=999;
type
	empleado=record
		dep,division,nro,horas:integer;
		cat:integer;
	end;
	maestro=file of empleado;
	vector= array[1..dimF]of real;
	
procedure cargarVector(var v:vector);
var
	txt:Text;nombre:string[12];
	cat:integer;monto:real;
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	while not eof(txt) do begin
		read(txt,cat,monto);
		v[cat]:=monto;
	end;
	close(txt);
end;

procedure cargarMaestro(var mae:maestro);
var
	txt:Text;nombre:string[12];e:empleado;
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	while not eof(txt) do begin
		read(txt,e.dep,e.division,e.nro,e.horas,e.cat);
		write(mae,e);
	end;
	close(mae);
	close(txt);
end;
procedure leer(var mae:maestro;var e:empleado);
begin
	if not eof(mae) then 
		read(mae,e)
	else
		e.dep:=valor;
end;

procedure mostrar(var mae:maestro;v:vector);
var
	dep,division:integer;
	e:empleado;
	horasDiv,totalDep,horasTot:integer;
	montoTotDep,montoTotDiv,montoTot:real;
	empAct,catAct:integer;
begin
	leer(mae,e);
	while(e.dep<>valor) do begin
		dep:=e.dep;
		totalDep:=0;
		montoTotDep:=0;
		writeln('departamento:',e.dep);
		while(e.dep=dep) do begin
			division:=e.division;
			horasDiv:=0;
			montoTotDiv:=0;
			writeln('division:',e.division);
			writeln('numero empleado ','','horas totales','','importe a cobrar');
			while(e.dep=dep) and (e.division=division) do begin
				montoTot:=0;
				horasTot:=0;
				empAct:=e.nro;
				catAct:=e.cat;
				while(e.dep=dep) and (e.division=division) and (e.nro=empAct) do begin
					horasTot:=horasTot+e.horas;
					leer(mae,e);
				end;
				montoTot:=v[catAct]*horasTot;
				writeln(empAct,' ',horasTot,' ',montoTot);
				horasDIv:=horasDiv+horasTot;
				montoTotDiv:=montoTotDiv+montoTot;
			end;
			writeln('total horas por division:',horasDiv);
			writeln('monto total por division:',montoTotDiv);
			totalDep:=totalDep+horasDiv;
			montoTotDep:=montoTotDep+montoTotDiv;
		end;
		writeln('total horas departamento:',totalDep);
		writeln('monto total depto:',montoTotDep);
	end;
	close(mae);
end;

var
	mae:maestro;
	v:vector;
begin
	cargarVector(v);
	cargarMaestro(mae);
	mostrar(mae,v);
end.
				
