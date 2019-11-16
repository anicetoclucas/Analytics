function varargout = limites(varargin)
% LIMITES MATLAB code for limites.fig
%      LIMITES, by itself, creates a new LIMITES or raises the existing
%      singleton*.
%
%      H = LIMITES returns the handle to a new LIMITES or the handle to
%      the existing singleton*.
%
%      LIMITES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIMITES.M with the given input arguments.
%
%      LIMITES('Property','Value',...) creates a new LIMITES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before limites_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to limites_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help limites

% Last Modified by GUIDE v2.5 16-Jul-2016 11:24:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @limites_OpeningFcn, ...
                   'gui_OutputFcn',  @limites_OutputFcn, ...
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


% --- Executes just before limites is made visible.
function limites_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to limites (see VARARGIN)

% Choose default command line output for limites
handles.output = hObject;
set(handles.lim_baixo,'String',0)
set(handles.lim_alto,'String',0)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes limites wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = limites_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
teste_erro=0;
limbaixo=str2double(get(handles.lim_baixo,'String'));
limalto=str2double(get(handles.lim_alto,'String'));
if limbaixo> limalto
    errordlg('Limite inferior maior que o limite superior.','Erro de limites');
    teste_erro=1;
end
if teste_erro~=1
    assignin('base','limbaixo',limbaixo);
    assignin('base','limalto',limalto);
    assignin('base','buttonchoise',1);
    pause('off');
    delete(limites);
end


function lim_alto_Callback(hObject, eventdata, handles)
% hObject    handle to lim_alto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lim_alto as text
%        str2double(get(hObject,'String')) returns contents of lim_alto as a double


% --- Executes during object creation, after setting all properties.
function lim_alto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lim_alto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lim_baixo_Callback(hObject, eventdata, handles)
% hObject    handle to lim_baixo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lim_baixo as text
%        str2double(get(hObject,'String')) returns contents of lim_baixo as a double


% --- Executes during object creation, after setting all properties.
function lim_baixo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lim_baixo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(handles.figure1, eventdata, handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
assignin('base','buttonchoise',0);
pause('off');
delete(hObject);
