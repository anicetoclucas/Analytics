function varargout = RegressaoNoLinearMulti(varargin)
% REGRESSAONOLINEARMULTI MATLAB code for RegressaoNoLinearMulti.fig
%      REGRESSAONOLINEARMULTI, by itself, creates a new REGRESSAONOLINEARMULTI or raises the existing
%      singleton*.
%
%      H = REGRESSAONOLINEARMULTI returns the handle to a new REGRESSAONOLINEARMULTI or the handle to
%      the existing singleton*.
%
%      REGRESSAONOLINEARMULTI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGRESSAONOLINEARMULTI.M with the given input arguments.
%
%      REGRESSAONOLINEARMULTI('Property','Value',...) creates a new REGRESSAONOLINEARMULTI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RegressaoNoLinearMulti_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RegressaoNoLinearMulti_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RegressaoNoLinearMulti

% Last Modified by GUIDE v2.5 19-May-2017 10:34:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RegressaoNoLinearMulti_OpeningFcn, ...
                   'gui_OutputFcn',  @RegressaoNoLinearMulti_OutputFcn, ...
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

% --- Executes just before RegressaoNoLinearMulti is made visible.
function RegressaoNoLinearMulti_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RegressaoNoLinearMulti (see VARARGIN)

% Choose default command line output for RegressaoNoLinearMulti
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global indexVarIN indexVarOUT
indexVarIN = -1;
indexVarOUT = -1;
% UIWAIT makes RegressaoNoLinearMulti wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = RegressaoNoLinearMulti_OutputFcn(hObject, eventdata, handles) 
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



% --- Executes on button press in btSelectIN.
function btSelectIN_Callback(hObject, eventdata, handles)
% hObject    handle to btSelectIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexVarIN
indexVarIN=selecao_variaveis('entrada');
waitfor(indexVarIN)
end

% --- Executes on button press in btSelectOUT.
function btSelectOUT_Callback(hObject, eventdata, handles)
% hObject    handle to btSelectOUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexVarOUT
indexVarOUT=selecao_variaveis('saida');
waitfor(indexVarOUT)
end


% --- Executes on button press in btSelectOK.
function btSelectOK_Callback(hObject, eventdata, handles)
% hObject    handle to btSelectOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexVarIN indexVarOUT
x=evalin('base','dado');
head=evalin('base','head');
modelFunStr='@(b,x)b(1)';
modelFunStr4Answer=modelFunStr;
ic=2;
for i=1:length(indexVarIN)
    modelFunStr=[modelFunStr ' + b(' num2str(ic) ')*x(:,' num2str(i) ').^2 + b(' num2str(ic+1) ')*x(:,' num2str(i) ')'];
    modelFunStr4Answer=[modelFunStr4Answer ' + b(' num2str(ic) ')*x(' num2str(i) ').^2 + b(' num2str(ic+1) ')*x(' num2str(i) ')'];
    ic=ic+2;
end
noLinearModel=fitnlm(x(:,indexVarIN),x(:,indexVarOUT),str2func(modelFunStr),rand(ic-1,1));
assignin('base','noLinearModel',noLinearModel);
str_principal=sprintf('\tModelo polinomial quadrática de regressão multivariada \n\nVariável resposta: %s\n\n',head{1,indexVarOUT+1});
str_principal=[str_principal sprintf('Variável(is) preditora(s): \n')];
for i=1:length(indexVarIN)
    str_principal=[str_principal sprintf('x(%i): %s \n',i,head{1,indexVarIN(i)+1})];
end
str_principal=[str_principal sprintf('\n\t%s = %s\n\nCoeficientes:\n',noLinearModel.Formula.ResponseName, modelFunStr4Answer(7:end))];
for i=1:height(noLinearModel.Coefficients(:,1))
    str_principal=[str_principal sprintf('b(%i)=%f\n',i,table2array(noLinearModel.Coefficients(i,1)))];
end
if noLinearModel.Rsquared.Ordinary<0
    str_principal=[str_principal sprintf('\nConfiabilidade do modelo\nR²: Inválido')];
else
    str_principal=[str_principal sprintf('\nConfiabilidade do modelo\nR²: %f',noLinearModel.Rsquared.Ordinary)];
end
set(handles.txt_box,'String',str_principal);
% set(handles.txt_box,'String','')
end
