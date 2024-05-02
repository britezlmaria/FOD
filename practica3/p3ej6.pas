program p3ej6;
const
	valor=9999;
type
	prenda=record
		cod,stock:integer;
		desc,colores,tipo:string;
		precio:real;
	end;
	
	codigo=record
		cod:integer;
	end;
	
	maestro=file of prenda;
	detalle=file of integer;
	
procedure crearMaestro(var arch: maestro);
var
    p: prenda;
    txt: text;
begin
    assign(txt, 'maestro.txt');
    reset(txt);
    assign(arch, 'ArchivoMaestro');
    rewrite(arch);
    while(not eof(txt)) do
        begin
            with p do
                begin
                    readln(txt, cod, stock, precio, desc);
                    readln(txt, tipo);
                    readln(txt, colores);
                    write(arch, p);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(arch);
    close(txt);
end;
procedure crearDetalle(var det: detalle);
var
    carga: text;
    codigo: integer;
begin
    assign(carga, 'detalle.txt');
    reset(carga);
    assign(det, 'ArchivoDetalle');
    rewrite(det);
    while(not eof(carga)) do
        begin
            readln(carga, codigo);
            write(det, codigo);
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure baja(var mae:maestro;var det:detalle);
var
	p:prenda;
	cod:integer;
begin
	reset(mae);
	reset(det);
	while not eof(det) do begin
		read(det,cod);
		seek(mae,0);
		read(mae,p);
		while(p.cod<>cod) do 
			read(mae,p);
		seek(mae,filePos(mae)-1);
		p.stock:=-1;
		write(mae,p);
	end;
	close(mae);
	close(det);
end;

procedure exportar(var mae,aux:maestro);
var
	p:prenda;
begin
	assign(aux,'archivoaux');
	reset(mae);
	rewrite(aux);
	while not eof(mae) do begin
		read(mae,p);
		if(p.stock>=0) then 
			write(aux,p);
	end;
	close(mae);
	close(aux);
	erase(mae);
	rename(aux,'ArchivoMaestro');
end;
procedure imprimirMaestro(var mae: maestro);
var
    p: prenda;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, p);
            writeln('Codigo=', p.cod, ' Desc=', p.desc, ' Stock=', p.stock, ' Precio=', p.precio:0:2);
        end;
    close(mae);
end;
procedure imprimirDetalle(var det: detalle);
var
    cod: integer;
begin
    reset(det);
    while(not eof(det)) do
        begin
            read(det, cod);
            write('CodBorrar=', cod , ' | ');
        end;
    close(det);
end;
var
    maeSinBorrados, maeConBorrados: maestro;
    det: detalle;
begin
    crearMaestro(maeSinBorrados);
    writeln('Archivo sin borrados:');
    imprimirMaestro(maeSinBorrados);
    crearDetalle(det);
    imprimirDetalle(det);
    writeln();
    writeln('Se realizan las bajas');
    writeln('Archivo con borrados logicos:');
    baja(maeSinBorrados, det);
    imprimirMaestro(maeSinBorrados);
    writeln('Archivo con borrados fisicos:');
    exportar(maeSinBorrados, maeConBorrados);
    imprimirMaestro(maeConBorrados);
end.



