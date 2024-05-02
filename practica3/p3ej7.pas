program p3ej7;
const
	valor=999;
type
	aves=record
		cod:integer;
		nombre,familia,desc,zona:string;
	end;
	
	archivo=file of aves;
	

procedure leerAve(var a: aves);
begin
    writeln('Ingrese el codigo de especie');
    readln(a.cod);
    if(a.cod<> -1) then
        begin
            writeln('Ingrese el nombre de la especie');
            readln(a.nombre);
            writeln('Ingrese la familia de ave');
            readln(a.familia);
            writeln('Ingrese la descripcion de la especie');
            readln(a.desc);
            writeln('Ingrese la zona geografica de la especie');
            readln(a.zona);
        end;
end;
procedure crearArchivo(var arc: archivo);
var
    a: aves;
begin
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    leerAve(a);
    while(a.cod <> -1) do
        begin
            write(arc, a);
            leerAve(a);
        end;
    close(arc);
end;
procedure imprimirArchivo(var arc: archivo);
var
    a: aves;
begin
    reset(arc);
    while (not eof(arc)) do
        begin
            read(arc, a);
            writeln('Codigo=', a.cod, ' Nombre=', a.nombre);
        end;
    close(arc);
end;

procedure bajalogica(var arch:archivo);
var
	a:aves;
	cod:integer;
	ok:boolean;
begin	
	writeln('ingrese el codigo del ave a eliminar:');
	readln(cod);
	while(cod <>valor)do begin
		ok:=false;
		while not eof(arch) and not ok do begin
			read(arch,a);
			if(a.cod=cod) then 
				ok:=true;
		end;
		if ok then begin
			a.cod:=-1;
			seek(arch,filepos(arch)-1);
			write(arch,a);
		end
		else
			writeln('no se encontro la especie con codigo: ',cod);
		writeln('ingrese el codigo del ave a eliminar:');
	    readln(cod);
	 end;
	 close(arch);
end;

procedure leer(var arch:archivo;var a:aves);
begin
	if not eof(arch) then 
		read(arch,a)
	else
		a.cod:=valor;
end;

procedure eliminar(var arch:archivo);
var
	a:aves;
	pos:integer;
begin
	reset(arch);
	leer(arch,a);
	while(a.cod<>valor) do begin
		if(a.cod<0) then begin
			pos:=filepos(arch)-1;
			seek(arch,filesize(arch)-1);
			read(arch,a);
			if(a.cod<0) then begin
				while(a.cod<0) do begin
					seek(arch,filesize(arch)-1);
					Truncate(arch);
					seek(arch,filesize(arch)-1);
					read(arch,a);
				end;
			end;
			seek(arch,pos);
			write(arch,a);
			seek(arch,filesize(arch)-1);
			truncate(arch);
			seek(arch,pos);
		end;
		leer(arch,a);
	end;
	close(arch);
end;

var 
	arch:archivo;
begin
	crearArchivo(arch);
	writeln('archiov original:');
	imprimirArchivo(arch);
	writeln('');
	bajalogica(arch);
	eliminar(arch);
	writeln('archivo compactado:');
	imprimirArchivo(arch);
end.
			
					
	
