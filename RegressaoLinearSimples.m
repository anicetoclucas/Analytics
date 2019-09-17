function varargout = RegressaoLinearSimples(varargin)
% REGRESSAOLINEARSIMPLES MATLAB code for RegressaoLinearSimples.fig
%      REGRESSAOLINEARSIMPLES, by itself, creates a new REGRESSAOLINEARSIMPLES or raises the existing
%      singleton*.
%
%      H = REGRESSAOLINEARSIMPLES returns the handle to a new REGRESSAOLINEARSIMPLES or the handle to
%      the existing singleton*.
%
%      REGRESSAOLINEARSIMPLES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGRESSAOLINEARSIMPLES.M with the given input arguments.
%
%      REGRESSAOLINEARSIMPLES('Property','Value',...) creates a new REGRESSAOLINEARSIMPLES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RegressaoLinearSimples_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RegressaoLinearSimples_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RegressaoLinearSimples

% Last Modified by GUIDE v2.5 05-May-2017 13:37:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RegressaoLinearSimples_OpeningFcn, ...
                   'gui_OutputFcn',  @RegressaoLinearSimples_OutputFcn, ...
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

% --- Executes just before RegressaoLinearSimples is made visible.
function RegressaoLinearSimples_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RegressaoLinearSimples (see VARARGIN)

% Choose default command line output for RegressaoLinearSimples
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Update figure's data
dado=evalin('base','dado');
head=evalin('base','head');
referencia=evalin('base','regno_referencia');
[~,col]=find(strcmp(referencia,head(1,:)));
col=col-1;
str_principal=sprintf('\tModelo de regressão linear simples\n\nVariável resposta: %s\n\n',referencia);
for i=1:length(dado(1,:)) %varia as colunas
    if i~=col
        somax=0;
        somax_quad=0;
        somay=0;
        somaxy=0;
        for j=1:length(dado(:,col)) %varia as linhas
            somax=somax+dado(j,i);
            somax_quad=somax_quad+dado(j,i)^2;
            somay=somay+dado(j,col);
            somaxy=somaxy+dado(j,i)*dado(j,col);
        end
        Sxx=somax_quad-(somax^2/length(dado(:,col)));
        Sxy=somaxy-(somax*somay/length(dado(:,col)));
        beta=Sxy/Sxx;
        alpha=mean(dado(:,col))-beta*mean(dado(:,i));
        resposta_modelado=beta*dado(:,i)+alpha;
        Rsquare=max(0,1-(sum((dado(:,col)-resposta_modelado(:)).^2)/sum((dado(:,col)-mean(dado(:,col))).^2)));
        matriz_resp(i,1)={Rsquare};
        matriz_resp(i,2)={beta};
        matriz_resp(i,3)=head(1,i+1);
        matriz_resp(i,4)={alpha};
    end
end
cont=1;
for i=1:length(matriz_resp(:,1))
    if ~isempty(matriz_resp{i,1})
        vetNaN(cont)=i;
        cont=cont+1;
    end
end
matriz_respNEW=matriz_resp(vetNaN,:);
result_sorted=sortrows(matriz_respNEW,1);
for i=length(result_sorted(:,1)):-1:1
    if result_sorted{i,4}>0
        str_principal=[str_principal sprintf('%f * %s + %f\n\n',result_sorted{i,2},result_sorted{i,3},result_sorted{i,4})];
    else
        str_principal=[str_principal sprintf('%f * %s - %f\n\n',result_sorted{i,2},result_sorted{i,3},abs(result_sorted{i,4}))];
    end
    str_principal=[str_principal sprintf('R²: %f\n-------------------------\n',result_sorted{i,1})];
end
set(handles.txt_texto,'String',str_principal);
% UIWAIT makes RegressaoLinearSimples wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = RegressaoLinearSimples_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function txt_texto_Callback(hObject, eventdata, handles)
% hObject    handle to txt_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_texto as text
%        str2double(get(hObject,'String')) returns contents of txt_texto as a double
end

% --- Executes during object creation, after setting all properties.
function txt_texto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_texto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
