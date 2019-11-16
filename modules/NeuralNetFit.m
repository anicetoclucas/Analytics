function varargout = NeuralNetFit(varargin)
% NEURALNETFIT MATLAB code for NeuralNetFit.fig
%      NEURALNETFIT, by itself, creates a new NEURALNETFIT or raises the existing
%      singleton*.
%
%      H = NEURALNETFIT returns the handle to a new NEURALNETFIT or the handle to
%      the existing singleton*.
%
%      NEURALNETFIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEURALNETFIT.M with the given input arguments.
%
%      NEURALNETFIT('Property','Value',...) creates a new NEURALNETFIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NeuralNetFit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NeuralNetFit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NeuralNetFit

% Last Modified by GUIDE v2.5 01-Jun-2017 09:34:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NeuralNetFit_OpeningFcn, ...
                   'gui_OutputFcn',  @NeuralNetFit_OutputFcn, ...
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

% --- Executes just before NeuralNetFit is made visible.
function NeuralNetFit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NeuralNetFit (see VARARGIN)

% Choose default command line output for NeuralNetFit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global indexRNAVarIN indexRNAVarOUT
indexRNAVarIN = NaN;
indexRNAVarOUT = NaN;

% UIWAIT makes NeuralNetFit wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = NeuralNetFit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in bt_selecIN.
function bt_selecIN_Callback(hObject, eventdata, handles)
% hObject    handle to bt_selecIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexRNAVarIN
indexRNAVarIN=selecao_variaveis('entrada');
waitfor(indexRNAVarIN)
end

% --- Executes on button press in bt_selecOUT.
function bt_selecOUT_Callback(hObject, eventdata, handles)
% hObject    handle to bt_selecOUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexRNAVarOUT
indexRNAVarOUT=selecao_variaveis('saida');
waitfor(indexRNAVarOUT)
end


function cx_nNeuronios_Callback(hObject, eventdata, handles)
% hObject    handle to cx_nNeuronios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_nNeuronios as text
%        str2double(get(hObject,'String')) returns contents of cx_nNeuronios as a double
end

% --- Executes during object creation, after setting all properties.
function cx_nNeuronios_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_nNeuronios (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function cx_pTreino_Callback(hObject, eventdata, handles)
% hObject    handle to cx_pTreino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_pTreino as text
%        str2double(get(hObject,'String')) returns contents of cx_pTreino as a double
end

% --- Executes during object creation, after setting all properties.
function cx_pTreino_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_pTreino (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function cx_pValid_Callback(hObject, eventdata, handles)
% hObject    handle to cx_pValid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_pValid as text
%        str2double(get(hObject,'String')) returns contents of cx_pValid as a double
end

% --- Executes during object creation, after setting all properties.
function cx_pValid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_pValid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function cx_pTeste_Callback(hObject, eventdata, handles)
% hObject    handle to cx_pTeste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_pTeste as text
%        str2double(get(hObject,'String')) returns contents of cx_pTeste as a double
end

% --- Executes during object creation, after setting all properties.
function cx_pTeste_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_pTeste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in bt_GO.
function bt_GO_Callback(hObject, eventdata, handles)
% hObject    handle to bt_GO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global indexRNAVarIN indexRNAVarOUT neuralnettemp
dado=evalin('base','dado');
if any(isnan(indexRNAVarIN)) || isnan(indexRNAVarOUT)
    errordlg('Selecione os dados de entrada e saída, primeiramente');
    return
end
inputs=dado(:,indexRNAVarIN).';
target=dado(:,indexRNAVarOUT).';
neuralnettemp=fitnet(str2double(get(handles.cx_nNeuronios,'String')));
neuralnettemp.divideParam.trainRatio = str2double(get(handles.cx_pTreino,'String'))/100;
neuralnettemp.divideParam.valRatio = str2double(get(handles.cx_pValid,'String'))/100;
neuralnettemp.divideParam.testRatio = str2double(get(handles.cx_pTeste,'String'))/100;
[neuralnettemp,~]=train(neuralnettemp,inputs,target);
resp=questdlg('Deseja salvar a rede neural em um arquivo?',...
    'Salvar','Sim','Não','Sim');
switch resp
    case 'Sim'
        uisave('neuralnettemp','Rede_Neural');     
    case 'Não'
        assignin('base','neuralnettemp',neuralnettemp);
end
end


% --------------------------------------------------------------------
function openneuralnet_Callback(hObject, eventdata, handles)
% hObject    handle to openneuralnet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[arquivo, caminho]=uigetfile('*.mat','File Selector');
if arquivo~=0
    load([caminho '\' arquivo]);
    neunet=openneunet(neuralnettemp);
    waitfor(neunet)
end
end
