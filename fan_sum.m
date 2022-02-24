#! /usr/bin/octave
# octave
# fanta.m Take the CSV data from the spectrometer and obtain just the addition of all of them as raw spectral data.



# First thing that does is to obtain the list of *.csv files within the folder where the script is.

# Later, for each structure with file list, FILIE, goes through its file list, FI for performing addition of light point for each wavelength.
# 	To do so, first find the number of frames in the file and the number of rows per wl.

# After making the wavelengths vector, WL, for every frame divides the intensities column by the number of rows that it has and creates a matrix with
# 	row number equal number of wavelength points and column the number of rows with light data.
# 	This matrix is then added and trasposed to obtain a vector with intensity for each wavelength.

#	Last part of the program save these data in a TXT file not badly formatted.

# CAREFUL. This script ASSUMES a clear structura for the data file:
# 	Three columns, first with the frame number, second with the wavelegth and third with light intensity counts.
# 	This can be configured in the spectrometer control program.







#########################################################################
#Script start:
#########################################################################

# Remove everything from Octave memory:
clear;

#Define el vector de intensidades:
Int = [];

#Variable que hace falta en un loop:
first = 0;


# Define el número de pixels de la cámara: 
# (ASUMO QUE TODA LA LONGITUD DE LA CCD SE TOMA COMO REGIÓN DE INTERÉS. 
# SI NO ES ASÍ, ESTA VARIABLE DEBE MODIFICARSE)
px = 1024;

# Estructura de Octave con las listas de archivos *.txt
# (La instrucción glob es sensible a mayúsculas, pero yo sé que los archivos que hago terminan en *.txt)
filie ={glob("*.txt")}

#Use the files:
for str=1:length(filie) #For every structure with data:
	if length(filie{str})>=1 #When there are data:
		for fi=1:length(filie{str}) #Por cada archivo:
		
		
		
			#El nombre del archivo es:
			archivito = char(filie{str}(fi));
			
			#Read the file starting from second row(First is with letters)
			X = dlmread(archivito," ",1,0);
			
			
			#Its size in (rows, columns) format:
			tam = size(X);
			
			if first==0
			 Int = zeros(tam(1),1); #Primero, llénalo de 0...
			 first = 1;
			endif;
			
			#Sumo intensidades con las anteriores:
			#ASUMO QUE EN ESTE DIRECTORIO SÓLO HAY ARCHIVOS EN LAS MISMAS CONDICIONES EXPERIMENTALES
			Int = X(:,2)+Int;
			
		endfor; %fi
		
		#Construyo el archivo:
		spec = [X(:,1),Int];
		
		#Bajo el valor de las cuentas restándole a todas las columnas el valor medio de intensidad:
		spec(:,2) = spec(:,2) - mean(spec(:,2));
		
			
		########################
		#Saving the file:
		########################
		
		#File name:
		#Usa el último nombre porque soy así de chulo...
		fil_name = strcat(archivito(1:end-4),"-all", ".txt");
		
		#Opening the file:
		salida = fopen(fil_name,"w");
		
		#First line of the file (Info over what is stored):
		fdisp(salida, "wl(nm)	Av-Int(AU)");
		
		redond = [3 4]; %Saved precision 
		
		display_rounded_matrix(spec, redond, salida); %This function is not made by me.
		
		#Close the file:
		fclose(salida);
		
		#display in the screen checking info:
		disp(strcat(fil_name, " saved"));
		
	endif; %When there are data
	
endfor; %str

#And tha...and tha...that's all folks!
