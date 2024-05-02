program ej3p1;

type
	empleado=record
		apellido,nombre:string;
		edad,dni,numero:integer;
	end;
	
	archivo=file of empleado;
	
procedure leerEmpleado(var e:empleado);
begin
	writeln('ingrese el apellido:');
	readln(e.apellido);
	if(e.apellido <> 'fin') then begin
		writeln('ingrese el nombre:');
		readln(e.nombre);
		writeln('ingrese la edad:');
		readln(e.edad);
		writeln('ingrese el dni:');
		readln(e.dni);
		writeln('ingrese numero:');
		readln(e.numero);
	end;
end;

procedure asignar(var arc_logico:archivo);
var
	arc_fisico:string[12];
begin
	writeln('ingrese nombre del archivo:');
	readln(arc_fisico);
	assign(arc_logico,arc_fisico);
end;

procedure cargar(var arc_logico:archivo);
var
	e:empleado;
begin
	rewrite(arc_logico);
	leerEmpleado(e);
	while(e.apellido<> 'fin') do begin
		write(arc_logico,e);
		leerEmpleado(e);
	end;
	close(arc_logico);
end;

procedure escribirEmp(e:empleado);
begin
	writeln('numero:',e.numero,
	'apellido:',e.apellido,
	'nombre:',e.nombre,
	'edad:',e.edad,
	'dni:',e.dni
	);
end;

procedure escribir(var arch:archivo);
var
	e:empleado;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch,e);
		escribirEmp(e);
	end;
	close(arch);
end;

procedure buscar(var arch:archivo);
var
	id:string[12];
	e:empleado;
begin
	writeln('ingrese nombre o apellido del empleado:');
	readln(id);
	reset(arch);
	while(not eof(arch)) do begin
		read(arch,e);
		if(e.nombre=id) or (e.apellido=id) then 
			escribirEmp(e);
	end;
	close(arch);
end;

procedure mayores(var arch:archivo);
var
	e:empleado;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch,e);
		if(e.edad>70) then 
			escribirEmp(e)
	end;
	close(arch);
end;
function buscar(var arch:archivo;numero:integer):boolean;
var
	e:empleado;
	ok:boolean;
begin
	ok:=false;
	reset(arch);
	while(not eof(arch)) do begin
		read(arch,e);
		if(numero=e.numero) then 
			ok:=true;
	end;
	close(arch);
	buscar:=ok;
end;
procedure actualizar(var arch:archivo);
var
	e:empleado;
begin
	reset(arch);
	leerEmpleado(e);
	while(e.apellido<>'fin') do begin
		if(not buscar(arch,e.numero)) then begin
			seek(arch,fileSize(arch));
			write(arch,e);
		end
		else
			writeln('ya existe el numero ingresado');
		leerEmpleado(e);
	end;
	close(arch);
end;

procedure sumar(e:empleado);
var
	nro:integer;
begin
	writeln('ingrese el numero que le quiere sumar:');
	readln(nro);
	e.edad:=e.edad+nro;
	writeln('la edad ahora es:',e.edad);
end;
procedure restar(e:empleado);
var
	nro:integer;
begin
	writeln('ingrese el numero que le quiere restar:');
	readln(nro);
	e.edad:=e.edad-nro;
	writeln('la edad ahora es:',e.edad);
end;

procedure modificar(var arch:archivo);
var
	e:empleado;
	nro,opcion:integer;
	ok:boolean;
begin
	ok:=false;
	writeln('ingrese el numero de empleado:');
	readln(nro);
	reset(arch);
	while(not eof(arch)) and not ok do begin
		read(arch,e);
		if(e.numero=nro) then begin
			ok:=true;
			writeln('ingrese como quiere modificar la edad:');
			writeln('1-sumarle a la edad');
			writeln('2-restarle a la edad');
			readln(opcion);
			case opcion of
				1: sumar(e);
				2: restar(e);
			end;
		end;
	end;
	if not ok then 
		writeln('el numero ingresado no corresponde a ningun empleado');
end;

procedure exportar(var arch:archivo);
var
	txt:Text;e:empleado;
begin
	reset(arch);
	assign(txt,'todos_empleados.txt');
	rewrite(txt);
	while not eof(arch) do begin
		read(arch,e);
		write(txt,e.apellido,e.nombre,e.dni,e.edad,e.numero);
	end;
	close(arch);
	close(txt);
end;
	
procedure sinDni(var arch:archivo);
var
	texto:Text;e:empleado;
begin
	reset(arch);
	assign(texto,'faltaDNIEmpleado.txt');
	rewrite(texto);
	while not eof(arch) do begin
		read(arch,e);
		if(e.dni = 00) then 
			write(texto,e.apellido,e.nombre,e.dni,e.edad,e.numero);
	end;
	close(arch);
	close(texto);
end;
procedure eliminar(var arch:archivo);
var
	posFound,posFinal,aux:integer;
	e:empleado;found:boolean;
begin
	found:=false;
	writeln('ingrese el numero de empleado que desea eliminar:');
	readln(aux);
	reset(arch);
	while not eof(arch) and not found do begin
		read(arch,e);
		if(e.numero=aux) then 
			found:=true;
	end;
	if (found) then begin
		posFound:=filePos(arch)-1;
		posFinal:=fileSize(arch)-1;
		
		seek(arch,posFinal);
		read(arch,e);
		
		seek(arch,posFound);
		write(arch,e);
		
		seek(arch,posFinal);
		Truncate(arch);
	end
	else
		writeln('numero no encontrado');
	close(arch);
end;

	
procedure runMenu(var arch:archivo);
var
	num:integer;
	ok:boolean;
begin
	ok:=false;
	while(not ok) do begin
		writeln('ingrese la opcion deseada:');
		writeln('1-buscar empleado');
		writeln('2-mostrar empleados registrados');
		writeln('3-mostrar empleados mayores a 70');
		writeln('4-ingresar nuevos empleados');
		writeln('5-modificar edad de un empleado:');
		writeln('6-exportar a archivo de texto');
		writeln('7-exportar a archivo de texto los que no tengan cargado el dni');
		writeln('8-eliminar un registro');
		writeln('9-finalizar el programa');
		readln(num);
		case num of
			1: buscar(arch);
			2: escribir(arch);
			3: mayores(arch);
			4: actualizar(arch);
			5: modificar(arch);
			6: exportar(arch);
			7: sinDni(arch);
			8: eliminar(arch);
			9: ok:=true;
		else
			writeln('operacion invalida:');
		end;
	end;
end;
			
var
	arch:archivo;
begin
	asignar(arch);
	cargar(arch);
	runMenu(arch);
end.
