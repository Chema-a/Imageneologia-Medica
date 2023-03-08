function varargout = Interfaz_ASC(varargin)
% INTERFAZ_ASC MATLAB code for Interfaz_ASC.fig
%      INTERFAZ_ASC, by itself, creates a new INTERFAZ_ASC or raises the existing
%      singleton*.
%
%      H = INTERFAZ_ASC returns the handle to a new INTERFAZ_ASC or the handle to
%      the existing singleton*.
%
%      INTERFAZ_ASC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFAZ_ASC.M with the given input arguments.
%   
%      INTERFAZ_ASC('Property','Value',...) creates a new INTERFAZ_ASC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interfaz_ASC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interfaz_ASC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interfaz_ASC

% Last Modified by GUIDE v2.5 05-Oct-2022 18:34:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interfaz_ASC_OpeningFcn, ...
                   'gui_OutputFcn',  @Interfaz_ASC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Interfaz_ASC is made visible.
function Interfaz_ASC_OpeningFcn(hObject, eventdata, handles, varargin)
path = strcat(uigetdir(matlabroot,'MATLAB Root Folder'),'\');
[B, global_min, global_max, n_img,n_cols, n_rows] = read_DICOM_3D(path); 
disp(n_img)
setappdata(handles.slider_sagital,'Image3D',B);
setappdata(handles.slider_axial,'Image3D',B);
setappdata(handles.slider_coronal,'Image3D',B);


setappdata(handles.edit_min,'min',global_min)
setappdata(handles.edit_max,'max',global_max)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Interfaz_ASC (see VARARGIN)

% Choose default command line output for Interfaz_ASC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% VISUALIZACION DE IMAGENES DICOM EN AXES

visualization_DICOM_3D(handles,B,"axial",round(n_img/2),global_min,global_max);
visualization_DICOM_3D(handles,B,"sagital",round(n_cols/2),global_min,global_max);
visualization_DICOM_3D(handles,B,"coronal",round(n_rows/2),global_min,global_max);

% COONFIGURACION DE SLIDERS Y DE EDIT
set(handles.slider_sagital, 'Min', 1);
set(handles.slider_sagital, 'Max', n_cols);
set(handles.slider_sagital, 'Value', round(n_cols/2));
set(handles.slider_sagital, 'SliderStep',[1/n_cols, 10/n_cols]);
set(handles.edit_sagital, 'string', num2str(round(n_cols/2)));

set(handles.slider_axial, 'Min', 1);    
set(handles.slider_axial, 'Max', n_img-2);
set(handles.slider_axial, 'Value', round((n_img/2)/2));
set(handles.slider_axial, 'SliderStep',[1/n_cols, 10/n_cols]);
set(handles.edit_axial, 'string', num2str(round(n_img/2)/2));

set(handles.slider_coronal, 'Min', 1);
set(handles.slider_coronal, 'Max', n_rows);
set(handles.slider_coronal, 'Value', round(n_rows/2));
set(handles.slider_coronal, 'SliderStep',[1/n_cols, 10/n_cols]);
set(handles.edit_coronal, 'string', num2str(round(n_rows/2)));
% UIWAIT makes Interfaz_ASC wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = Interfaz_ASC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_sagital_Callback(hObject, eventdata, handles)
% hObject    handle to slider_sagital (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = round(get(hObject,'Value'));
J = getappdata(handles.slider_sagital,'Image3D');
set(handles.edit_sagital, 'string', num2str(valor));
min = getappdata(handles.edit_min,'min');
max = getappdata(handles.edit_max,'max');
visualization_DICOM_3D(handles,J,"sagital", valor,min,max);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider_sagital_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_sagital (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_axial_Callback(hObject, eventdata, handles)
% hObject    handle to slider_axial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = round(get(hObject,'Value'));
set(handles.edit_axial, 'string', num2str(valor));
axial = getappdata(handles.slider_axial,'Image3D');
min = getappdata(handles.edit_min,'min');
max = getappdata(handles.edit_max,'max');
visualization_DICOM_3D(handles,axial,"axial", valor,min,max);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_axial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_axial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_coronal_Callback(hObject, eventdata, handles)
% hObject    handle to slider_coronal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = round(get(hObject,'Value'));
set(handles.edit_coronal, 'string', num2str(valor));
coronal = getappdata(handles.slider_coronal,'Image3D');
min = getappdata(handles.edit_min,'min');
max = getappdata(handles.edit_max,'max');
visualization_DICOM_3D(handles,coronal,"coronal", valor,min,max);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_coronal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_coronal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_sagital_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sagital (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = round(str2double((get(hObject,'string'))));
if isnan(valor)
      warndlg('Input must be numerical');
elseif valor > get(handles.slider_sagital, 'Max')
      warndlg(strcat('Tiene que ser menor que ',num2str(get(handles.slider_sagital, 'Max'))));
elseif valor < get(handles.slider_sagital, 'Min')
      warndlg(strcat('Tiene que ser mayor que ',num2str(get(handles.slider_sagital, 'Min'))));      
else 

sagital= getappdata(handles.slider_sagital,'Image3D');
set(handles.slider_sagital, 'Value', valor);
min = getappdata(handles.edit_min,'min');
max = getappdata(handles.edit_max,'max');
visualization_DICOM_3D(handles,sagital,"sagital", valor,min,max);
end


% Hints: get(hObject,'String') returns contents of edit_sagital as text
%        str2double(get(hObject,'String')) returns contents of edit_sagital as a double


% --- Executes during object creation, after setting all properties.
function edit_sagital_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sagital (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_axial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_axial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = round(str2double((get(hObject,'string'))));
if isnan(valor)
      warndlg('Input must be numerical');
elseif valor > get(handles.slider_axial, 'Max')
      warndlg(strcat('Tiene que ser menor que ',num2str(get(handles.slider_axial, 'Max'))));
elseif valor < get(handles.slider_axial, 'Min')
    warndlg(strcat('Tiene que ser mayor que ',num2str(get(handles.slider_axial, 'Min'))));
else 
axial = getappdata(handles.slider_axial,'Image3D');
set(handles.slider_axial, 'Value', valor);
min = getappdata(handles.edit_min,'min');
max = getappdata(handles.edit_max,'max');
visualization_DICOM_3D(handles,axial,"axial", valor,min,max);
end
% Hints: get(hObject,'String') returns contents of edit_axial as text
%        str2double(get(hObject,'String')) returns contents of edit_axial as a double


% --- Executes during object creation, after setting all properties.
function edit_axial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_axial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_coronal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_coronal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
valor = round(str2double((get(hObject,'string'))));
if isnan(valor)
      warndlg('Input must be numerical');
elseif valor > get(handles.slider_coronal, 'Max')
      warndlg(strcat('Tiene que ser menor que ',num2str(get(handles.slider_coronal, 'Max'))));
elseif valor < get(handles.slider_coronal , 'Min')
    warndlg(strcat('Tiene que ser mayor que ',num2str(get(handles.slider_coronal, 'Min'))));    
else 
    disp(valor)
coronal = getappdata(handles.slider_coronal,'Image3D');
set(handles.slider_coronal, 'Value', valor);
min = getappdata(handles.edit_min,'min');
max = getappdata(handles.edit_max,'max');
visualization_DICOM_3D(handles,coronal,"coronal", valor,min,max);
end
% Hints: get(hObject,'String') returns contents of edit_coronal as text
%        str2double(get(hObject,'String')) returns contents of edit_coronal as a double


% --- Executes during object creation, after setting all properties.
function edit_coronal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_coronal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
min = round(str2double((get(hObject,'string'))));
disp(min)
if isnan(min)
      warndlg('Input must be numerical');
else

 min = int32(min);
setappdata(handles.edit_min, 'min',min);
max = getappdata(handles.edit_max,'max');
disp(max)
disp(min)
coronal = getappdata(handles.slider_coronal,'Image3D');
sagital = getappdata(handles.slider_sagital,'Image3D');
axial = getappdata(handles.slider_axial,'Image3D');

valor_sagital = round(get(handles.slider_sagital, 'Value'));
valor_coronal = round(get(handles.slider_coronal, 'Value'));
valor_axial = round(get(handles.slider_axial, 'Value'));

visualization_DICOM_3D(handles,coronal,"coronal", valor_coronal,min,max);
visualization_DICOM_3D(handles,sagital,"sagital", valor_sagital,min,max);
visualization_DICOM_3D(handles,axial,"axial", valor_axial,min,max);
end
% Hints: get(hObject,'String') returns contents of edit_min as text
%        str2double(get(hObject,'String')) returns contents of edit_min as a double


% --- Executes during object creation, after setting all properties.
function edit_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

max = round(str2double((get(hObject,'string'))));

if isnan(max)
      warndlg('Input must be numerical');
else  
max = int32(max);
min = getappdata(handles.edit_min,'min');
setappdata(handles.edit_max, 'max',max);
coronal = getappdata(handles.slider_coronal,'Image3D');
sagital = getappdata(handles.slider_sagital,'Image3D');
axial = getappdata(handles.slider_axial,'Image3D');

valor_sagital = round(get(handles.slider_sagital, 'Value'));
valor_coronal = round(get(handles.slider_coronal, 'Value'));
valor_axial = round(get(handles.slider_axial, 'Value'));

visualization_DICOM_3D(handles,coronal,"coronal", valor_coronal,min,max);
visualization_DICOM_3D(handles,sagital,"sagital", valor_sagital,min,max);
visualization_DICOM_3D(handles,axial,"axial", valor_axial,min,max);

end

% Hints: get(hObject,'String') returns contents of edit_max as text
%        str2double(get(hObject,'String')) returns contents of edit_max as a double


% --- Executes during object creation, after setting all properties.
function edit_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
