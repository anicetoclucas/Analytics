function varargout = openneunet(varargin)
% OPENNEUNET MATLAB code for openneunet.fig
%      OPENNEUNET, by itself, creates a new OPENNEUNET or raises the existing
%      singleton*.
%
%      H = OPENNEUNET returns the handle to a new OPENNEUNET or the handle to
%      the existing singleton*.
%
%      OPENNEUNET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPENNEUNET.M with the given input arguments.
%
%      OPENNEUNET('Property','Value',...) creates a new OPENNEUNET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before openneunet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to openneunet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help openneunet

% Last Modified by GUIDE v2.5 01-Jun-2017 09:35:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @openneunet_OpeningFcn, ...
                   'gui_OutputFcn',  @openneunet_OutputFcn, ...
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

% --- Executes just before openneunet is made visible.
function openneunet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to openneunet (see VARARGIN)

% Choose default command line output for openneunet
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global netneural
netneural = varargin{1};
set(handles.cx_in,'String',num2str(varargin{1}.inputs{1}.size));
set(handles.cx_out,'String',num2str(varargin{1}.outputs{2}.size));
% UIWAIT makes openneunet wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = openneunet_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in bt_in.
function bt_in_Callback(hObject, eventdata, handles)
% hObject    handle to bt_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexRNALoadVarIN
indexRNALoadVarIN=selecao_variaveis('entrada');
waitfor(indexRNALoadVarIN)
tam=length(indexRNALoadVarIN);
if tam==str2double(get(handles.cx_in,'String'))
    set(handles.check_in,'Value',1);
else
    set(handles.check_in,'Value',0);
end
if get(handles.check_in,'Value')
    set(handles.bt_ir,'Enable','on');
else
    set(handles.bt_ir,'Enable','off');
end
end



function cx_in_Callback(hObject, eventdata, handles)
% hObject    handle to cx_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_in as text
%        str2double(get(hObject,'String')) returns contents of cx_in as a double
end

% --- Executes during object creation, after setting all properties.
function cx_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in bt_ir.
function bt_ir_Callback(hObject, eventdata, handles)
% hObject    handle to bt_ir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexRNALoadVarIN netneural
dado=evalin('base','dado');
saida = netneural(dado(:,indexRNALoadVarIN).');
plotar2d(saida);
end

% --- Executes on button press in check_in.
function check_in_Callback(hObject, eventdata, handles)
% hObject    handle to check_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_in
end


% --- Executes during object creation, after setting all properties.
function cx_out_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
