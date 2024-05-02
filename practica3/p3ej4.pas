program p3ej4;
const
	valor=999;
type
	flor=record
		nombre:string[45];
		cod:integer;
	end;
	
	archivo=file of flor;
	
	
procedure leerFlor(var f: flor);
begin
    writeln('Ingrese el codigo de flor');
    readln(f.cod);
    if(f.cod <> -1) then
        begin
            writeln('Ingrese el nombre de flor');
            readln(f.nombre);
        end;
end;
procedure crearArchivo(var arc: archivo);
var
    f: flor;
begin
    assign(arc, 'ArchivoFlores');
    rewrite(arc);
    f.cod:= 0;
    f.nombre:= 'Cabecera';
    write(arc, f);
    leerFlor(f);
    while(f.cod <> -1) do
        begin
            write(arc, f);
            leerFlor(f);
        end;
    close(arc);
end;

procedure agregar(var arch:archivo;nombre:string;cod:integer);
var 
	f,cabecera:flor;
begin
	reset(arch);
	read(arch,cabecera);
	f.nombre:=nombre;
	f.cod:=cod;
	if(cabecera.cod=0) then begin
		seek(arch,filesize(arch));
		write(arch,f);
	end
	else begin
		seek(arch,cabecera.cod*(-1));
		read(arch,cabecera);
		seek(arch,filePos(arch)-1);
		write(arch,f);
		seek(arch,0);
		write(arch,cabecera);
	end;
	close(arch);
end;

procedure eliminar(var arch:archivo;fl:flor);
var
	f,cabecera:flor;
	ok:boolean;
begin
	reset(arch);
	read(arch,cabecera);
	ok:=false;
	while not eof(arch) and not ok do begin
		read(arch,f);
		if(f.cod=fl.cod) then begin
			ok:=true;
			seek(arch,filePos(arch)-1);
			write(arch,fl);
			cabecera.cod:=cabecera.cod*(-1);
			seek(arch,0);
			write(arch,cabecera);
		end;
	end;
	close(arch);
	if(not ok) then 
		writeln('no se encontro el archivo');
end;

procedure imprimir(var arch:archivo);
var
	f:flor;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,f);
		if(f.cod>0) then 
			writeln('codigo=',f.cod,'nombre=',f.nombre);
	end;
	close(arch);
end;

var
	arch:archivo;
	f:flor;
begin
	crearArchivo(arch);
	imprimir(arch);
	writeln('');
	writeln('----------------------------------------------------------');
	agregar(arch,'margarita',10);
	imprimir(arch);
	writeln('');
	writeln('----------------------------------------------------------');
	f.cod:=10;
	eliminar(arch,f);
	imprimir(arch);
	writeln('');
	writeln('----------------------------------------------------------');
	agregar(arch,'rosa',20);
	imprimir(arch);
end.
	


