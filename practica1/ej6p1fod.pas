program p1ej6;

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

procedure agregar(var arch:archivo);
var
	c:celular;
begin
	reset(arch);
	seek(arch,fileSize(arch));
	leerCelular(c);
	while(c.cod<>-1) do begin
		write(arch,c);
		leerCelular(c);
	end;
	close(arch);
end;

procedure modificarStock(var arch:archivo);
var
	c:celular;
	id:string;
	stock:integer;
	ok:boolean;
begin
	ok:=false;
	writeln('ingrese el nombre del celular al que le quiere modificar el stock:');
	readln(id);
	reset(arch);
	while not eof(arch) and not ok do begin
		read(arch,c);
		if(c.nombre = id) then begin
			ok:=true;
			writeln('ingrese el nuevo stock:');
			readln(stock);
			seek(arch,filepos(arch)-1);
			c.stock:=stock;
		end;
	end;
	if not ok then 
		writeln('no se ha encontrado el codigo que busca');
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
procedure sinStock(var arch:archivo);
var
	c:celular;
	txt:Text;
begin
	reset(arch);
	assign(txt,'SinStock.txt');
	rewrite(txt);
	while not eof(arch) do begin
		read(arch,c);
		if(c.stock= 0) then begin
			writeln(txt,c.cod,c.precio:2:2,c.marca);
            writeln(txt,c.stock,c.stockmin,c.desc);
            writeln(txt,c.nombre);
        end;
    end;
    close(arch);
    close(txt);
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
		writeln('5:añadir uno o más celulares' );
		writeln('6: modificar el stock de un celular dado');
		writeln('7: exportar los celulares sin stock');
		writeln('8:finalizar el programa');
		readln(opcion);
		case opcion of
			1: cargar(arch);
			2: mostrar(arch);
			3: buscar(arch);
			4: exportar(arch);
			5: agregar(arch);
			6: modificarStock(arch);
			7: sinStock(arch);
			8: ok:=true;
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
	
