clc
clear
close all
im = imread('Figuras.png');

im = im(:,:,1);
[n_rows,ncols] = size(im);
i_max = max(max(im)); im = im > 0.5*i_max; i_max = max(max(im));
i_min = min(min(im));

[L, n_o] = bwlabel(im,8);
i_max_label = max(max(L));
i_min_label = min(min(L));
figure(2)
subplot(1,2,1)
imshow(im)
colorbar
subplot(1,2,2)
imshow(L, [0, n_o]);
colormap(gca, 'jet');
colorbar

% CC = bwconncomp(im, 8);
% n_obj= CC.NumObjects;
% pixels_obj_1 = CC.PixelIdxList{1};
% im_copy = im;
% area_threshold = 1000;
% for n = 1:n_obj
%     [area_obj, x ] = size(CC.PixelIdxList{n});
%     if(area_obj < area_threshold)
%         for i = 1:area_obj
%             [r,c ] = IndexToCoordinates(CC.PixelIdxList{n}(i), n_rows);
%             im_copy(r,c) = 0;
%         end
%     end
% end
% 
% figure(3)
% subplot(1,2,1)
% imshow(im)
% subplot(1,2,2)
% imshow(im_copy)
% 
% new_CC = bwconncomp(im_copy,8);
% new_n_obj = new_CC.NumObjects;
% seg = im_copy;
% CC_boundaries = bwboundaries(im_copy, 8);
% stats =  regionprops(new_CC, 'all');
% 
% for n=1:new_n_obj
%     % Dibujo de Bounding Box de la figura
%     rectangle('Position',[stats(n).BoundingBox(1),stats(n).BoundingBox(2),stats(n).BoundingBox(3),stats(n).BoundingBox(4)], 'EdgeColor','r','LineWidth',2);
%     % Calculo de parametros para identificar figuras
%     [area_obj_filtered, x] = size(new_CC.PixelIdxList{n}); % Calcula de area 2D / Volumen 3D
%     area = stats(n).Area;
%     [perimeter1, x] = size(CC_boundaries{n}); % Calculo de perimetro 2D
%     
%     roundness = perimeter1^2/(4*pi*area); % Calculo de circularidad - Figura Z
%     compacity_coeficcient = (2*pi*sqrt(area/pi))/perimeter1; % Calculo de coeficiente de compacidad
%     compacity_coeficcient_square = (4*sqrt(area))/perimeter1; % Calculo de cuadratura de figura
%     compacity_coeficcient_triangle = ((6*sqrt(area))/sqrt(sqrt(3)))/perimeter1; % Calculo para triangulo
%     compacity_coeficcient_pentagon = ((2*area)/(stats(n).BoundingBox(4)/2)/perimeter1); %Calculo para pentagono
%     ratio = stats(n).BoundingBox(3)/stats(n).BoundingBox(4); % Relación aspecto de Bounding Box - Rectangulo
%     text(stats(n).BoundingBox(1),stats(n).BoundingBox(2), int2str(compacity_coeficcient_square),'Color','blue','FontSize',14);
%     disp(compacity_coeficcient_square)
%     %SEGMENTACIÓN POR CONDICIONALES
%     %PENTAGONO
% %     if(compacity_coeficcient_pentagon < .79 || compacity_coeficcient < .99  || roundness < .85 ) % condicional para identificar objeto
% %         for i=1: area
% %             [r,c] = IndexToCoordinates(new_CC.PixelIdxList{n}(i), n_rows);
% %             im_copy(r,c) = 0;
% %         end
% %     end 
%     % CIRCULO 
% %     if(compacity_coeficcient < 1.1) % condicional para identificar objeto
% %         for i=1: area
% %             [r,c] = IndexToCoordinates(new_CC.PixelIdxList{n}(i), n_rows);
% %             im_copy(r,c) = 0;
% %         end
% %     end 
% 
%     % RECTANGULO
%     if( ratio > .99) % condicional para identificar objeto
%         for i=1: area
%             [r,c] = IndexToCoordinates(new_CC.PixelIdxList{n}(i), n_rows);
%             im_copy(r,c) = 0;
%         end
%     end    
% %     FIGURA Z  
% %     if(roundness < 2.0) % condicional para identificar objeto
% %         for i=1: area
% %             [r,c] = IndexToCoordinates(new_CC.PixelIdxList{n}(i), n_rows);
% %             im_copy(r,c) = 0;
% %         end
% %     end
% %     TRIANGULO
% %     if(compacity_coeficcient_triangle < 1 || compacity_coeficcient_square > 1 ) % condicional para identificar objeto
% %         for i=1: area
% %             [r,c] = IndexToCoordinates(new_CC.PixelIdxList{n}(i), n_rows);
% %             im_copy(r,c) = 0;
% %         end
% %     end
%     % CUADRADO
% %     if(compacity_coeficcient_square < 1.0 || compacity_coeficcient_triangle < 1 || compacity_coeficcient > 1 ) % condicional para identificar objeto
% %         for i=1: area
% %             [r,c] = IndexToCoordinates(new_CC.PixelIdxList{n}(i), n_rows);
% %             im_copy(r,c) = 0;
% %         end
% %     end
% end
%  figure(4)
%  imshow(im_copy)
