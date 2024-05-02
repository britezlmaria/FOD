program p3p2ej2;

type
	mesa=record
		cod,nro,cant:integer;
	end;
	
	archivo=file of mesa;
	
procedure cargarArchivo(var arc: archivo);
var
    txt: text;
    m:mesa;
begin
    assign(txt, 'archivo.txt');
    reset(txt);
    assign(arc, 'ArchivoMaestro');
    rewrite(arc);
    while(not eof(txt)) do
        begin
            with m do
                begin
                    readln(txt, cod, nro, cant);
                    write(arc, m);
                end;
        end;
    writeln('Archivo maestro generado');
    close(arc);
    close(txt);
end;


procedure corteDeControl(var arch:archivo;var auxArc:archivo;var cantTot:integer);
var
	m,aux:mesa;
	ok:boolean;
begin
	assign(auxArc,'archAux');
	rewrite(auxArc);
	reset(arch);
	cantTot:=0;
	while not eof(arch) do begin
		read(arch,m);
		ok:=false;
		seek(auxArc,0);
		while not eof(auxArc) and not ok do begin
			read(auxArc,aux);
			if(aux.cod=m.cod) then 
				ok:=true;
		end;
		if (ok) then begin
			aux.cant:=aux.cant+m.cant;
			seek(auxArc,filepos(auxArc)-1);
			write(auxArc,aux);
		end
		else
			write(auxArc,m);
		cantTot:=cantTot+m.cant;
	end;
	close(arch);
	close(auxArc);
end;

procedure imprimirArchivo(var arc: archivo; cantTotal: integer);
var
    m:mesa;
begin
    reset(arc);
    writeln('Codigo de Localidad          Total de Votos');
    while(not eof(arc)) do
        begin
            read(arc, m);
            writeln(m.cod, '                                ', m.cant);
        end;
    writeln('Total General de Votos: ', cantTotal);
    close(arc);
end;
var
    arc, arcAux: archivo;
    cantTotal: integer;
begin
    cargarArchivo(arc);
    corteDeControl(arc, arcAux, cantTotal);
    imprimirArchivo(arcAux, cantTotal);
end.
