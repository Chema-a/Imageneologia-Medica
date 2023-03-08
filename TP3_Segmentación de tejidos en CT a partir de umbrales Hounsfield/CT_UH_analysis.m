clc 
clear 
close all
path = 'CT\'; %Definir dirección relativa de la carpeta CT
[Imagen3D, global_min, global_max] = read_DICOM_3D(path);
[n_rows, n_cols, n_slices] = size(Imagen3D);
n_corte = 100; % Valor arbitrario
slice_CT = permute(Imagen3D(:,n_corte,:),[3 1 2]); % Organización de lineas y de slices en el 'n_corte'
% columna para la vista sagital  en la matrix slice_CT
min_tejido = 20;
max_tejido = 46;
tejido = Imagen3D > min_tejido & Imagen3D < max_tejido; % Definir umbral-intervalo de lectura
% para binarización(tejido y fondo) de los datos de la imagen CT. Si el
% umbral tiende hacia infinito positivo o negativo, quitar & y la parte > o
%  < respectiva: La matriz 3D resultante(tejido) tiene el mismo tamaño y
%  organización anatomica que Imagen3D
slice_tejido = permute(tejido(:,n_corte,:),[3 1 2]); % Organización de lineas y de slices en el 'n_corte'
% columna para la vista sagital en la matrix 'slice_tejido'

figure(1)
imshow(slice_CT(:,:,1),[-160, 240]);
color = zeros(n_slices, n_rows, 3);
color(:,:,1) = 50/255;
color(:,:,2) = 240/255;
color(:,:,3) = 23/255;

red = zeros(n_slices, n_rows, 3); % Creacion de matrix en ceros de vista sagital
red(:,:,2) = .4;
hold all
h = imshow(color);
set(h, 'AlphaData', slice_tejido(:,:,1))