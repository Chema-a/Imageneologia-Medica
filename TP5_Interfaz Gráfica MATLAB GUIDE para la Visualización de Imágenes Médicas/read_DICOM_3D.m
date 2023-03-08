Sfunction[B, global_min, global_max, n_img, n_cols, n_rows] = read_DICOM(path) % Iniciar función declarando parametros de entrada y salida

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


%Ordenamiento de imagenes
for i = 1:1:n_img % Para todas las imágenes de la carpeta:
    h=char(names(i)); %Se obtiene el nombre de la imágen
    h=strcat(path,h); % Contatena el nombre de la imágen con la dirección de la carpeta
    current_data =dicomread(h); % La información de la imágen la pasa a current_data
    DCM = dicominfo(h); %Lectura de metadatos
    current_data_corregido = DCM.RescaleSlope*current_data+DCM.RescaleIntercept;
    current_max = max(max(current_data_corregido)); %Escala de grises declarada
    current_min = min(min(current_data_corregido)); %Escala de grises declarada 
    Image(:,:,DCM.InstanceNumber) = current_data_corregido; %Acomoda la matrix de la imagen
    % la imágen para que se imprima en orden
    if(current_min<global_min) % Verificación y cambio de los valores mínimos y máximos
        global_min = current_min;
    end
    if(current_max>global_max)
        global_max = current_max;
    end
end

planesfactor = DCM.PixelSpacing(1)/DCM.SliceThickness;
B = imresize3(Image,[n_rows,n_cols, round(n_img*planesfactor)]);


end