function varargout = RegressaoLinearMulti(varargin)
% REGRESSAOLINEARMULTI MATLAB code for RegressaoLinearMulti.fig
%      REGRESSAOLINEARMULTI, by itself, creates a new REGRESSAOLINEARMULTI or raises the existing
%      singleton*.
%
%      H = REGRESSAOLINEARMULTI returns the handle to a new REGRESSAOLINEARMULTI or the handle to
%      the existing singleton*.
%
%      REGRESSAOLINEARMULTI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGRESSAOLINEARMULTI.M with the given input arguments.
%
%      REGRESSAOLINEARMULTI('Property','Value',...) creates a new REGRESSAOLINEARMULTI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RegressaoLinearMulti_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RegressaoLinearMulti_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RegressaoLinearMulti

% Last Modified by GUIDE v2.5 25-May-2017 09:51:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RegressaoLinearMulti_OpeningFcn, ...
                   'gui_OutputFcn',  @RegressaoLinearMulti_OutputFcn, ...
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

% --- Executes just before RegressaoLinearMulti is made visible.
function RegressaoLinearMulti_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RegressaoLinearMulti (see VARARGIN)

% Choose default command line output for RegressaoLinearMulti
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Update figure's data

% UIWAIT makes RegressaoLinearMulti wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = RegressaoLinearMulti_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
clearvars -global
end



function txt_equacao_Callback(hObject, eventdata, handles)
% hObject    handle to txt_equacao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_equacao as text
%        str2double(get(hObject,'String')) returns contents of txt_equacao as a double
end

% --- Executes during object creation, after setting all properties.
function txt_equacao_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_equacao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in bt_in.
function bt_in_Callback(hObject, eventdata, handles)
% hObject    handle to bt_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexVarIN
indexVarIN=selecao_variaveis('entrada');
waitfor(indexVarIN)
end

% --- Executes on button press in bt_out.
function bt_out_Callback(hObject, eventdata, handles)
% hObject    handle to bt_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexVarOUT
indexVarOUT=selecao_variaveis('saida');
waitfor(indexVarOUT)
end

% --- Executes on button press in bt_ok.
function bt_ok_Callback(hObject, eventdata, handles)
% hObject    handle to bt_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexVarIN indexVarOUT
dado=evalin('base','dado');
head=evalin('base','head');
str_principal=sprintf('\tModelo de regressão linear multivariável\n\nVariável resposta: %s\n\n',head{1,indexVarOUT+1});
[fn_reg,~,~,~,status]=regress(dado(:,indexVarOUT),dado(:,indexVarIN));
for i=1:length(fn_reg)
    if fn_reg(i)>0
        str_principal=[str_principal sprintf('+%f * %s\n',fn_reg(i),head{1,indexVarIN(i)+1})];
    else
        str_principal=[str_principal sprintf('%f * %s\n',fn_reg(i),head{1,indexVarIN(i)+1})];
    end
end
if status(1)>=0
    str_principal=[str_principal sprintf('\nConfiabilidade do modelo:\nR²: %f', status(1))];
else
    str_principal=[str_principal sprintf('\nConfiabilidade do modelo:\nR²: Erro [R² negativo]')];
end
set(handles.txt_equacao,'String',str_principal);
end
