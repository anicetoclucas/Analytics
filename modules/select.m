function varargout = select(varargin)
% SELECT MATLAB code for select.fig
%      SELECT, by itself, creates a new SELECT or raises the existing
%      singleton*.
%
%      H = SELECT returns the handle to a new SELECT or the handle to
%      the existing singleton*.
%
%      SELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT.M with the given input arguments.
%
%      SELECT('Property','Value',...) creates a new SELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select

% Last Modified by GUIDE v2.5 06-Mar-2017 13:36:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_OpeningFcn, ...
                   'gui_OutputFcn',  @select_OutputFcn, ...
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

% --- Executes just before select is made visible.
function select_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select (see VARARGIN)

% Choose default command line output for select
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
matrizcorr=evalin('base','matrizcorr');
set(handles.listbox_load,'String',matrizcorr);
try matrizcorr_del=evalin('base','matrizcorr_del');    
    set(handles.listbox_unload,'String',matrizcorr_del);
end
end
% UIWAIT makes select wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = select_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on selection change in listbox_load.
function listbox_load_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_load contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_load
end

% --- Executes during object creation, after setting all properties.
function listbox_load_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in listbox_unload.
function listbox_unload_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_unload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_unload contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_unload
end

% --- Executes during object creation, after setting all properties.
function listbox_unload_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_unload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in button_back.
function button_back_Callback(~, eventdata, handles)
% hObject    handle to button_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
List1=get(handles.listbox_unload,'String');
Selection=get(handles.listbox_unload,'Value');
List2=get(handles.listbox_load,'String');
try List2=[List2;List1(Selection)];
    List1(Selection)=[];
end
if Selection==length(get(handles.listbox_unload,'String')) && Selection~=1
    set(handles.listbox_unload,'Value',length(get(handles.listbox_unload,'String'))-1)
end
set(handles.listbox_load,'String',List2);
set(handles.listbox_unload,'String',List1);
end

% --- Executes on button press in button_backall.
function button_backall_Callback(hObject, eventdata, handles)
% hObject    handle to button_backall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
List1=get(handles.listbox_unload,'String');
List2=get(handles.listbox_load,'String');
try List2=[List2;List1];
    List1=[];
end
set(handles.listbox_load,'String',List2);
set(handles.listbox_unload,'String',List1);
set(handles.listbox_unload,'Value',1);
end

% --- Executes on button press in button_next.
function button_next_Callback(hObject, eventdata, handles)
% hObject    handle to button_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
List1=get(handles.listbox_load,'String');
Selection=get(handles.listbox_load,'Value');
List2=get(handles.listbox_unload,'String');
try List2=[List2;List1(Selection)];
    List1(Selection)=[];
end
if Selection==length(get(handles.listbox_load,'String')) && Selection~=1
    set(handles.listbox_load,'Value',length(get(handles.listbox_load,'String'))-1)
end
set(handles.listbox_unload,'String',List2);
set(handles.listbox_load,'String',List1);

end

% --- Executes on button press in button_nextall.
function button_nextall_Callback(hObject, eventdata, handles)
% hObject    handle to button_nextall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
List1=get(handles.listbox_load,'String');
List2=get(handles.listbox_unload,'String');
try List2=[List2;List1];
    List1=[];
end
set(handles.listbox_unload,'String',List2);
set(handles.listbox_load,'String',List1);
set(handles.listbox_load,'Value',1);
end

% --- Executes on button press in button_OK.
function button_OK_Callback(hObject, eventdata, handles)
% hObject    handle to button_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dadofix=evalin('base','dadofix');
headfix=evalin('base','headfix');
string_load=get(handles.listbox_load,'String');
string_unload=get(handles.listbox_unload,'String');
assignin('base','matrizcorr',string_load);
assignin('base','matrizcorr_del',string_unload);
head=headfix(:,1);
z=1;
for i=2:length(headfix(1,:))
    for j=1:length(string_load)
        if strcmp(headfix(1,i),string_load(j))
            head(:,z+1)=headfix(:,i);
            dado(:,z)=dadofix(:,i-1);
            z=z+1;
        end
    end
end
assignin('base','head',head);
assignin('base','dado',dado);
st_options=evalin('base','st_options');
if isempty(string_unload)
    st_options.selectVar=0;
else
    st_options.selectVar=1;
end
st_options.selectOK=1;
assignin('base','st_options',st_options);
close(select);
end

% --- Executes on button press in button_Cancel.
function button_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st_options=evalin('base','st_options');
st_options.selectOK=0;
assignin('base','st_options',st_options);
close(select);
end
