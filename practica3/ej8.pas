program p3ej8;

type
	distribucion=record
		anio,cant,version:integer;
		nombre,desc:string;
	end;
	
	archivo=file of distribucion;
	
procedure leerDistribucion(var d: distribucion);
begin
    writeln('Ingrese el nombre de la distribucion');
    readln(d.nombre);
    if(d.nombre <> 'fin') then
        begin
            writeln('Ingrese el anio de lanzamiento');
            readln(d.anio);
            writeln('Ingrese el numero de version de kernel');
            readln(d.version);
            writeln('Ingrese la cantidad de desarrolladores');
            readln(d.cant);
            writeln('Ingrese la descripcion');
            readln(d.desc);
        end;
end;

procedure crearArchivo(var arc: archivo);
var
    d: distribucion;
begin
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    d.nombre:= '';
    d.cant:= 0;
    d.anio:= 0;
    d.version:= 0;
    d.desc:= '';
    write(arc, d);
    leerDistribucion(d);
    while(d.nombre <> 'fin') do
        begin
            write(arc, d);
            leerDistribucion(d);
        end;
    close(arc);
end;

function existeDistribucion(var arch:archivo;nombre:string):boolean;
var
	ok:boolean;
	d:distribucion;
begin
	reset(arch);
	ok:=false;
	while not eof and not ok do begin
		read(arch,d);
		if(d.nombre=nombre) then 
			ok:=true;
	end;
	close(arch);
	existeDistribucion:=ok;
end;

procedure altaDistribucion(var arch:archivo);
var
	d,cabecera:distribucion;
begin
	leerDistribucion(d);
	if(not existeDistribucion(arch,d.nombre)) then begin
		reset(arch);
		read(arch,cabecera);
		if(cabecera.cant=0) then begin
			seek(arch,filesize(arch));
			write(arch,d);
		end
		else begin
			seek(arch,cabecera.cant*(-1));
			read(arch,cabecera);
			seek(arch,filepos(arch)-1);
			write(arch,d);
			seek(arch,0);
			write(arch,cabecera);
			close(arch);
		end;
	end
	else
		writeln('ya existe la distribucion');
end;

procedure bajaDistribucion(var arch:archivo);
var
	d,cabecera:distribucion;
	nombre:string;
begin
	writeln('ingrese el nombre del archivo a dar de baja:');
	readln(nombre);
	if(existeDistribucion(arch,nombre)) then begin
		reset(arch);
		read(arch,cabecera);
		read(arch,d);
		while(d.nombre<>nombre) do 
			read(arch,d);
		seek(arch,filepos(arch)-1);
		write(arch,cabecera);
		cabecera.cant:=cabecera.cant * (-1);
		seek(arch,0);
		write(arch,cabecera);
		close(arch);
	end
	else
		writeln('no existe esa distribucion');
end;
procedure imprimirArchivo(var arc: archivo);
var
    d: distribucion;
begin
    reset(arc);
    while(not eof(arc)) do
        begin
            read(arc, d);
            writeln('Nombre=', d.nombre, ' Cant=', d.cant);
        end;
    close(arc);
end;

var
    arc: archivo;
begin
    crearArchivo(arc);
    writeln('Archivo original:');
    imprimirArchivo(arc);
    altaDistribucion(arc);
    writeln('Archivo con un alta');
    imprimirArchivo(arc);
    bajaDistribucion(arc);
    writeln('Archivo con una baja');
    imprimirArchivo(arc);
end.

		
		
		

