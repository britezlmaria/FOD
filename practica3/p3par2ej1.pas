program p3p2ej1;

type
	producto=record
		cod,stock,stockMin:integer;
		 nombre:string;
		 precio:real;
	end;
	
	venta=record
		cod,cant:integer;
	end;
	
	maestro=file of producto;
	detalle=file of venta;
	
procedure crearMaestro(var mae: maestro; var carga: text);
var
    nombre: string;
    p: producto;
begin
    reset(carga);
    nombre:= 'ArchivoMaestro';
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with p do
                begin
                    readln(carga, cod, precio, stock, stockMin, nombre);
                    write(mae, p);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure crearDetalle(var det: detalle; var carga: text);
var
    nombre: string;
    v: venta;
begin
    reset(carga);
    nombre:= 'ArchivoDetalle';
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with v do
                begin
                    readln(carga, cod, cant);
                    write(det, v);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;

procedure actualizar(var mae:maestro;var det:detalle);
var
	p:producto;
	v:venta;
	cantAct:integer;
begin
	reset(mae);
	reset(det);
	while not eof(mae) do begin
		read(mae,p);
		cantAct:=0;
		while(not eof(det)) do begin
			read(det,v);
			if(v.cod=p.cod) then begin
				cantAct:=cantAct+v.cant;
			end;
		end;
		seek(det,0);
		if(cantAct>0) then begin
			seek(mae,filePos(mae)-1);
			p.stock:=p.stock-cantAct;
			write(mae,p);
		end;
	end;
	close(mae);
	close(det);
end;
procedure imprimirMaestro(var mae: maestro);
var
    p: producto;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, p);
            with p do
                writeln('Codigo=', cod, ' Precio=', precio:0:2, ' StockActual=', stock, ' StockMin=', stockMin, ' Nombre=', nombre);
        end;
    close(mae);
end;
var
    mae: maestro;
    det: detalle;
    cargaMae, cargaDet: text;
begin
    assign(cargaMae, 'maestro.txt');
    crearMaestro(mae, cargaMae);
    assign(cargaDet, 'detalle.txt');
    crearDetalle(det, cargaDet);
    actualizar(mae, det);
    imprimirMaestro(mae);
end.

		
