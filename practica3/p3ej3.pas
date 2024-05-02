program p3ej3;

type
	novela=record
		cod:integer;
		genero,nombre,director,duracion:string;
		precio:real;
	end;
	archivo=file of novela;
	
procedure leerNovela(var n:novela);
begin
	writeln('ingrese el codigo de novela:');
	readln(n.cod);
	if(n.cod<>-1) then begin
		writeln('ingrese el genero:');
		readln(n.genero);
		writeln('ingrese el nombre:');
		readln(n.nombre);
		writeln('ingrese el director:');
		readln(n.director);
		writeln('ingrese la duracion:');
		readln(n.duracion);
		writeln('ingrese el precio:');
		readln(n.precio);
	end;
end;

procedure cargar(var arch:archivo);
var
	n:novela;
	nombre:string;
begin
	writeln('ingrese un nombre para el archivo:');
	readln(nombre);
	assign(arch,nombre);
	rewrite(arch);
	n.cod:=0;
	n.genero:='';
	n.nombre:='';
	n.duracion:='';
	n.director:='';
	n.precio:=0;
	write(arch,n);
	leerNovela(n);
	while(n.cod<>-1) do begin
		write(arch,n);
		leerNovela(n);
	end;
	close(arch);
end;

procedure alta(var arch:archivo);
var
	n,aux:novela;
begin
	reset(arch);
	read(arch,aux);
	leerNovela(n);
	if(aux.cod=0) then begin
		seek(arch,filesize(arch));
		write(arch,n);
	end
	else
		seek(arch,aux.cod*(-1));
		read(arch,aux);
		seek(arch,filePos(arch)-1);
		write(arch,n);
		seek(arch,0);
		write(arch,aux);
	close(arch);
end;
procedure modificarNovela(var n: novela);
var
    opcion: char;
begin
    writeln('MENU DE NOVELAS');
    writeln('Opcion A: Modificar la novela entera (el codigo no puede ser modificado)');
    writeln('Opcion B: Modificar el genero de la novela');
    writeln('Opcion C: Modificar el nombre de la novela');
    writeln('Opcion D: Modificar la duracion de la novela');
    writeln('Opcion E: Modificar el director de la novela');
    writeln('Opcion F: Modificar el precio de la novela');
    readln(opcion);
    case opcion of
        'A': 
            begin
                writeln('Ingrese el genero de la novela');
                readln(n.genero);
                writeln('Ingrese el nombre de la novela');
                readln(n.nombre);
                writeln('Ingrese la duracion de la novela');
                readln(n.duracion);
                writeln('Ingrese el director de la novela');
                readln(n.director);
                writeln('Ingrese el precio de la novela');
                readln(n.precio);
            end;
        'B': 
            begin
                writeln('Ingrese el genero de la novela');
                readln(n.genero);
            end;
        'C':
            begin
                writeln('Ingrese el nombre de la novela');
                readln(n.nombre);
            end;
        'D':
            begin
                writeln('Ingrese la duracion de la novela');
                readln(n.duracion);
            end;
        'E':
            begin
                writeln('Ingrese el director de la novela');
                readln(n.director);
            end;
        'F':
            begin
                writeln('Ingrese el precio de la novela');
                readln(n.precio);
            end;
    else
        writeln('Opcion invalida');
    end;
end;

procedure modificarNovela(var arch:archivo);
var
	cod:integer;
	n:novela;
	ok:boolean;
begin
	reset(arch);
	ok:=false;
	writeln('ingrese el codigo de la novela que quiere modificar:');
	readln(cod);
	while(not eof(arch)) and (not ok) do begin
		read(arch,n);
		if(n.cod=cod) then begin
			ok:=true;
			modificarNovela(n);
			seek(arch,filepos(arch)-1);
			write(arch,n);
		end;
	end;
	if not ok then 
		writeln('el codigo no se encontro en el archivo');
	close(arch);
end;


procedure baja(var arch:archivo);
var
	n,aux:novela;
	cod:integer;
	ok:boolean;
	pos:integer;
begin
	writeln('ingrese el codigo de la novela que desea eliminar:');
	readln(cod);
	ok:=false;
	while not eof(arch) and not ok do begin
		read(arch,aux);
		if(aux.cod=cod) then begin
			ok:=true;
			pos:=filePos(arch)-1;
			seek(arch,0);
			read(arch,n);
			seek(arch,0);
			aux.cod:=aux.cod*(-1);
			write(arch,aux);
			seek(arch,pos);
			write(arch,n);
		end;
	end;
	if(not ok) then 
		writeln('no se encontro el archivo a eliminar');
	close(arch);
end;
procedure pasarTxt(var arc: archivo);
var
    txt: text;
    n: novela;
begin
    reset(arc);
    seek(arc, 1);
    assign(txt, 'novelas.txt');
    rewrite(txt);
    while(not eof(arc)) do
        begin
            read(arc, n);
            if(n.cod < 1) then
                write(txt, 'Novela eliminada: ');
            write(txt, ' Codigo=', n.cod, ' Genero=', n.genero, ' Nombre=', n.nombre, ' Duracion=', n.duracion, ' Director=', n.director, ' Precio=', n.precio:0:2);
        end;
    writeln('Archivo de texto creado');
    close(arc);
    close(txt);
end;
procedure imprimirArchivo(var arc: archivo);
var
    n: novela;
begin
    reset(arc);
    while(not eof(arc)) do
        begin
            read(arc, n);
            if(n.cod < 1) then
                write('Novela eliminada: ');
            write('Codigo=', n.cod, ' Genero=', n.genero, ' Nombre=', n.nombre, ' Duracion=', n.duracion, ' Director=', n.director, ' Precio=', n.precio:0:2);
            writeln();
        end;
    close(arc);
end;
procedure menu();
var
    arc: archivo;
    opcion: integer;
begin
    writeln('MENU DE OPCIONES');
    writeln('Opcion 1: Crear el archivo');
    writeln('Opcion 2: Dar de alta una novela');
    writeln('Opcion 3: Modificar los datos de una novela');
    writeln('Opcion 4: Eliminar una novela');
    writeln('Opcion 5: Listar en un archivo de texto todas las novelas, incluyendo las borradas');
    writeln('Opcion 6: Imprimir archivo');
    writeln('Opcion 7: Salir del menu');
    readln(opcion);
    while(opcion <> 7) do
        begin
            case opcion of
                1: cargar(arc);
                2: alta(arc);
                3: modificarNovela(arc);
                4: baja(arc);
                5: pasarTxt(arc);
                6: imprimirArchivo(arc);
            else
                writeln('Opcion invalida');
            end;
            writeln('MENU DE OPCIONES');
            writeln('Opcion 1: Crear el archivo');
            writeln('Opcion 2: Dar de alta una novela');
            writeln('Opcion 3: Modificar los datos de una novela');
            writeln('Opcion 4: Eliminar una novela');
            writeln('Opcion 5: Listar en un archivo de texto todas las novelas, incluyendo las borradas');
            writeln('Opcion 6: Imprimir archivo');
            writeln('Opcion 7: Salir del menu');
            readln(opcion);
        end;
end;
begin
    menu;
end.


	

		
	
