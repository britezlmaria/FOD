program p3par2ej3;
const
	dimF=5;
type
	infoDet=record
		cod:integer;
		fecha:string;
		tiempo:real;
	end;
	
	detalle=file of infoDet;
	vec=array[1..dimF] of detalle;

procedure crearUnSoloDetalle(var det: detalle);
var
    carga: text;
    nombre: string;
    i: infoDet;
begin
    writeln('Ingrese la ruta del detalle');
    readln(nombre);
    assign(carga, nombre);
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with i do
                begin
                    readln(carga, cod, tiempo, fecha);
                    write(det, i);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure crearDetalles(var vec: vec);
var
    i: integer;
begin
    for i:= 1 to dimf do
        crearUnSoloDetalle(vec[i]);
end;
procedure merge(var mae:detalle;var v:vec);
var
	d,aux:infoDet;
	i:integer;
	ok:boolean;
begin
	for i:=1 to dimF do begin
		reset(v[i]);
		while not eof(v[i]) do begin
			read(v[i],d);
			ok:=false;
			seek(mae,0);
			while not eof(mae) and not ok do begin
				read(mae,aux);
				if(aux.cod=d.cod) then 
					ok:=true;
			end;
			if ok then begin
				aux.tiempo:=aux.tiempo+d.tiempo;
				seek(mae,filepos(mae)-1);
				write(mae,aux);
			end
			else
				write(mae,d);
		end;
		close(v[i]);
	end;
	close(mae);
end;
procedure imprimirArchivo(var mae: detalle);
var
    i: infoDet;
begin
    reset(mae);
    while(not eof(mae)) do
        begin
            read(mae, i);
            writeln('Codigo=', i.cod, ' TiempoTotal=', i.tiempo:0:2);
        end;
    close(mae);
end;
var
    v: vec;
    mae: detalle;
begin
    crearDetalles(v);
    merge(mae, v);
    imprimirArchivo(mae);
end.
		
	
