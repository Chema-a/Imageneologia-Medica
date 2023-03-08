clc; %Limpiamos el command view
clear; %Limpiamos el workspace
close all; %Cerramos todas las ventanas

%Los archivos CT
path = "CT/";
filelistdcm=dir(path); %Leemos todos los archivos

names = {filelistdcm.name}; % Extracción de la columna de datos 'name' de la lista matricial'filelistdem' tipo 'struct'.
names = names(~strncmp(names,'.',1)); %Quitamos los elementos de vector que inicien con un {.}

[x, n_img] = size(names); % Definición del número de columnas 'n_img' mediante la función 'size' en el arreglo/matriz 'names'

path_image = strcat(path,char(names(1))); %concatemos el path con el nombre de la imagen

I_base = dicomread(path_image); %Realizamos la llamada a la funcion para leer el archivo

[n_rows, n_cols] = size(I_base); %Obtenemos el x(num filas) y y(num cols) de I_base

Image = zeros(n_rows, n_cols, n_img); %Creamos una matriz tridimensional de x, y con unicamente 0

global_max = intmax; %Obtenemos el minimo valor real de matlab

global_min = intmin; %Obtenemos el maximo valor real de matlab

current_metada = dicominfo(path_image); %Obtenemos metadata image

% Ordenar antes

for i= 1:1:n_img %Recorremos desde 1 hasta todos los archivos (slices)
    h=char(names(i)); %hacemos char el nombre del archivo actual
    h=strcat(path,h); %concatemos el path con el nombre del archivo
    current_data = dicomread(h); %leer el archivo actual y guardar en current_data
    
    current_data_corregido = current_metada.RescaleSlope * current_data + current_metada.RescaleIntercept; % Realizamos la correccion con la ecuacion de la recta

    %Antes current_data
    current_max = max(max(current_data)); %current_max = el vector valor maximo del vector maximo de current_data (una matriz)
    current_min = min(min(current_data)); %current_min = el vector valor minimo del vector minimo de current_data (una matriz)
    
%     Image(:,:,n_img - i + 1) = current_data_corregido; % La Matrix tridi, dejamos todos los valores en x(rows), y(col), z (slices) escribimos;
    
%     current_data_corregido1 = current_data_corregido > 20 & current_data_corregido < 30;
    
    Image(:,:,n_img - i + 1) = current_data_corregido; % Ordenamos segun su num para que muestre la imagen correctamente...

    if(current_min > global_min) % El global minimo debe ser el minimo de toda la funcion
        global_min = current_min;
    end

    if(current_max < global_max) % El global maximo debe ser el maximo de toda la funcion
        global_max = current_max;
    end
end

%Obtenemos el spacing de x, y
spacing = current_metada.PixelSpacing(1);

%Obtenemos el spacing de sliceThi (z)
slicethi = current_metada.SliceThickness;


% Obtenemos la razon la cual se mustriplica por la cantidad de imagene que tenemos
razon = (slicethi / spacing) * n_img;

razon = round(razon); %Realizamos un redondeo.

tejido = Image > 37 & Image < 44; %Materia Blanca

B = imresize3(tejido, [n_rows, n_cols, razon]); % Ajusta el spacing de x, y, z para que se vea correctamente ;
BAux = B;
% Realiza algunos intercamios estas dimensiones en la matriz y produce una
% combinación extrana de matrices sin alterar los elementos dentro, solo
% las dimensiones 

%% Opeaciones morfologicas
volumenMilimentros3 = slicethi * spacing * spacing; % 1.9531125
volumenBuscadoLitros = 1.3; % Cerebro en litros
volumenBuscadoMilimetros3 = volumenBuscadoLitros * 1000; % 1300 Cerebro en milimetros cubicos
cubosN = round(volumenBuscadoMilimetros3 / volumenMilimentros3); %666 (CUBOS DE 1.9)
radio = round(nthroot(cubosN / (pi * 4), 3));

B = bwareaopen(B,cubosN,6);
SE = strel('sphere', 1);
B = imdilate(B,SE);
B = bwareaopen(B,cubosN,6);
SE = strel('sphere', 1);
B = imerode(B,SE);
SE = strel('sphere', 3);
B = imdilate(B,SE);
B = bwareaopen(B,cubosN*700,6);

%% Visualizacion en 2D con la segmentacion completa de la matriz 3D con animacion de cada slice
for i= 1:1:265

    sliceSagital = permute(B(:,i,:),[3 1 2]); %Sagital
    sliceCoronal = permute(B(i,:,:),[3 2 1]); %Coronal
    sliceAxial = permute(B(:,:,i),[1 2 3]); %Axial

    figure(1); 
    
    subplot(2,3,1);
    imshow (sliceSagital);
    
    subplot(2,3,2);
    imshow (sliceCoronal);
    
    subplot(2,3,3);
    imshow (sliceAxial);
   
end
