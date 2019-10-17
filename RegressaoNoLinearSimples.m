function varargout = RegressaoNoLinearSimples(varargin)
% REGRESSAONOLINEARSIMPLES MATLAB code for RegressaoNoLinearSimples.fig
%      REGRESSAONOLINEARSIMPLES, by itself, creates a new REGRESSAONOLINEARSIMPLES or raises the existing
%      singleton*.
%
%      H = REGRESSAONOLINEARSIMPLES returns the handle to a new REGRESSAONOLINEARSIMPLES or the handle to
%      the existing singleton*.
%
%      REGRESSAONOLINEARSIMPLES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGRESSAONOLINEARSIMPLES.M with the given input arguments.
%
%      REGRESSAONOLINEARSIMPLES('Property','Value',...) creates a new REGRESSAONOLINEARSIMPLES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RegressaoNoLinearSimples_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RegressaoNoLinearSimples_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RegressaoNoLinearSimples

% Last Modified by GUIDE v2.5 30-May-2017 10:54:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RegressaoNoLinearSimples_OpeningFcn, ...
                   'gui_OutputFcn',  @RegressaoNoLinearSimples_OutputFcn, ...
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

% --- Executes just before RegressaoNoLinearSimples is made visible.
function RegressaoNoLinearSimples_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RegressaoNoLinearSimples (see VARARGIN)

% Choose default command line output for RegressaoNoLinearSimples
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global indexVarIN indexVarOUT
indexVarIN = -1;
indexVarOUT = -1;
% UIWAIT makes RegressaoNoLinearSimples wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = RegressaoNoLinearSimples_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
clearvars -global
end

function txt_box_Callback(hObject, eventdata, handles)
% hObject    handle to txt_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_box as text
%        str2double(get(hObject,'String')) returns contents of txt_box as a double
end

% --- Executes during object creation, after setting all properties.
function txt_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_box (see GCBO)
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
referencia=head{1,indexVarOUT+1};
str_principal=sprintf('\tModelos polinomiais quadráticas de regressão simples\n\nVariável resposta: %s\n\n',referencia);
modelFunStr='@(b,x)b(1)*x.^2+b(2)*x+b(3)';
for i=1:length(indexVarIN) 
    noLinearModel=fitnlm(dado(:,indexVarIN(i)),dado(:,indexVarOUT),str2func(modelFunStr),rand(3,1));
    matriz_resp(i,1)={table2array(noLinearModel.Coefficients(1,1))};
    matriz_resp(i,2)={table2array(noLinearModel.Coefficients(2,1))};
    matriz_resp(i,3)={table2array(noLinearModel.Coefficients(3,1))};
    matriz_resp(i,4)={noLinearModel.Rsquared.Ordinary};
end
cont=1;
for i=1:length(matriz_resp(:,4))
    if ~isempty(matriz_resp{i,4})
        vetNaN(cont)=i;
        cont=cont+1;
    end
end
matriz_respNEW=matriz_resp(vetNaN,:);
result_sorted=sortrows(matriz_respNEW,4);
for i=length(indexVarIN):-1:1 
    str_principal=[str_principal sprintf('%s:\n',head{1,1+indexVarIN(i)})];
    str_principal=[str_principal sprintf('%f*x^2 + %f*x + %f\n\n',result_sorted{i,1},result_sorted{i,2},result_sorted{i,3})];     
    str_principal=[str_principal sprintf('R²: %f\n-------------------------------\n',result_sorted{i,4})];
    [~,msgid]=lastwarn;
    warning('off',msgid);
end
set(handles.txt_box,'String',str_principal);
end
