program p2ej17;
const
	valor=9999;
type
		info=record
			loc,mun,hospital,cant:integer;
			nombreLoc,nombreMun,nombreHosp,fecha:string[12];
		end;
		
		maestro=file of info;
		
procedure cargar(var mae:maestro);
var
	txt:Text;nombre:string[12];i:info;
begin
	writeln('ingrese una ruta:');
	readln(nombre);
	assign(txt,nombre);
	reset(txt);
	writeln('ingrese un nombre para el archivo maestro:');
	readln(nombre);
	assign(mae,nombre);
	rewrite(mae);
	while not eof(txt) do begin
		readln(txt, i.loc, i.mun, i.hospital, i.nombreLoc);
		readln(txt, i.nombreMun);
        readln(txt, i.fecha);
        readln(txt, i.cant, i.nombreHosp);
        write(mae, i);
    end;
    close(mae);
    close(txt);
end;
procedure leer(var mae:maestro;var i:info);
begin
	if not eof(mae) then 
		read(mae,i)
	else
		i.loc:=valor;
end;

procedure imprimir(var mae:maestro);
var
	txt:Text;
	i:info;
	cantLoc,cantMun,cantHosp:integer;
	nombreLoc,nombreMun,nombreHosp:string;
	locActual,munActual,hospActual,cant:integer;
begin
	leer(mae,i);
	while(i.loc<>valor) do begin
		locActual:=i.loc;
		nombreLoc:=i.nombreLoc;
		cantLoc:=0;
		writeln('nombre localidad:',nombreLoc,'',locActual);
		while(i.loc=locActual) do begin
			munActual:=i.mun;
			nombreMun:=i.nombreMun;
			cantMun:=0;
			writeln('nombre municipio:',nombreMun,'',munActual);
			while (i.loc=locActual) and (i.mun=munActual) do begin
				hospActual:=i.hosp;
				nombreHosp:=i.nombreHosp;
				cantHosp:=0;
				while (i.loc=locActual) and (i.mun=munActual) and (i.hosp=hospActual) do begin
					cantHosp:=cantHosp+i.cant;
					leer(mae,i);
				end;
				writeln('nombre hospital:',nombreHosp,'',hospActual.'cantidad de casos:',cantHosp);
				cantMun:=cantMun+cantHosp;
			end;
			writeln('cantidad de casos en el municipio:',nombreMun,':',cantMun);
			cantLoc:=cantLoc+cantMun;
			if(cantMun>1500) then begin
				writeln(txt,nombreLoc);
				writeln(txt,nombreMun,cantMun);
			end;
			writeln('cantidad de casos en la localidad:',nombreLoc,':',cantLoc);
		end;
	end;
	close(mae);
	close(txt);
end;

var
	mae:maestro;
begin
	cargarMaestro(mae);
	imprimir(mae);
end.
		
		
