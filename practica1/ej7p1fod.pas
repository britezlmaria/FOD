program p1ej7;

type
	novela=record
		cod:integer;
		nombre,genero:string[12];
		precio:real;
	end;
	
	archivo= file of novela;

procedure leerNovela(var n:novela);
begin
	writeln('ingrese el codigo:');
	readln(n.cod);
	if(n.cod<>-1) then begin
		writeln('ingrese el precio:');
		readln(n.precio);
		writeln('ingrese el genero:');
		readln(n.genero);
		writeln('ingrese el nombre:');
		readln(n.nombre);
	end;
end;

procedure imprimir(n:novela);
begin
	writeln('el codigo es:',n.cod,
	'el precio es:',n.precio,
	'el genero es:',n.genero,
	'el nombre es:',n.nombre);
end;


procedure cargar(var arch:archivo);
var
	txt:Text;
	n:novela;
	nombre:string[12];
begin
	assign(txt,'novelas.txt');
	reset(txt);
	writeln('ingrese un nombre para el archivo binario:');
	readln(nombre);
	assign(arch,nombre);
	rewrite(arch);
	while not eof(txt) do begin
		readln(txt,n.cod,n.precio,n.genero);
		readln(txt,n.nombre);
		write(arch,n);
	end;
	close(txt);
	close(arch);
end;

procedure agregar(var arch:archivo);
var
	n:novela;
begin
	reset(arch);
	seek(arch,filesize(arch));
	leerNovela(n);
	if(n.cod<>-1)  then 
		write(arch,n)
	else
		writeln('no se ha podido incorporar la novela debido a que el codigo es -1');
	close(arch);
end;

procedure modificar(var arch:archivo);
var
	cod:integer;
	n:novela;ok:boolean;
begin
	ok:=false;
	reset(arch);
	writeln('ingrese el codigo de la novela que desea modificar:');
	readln(cod);
	while not eof(arch) and not ok do begin
		read(arch,n);
		if(n.cod = cod) then begin
			ok:=true;
			writeln('ingrese los nuevos datos');
			leerNovela(n);
			seek(arch,filePos(arch)-1);
			write(arch,n);
		end;
	end;
	if(not ok) then 
		writeln('no se encontro el codigo de la novela que se desea modificar');
	close(arch);
end;

procedure exportar(var arch:archivo);
var 
    txt:Text;
    n:novela;
begin 
    assign(txt,'novelas.txt');
    rewrite(txt);
    reset(arch);
    while (not eof(arch)) do 
        begin 
            read(arch, n);
            writeln(txt,n.cod,' ',n.precio:0:2,' ',n.genero);
            writeln(txt,n.nombre);
        end;
    close(arch);
    close(txt);
end;

procedure runMenu(var arch:archivo);
var
	opcion:integer;ok:boolean;
begin
	ok:=false;
	while not ok do begin
		writeln('Ingrese la operacion deseada:');
            writeln('1 - Cargar datos.');
            writeln('2 - Agregar novela.');
            writeln('3 - Modificar novela.');
            writeln('4 - Exportar datos.');
            writeln('5 - Finalizar programa.');
			readln(opcion);
			case opcion of
				1: cargar(arch);
				2: agregar(arch);
				3: modificar(arch);
				4: exportar(arch);
				5: ok:=true;
			end;
	end;
end;

var
	arch:archivo;
begin
	cargar(arch);
	runMenu(arch);
end.

		

