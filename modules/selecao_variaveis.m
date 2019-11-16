function varargout = selecao_variaveis(varargin)
% SELECAO_VARIAVEIS MATLAB code for selecao_variaveis.fig
%      SELECAO_VARIAVEIS, by itself, creates a new SELECAO_VARIAVEIS or raises the existing
%      singleton*.
%
%      H = SELECAO_VARIAVEIS returns the handle to a new SELECAO_VARIAVEIS or the handle to
%      the existing singleton*.
%
%      SELECAO_VARIAVEIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECAO_VARIAVEIS.M with the given input arguments.
%
%      SELECAO_VARIAVEIS('Property','Value',...) creates a new SELECAO_VARIAVEIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selecao_variaveis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selecao_variaveis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selecao_variaveis

% Last Modified by GUIDE v2.5 18-May-2017 14:22:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selecao_variaveis_OpeningFcn, ...
                   'gui_OutputFcn',  @selecao_variaveis_OutputFcn, ...
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

% --- Executes just before selecao_variaveis is made visible.
function selecao_variaveis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selecao_variaveis (see VARARGIN)

% Choose default command line output for selecao_variaveis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
matrizcorr=evalin('base','matrizcorr');
set(handles.listvar,'String',matrizcorr)
if strcmp(varargin,'entrada')
    set(handles.figure1,'Name','Selecione as entradas');
    set(handles.listvar,'Max',2);
elseif strcmp(varargin,'saida')
    set(handles.figure1,'Name','Selecione a saída');
    set(handles.listvar,'Max',1);
end
% UIWAIT makes selecao_variaveis wait for user response (see UIRESUME)
uiwait(handles.figure1)
end

% --- Outputs from this function are returned to the command line.
function varargout = selecao_variaveis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global varsaida
varargout{1} = varsaida;
end

% --- Executes on selection change in listvar.
function listvar_Callback(hObject, eventdata, handles)
% hObject    handle to listvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listvar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listvar
end

% --- Executes during object creation, after setting all properties.
function listvar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in bt_OK.
function bt_OK_Callback(hObject, eventdata, handles)
% hObject    handle to bt_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global varsaida
index=get(handles.listvar,'Value');
varsaida=index;
close(gcf);
end

% --- Executes on button press in bt_Cancel.
function bt_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to bt_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);
end
