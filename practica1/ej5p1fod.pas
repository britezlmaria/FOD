program p1ej5;

type
	celular=record
		cod,stockmin,stock:integer;
		nombre,desc,marca:string[12];
		precio:real;
	end;
	
	archivo= file of celular;

procedure leerCelular(var c:celular);
begin
	writeln('ingrese el codigo:');
	readln(c.cod);
	if(c.cod<>-1) then begin
		writeln('ingrese el stock minimo:');
		readln(c.stockmin);
		writeln('ingrese el stock disponible:');
		readln(c.stock);
		writeln('ingrese el nombre:');
		readln(c.nombre);
		writeln('ingrese la descipcion:');
		readln(c.desc);
		writeln('ingrese la marca:');
		readln(c.marca);
		writeln('ingrese el precio:');
		readln(c.precio);
	end;
end;

procedure cargar(var arch:archivo);
var 
    nombre:string[12];
    txt:Text;
    c:celular;
begin 
    writeln;
    writeln('Cargando datos desde "celulares.txt".');
    write('Ingrese el nombre del archivo binario: ');
    readln(nombre);
    assign(arch, nombre);
    rewrite(arch);
    assign(txt,'celulares.txt');
    reset(txt);

    while (not eof(txt)) do 
        begin 
            readln(txt,c.cod,c.precio,c.marca);
            readln(txt,c.stock,c.stockmin,c.desc);
            readln(txt,c.nombre);
            write(arch, c);
        end;
    close(txt);
    close(arch);
end;

procedure imprimir(c:celular);
begin
	writeln('codigo:',c.cod,
	'stock minimo:',c.stockmin,
	'stock disponible:',c.stock,
	'precio:',c.precio,
	'nombre:',c.nombre,
	'marca:',c.marca,
	'descripcion:',c.desc);
end;

procedure mostrar(var arch:archivo);
var
	c:celular;
	ok:boolean;
begin
	ok:=false;
	reset(Arch);
	while(not eof(arch)) do begin 
		read(arch,c);
		if(c.stock<c.stockmin) then begin
			if(not ok) then begin
				writeln('los celulares con menos stock al minimo son:');
				ok:=true;
			end;
			imprimir(c);
		end;
	end;
	if(not ok) then 
		writeln('no se encontraron coincidencias');
	close(arch);
end;

procedure buscar(var arch:archivo);
var
	desc:string[12];c:celular;ok:boolean;
begin
	ok:=false;
	writeln('ingrese la descipcion a buscar:');
	readln(desc);
	reset(arch);
	while not eof(arch) do begin
		read(arch,c);
		if(c.desc = desc) then begin
			if(not ok) then begin
				writeln('las coincidencias encontradas son:');
				ok:=true;
			end;
			imprimir(c);
		end;
	end;
	if(not ok) then 
		writeln('no se encontraron coincidencias');
	close(arch);
end;

procedure exportar(var arch:archivo);
var 
    txt:Text;
    c:celular;
begin 
    assign(txt,'celulares.txt');
    rewrite(txt);
    reset(arch);
    while (not eof(arch)) do 
        begin 
            read(arch, c);
            writeln(txt,c.cod,' ',c.precio:0:2,' ',c.marca);
            writeln(txt,c.stock,' ',c.stockmin,' ',c.desc);
            writeln(txt,c.nombre);
        end;
    close(arch);
    close(txt);
end;
		
procedure runMenu(var arch:archivo);
var
	opcion:integer;ok:boolean;
begin
	ok:=false;
	while (not ok) do begin
		writeln('ingrese la opcion deseada:');
		writeln('1:cargar datos');
		writeln('2:mostrar celulares con stock menor al minimo');
		writeln('3:buscar una descripcion:');
		writeln('4:exportar archivo');
		writeln('5:finalizar el programa');
		readln(opcion);
		case opcion of
			1: cargar(arch);
			2: mostrar(arch);
			3: buscar(arch);
			4: exportar(arch);
			5: ok:=true;
		else
			writeln('la operacion deseada es invalida');
		end;
	end;
end;

var
	arch:archivo;
begin
	cargar(arch);
	runMenu(arch);
end.
	
	


