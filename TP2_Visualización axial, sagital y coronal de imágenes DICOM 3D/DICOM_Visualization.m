clc; %Limpiamos el command view
clear; %Limpiamos el workspace
close all; %Cerramos todas las ventanas

path = "DICOM/";
filelistdcm=dir(path); %Leemos todos los archivos

names = {filelistdcm.name}; % Extracción de la columna de datos 'name' de la lista matricial'filelistdem' tipo 'struct'.
names = names(~strncmp(names,'.',1)); %Quitamos los elementos de vector que inicien con un {.}

[x, n_img] = size(names); % Definición del número de columnas 'n_img' mediante la función 'size' en el arreglo/matriz 'names'

path_image = strcat(path,char(names(1))); %concatemos el path con el nombre de la imagen

I_base = dicomread(path_image); %Realizamos la llamada a la funcion para leer el archivo

[n_rows, n_cols] = size(I_base); %Obtenemos el x(num filas) y y(num cols) de I_base

Image = zeros(n_rows, n_cols, n_img); %Creamos una matriz tridimensional de x, y con unicamente 0

global_max = realmin; %Obtenemos el minimo valor real de matlab

global_min = realmax; %Obtenemos el maximo valor real de matlab

current_metada = dicominfo(path_image); %Obtenemos metadata image

% Ordenar antes

for i= 1:1:n_img %Recorremos desde 1 hasta todos los archivos (slices)
    h=char(names(i)); %hacemos char el nombre del archivo actual
    h=strcat(path,h); %concatemos el path con el nombre del archivo
    current_data = dicomread(h); %leer el archivo actual y guardar en current_data
    
    current_data_corregido = current_metada.RescaleSlope * current_data + current_metada.RescaleIntercept; % Realizamos la correccion con la ecuacion de la recta

    %Antes current_data
    current_max = max(max(current_data_corregido)); %current_max = el vector valor maximo del vector maximo de current_data (una matriz)
    current_min = min(min(current_data_corregido)); %current_min = el vector valor minimo del vector minimo de current_data (una matriz)
    
%     Image(:,:,n_img - i + 1) = current_data_corregido; % La Matrix tridi, dejamos todos los valores en x(rows), y(col), z (slices) escribimos;
    
    Image(:,:,dicominfo(h).InstanceNumber) = current_data_corregido; % Ordenamos segun su num para que muestre la imagen correctamente...

    if(current_min < global_min) % El global minimo debe ser el minimo de toda la funcion
        global_min = current_min;
    end

    if(current_max > global_max) % El global maximo debe ser el maximo de toda la funcion
        global_max = current_max;
    end
end

%Obtenemos el spacing de x, y
spacing = current_metada.PixelSpacing(1);

%Obtenemos el spacing de sliceThi (z)
slicethi = current_metada.SliceThickness;


% Obtenemos la razon la cual se mustriplica por la cantidad de imagene que tenemos
razon = (spacing / slicethi) * n_img;

razon = round(razon); %Realizamos un redondeo.

B = imresize3(round(Image), [n_rows, n_cols, razon]); % Ajusta el spacing de x, y, z para que se vea correctamente ;

% Realiza algunos intercamios estas dimensiones en la matriz y produce una
% combinación extrana de matrices sin alterar los elementos dentro, solo
% las dimensiones 
slice = permute(B(:,190,:),[3 1 2]); %Sagital
% slice = permute(B(:,200,:),[3 1 2]);  %(slices, rows, colomns)
% slice = permute(B(200,:,:),[3 2 1]); %Coronal
% slice = permute(B(:,:,200),[1 2 3]); %Axial

figure(1); % No entendi para que figure(1), funciona igual sin el...

valor_min = min(min(slice(:,:))); %Usamos el minimo pero solo del slice no de todo el tridim.
valor_max = max(max(slice(:,:))); %Usamos el maximo pero solo del slice no de todo el tridim.

% Mostramos la imagen desde el slice, con el rango minimo de grisis hasta el
% Mayor encontrado
imshow (slice(:,:),[valor_min, valor_max])
