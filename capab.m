function varargout = capab(varargin)
% CAPAB MATLAB code for capab.fig
%      CAPAB, by itself, creates a new CAPAB or raises the existing
%      singleton*.
%
%      H = CAPAB returns the handle to a new CAPAB or the handle to
%      the existing singleton*.
%
%      CAPAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAPAB.M with the given input arguments.
%
%      CAPAB('Property','Value',...) creates a new CAPAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before capab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to capab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help capab

% Last Modified by GUIDE v2.5 12-Apr-2017 14:35:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @capab_OpeningFcn, ...
                   'gui_OutputFcn',  @capab_OutputFcn, ...
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

% --- Executes just before capab is made visible.
function capab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to capab (see VARARGIN)

% Choose default command line output for capab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

matrizcorr=evalin('base','matrizcorr');
set(handles.combobox_In,'String',matrizcorr);


% UIWAIT makes capab wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = capab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on selection change in combobox_In.
function combobox_In_Callback(hObject, eventdata, handles)
% hObject    handle to combobox_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns combobox_In contents as cell array
%        contents{get(hObject,'Value')} returns selected item from combobox_In
end

% --- Executes during object creation, after setting all properties.
function combobox_In_CreateFcn(hObject, eventdata, handles)
% hObject    handle to combobox_In (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in bt_Ok.
function bt_Ok_Callback(hObject, eventdata, handles)
% hObject    handle to bt_Ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reset(handles.grafico);
dado=evalin('base','dado');
head=evalin('base','head');
string=get(handles.combobox_In,'String');
for i=1:length(head(1,:))
    if strcmp(string(get(handles.combobox_In,'value')),head{1,i})
        index=i-1;
        break
    end
end
Pp=(str2double(get(handles.txt_Sup,'String'))-str2double(get(handles.txt_Inf,'String')))/(6*std(dado(~isnan(dado(:,index)),index)));
Ppu=(str2double(get(handles.txt_Sup,'String'))-mean(dado(~isnan(dado(:,index)),index)))/(3*std(dado(~isnan(dado(:,index)),index)));
Ppl=(mean(dado(~isnan(dado(:,index)),index))-str2double(get(handles.txt_Inf,'String')))/(3*std(dado(~isnan(dado(:,index)),index)));
Ppk=min(Ppu,Ppl);
%-----------
am=[];
for i=1:(length(dado(:,index))-1)
    am(i)=abs(dado(i,index)-dado(i+1,index));
end
d2=1.128;
meanAM=mean(am(~isnan(am)));
Cp=(str2double(get(handles.txt_Sup,'String'))-str2double(get(handles.txt_Inf,'String')))/(6*(meanAM/d2));
Cpu=(str2double(get(handles.txt_Sup,'String'))-mean(dado(~isnan(dado(:,index)),index)))/(3*(meanAM/d2));
Cpl=(mean(dado(~isnan(dado(:,index)),index))-str2double(get(handles.txt_Inf,'String')))/(3*(meanAM/d2));
Cpk=min(Cpu,Cpl);
%----
set(handles.cx_cp,'String',Cp);
set(handles.cx_cpl,'String',Cpl);
set(handles.cx_cpu,'String',Cpu);
set(handles.cx_cpk,'String',Cpk);
%----
set(handles.cx_pp,'String',Pp);
set(handles.cx_ppl,'String',Ppl);
set(handles.cx_ppu,'String',Ppu);
set(handles.cx_ppk,'String',Ppk);
axes(handles.grafico)
[~,h]=capaplot(dado(:,index),[str2double(get(handles.txt_Inf,'String')) str2double(get(handles.txt_Sup,'String'))]);
hold on
set(h,'Color',[0 0 0]);
Plot=gca;
Plot.Title.String='';
child2=Plot.Children(2);
child2.FaceAlpha=1;
child2.FaceColor=[1 1 0.48];
hold on
limiteSup=get(handles.grafico,'YLim');
plot([str2double(get(handles.txt_Sup,'String')) str2double(get(handles.txt_Sup,'String'))],[0 limiteSup(2)],'r');
plot([str2double(get(handles.txt_Inf,'String')) str2double(get(handles.txt_Inf,'String'))],[0 limiteSup(2)],'r');
text(str2double(get(handles.txt_Inf,'String')),limiteSup(2),'LIC');
text(str2double(get(handles.txt_Sup,'String')),limiteSup(2),'LSC');
if ~isempty(str2double(get(handles.txt_Tar,'String')))
    plot([str2double(get(handles.txt_Tar,'String')) str2double(get(handles.txt_Tar,'String'))],[0 limiteSup(2)],'g');
    text(str2double(get(handles.txt_Tar,'String')),limiteSup(2),'Target','Color',[0 0.7 0]);
end
hold off
%-------------
axes(handles.graf_Especs)
plot(handles.graf_Especs,[str2double(get(handles.txt_Inf,'String')) str2double(get(handles.txt_Sup,'String'))],[0 0],'Marker','*','MarkerEdgeColor','red');
if ~isempty(str2double(get(handles.txt_Tar,'String')))
    hold on
    plot(handles.graf_Especs,str2double(get(handles.txt_Tar,'String')),0,'Marker','*','MarkerEdgeColor','green');
    hold off
end
set(handles.graf_Especs,'XTickLabel',{[]});
set(handles.graf_Especs,'YTickLabel',{[]});
%-
hGlobal=plot(handles.graf_Global,[(mean(dado(~isnan(dado(:,index)),index))-(3*std(dado(~isnan(dado(:,index)),index)))) (mean(dado(~isnan(dado(:,index)),index))) (mean(dado(~isnan(dado(:,index)),index))+(3*std(dado(~isnan(dado(:,index)),index))))],[0 0 0]);
hGlobal.Marker='*';
hGlobal.MarkerEdgeColor='red';
set(handles.graf_Global,'XTickLabel',{[]});
set(handles.graf_Global,'YTickLabel',{[]});
%-
hWithin=plot(handles.graf_Within,[(mean(dado(~isnan(dado(:,index)),index))-(3*(meanAM/d2))) (mean(dado(~isnan(dado(:,index)),index))) (mean(dado(~isnan(dado(:,index)),index))+(3*(meanAM/d2)))],[0 0 0]);
hWithin.Marker='*';
hWithin.MarkerEdgeColor='red';
set(handles.graf_Within,'XTickLabel',{[]});
set(handles.graf_Within,'YTickLabel',{[]});
%---
minimox=min([str2double(get(handles.txt_Inf,'String')) (mean(dado(~isnan(dado(:,index)),index))-(3*std(dado(~isnan(dado(:,index)),index)))) (mean(dado(~isnan(dado(:,index)),index))-(3*(meanAM/d2)))]);
maximox=max([str2double(get(handles.txt_Sup,'String')) (mean(dado(~isnan(dado(:,index)),index))+(3*std(dado(~isnan(dado(:,index)),index)))) (mean(dado(~isnan(dado(:,index)),index))+(3*(meanAM/d2)))]);
if minimox<0
    minimox=minimox*1.1;
else
    minimox=minimox*0.9;
end
if maximox<0
    maximox=maximox*0.9;
else
    maximox=maximox*1.1;
end
handles.graf_Especs.XLim=[(minimox) (maximox)];
handles.graf_Global.XLim=[(minimox) (maximox)];
handles.graf_Within.XLim=[(minimox) (maximox)];
end

function txt_Sup_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Sup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Sup as text
%        str2double(get(hObject,'String')) returns contents of txt_Sup as a double
end

% --- Executes during object creation, after setting all properties.
function txt_Sup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Sup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function txt_Inf_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Inf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Inf as text
%        str2double(get(hObject,'String')) returns contents of txt_Inf as a double
end

% --- Executes during object creation, after setting all properties.
function txt_Inf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Inf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function txt_Tar_Callback(hObject, eventdata, handles)
% hObject    handle to txt_Tar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_Tar as text
%        str2double(get(hObject,'String')) returns contents of txt_Tar as a double
end

% --- Executes during object creation, after setting all properties.
function txt_Tar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_Tar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in check_sort.
function check_sort_Callback(hObject, eventdata, handles)
% hObject    handle to check_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_sort
matrizcorr=evalin('base','matrizcorr');
if get(hObject,'Value')==0
    set(handles.combobox_In,'string',matrizcorr);
else
    set(handles.combobox_In,'string',sort(matrizcorr));
end
end

function cx_cp_Callback(hObject, eventdata, handles)
% hObject    handle to cx_cp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_cp as text
%        str2double(get(hObject,'String')) returns contents of cx_cp as a double
end

% --- Executes during object creation, after setting all properties.
function cx_cp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_cp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function cx_cpl_Callback(hObject, eventdata, handles)
% hObject    handle to cx_cpl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_cpl as text
%        str2double(get(hObject,'String')) returns contents of cx_cpl as a double
end

% --- Executes during object creation, after setting all properties.
function cx_cpl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_cpl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function cx_cpu_Callback(hObject, eventdata, handles)
% hObject    handle to cx_cpu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_cpu as text
%        str2double(get(hObject,'String')) returns contents of cx_cpu as a double
end

% --- Executes during object creation, after setting all properties.
function cx_cpu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_cpu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function cx_cpk_Callback(hObject, eventdata, handles)
% hObject    handle to cx_cpk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_cpk as text
%        str2double(get(hObject,'String')) returns contents of cx_cpk as a double
end

% --- Executes during object creation, after setting all properties.
function cx_cpk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_cpk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function cx_pp_Callback(hObject, eventdata, handles)
% hObject    handle to cx_pp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_pp as text
%        str2double(get(hObject,'String')) returns contents of cx_pp as a double
end

% --- Executes during object creation, after setting all properties.
function cx_pp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_pp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function cx_ppl_Callback(hObject, eventdata, handles)
% hObject    handle to cx_ppl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_ppl as text
%        str2double(get(hObject,'String')) returns contents of cx_ppl as a double
end

% --- Executes during object creation, after setting all properties.
function cx_ppl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_ppl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function cx_ppu_Callback(hObject, eventdata, handles)
% hObject    handle to cx_ppu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_ppu as text
%        str2double(get(hObject,'String')) returns contents of cx_ppu as a double
end

% --- Executes during object creation, after setting all properties.
function cx_ppu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_ppu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function cx_ppk_Callback(hObject, eventdata, handles)
% hObject    handle to cx_ppk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cx_ppk as text
%        str2double(get(hObject,'String')) returns contents of cx_ppk as a double
end

% --- Executes during object creation, after setting all properties.
function cx_ppk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_ppk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
