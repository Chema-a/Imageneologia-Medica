function[DCM,Image, global_min,global_max]=read_DICOM_3D(path) 
    filelistdcm = dir(path); %Lista de los archivos dentro de la ruta
    names = {filelistdcm.name}; %Extrae los nombres de los archivos 
    names = names(~strncmp(names,'.',1)); % Se hace una comparación dentro de los
    % nombres de los archivos, de los cuales solo se obtendrán aquellos cuyo nombre no inicie con un punto (.)
    [~, n_img] = size(names); % Se obtiene el tamaño de los componentes de 'names', 
    % y dado que el resultado obtenido de lo nombres es una matriz, se guarda la fila 
    % donde están los nombres (x) y el tamaño o cantidad de las columnas con los nombres (n_img)
    path_image = strcat(path,char(names(1))); % Se concatena la ruta de los archivos y el 
    % nombre del primer archivo
    I_base = dicomread(path_image); % Lee los datos de la imagen del archivo compatible
    % con DICOM y los pone en la variable
    [n_rows, n_cols] = size (I_base); % Obtiene las filas y columnas (el tamaño) 
    % de la imágen dicom
    Image = zeros(n_rows, n_cols, n_img); %Se crea una matriz con 0s del tamaño 
    % de la imágen 3D DICOM
    global_max = realmin; %Se inicializan variables máximas y mínimas
    global_min = realmax; 
    for i = 1:1:n_img % Para todas las imágenes de la carpeta:
        h=char(names(i)); %Se obtiene el nombre de la imágen
        h=strcat(path,h); % Contatena el nombre de la imágen con la dirección de la carpeta
        current_data =dicomread(h); % La información de la imágen la pasa a current_data
        DCM = dicominfo(h); %Obtiene la metadata de la imágen
        current_data_corregido = DCM.RescaleSlope*current_data+DCM.RescaleIntercept;
        current_max = max(max(current_data_corregido)); % Obtiene los valores máximos y mínimos
        % dentro de la información de la imágen
        current_min = min(min(current_data_corregido));
        Image(:,:,DCM.InstanceNumber) = current_data_corregido;% Se acomoda dentro de la matriz
        % la imágen para que se imprima en orden
        if(current_min<global_min) % Verificación y cambio de los valores mínimos y máximos
            global_min = current_min;
        end
        if(current_max>global_max)
            global_max = current_max;
        end
    end
end