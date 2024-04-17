program p2ej3;
const
	valor=999;
type
	producto=record
		cod,stock,stockMin:integer;
		nombre:string[12];
		precio:real;
	end;
	
	venta=record
		cod,cant:integer;
	end;
	
	maestro=file of producto;
	detalle=file of venta;
	
procedure leerProducto(var p:producto);
begin
	writeln('ingrese el codigo de producto:');
	readln(p.cod);
	if(p.cod<>-1) then begin
		writeln('ingrese el stock del producto:');
		readln(p.stock);
		writeln('ingrese el stock minimo del producto:');
		readln(p.stockMin);
		writeln('ingrese el nombre del producto:');
		readln(p.nombre);
		writeln('ingrese el precio del producto:');
		readln(p.precio);
	end;
end;

procedure cargarMaestro(var mae:maestro);
var
	p:producto;
	nombre:string[12];
begin
	writeln('ingrese un nombre para el archivo binario:');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	leerProducto(p);
	while(p.cod<>-1) do begin
		write(mae,p);
		leerProducto(p);
	end;
	close(mae);
end;

procedure leerVenta(var v:venta);
begin
	writeln('ingrese el codigo de producto:');
	readln(v.cod);
	if(v.cod<>-1) then  begin
		writeln('ingrese la cantidad de unidades vendidas:');
		readln(v.cant);
	end;
end;

procedure cargarDetalle(var det:detalle);
var
	v:venta;
	nombre:string[12];
begin
	writeln('ingrese un nombre para el archivo binario detalle:');
	readln(nombre);
	assign(det,nombre);
	rewrite(det);
	leerVenta(v);
	while(v.cod<>-1) do begin
		write(det,v);
		leerVenta(v);
	end;
	close(det);
end;

procedure leer(var det:detalle;var v:venta);
begin
	if not eof(det) then 
		read(det,v)
	else
		v.cod:=valor;
end;

procedure actualizar(var mae:maestro;var det:detalle);
var
	v:venta;
	p:producto;
begin
	reset(mae);
	reset(det);
	leer(det,v);
	while(v.cod<>valor) do begin
		read(mae,p);
		while(p.cod<>v.cod) do
			read(mae,p);
		while (p.cod=v.cod) do begin
			if(v.cant>=p.stock) then 
				p.stock:=0
			else
				p.stock:=p.stock-v.cant;
			leer(det,v);
		end;
		seek(mae,filepos(mae)-1);
		write(mae,p);
	end;
	close(mae);
	close(det);
end;

procedure listar(var mae:maestro);
var
	txt:Text;p:producto;
begin
	assign(txt,'productos.txt');
	rewrite(txt);
	reset(mae);
	while not eof(mae) do begin
		read(mae,p);
		if(p.stock<p.stockMin) then 
			write(txt,'codigo:',p.cod,'stock actual:',p.stock,'stock minimo:',p.stockMin,'nombre:',p.nombre,'precio:',p.precio);
	end;
	close(mae);
	close(txt);
end;

procedure runMenu(var mae:maestro;var det:detalle);
var
	opcion:integer;
	ok:boolean;
begin	
	ok:=false;
	while not ok do begin
		writeln('ingrese una opcion:');
		writeln('1-actualizar archivo');
		writeln('2-listar');
		writeln('3-finalizar programa');
		readln(opcion);
		case opcion of
			1: actualizar(mae,det);
			2: listar(mae);
			3: ok:=true;
		end;
	end;
end;
		
		
var
	det:detalle;
	mae:maestro;
begin
	cargarMaestro(mae);
	cargarDetalle(det);
	runMenu(mae,det);
end.
