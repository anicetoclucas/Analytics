function varargout = Scatter3D(varargin)
% SCATTER3D MATLAB code for Scatter3D.fig
%      SCATTER3D, by itself, creates a new SCATTER3D or raises the existing
%      singleton*.
%
%      H = SCATTER3D returns the handle to a new SCATTER3D or the handle to
%      the existing singleton*.
%
%      SCATTER3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCATTER3D.M with the given input arguments.
%
%      SCATTER3D('Property','Value',...) creates a new SCATTER3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Scatter3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Scatter3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Scatter3D

% Last Modified by GUIDE v2.5 29-Mar-2017 10:54:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Scatter3D_OpeningFcn, ...
                   'gui_OutputFcn',  @Scatter3D_OutputFcn, ...
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
end

% --- Executes just before Scatter3D is made visible.
function Scatter3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Scatter3D (see VARARGIN)

% Choose default command line output for Scatter3D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

dado=evalin('base','dado');
head=evalin('base','head');
set(handles.popX,'String',sort(head(1,2:end)));
set(handles.popY,'String',sort(head(1,2:end)));
set(handles.popZ,'String',sort(head(1,2:end)));
set(handles.slider,'Min',1);
set(handles.slider,'Max',1000);
set(handles.slider,'Value',100);
OK_Callback(handles);
% UIWAIT makes Scatter3D wait for user response (see UIRESUME)
% uiwait(handles.scatter3d);
end

% --- Outputs from this function are returned to the command line.
function varargout = Scatter3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on selection change in popX.
function popX_Callback(hObject, eventdata, handles)
% hObject    handle to popX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OK_Callback(handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popX contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popX
end

% --- Executes during object creation, after setting all properties.
function popX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popY.
function popY_Callback(hObject, eventdata, handles)
% hObject    handle to popY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OK_Callback(handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popY
end

% --- Executes during object creation, after setting all properties.
function popY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popZ.
function popZ_Callback(hObject, eventdata, handles)
% hObject    handle to popZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OK_Callback(handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popZ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popZ
end

% --- Executes during object creation, after setting all properties.
function popZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popCor.
function popCor_Callback(hObject, eventdata, handles)
% hObject    handle to popCor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OK_Callback(handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popCor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCor
end

% --- Executes during object creation, after setting all properties.
function popCor_CreateFcn(hObject, eventdata, handles)
%     handle to popCor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in buttonOK.
function OK_Callback(handles)
% handles    structure with handles and user data (see GUIDATA)
head=evalin('base','head');
dado=evalin('base','dado');
%--------X
stringX=get(handles.popX,'String');
rowX=strmatch(stringX(get(handles.popX,'value')),cellstr(head(1,2:end)));
%--------Y
stringY=get(handles.popY,'String');
rowY=strmatch(stringY(get(handles.popY,'value')),cellstr(head(1,2:end)));
%--------Z
stringZ=get(handles.popZ,'String');
rowZ=strmatch(stringZ(get(handles.popZ,'value')),cellstr(head(1,2:end)));
%--------Cor
vt_bom=evalin('base','bom');
vt_ruim=evalin('base','ruim');
vt_unido=zeros(length(vt_bom),3);
for i=1:length(vt_bom)
    if ~isnan(vt_bom(i))
        vt_unido(i,2)=1;
    elseif ~isnan(vt_ruim(i))
        vt_unido(i,1)=1;
    else
        vt_unido(i,1)=0.827451;
        vt_unido(i,2)=0.827451;
        vt_unido(i,3)=0.827451;
    end
end
assignin('base','vt_unido',vt_unido);
rowCor=vt_unido;
%--------
try grafico1=scatter3(handles.axes3D,dado(:,rowX),dado(:,rowY),dado(:,rowZ),100,rowCor);
xlabel(cellstr(head(1,rowX+1)));
ylabel(cellstr(head(1,rowY+1)));
zlabel(cellstr(head(1,rowZ+1)));
%--
grafico1.Marker='.';
grafico1.SizeData=get(handles.slider,'Value');
set(handles.axes3D,'Box','on');
%--
rotate3d on;
catch erro
    errordlg(sprintf('Erro ao carregar o Scatter.\n%s', erro.message),'Erro');
end
end

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

grafico=findobj(handles.axes3D);
grafico(2).SizeData=hObject.Value;

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end
