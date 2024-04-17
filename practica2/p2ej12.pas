program p2ej12;
const
	valor=999;
type
	infoMae=record
		nro,mails:integer;
		nombreUsuario,nombre,apellido:string[12];
	end;
	
	infoDet=record
		nro:integer;
		cuentaDest,cuerpoMen:string;
	end;
	
	detalle=file of infoDet;
	maestro=file of infoMae;
	
procedure cargarMaestro(var mae:maestro);
var
	txt:Text;
	nombre:string[12];
	i:infoMae;
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo binario:');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	while not eof(mae) do begin
		read(txt,i.nro,i.mals,i.nombreUsuario,i.nombre,i.apellido);
		write(mae,i);
	end;
	close(mae);
	close(txt);
end;

procedure cargarDetalle(var det:detalle);
var
	txt:Text;nombre:string[12];
	i:infoDet;
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo detalle:');
	readln(nombre);
	assign(det,i);
	while not eof(txt) do begin
		read(txt,i.nro,i.cuentaDest,i.cuerpoMen);
	end;
	close(mae):
end;
procedure leer(var det:detalle;var i:infoDet);
begin
	if not eof(det) then 
		read(det,i)
	else
		i.nro:=valor;
end;

procedure actualizar(var mae:maestro;var det:detalle);
var
	usuario:integer;
	id:infoDet;
	cant:integer;
	im:infoMae;
begin
	leer(det,id);
	while(id.nro <> valor) do begin
		usuario:=id.nro;
		cant:=0;
		while(id.nro=usuario) do begin
			read(mae,im);
			while(im.nro<>usuario) do 
				read(mae,im);
			while(im.nro=usuario) do begin
				im.mails:=im.mails+1;
				leer(det,id);
			end;
			seek(mae,filepos(mae)-1);
			write(mae,im);
			writeln('nro usuario:',usuario,'cantidad de mensajes enviados:',im.mails);
		end;
	end;
	close(mae);
	close(det);
end;
var
	mae:maestro;
	det:detalle;
begin
	cargarDetalle(det);
	cargarMaestro(mae);
	actualizar(mae,det);
end.
			
