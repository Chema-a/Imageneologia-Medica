function[] = visualization_DICOM(handles,B, vista, slider, min,max)
%clc; %Limpiamos el command view

% Cambia el tamaño de la imágen para que se vea más proporcional.
if(vista == "axial")
    axes(handles.axial)
    slice = permute(B(:,:,slider),[1 2 3]); % i:: 321 // ::i 123 // :i:312  -- 
%         % diferentes tipos de cortes de la imágen
    %valor_min = min(min(slice(:,:))); %Usamos el minimo pero solo del slice no de todo el tridim.
    %valor_max = max(max(slice(:,:))); %Usamos el maximo pero solo del slice no de todo el tridim.
    imshow(slice(:,:,1),[min, max]) %(rescalada) los atributos de mínimo y
%         % máximo permiten a las imágenes imprimirse con este rango de contraste
%         % para mejor visualización de la imágenes
elseif(vista == "sagital")
    axes(handles.sagital);
    
        slice = permute(B(:,slider,:),[3 1 2]); % i:: 321 // ::i 123 // :i:312  -- 
        % diferentes tipos de cortes de la imágen
    %valor_min = min(min(slice(:,:))); %Usamos el minimo pero solo del slice no de todo el tridim.
    %valor_max = max(max(slice(:,:))); %Usamos el maximo pero solo del slice no de todo el tridim.
    imshow(slice(:,:,1),[min, max]) %(rescalada) los atributos de mínimo y
        % máximo permiten a las imágenes imprimirse con este rango de contraste
        % para mejor visualización de la imágenes
elseif(vista == "coronal")
    axes(handles.coronal);
        slice = permute(B(slider,:,:),[3 2 1]); % i:: 321 // ::i 123 // :i:312  -- 
        % diferentes tipos de cortes de la imágen
    %valor_min = min(min(slice(:,:))); %Usamos el minimo pero solo del slice no de todo el tridim.
    %valor_max = max(max(slice(:,:))); %Usamos el maximo pero solo del slice no de todo el tridim.
    imshow(slice(:,:,1),[min, max]) %(rescalada) los atributos de mínimo y
end

end