program p3ej2;
const
	valor='@';
type
	asistente=record
		nro,tel,dni:integer;
		apellido,nombre,email:string;
	end;
	
	archivo=file of asistente;
	
procedure leerAsist(var a:asistente);
begin
	writeln('ingrese el nro de asistente:');
	readln(a.nro);
	if(a.nro<>-1) then begin
		writeln('ingrese el telefono:');
		readln(a.tel);
		writeln('ingrese el dni:');
		readln(a.dni);
		writeln('ingrese el apellido:');
		readln(a.apellido);
		writeln('ingrese el nombre:');
		readln(a.nombre);
		writeln('ingrese el email:');
		readln(a.email);
	end;
end;

procedure crearArch(var arch:archivo);
var
	nombre:string[12];
	a:asistente;
begin
	writeln('ingrese un nombre para el archivo:');
	readln(nombre);
	assign(arch,nombre);
	rewrite(arch);
	leerAsist(a);
	while(a.nro<>-1) do begin
		write(arch,a);
		leerAsist(a);
	end;
	close(arch);
end;

procedure eliminar(var arch:archivo);
var
	a:asistente;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,a);
		if(a.nro<1000) then 
			a.apellido:=valor+a.apellido;
		seek(arch,filePos(arch)-1);
		write(arch,a);
	end;
	close(arch);
end;

procedure imprimir(var arch:archivo);
var
	a:asistente;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,a);
		writeln('numero: ',a.nro,
		'telefono: ',a.tel,
		'dni:',a.dni,
		'apellido: ',a.apellido,
		'nombre: ',a.nombre,
		'email: ',a.email);
	end;
	close(arch);
end;

var
	arch:archivo;
begin
	crearArch(arch);
	imprimir(arch);
	eliminar(arch);
	writeln('-------------------------------------------------');
	imprimir(arch);
end.
		

