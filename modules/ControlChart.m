function varargout = ControlChart(varargin)
% CONTROLCHART MATLAB code for ControlChart.fig
%      CONTROLCHART, by itself, creates a new CONTROLCHART or raises the existing
%      singleton*.
%
%      H = CONTROLCHART returns the handle to a new CONTROLCHART or the handle to
%      the existing singleton*.
%
%      CONTROLCHART('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROLCHART.M with the given input arguments.
%
%      CONTROLCHART('Property','Value',...) creates a new CONTROLCHART or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ControlChart_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ControlChart_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ControlChart

% Last Modified by GUIDE v2.5 06-Oct-2017 09:32:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ControlChart_OpeningFcn, ...
                   'gui_OutputFcn',  @ControlChart_OutputFcn, ...
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

% --- Executes just before ControlChart is made visible.
function ControlChart_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ControlChart (see VARARGIN)

% Choose default command line output for ControlChart
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ControlChart wait for user response (see UIRESUME)
% uiwait(handles.figure1);
controlchart(zeros(20),'charttype','i','display','off','parent',handles.axesCarta);
controlchart(zeros(20),'charttype','i','display','off','parent',handles.axesCarta2);
matrizcorr=evalin('base','matrizcorr');
if get(handles.check_sort,'Value')==0
    set(handles.popupmenu1,'String',matrizcorr);
else
    set(handles.popupmenu1,'String',sort(matrizcorr));
end
end

function varargout = ControlChart_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
end

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
dado=evalin('base','dado');
head=evalin('base','head');
matrizcorr=head(1,2:end).';
index=get(hObject,'value');
string=get(hObject,'String');

rowx=strcmp(string(index),cellstr(matrizcorr(:,1)));

controlchart(dado(:,rowx),'charttype','i','parent',handles.axesCarta);
controlchart(dado(:,rowx),'charttype','mr','parent',handles.axesCarta2);
handctrl=findobj(handles.axesCarta,'Type','Axes');
handctrl.Title.String='Carta de Valores Individuais';
handctrl2=findobj(handles.axesCarta2,'Type','Axes');
handctrl2.Title.String='Carta de Amplitude Móvel';

end


% --- Executes on button press in bt_Cancelar.
function bt_Cancelar_Callback(hObject, eventdata, handles)
% hObject    handle to bt_Cancelar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);

end


% --- Executes on button press in check_sort.
function check_sort_Callback(hObject, eventdata, handles)
% hObject    handle to check_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
head=evalin('base','head');
if get(hObject,'Value')==0
    set(handles.popupmenu1,'string',head(1,2:size(head,2)))
else
    set(handles.popupmenu1,'string',sort(head(1,2:size(head,2))));
end
% Hint: get(hObject,'Value') returns toggle state of check_sort
end
