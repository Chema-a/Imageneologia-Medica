
%4 operaciones morfologicas; erocion, dilatacion, apertura, cerradura
%operaciones básicas;
%erocion por viento, agua, 
%dilatacion como pupila
%componente conexo, formado por 1 o mas pixeles intensidad=1
%conectividad propiedad trancitiva de pertenecer a uno o más pixeles por medio de las
%vecindades     nb = 4,8,16,12      3d-> nb=6,18,26,24

%dos pixeles vecinos pueden estar o no conectados
%dos pixeles pueden ser o no ser vecinos -> propiedad transitiva
%dependiendo del tipo nb de adyacencia, dos pixeles pueden o no estra
%conectados

%elemento estructurante, elemento conexo art, para realizar una operación
%morfológica.

%recorrer comoponente conexo a travez de elemento estructurante, se aplica
%sustracci, o adicion del mismo
%imdilated  imerode

%Apertura = erocion + dilatacion -> separar objetos de un lado a otro
%cerradura = dilatacion + erocion ->Huecos
%Unidades config, 
%voxeles a medidas métricas, cuantos si se tiene cierto spicing.
%bwareopen
%PET rangos color SUV
%% Inicio
clc
clear
close all

%I = imread('jointed_circs.png');
I = imread('jointed_circ_triang.png');
I = I(:,:,3);% solo se toma un nivel; Tiene 8 bits, por eso se binariza
%2  a la 6, sse ponen 7 bits debido a la mitad de 256
I = I > 128; %Introducción a la morfología matemática; ahora la ultima capa es logical
%es mejor hacer las operaciones en binario que a color
% % Operaciones morfológicas
SE = strel('disk', 50); %20 pixeles elemento estructurante, da el circuito de un disco por el contorno 'circular' 
%Ayuda a tunear objetos
%SE = strel('line', 30, 45); 
I_erosion = imerode(I,SE);
I_dilatacion = imdilate(I,SE);

I_apertura = imdilate(I_erosion,SE);
I_cerradura = imerode(I_dilatacion,SE);

I_apertura_1 = imopen(I,SE);
I_cerradura_1 = imclose(I,SE);

figure
subplot(3,3,1)
imshow(I); 
subplot(3,3,2)
imshow(I_erosion); 
subplot(3,3,3)
imshow(I_dilatacion); 

subplot(3,3,5)
imshow(I_apertura); 
subplot(3,3,6)
imshow(I_cerradura); 

subplot(3,3,8)
imshow(I_apertura_1); 
subplot(3,3,9)
imshow(I_cerradura_1); 

%% Inicio CT
clc
clear
close all

CT = imread('CT_brain.png');
CT = CT(:,:,1);

hueso = CT > 170;
aire = CT < 50;
tejido_blando = CT>50 & CT<170;

SE = strel('disk', 10);
cerebro_1=imopen(tejido_blando,SE);
cerebro_limpio = bwareaopen(cerebro_1, 9000);

figure
subplot(2,4,1)
imshow(CT);
subplot(2,4,2)
imshow(hueso);
subplot(2,4,3)
imshow(aire);
subplot(2,4,4)
imshow(tejido_blando);

subplot(2,4,5)
imshow(cerebro_1);
subplot(2,4,6)
imshow(cerebro_limpio);

%% Inicio PET
clc
clear
close all

PET = imread('PET_brain.png');
PET = PET(:,:,1);

iperactividad= PET > 30;
SE = strel('disk',10);
cerebro = imclose(iperactividad,SE);
cerebro_limpio = bwareaopen(cerebro, 9000);

figure
subplot(1,3,1)
imshow(cerebro_limpio);
subplot(1,3,2)
imshow(iperactividad);
subplot(1,3,3)
imshow(cerebro);
%% Práctica 6
clc 
clear
close all

path = "CT\";%Img_2"; %Ruta relativa de cualquier imágen DICOM seleccionada
filelistdcm = dir(path);
names = {filelistdcm.name}; %Extrae los nombres
names = names(~strncmp(names,'.',1)); %Verifica que sea un documento original y no carpetas
[x, n_img] = size(names); %Extrae el tamaño  
path_image = strcat(path,char(names(1))); 
I_base = dicomread(path_image); %Lee la imagen por pixeles
[n_rows, n_cols] = size(I_base); %Extrae el tamaño de la imagen
Image = zeros(n_rows, n_cols, n_img); %Declara la matriz
global_max = realmin; %Se declaran variables globales
global_min = realmax; %Se declaran variables globales
data = dicominfo(path_image);
%Ordenamiento de imagenes

for i = 1:1:n_img
    h=char(names(i)); % Nombre de la imagen
    h=strcat(path,h); % Concatena todo el path
    current_data =dicomread(h); % Lectura de imagen
    DCM = dicominfo(h); %Lectura de metadatos
    current_data_corregido = DCM.RescaleSlope*current_data+DCM.RescaleIntercept;
    current_max = max(max(current_data_corregido)); %Escala de grises declarada
    current_min = min(min(current_data_corregido)); %Escala de grises declarada 
    Image(:,:,DCM.InstanceNumber) = current_data_corregido; %Acomoda la matrix de la imagen
    if(current_min<global_min) %Asigna el rango en caso de que el rango de grises sea mayor en la imagen
        global_min = current_min;
    end
    if(current_max>global_max)
        global_max = current_max;
    end
end
Image =   Image > 37 & Image < 50;
razon = round(data.SliceThickness/data.PixelSpacing(1))*n_img;
B2 = imresize3(round(Image),[n_rows, n_cols, razon]);

%B2 = permute(B(:,190,:),[3 1 2]);





volumenMilimentros3 = data.SliceThickness * data.PixelSpacing(1) * data.PixelSpacing(2); % 1.9531125
volumenBuscadoLitros = 1.3; % Cerebro en litros
volumenBuscadoMilimetros3 = volumenBuscadoLitros * 1000; % 1300 Cerebro en milimetros cubicos
cubosN = round(volumenBuscadoMilimetros3 / volumenMilimentros3); %666 (CUBOS DE 1.9)
radio = round(nthroot(cubosN / (pi * 4), 3));


for i= 1:1:265

    sliceSagital = permute(B2(:,i,:),[3 1 2]); %Sagital
    sliceCoronal = permute(B2(i,:,:),[3 2 1]); %Coronal
    sliceAxial = permute(B2(:,:,i),[1 2 3]); %Axial

    figure(1); 
    
    subplot(2,3,1);
    imshow (sliceSagital);
    
    subplot(2,3,2);
    imshow (sliceCoronal);
    
    subplot(2,3,3);
    imshow (sliceAxial);
   
end


CC = bwconncomp(B2, 6);
n_obj= CC.NumObjects;
pixels_obj_1 = CC.PixelIdxList{1};

im_copy = B2;
area_threshold = 3000;
for n = 1:n_obj
    [area_obj, x ] = size(CC.PixelIdxList{n});
    if(area_obj < area_threshold)
        for i = 1:area_obj
            [r,c,m ] = IndexToCoordinates3D(CC.PixelIdxList{n}(i), n_rows,n_cols);
            im_copy(r,c,m) = 0;
        end
    end
end

for i= 1:1:265

    sliceSagital = permute(im_copy(:,i,:),[3 1 2]); %Sagital
    sliceCoronal = permute(im_copy(i,:,:),[3 2 1]); %Coronal
    sliceAxial = permute(im_copy(:,:,i),[1 2 3]); %Axial

    figure(1); 
    
    subplot(2,3,1);
    imshow (sliceSagital);
    
    subplot(2,3,2);
    imshow (sliceCoronal);
    
    subplot(2,3,3);
    imshow (sliceAxial);
   
end
new_CC = bwconncomp(im_copy, 6);
new_n_obj = new_CC.NumObjects;
seg = im_copy;
stats_area =  regionprops3(new_CC, 'Volume');
stats_surface =  regionprops3(new_CC, 'SurfaceArea');


for n=1:new_n_obj
    % Calculo de parametros para identificar figuras
    volumen = stats_area(n,1);
    superfice= stats_surface(n,1);
     esfericidad = (4*pi*(nthroot(((3*volumen.Volume)/4*pi), 3))^2)/(superfice.SurfaceArea);
     disp(esfericidad)
    if(esfericidad < 2.0) % condicional para identificar objeto
        for i=1: volumen.Volume
            [r,c,m] = IndexToCoordinates3D(new_CC.PixelIdxList{n}(i), n_rows,n_cols);
            im_copy(r,c,m) = 0;
        end
    end 
end
for i= 1:1:265

    sliceSagital = permute(im_copy(:,i,:),[3 1 2]); %Sagital
    sliceCoronal = permute(im_copy(i,:,:),[3 2 1]); %Coronal
    sliceAxial = permute(im_copy(:,:,i),[1 2 3]); %Axial

    figure(1); 
    
    subplot(2,3,1);
    imshow (sliceSagital);
    
    subplot(2,3,2);
    imshow (sliceCoronal);
    
    subplot(2,3,3);
    imshow (sliceAxial);
   
end




