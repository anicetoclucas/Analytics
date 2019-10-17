function varargout = Form(varargin)
% FORM MATLAB code for Form.fig
%      FORM, by itself, creates a new FORM or raises the existing
%      singleton*.
%
%      H =  FORM returns the handle to a new FORM or the handle to
%      the existing singleton*.
%
%      FORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM.M with the given input arguments.
%
%      FORM('Property','Value',...) creates a new FORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Form_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Form_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Form

% Last Modified by GUIDE v2.5 07-Jul-2017 12:48:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Form_OpeningFcn, ...
    'gui_OutputFcn',  @Form_OutputFcn, ...
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
end

% End initialization code - DO NOT EDIT


%    --- Executes just before Form is made visible.
function Form_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Form (see VARARGIN)

% Choose default command line output for Form
handles.output = hObject;

% Find app directory
if isdeployed
    [~,result]=system('path');
    currentDirPre=char(regexpi(result,'Path=(.*?);','tokens','once'));
    currentDir=strcat(currentDirPre,'\');
    assignin('base','currentDir',currentDir);
else
    currentDir='';
end
% Define variables to software options
st_options.removeOutliers=1;
st_options.selectVar=0;
st_options.selectOK=0;
assignin('base','st_options',st_options);
% Update the 'handles'
guidata(hObject, handles);
assignin('base','itUiTable',0);
assignin('base','loaded',0);
javaFrame=get(handles.output,'javaframe');
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon(strcat(currentDir,'icon.ico')));
Htable=findobj('Type','uitable');
jscrollpane=findjobj(Htable);
jtable=jscrollpane.getViewport.getView;
jtable.setSortable(true);
jtable.setAutoResort(true);
jtable.setMultiColumnSortable(false);
jtable.setPreserveSelectionsAfterSorting(true);

%Buttons icon
handles.btCorr.String='';
handles.btEstat.String='';
try
    [imCorr,~,~]=imread(strcat(currentDir,'icon2.png'));
    [imEstat,~,~]=imread(strcat(currentDir,'icon3.png'));
    handles.btCorr.Units='pixels';
    handles.btEstat.Units='pixels';
    imCorr=imresize(imCorr,fliplr(handles.btCorr.Position(1,3:4)));
    imEstat=imresize(imEstat,fliplr(handles.btEstat.Position(1,3:4)));
    handles.btCorr.Units='normalized';
    handles.btEstat.Units='normalized';
    set(handles.btCorr,'CData',imCorr);
    set(handles.btEstat,'CData',imEstat);
catch
    handles.btCorr.String='Correlação';
    handles.btEstat.String='Estatística';
end
end
% UIWAIT makes Form wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Form_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --------------------------------------------------------------------
function menu_abrir_Callback(hObject, eventdata, handles)
% hObject    handle to menu_abrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
progress=0;
assignin('base','itUiTable',0);
try
    [arq, caminho]=uigetfile('*.xls;*.xlsx','Abrir Arquivo');
    if arq ~= 0
        [~,plan]=xlsfinfo(strcat(caminho,arq));
        [selection,ok]=listdlg('PromptString','Selecione a planilha','ListSize',[160 50],'SelectionMode','single','ListString',plan);
        if ok==0
            return
        end
        progress=waitbar(0,'Carregando...');
        set(handles.figure1,'Pointer','watch')
        steps=3;
        step=1;
        waitbar(step/steps)Tratamento
        [dado,head]=xlsread(strcat(caminho,arq),selection);
        set(handles.uitable1,'Data',cellstr(''));
        evalin('base','clear matrizcorr matrizcorr_del bom ruim vt'); %Clear any remnant of last run
        tamHead=size(head);
        for i=tamHead(2):-1:2
            if strcmp(head{1,i},'') %Fixing invalid data
                head(1,i)=cellstr('[Null]'); 
            end
            if ~strcmp(head{2,i},'')
                head(:,i)=[];
            end
        end
        for i=2:tamHead(1)
            if length(head{i,1})==10
                head(i,1)=cellstr(strcat(head{i,1},' 00:00:00'));
            end
        end
        step=step+1;
        waitbar(step/steps)
        step=step+1;
        waitbar(step/steps)
        close(progress)
        %Loading ComboBox + First matrizcorr column
        assignin('base','dado',dado);
        assignin('base','dadofix',dado);
        assignin('base','head',head);
        assignin('base','headfix',head);
        matrizcorr=cellstr(head(1,2:end).');
        for i=1:length(matrizcorr)
            findReturn=matrizcorr{i}==char(10);
            marker=find(findReturn);
            if marker~=0
                temp=matrizcorr{i};
                temp(marker)=' ';
                matrizcorr(i)=cellstr(temp);
            end
        end
        assignin('base','matrizcorr',matrizcorr);
        if get(handles.check_sort,'Value')==0
            set(handles.combobox,'string',matrizcorr);
            set(handles.selxtar_combobox,'string',matrizcorr);
        else
            set(handles.combobox,'string',sort(head(1,2:size(head,2))));
            set(handles.selxtar_combobox,'string',sort(head(1,2:size(head,2))));
        end
        strTitle=['Analytics - ',arq];
        set(handles.figure1,'Name',strTitle);
        assignin('base','loaded',1);
        set(handles.figure1,'Pointer','arrow')
        mensagem=msgbox('Arquivo carregado com sucesso','Concluido');
        cla(handles.tabela1);
        cla(handles.tabela2);
        set(handles.caixa_menor,'string','0');
        set(handles.caixa_maior,'string','0');
        set(handles.cx_int_menor,'string','');
        set(handles.cx_int_maior,'string','');
        pause(1)
        try close(mensagem)
        end
    end
catch
    msgbox('Erro ao carregar o arquivo.','Erro','error');
    set(handles.figure1,'Pointer','arrow')
    try
        close(progress)
    end
    evalin('base','clear dado');
    evalin('base','clear head');
end
end

% --- Executes on selection change in combobox.
function combobox_Callback(hObject, eventdata, handles)
% hObject    handle to combobox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Calculate correlation for every item
cla;
clear dadoOld
global dadoedit
dado=evalin('base','dado');
head=evalin('base','head');
matrizcorr=head(1,2:end).';
string=get(handles.combobox,'String');
set(handles.cx_int_menor,'String','');
set(handles.cx_int_maior,'String','');
%--------------- Inicialize the table maker to Java
Htable=findobj('Type','uitable');
jscrollpane=findjobj(Htable);
jtable=jscrollpane.getViewport.getView;
row=strmatch(string(get(handles.combobox,'value')),cellstr(matrizcorr(:,1)));
row=row(1);
jtable.setRowSelectionAllowed(0);
jtable.setColumnSelectionAllowed(0);
%--------------- Start calcs to show on table
try
    for i=1:length(head(1,:))
        if strcmp(string(get(handles.combobox,'value')),head{1,i})
            index=i-1;
            break
        end
    end
    progress=waitbar(0,'Carregando...');
    set(handles.figure1,'Pointer','watch')
    steps=4+length(matrizcorr(:,1).');
    step=1;
    for i=1:length(matrizcorr(:,1).')
        matrizcorr(i,9)=cellstr(sprintf('%g',min(dado(:,i))));
        z=1;
        for j=1:length(dado(:,i))
            if ~isnan(dado(j,i))
                media(z)=dado(j,i);
            end
            z=z+1;
        end
        matrizcorr(i,10)=cellstr(sprintf('%g',median(media(:))));
        matrizcorr(i,11)=cellstr(sprintf('%g',max(dado(:,i))));
    end
    set(handles.caixa_menor,'String',sprintf('%.3f',min(dado(:,index))-min(dado(:,index))*0.01));
    if strcmp(get(handles.caixa_menor,'String'),sprintf('%.3f',min(dado(:,index))))
        if sprintf('%.3f',min(dado(:,index)))==0
            set(handles.caixa_menor,'String',0);
        else
            set(handles.caixa_menor,'String',sprintf('%.3f',min(dado(:,index))-0.001));
        end
    end
    set(handles.caixa_maior,'String',sprintf('%.3f',max(dado(:,index))+min(dado(:,index))*0.01));
    if strcmp(get(handles.caixa_maior,'String'),sprintf('%.3f',min(dado(:,index))))
        set(handles.caixa_maior,'String',sprintf('%.3f',min(dado(:,index))+0.001));
    end
    %%%Pearson a Spearman(FP) (w/ pvalue)
    for i=1:length(matrizcorr(:,1).')
        try [~,pvalue_norm]=adtest(dado(:,i));
        catch
            pvalue_norm=NaN;
        end
        try correlacao=corr(dado(:,index),dado(:,i),'rows','pairwise');
        catch
            correlacao=NaN;
        end
        try correlacaofp=corr(dado(:,index),dado(:,i),'type','Spearman','rows','pairwise');
        catch
            correlacaofp=NaN;
        end
        if correlacao<0
            matrizcorr(i,2)=cellstr('-');
        end
        if correlacaofp<0
            matrizcorr(i,4)=cellstr('-');
        end
        matrizcorr(i,3)=cellstr(sprintf('%0.4f',abs(correlacao)));
        matrizcorr(i,5)=cellstr(sprintf('%0.4f',abs(correlacaofp)));
        if pvalue_norm <= 0.0005
            matrizcorr(i,7)=cellstr('<');
        end
        matrizcorr(i,8)=cellstr(sprintf('%0.6f',pvalue_norm));
        [~,msgid]=lastwarn();
        warning('off',msgid);
        assignin('base','dadoFULL',matrizcorr);
        dadoedit=matrizcorr;
    end
    waitbar(step/steps)
    step=step+1;
    %%%------------------
    %%%Rsquare
    for i=1:length(matrizcorr(:,1).')
        mdl=fitlm(dado(:,index),dado(:,i));
        [~,msgid]=lastwarn();
        matrizcorr(i,6)=cellstr(sprintf('%0.4f',abs(mdl.Rsquared.Adjusted)));
        waitbar(step/steps)
        step=step+1;
    end
    warning('off',msgid);
    waitbar(step/steps)
    step=step+1;
    %%%---------
    %%% Convert NaN to 0
    for i=1:length(matrizcorr(:,1).')
        if strcmp((matrizcorr{i,3}),'NaN')
            matrizcorr(i,3)=cellstr('0.000a');
        end
        if strcmp((matrizcorr{i,5}),'NaN')
            matrizcorr(i,5)=cellstr('0.000a');
        end
        if strcmp((matrizcorr{i,6}),'NaN')
            matrizcorr(i,6)=cellstr('0.000a');
        end
    end
    
    %%%---------
    vt_bom=NaN(1,length(dado(:,index).'));
    vt_tampao=NaN(1,length(dado(:,index).'));
    vt_ruim=NaN(1,length(dado(:,index).'));
    waitbar(step/steps);
    step=step+1;
    assignin('base','index',index);
    assignin('base','bom',vt_bom);
    assignin('base','tampao',vt_tampao);
    assignin('base','ruim',vt_ruim);
    assignin('base','dadoFULL',matrizcorr);
    btCorr_Callback(handles.btCorr,eventdata,handles);
    waitbar(step/steps)
    set(handles.figure1,'Pointer','arrow')
    close(progress)
    jtable.changeSelection(row-1,0,false,false);
    set(handles.caixa_pBom,'String','100%');
    set(handles.caixa_pRuim,'String','0%');
    set(handles.caixa_pTampao,'String','0%');
catch erro
    set(handles.figure1,'Pointer','arrow')
    errordlg(sprintf('Erro ao calcular os dados.\n\n%s', erro.message),'Erro');
    close(progress)
end
end

% --- Executes on selection change in popupbom.
function popupbom_Callback(hObject, eventdata, handles)
% hObject    handle to popupbom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.popupbom,'value')==1
    set(handles.popupruim,'value',1);
    reset(handles.tabela1);
end
if get(handles.popupbom,'value')==2
    set(handles.popupruim,'value',2);
    reset(handles.tabela1);
end
end
% Hints: contents = cellstr(get(hObject,'String')) returns popupbom contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupbom

% --- Executes on selection change in popupruim.
function popupruim_Callback(hObject, eventdata, handles)
% hObject    handle to popupruim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.popupruim,'value')==1
    set(handles.popupbom,'value',1);
    reset(handles.tabela1);
end
if get(handles.popupruim,'value')==2
    set(handles.popupbom,'value',2);
    reset(handles.tabela1);
end
end

% Hints: contents = cellstr(get(hObject,'String')) returns popupruim contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupruim

% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
cla;
index=evalin('base','index');
dado=evalin('base','dado');
dadoFULL=evalin('base','dadoFULL');
try
    num_row=eventdata.Indices(1);
    Htable=findobj('Type','uitable');
    %---------------
    jscrollpane=findjobj(Htable);
    jtable=jscrollpane.getViewport.getView;
    object=jtable.getValueAt(num_row-1,0);
    row=strmatch(object,cellstr(dadoFULL(:,1)));
    row=row(1);
    %---------------
    if index==row
        set(handles.radioBom,'Enable','on');
        set(handles.radioRuim,'Enable','on');
        set(handles.caixa_menor,'Enable','on');
        set(handles.caixa_maior,'Enable','on');
        set(handles.caixa_pBom,'Visible','on');
        set(handles.caixa_pRuim,'Visible','on');
        set(handles.caixa_pTampao,'Visible','on');
        set(handles.str_Bom,'Visible','on');
        set(handles.str_Ruim,'Visible','on');
        set(handles.str_Tampao,'Visible','on');
        set(handles.cx_int_menor,'Enable','on')
        set(handles.cx_int_maior,'Enable','on')
    else
        set(handles.radioBom,'Enable','off');
        set(handles.radioRuim,'Enable','off');
        set(handles.caixa_menor,'Enable','off');
        set(handles.caixa_maior,'Enable','off');
        set(handles.caixa_pBom,'Visible','off');
        set(handles.caixa_pRuim,'Visible','off');
        set(handles.caixa_pTampao,'Visible','off');
        set(handles.str_Bom,'Visible','off');
        set(handles.str_Ruim,'Visible','off');
        set(handles.str_Tampao,'Visible','off');
        set(handles.cx_int_menor,'Enable','off')
        set(handles.cx_int_maior,'Enable','off')
    end
    %--------------- Segmentation good and bad data
    set(handles.figure1,'Pointer','watch')
    assignin('base','itUiTable',row);
    vt_bom=NaN(1,length(dado(:,index).'));
    vt_ruim=NaN(1,length(dado(:,index).'));
    if get(handles.radioBom,'value')==1
        for i=1:length(dado(:,row).')
            if dado(i,index)>=str2double(get(handles.caixa_menor,'string')) &&...
                    dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
                vt_bom(i)=dado(i,row);
            else
                vt_ruim(i)=dado(i,row);
            end
        end
    else
        for i=1:length(dado(:,row).')
            if dado(i,index)>=str2double(get(handles.caixa_menor,'string')) &&...
                    dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
                vt_ruim(i)=dado(i,row);
            else
                vt_bom(i)=dado(i,row);
            end
        end
    end
    if ~isempty(get(handles.cx_int_maior,'string')) && ~isempty(get(handles.cx_int_menor,'string'))    
        vt_tampao=NaN(1,length(dado(:,row).'));
        for i=1:length(dado(:,row).')
            if ~isnan(vt_bom(i))
                if dado(i,index)>=str2double(get(handles.cx_int_menor,'string')) &&...
                        dado(i,index)<=str2double(get(handles.cx_int_maior,'string'))
                    vt_tampao(i)=vt_bom(i);
                    vt_bom(i)=NaN;
                end
            elseif ~isnan(vt_ruim(i))
                if dado(i,index)>=str2double(get(handles.cx_int_menor,'string')) &&...
                        dado(i,index)<=str2double(get(handles.cx_int_maior,'string'))
                    vt_tampao(i)=vt_ruim(i);
                    vt_ruim(i)=NaN;
                end
            end
        end
    else
        vt_tampao=NaN(1,length(dado(:,row).'));
    end
    assignin('base','bom',vt_bom);
    assignin('base','ruim',vt_ruim);
    assignin('base','tampao',vt_tampao);
    if get(handles.table_hist,'value') % Histogram
        table_hist_Callback(handles.table_hist, eventdata, handles)
    end
    if get(handles.table_dots,'value')  % Dots chart
        table_dots_Callback(handles.table_dots, eventdata, handles)
    elseif get(handles.table_chart,'value') % Control chart
        table_chart_Callback(handles.table_chart, eventdata, handles)
    end
    rangeLim=get(handles.tabela2,'YLim');       %%
    rangeLim(1)=rangeLim(1)-rangeLim(1)*0.01;    % Define the range
    rangeLim(2)=rangeLim(2)+rangeLim(2)*0.01;    % of histogram.
    set(handles.tabela1,'XLim',rangeLim);       %%
    if get(handles.table_boxplot,'value') % Boxplot
        table_boxplot_Callback(handles.table_boxplot, eventdata, handles)
    elseif get(handles.table_selxtar,'value'); % Variable x Variable chart
        table_selxtar_Callback(handles.table_selxtar, eventdata, handles);
    end
    set(handles.figure1,'Pointer','arrow')
catch
    set(handles.figure1,'Pointer','arrow')
end
end

function intClasses = ajuste_barras (dados)
% Adjustment intervals lenght of histogram function
minimo=min(dados);
maximo=max(dados);
delta=maximo - minimo;
numClasses=sqrt(length(dados));
intClasses=delta/(numClasses);
if isnan(intClasses)
    intClasses=0;
end
end

% --------------------------------------------------------------------
function menu_limpeza_Callback(hObject, eventdata, handles)
% hObject    handle to menu_limpeza (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hand=limites;
waitfor(hand);
choise=evalin('base','buttonchoise');
if choise == 1
    h=findobj('Type','histogram');
    limbaixo=evalin('base','limbaixo');
    limalto=evalin('base','limalto');
    h(1).BinLimits=[limbaixo limalto];
    classe=ajuste_barras(h(1).Data);
    h(1).BinWidth=classe;
    h(2).BinLimits=[limbaixo limalto];
    h(2).BinWidth=classe;
    clear base limalto;
    clear base limbaixo;
    clear base buttonchoise;
end
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hO    bject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.gra_hist,'value')==1
    %%%%%Generate histogram chart
    table_hist_Callback(handles.table_hist, eventdata, handles)
end
end

% --- Executes on button press in radioBom.
function radioBom_Callback(hObject, eventdata, handles)
% hObject    handle to radioBom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radioRuim,'value')==0
    set(hObject,'value',1);
else
    set(handles.radioRuim,'value',0);
    caixa_menor_Callback(handles.caixa_menor, eventdata, handles)
end
% Hint: get(hObject,'Value') returns toggle state of radioBom
end

% --- Executes on button press in radioRuim.
function radioRuim_Callback(hObject, eventdata, handles)
% hObject    handle to radioRuim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.radioBom,'value')==0
    set(hObject,'value',1);
else
    set(handles.radioBom,'value',0);
    set(hObject,'value',1);
    caixa_menor_Callback(handles.caixa_menor, eventdata, handles)
end
% Hint: get(hObject,'Value') returns toggle state of radioRuim
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','clear all');
% Hint: delete(hObject) closes the figure
delete(hObject);
end

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global dadoedit
dado=evalin('base','dado');
dadofix=evalin('base','dadofix');
index=evalin('base','index');
dadoFULL=evalin('base','dadoFULL');
row=evalin('base','itUiTable');
st_options=evalin('base','st_options');
% Variable 'dado' editing
step=1;
steps=5;
progress=waitbar(0,'Carregando...');
set(handles.figure1,'Pointer','watch')
waitbar(step/steps);
switch st_options.removeOutliers
    case 0
        step=step+1;
        waitbar(step/steps);
        if eventdata.Indices(2)==2
            for i=1:length(dado(:,row))
                if dadofix(i,row)>=str2double(eventdata.EditData) ...
                        && dadofix(i,row)<=str2double(dadoedit(row,11))
                    dado(i,row)=dadofix(i,row);
                else
                    dado(i,row)=NaN;
                end
            end
            dadoedit(row,9)=cellstr(event.EditData);
            dadoFULL(row,9)=cellstr(event.EditData);
        elseif eventdata.Indices(2)==4
            for i=1:length(dado(:,row))
                if dadofix(i,row)<=str2double(eventdata.EditData) ...
                        && dadofix(i,row)>=str2double(dadoedit(row,9))
                    dado(i,row)=dadofix(i,row);
                else
                    dado(i,row)=NaN;
                end
            end
            dadoedit(row,11)=cellstr(event.EditData);
            dadoFULL(row,11)=cellstr(event.EditData);
        elseif eventdata.Indices(2)==9
            for i=1:length(dado(:,row))
                if dadofix(i,row)>=str2double(eventdata.EditData) ...
                        && dadofix(i,row)<=str2double(dadoedit(row,11))
                    dado(i,row)=dadofix(i,row);
                else
                    dado(i,row)=NaN;
                end
            end
            dadoedit(row,9)=cellstr(event.EditData);
            dadoFULL(row,9)=cellstr(event.EditData);
        elseif eventdata.Indices(2)==11
            for i=1:length(dado(:,row))
                if dadofix(i,row)<=str2double(eventdata.EditData) ...
                        && dadofix(i,row)>=str2double(dadoedit(row,9))
                    dado(i,row)=dadofix(i,row);
                else
                    dado(i,row)=NaN;
                end
            end
            dadoedit(row,11)=cellstr(event.EditData);
            dadoFULL(row,11)=cellstr(event.EditData);
        end
        step=step+1;
        waitbar(step/steps);
        dadoFULL(row,10)=cellstr(sprintf('%g',median(dado(~isnan(dado(:,row)),row))));
        % Change the data edited color style
        if isdeployed
            currentDir=evalin('base','currentDir');
        else
            currentDir='';
        end
        javaaddpath(strcat(currentDir,'ColoredFieldCellRenderer.zip'));
        cr=ColoredFieldCellRenderer(java.awt.Color.white);
        cr.setDisabled(false);
        step=step+1;
        waitbar(step/steps);
        if eventdata.Indices(2)==2
            Stemp='<html><span style="color:#FF0000"><b>';
            Stemp=strcat(Stemp,num2str(eventdata.EditData));
            Stemp=strcat(Stemp,'</b></span></html>');
            dadoFULL(eventdata.Indices(1),9)=cellstr(Stemp);
        elseif eventdata.Indices(2)==4
            Stemp='<html><span style="color:#FF0000"><b>';
            Stemp=strcat(Stemp,num2str(eventdata.EditData));
            Stemp=strcat(Stemp,'</b></span></html>');
            dadoFULL(eventdata.Indices(1),11)=cellstr(Stemp);
        elseif eventdata.Indices(2)==9
            Stemp='<html><span style="color:#FF0000"><b>';
            Stemp=strcat(Stemp,num2str(eventdata.EditData));
            Stemp=strcat(Stemp,'</b></span></html>');
            dadoFULL(eventdata.Indices(1),9)=cellstr(Stemp);
        elseif eventdata.Indices(2)==11
            Stemp='<html><span style="color:#FF0000"><b>';
            Stemp=strcat(Stemp,num2str(eventdata.EditData));
            Stemp=strcat(Stemp,'</b></span></html>');
            dadoFULL(eventdata.Indices(1),11)=cellstr(Stemp);
        end
        step=step+1;
        waitbar(step/steps);
        assignin('base','dadoFULL',dadoFULL);
        assignin('base','dado',dado);
        reset(handles.tabela1);
        h1=histogram(handles.tabela1,dado(:,row));
        h1.BinWidth=ajuste_barras(h1.Data);
        h1.FaceColor=[0.666667 0.666667 0.666667];
        %--------------------------------------------------------------------------------
    case 1
        step=step+1;
        waitbar(step/steps);
        if eventdata.Indices(2)==2
            for i=1:length(dado(:,row))
                if dadofix(i,row)>=str2double(eventdata.EditData) ...
                        && dadofix(i,row)<=str2double(dadoedit(row,11))
                    dado(i,:)=dadofix(i,:);
                else
                    dado(i,:)=NaN;
                end
            end
            dadoedit(row,9)=cellstr(eventdata.EditData);
            dadoFULL(row,9)=cellstr(eventdata.EditData);
        elseif eventdata.Indices(2)==4
            for i=1:length(dado(:,row))
                if dadofix(i,row)<=str2double(eventdata.EditData) ...
                        && dadofix(i,row)>=str2double(dadoedit(row,9))
                    dado(i,:)=dadofix(i,:);
                else
                    dado(i,:)=NaN;
                end
            end
            dadoedit(row,11)=cellstr(eventdata.EditData);
            dadoFULL(row,11)=cellstr(eventdata.EditData);
        elseif eventdata.Indices(2)==9
            for i=1:length(dado(:,row))
                if dadofix(i,row)>=str2double(eventdata.EditData) ...
                        && dadofix(i,row)<=str2double(dadoedit(row,11))
                    dado(i,:)=dadofix(i,:);
                else
                    dado(i,:)=NaN;
                end
            end
            dadoedit(row,9)=cellstr(eventdata.EditData);
            dadoFULL(row,9)=cellstr(eventdata.EditData);
        elseif eventdata.Indices(2)==11
            for i=1:length(dado(:,row))
                if dadofix(i,row)<=str2double(eventdata.EditData) ...
                        && dadofix(i,row)>=str2double(dadoedit(row,9))
                    dado(i,:)=dadofix(i,:);
                else
                    dado(i,:)=NaN;
                end
            end
            dadoedit(row,11)=cellstr(eventdata.EditData);
            dadoFULL(row,11)=cellstr(eventdata.EditData);
        end
        step=step+1;
        waitbar(step/steps);
        dadoFULL(row,10)=cellstr(sprintf('%g',median(dado(~isnan(dado(:,row)),row))));
        % Change the data edited color style
        if isdeployed
            currentDir=evalin('base','currentDir');
        else
            currentDir='';
        end
        javaaddpath(strcat(currentDir,'ColoredFieldCellRenderer.zip'));
        cr=ColoredFieldCellRenderer(java.awt.Color.white);
        cr.setDisabled(false);
        step=step+1;
        waitbar(step/steps);
        if eventdata.Indices(2)==2
            Stemp='<html><span style="color:#FF0000"><b>';
            Stemp=strcat(Stemp,num2str(eventdata.EditData));
            Stemp=strcat(Stemp,'</b></span></html>');
            dadoFULL(eventdata.Indices(1),9)=cellstr(Stemp);
        elseif eventdata.Indices(2)==4
            Stemp='<html><span style="color:#FF0000"><b>';
            Stemp=strcat(Stemp,num2str(eventdata.EditData));
            Stemp=strcat(Stemp,'</b></span></html>');
            dadoFULL(eventdata.Indices(1),11)=cellstr(Stemp);
        elseif eventdata.Indices(2)==9
            Stemp='<html><span style="color:#FF0000"><b>';
            Stemp=strcat(Stemp,num2str(eventdata.EditData));
            Stemp=strcat(Stemp,'</b></span></html>');
            dadoFULL(eventdata.Indices(1),9)=cellstr(Stemp);
        elseif eventdata.Indices(2)==11
            Stemp='<html><span style="color:#FF0000"><b>';
            Stemp=strcat(Stemp,num2str(eventdata.EditData));
            Stemp=strcat(Stemp,'</b></span></html>');
            dadoFULL(eventdata.Indices(1),11)=cellstr(Stemp);
        end
        step=step+1;
        waitbar(step/steps);
        assignin('base','dadoFULL',dadoFULL);
        assignin('base','dado',dado);
        reset(handles.tabela1);
        h1=histogram(handles.tabela1,dado(:,row));
        h1.BinWidth=ajuste_barras(h1.Data);
        h1.FaceColor=[0.666667 0.666667 0.666667];
end
%--- End of variable 'dado' editing

% Update correlations
%%%Pearson a Spearman(FP) (w/ pvalue)
matrizcorr=dadoFULL;
step=1;
steps=8+length(matrizcorr(:,1).')*2;
waitbar(step/steps);
for i=1:length(matrizcorr(:,1).')
    step=step+1;
    waitbar(step/steps);
    try [~,pvalue_norm]=adtest(dado(:,i));
    catch
        pvalue_norm=NaN;
    end
    try correlacao=corr(dado(:,index),dado(:,i),'rows','pairwise');
    catch
        correlacao=NaN;
    end
    try correlacaofp=corr(dado(:,index),dado(:,i),'type','Spearman','rows','pairwise');
    catch
        correlacaofp=NaN;
    end
    if correlacao<0
        matrizcorr(i,2)=cellstr('-');
    end
    if correlacaofp<0
        matrizcorr(i,4)=cellstr('-');
    end
    matrizcorr(i,3)=cellstr(sprintf('%0.4f',abs(correlacao)));
    matrizcorr(i,5)=cellstr(sprintf('%0.4f',abs(correlacaofp)));
    if pvalue_norm <= 0.0005
        matrizcorr(i,7)=cellstr('<');
    end
    matrizcorr(i,8)=cellstr(sprintf('%0.6f',pvalue_norm));
    [~,msgid]=lastwarn();
    warning('off',msgid);
    assignin('base','dadoFULL',matrizcorr);
end
step=step+1;
waitbar(step/steps);
%%%------------------
%%%Rsquare
for i=1:length(matrizcorr(:,1).')
    mdl=fitlm(dado(:,index),dado(:,i));
    [~,msgid]=lastwarn();
    matrizcorr(i,6)=cellstr(sprintf('%0.4f',abs(mdl.Rsquared.Adjusted)));
    step=step+1;
    waitbar(step/steps);
end
warning('off',msgid);
step=step+1;
waitbar(step/steps);
%%%---------
%%% NaN to 0
for i=1:length(matrizcorr(:,1).')
    if strcmp((matrizcorr{i,3}),'NaN')
        matrizcorr(i,3)=cellstr('0');
    end
    if strcmp((matrizcorr{i,5}),'NaN')
        matrizcorr(i,5)=cellstr('0');
    end
    if strcmp((matrizcorr{i,6}),'NaN')
        matrizcorr(i,6)=cellstr('0');
    end
end
assignin('base','dadoFULL',matrizcorr);
step=step+1;
waitbar(step/steps);
%--- End of correlations update

assignin('base','itUiTable',row);
vt_bom=NaN(1,length(dado(:,index).'));
vt_ruim=NaN(1,length(dado(:,index).'));
if get(handles.radioBom,'value')==1
    for i=1:length(dado(:,row).')
        if dado(i,index)>=str2double(get(handles.caixa_menor,'string')) &&...
                dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
            vt_bom(i)=dado(i,row);
        else
            vt_ruim(i)=dado(i,row);
        end
    end
else
    for i=1:length(dado(:,row).')
        if dado(i,index)>=str2double(get(handles.caixa_menor,'string')) &&...
                dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
            vt_ruim(i)=dado(i,row);
        else
            vt_bom(i)=dado(i,row);
        end
    end
end
step=step+1;
waitbar(step/steps);
if get(handles.table_hist,'value') %Histogram
    table_hist_Callback(handles.table_hist, eventdata, handles)
end
step=step+1;
waitbar(step/steps);
if get(handles.table_dots,'value')  %%%  Dots chart
    table_dots_Callback(handles.table_dots, eventdata, handles)
elseif get(handles.table_chart,'value') %%%  Control chart
    table_chart_Callback(handles.table_chart, eventdata, handles)
end
step=step+1;
waitbar(step/steps);
set(handles.tabela1,'XLim',get(handles.tabela2,'YLim'));
if get(handles.table_boxplot,'value') %Boxplot
    table_boxplot_Callback(handles.table_boxplot, eventdata, handles)
elseif get(handles.table_selxtar,'value'); %Variable x Variable chart
    table_selxtar_Callback(handles.table_selxtar, eventdata, handles)
end
step=step+1;
waitbar(step/steps);
assignin('base','bom',vt_bom);
assignin('base','ruim',vt_ruim);
if eventdata.Indices(2)==2 || eventdata.Indices(2)==4
    btEstat_Callback(handles.btEstat, eventdata, handles);
else
    btCorr_Callback(handles.btCorr, eventdata, handles);
end
set(handles.figure1,'Pointer','arrow')
close(progress)
Htable=findobj('Type','uitable');
jscrollpane=findjobj(Htable);
jtable=jscrollpane.getViewport.getView;
jtable.changeSelection(eventdata.Indices(1)-1,eventdata.Indices(2)-1,false,false);
end

% --------------------------------------------------------------------
function form_Options_Callback(hObject, eventdata, handles)
% hObject    handle to form_Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
form_Options;
end

% --- Executes on button press in btCorr.
function btCorr_Callback(hObject, eventdata, handles)
% hObject    handle to btCorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Define main table exibition mode
matrizcorr=evalin('base','dadoFULL');
get(handles.uitable1,'data');
matrizcorr_new=matrizcorr(:,1:11);
for i=1:length(matrizcorr_new)
    vet_tam(i)=length(matrizcorr_new{i,1});
end
max_tam=max(vet_tam);
set(handles.uitable1,'data',matrizcorr_new);
set(handles.uitable1,'ColumnName',{'Nome';[];'Pearson';[];'Spearman';'R²';[];'P-Value';'Min';'Mediana';'Max'});
set(handles.uitable1,'ColumnWidth',{max_tam*5 10 'auto' 10 'auto' 'auto' 10 'auto' 'auto' 'auto' 'auto'});
set(handles.uitable1,'ColumnEditable',[false false false false false false false false true false true]);
end

% --- Executes on button press in btEstat.
function btEstat_Callback(hObject, eventdata, handles)
% hObject    handle to btEstat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Define main table exibition mode
matrizcorr=evalin('base','dadoFULL');
matrizcorr_new=[matrizcorr(:,1) matrizcorr(:,9:11)];
set(handles.uitable1,'data',matrizcorr_new);
set(handles.uitable1,'ColumnName',{'Nome';'Min';'Mediana';'Max'});
set(handles.uitable1,'ColumnWidth',{'auto' 'auto' 'auto' 'auto'});
set(handles.uitable1,'ColumnEditable',[false true false true]);
end

function ctrlChart_Callback(hObject, eventdata, handles)
% hObject    handle to ctrlChart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Start control chart
if evalin('base','loaded')~=0
    fh=ControlChart;
    waitfor(fh);
else
    msgbox({'Dado inexistente.' 'Carregue uma fonte de dados antes de solicitar uma carta de controle.'},'Erro','error');
end
end

% --------------------------------------------------------------------
function corrTab_Callback(hObject, eventdata, handles)
% hObject    handle to corrTab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Start the color correlation chart
if evalin('base','loaded')~=0
    fh=matrizcor;
    waitfor(fh);
else
    msgbox({'Dado inexistente.' 'Carregue uma fonte de dados antes de solicitar a tabela de correlações.'},'Erro','error');
end
end

function caixa_menor_Callback(hObject, eventdata, handles)
% hObject    handle to caixa_menor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=get(hObject,'String');
new_temp=strrep(temp,',','.');
set(hObject,'String',new_temp);
index=evalin('base','index');
dado=evalin('base','dado');
row=evalin('base','itUiTable');
if row==0
    row=index;
end
set(handles.figure1,'Pointer','watch')
vt_bom=NaN(1,length(dado(:,row).'));
vt_ruim=NaN(1,length(dado(:,row).'));
if ~isempty(get(handles.caixa_menor,'string')) || ~isempty(get(handles.caixa_maior,'string'))
    if get(handles.radioBom,'value')==1
        for i=1:length(dado(:,row).')
            if str2double(num2str(dado(i,index)))>=str2double(get(handles.caixa_menor,'string')) &&...
                    str2double(num2str(dado(i,index)))<=str2double(get(handles.caixa_maior,'string'))
                vt_bom(i)=dado(i,row);
            else
                vt_ruim(i)=dado(i,row);
            end
        end
    else
        for i=1:length(dado(:,row).')
            if str2double(num2str(dado(i,index)))>=str2double(get(handles.caixa_menor,'string')) &&...
                    str2double(num2str(dado(i,index)))<=str2double(get(handles.caixa_maior,'string'));
                vt_ruim(i)=dado(i,row);
            else
                vt_bom(i)=dado(i,row);
            end
        end
    end
else
    if isempty(get(handles.caixa_menor,'string'))
        if get(handles.radioBom,'value')==1
            for i=1:length(dado(:,row).')
                if dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
                    vt_bom(i)=dado(i,row);
                else
                    vt_ruim(i)=dado(i,row);
                end
            end
        else
            for i=1:length(dado(:,row).')
                if dado(i,index)<=str2double(get(handles.caixa_maior,'string'));
                    vt_ruim(i)=dado(i,row);
                else
                    vt_bom(i)=dado(i,row);
                end
            end
        end
    else
        if isempty(get(handles.caixa_maior,'string'))
            if get(handles.radioBom,'value')==1
                for i=1:length(dado(:,row).')
                    if dado(i,index)>=str2double(get(handles.caixa_menor,'string'))
                        vt_bom(i)=dado(i,row);
                    else
                        vt_ruim(i)=dado(i,row);
                    end
                end
            else
                for i=1:length(dado(:,row).')
                    if dado(i,index)>=str2double(get(handles.caixa_menor,'string'));
                        vt_ruim(i)=dado(i,row);
                    else
                        vt_bom(i)=dado(i,row);
                    end
                end
            end
        end
    end
end
if ~isempty(get(handles.cx_int_maior,'string')) && ~isempty(get(handles.cx_int_menor,'string'))    
    vt_tampao=NaN(1,length(dado(:,row).'));
    for i=1:length(dado(:,row).')
        if ~isnan(vt_bom(i))
            if vt_bom(i)>=str2double(get(handles.cx_int_menor,'string')) &&...
                    vt_bom(i)<=str2double(get(handles.cx_int_maior,'string'))
                vt_tampao(i)=vt_bom(i);
                vt_bom(i)=NaN;
            end
        elseif ~isnan(vt_ruim(i))
            if vt_ruim(i)>=str2double(get(handles.cx_int_menor,'string')) &&...
                    vt_ruim(i)<=str2double(get(handles.cx_int_maior,'string'))
                vt_tampao(i)=vt_ruim(i);
                vt_ruim(i)=NaN;
            end
        end
    end
else
    vt_tampao=NaN(1,length(dado(:,row).'));
end
assignin('base','bom',vt_bom);
assignin('base','ruim',vt_ruim);
assignin('base','tampao',vt_tampao);
set(handles.figure1,'Pointer','arrow')
if get(handles.table_hist,'value') % Histogram
    table_hist_Callback(handles.table_hist, eventdata, handles)
end
if get(handles.table_dots,'value')  %%%  Dots chart
    table_dots_Callback(handles.table_dots, eventdata, handles)
elseif get(handles.table_chart,'value') %%%  Control chart
    table_chart_Callback(handles.table_chart, eventdata, handles)
end
set(handles.tabela1,'XLim',get(handles.tabela2,'YLim'))
if get(handles.table_boxplot,'value') %Boxplot
    table_boxplot_Callback(handles.table_boxplot, eventdata, handles)
elseif get(handles.table_selxtar,'value') %Variable x Variable chart
    table_selxtar_Callback(handles.table_selxtar, eventdata, handles);
end
[strBom,strRuim,strTampao]=cont_Percent(vt_bom,vt_ruim,vt_tampao);
set(handles.caixa_pBom,'String',strBom);
set(handles.caixa_pRuim,'String',strRuim);
set(handles.caixa_pTampao,'String',strTampao);
% Hints: get(hObject,'String') returns contents of caixa_menor as text
%        str2double(get(hObject,'String')) returns contents of caixa_menor as a double
end

function caixa_maior_Callback(hObject, eventdata, handles)
% hObject    handle to caixa_maior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp=get(hObject,'String');
new_temp=strrep(temp,',','.');
set(hObject,'String',new_temp);
index=evalin('base','index');
dado=evalin('base','dado');
row=evalin('base','itUiTable');
if row==0
    row=index;  
end
set(handles.figure1,'Pointer','watch')
vt_bom=NaN(1,length(dado(:,row).'));
vt_ruim=NaN(1,length(dado(:,row).'));
if ~isempty(get(handles.caixa_menor,'string')) || ~isempty(get(handles.caixa_maior,'string'))
    if get(handles.radioBom,'value')==1
        for i=1:length(dado(:,row).')
            if dado(i,index)>=str2double(get(handles.caixa_menor,'string')) &&...
                    dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
                vt_bom(i)=dado(i,row);
            else
                vt_ruim(i)=dado(i,row);
            end
        end
    else
        for i=1:length(dado(:,row).')
            if dado(i,index)>=str2double(get(handles.caixa_menor,'string')) &&...
                    dado(i,index)<=str2double(get(handles.caixa_maior,'string'));
                vt_ruim(i)=dado(i,row);
            else
                vt_bom(i)=dado(i,row);
            end
        end
    end
else
    if isempty(get(handles.caixa_menor,'string'))
        if get(handles.radioBom,'value')==1
            for i=1:length(dado(:,row).')
                if dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
                    vt_bom(i)=dado(i,row);
                else
                    vt_ruim(i)=dado(i,row);
                end
            end
        else
            for i=1:length(dado(:,row).')
                if dado(i,index)<=str2double(get(handles.caixa_maior,'string'));
                    vt_ruim(i)=dado(i,row);
                else
                    vt_bom(i)=dado(i,row);
                end
            end
        end
    else
        if isempty(get(handles.caixa_maior,'string'))
            if get(handles.radioBom,'value')==1
                for i=1:length(dado(:,row).')
                    if dado(i,index)>=str2double(get(handles.caixa_menor,'string'))
                        vt_bom(i)=dado(i,row);
                    else
                        vt_ruim(i)=dado(i,row);
                    end
                end
            else
                for i=1:length(dado(:,row).')
                    if dado(i,index)>=str2double(get(handles.caixa_menor,'string'));
                        vt_ruim(i)=dado(i,row);
                    else
                        vt_bom(i)=dado(i,row);
                    end
                end
            end
        end
    end
end
if ~isempty(get(handles.cx_int_maior,'string')) && ~isempty(get(handles.cx_int_menor,'string'))    
    vt_tampao=NaN(1,length(dado(:,row).'));
    for i=1:length(dado(:,row).')
        if ~isnan(vt_bom(i))
            if vt_bom(i)>=str2double(get(handles.cx_int_menor,'string')) &&...
                    vt_bom(i)<=str2double(get(handles.cx_int_maior,'string'))
                vt_tampao(i)=vt_bom(i);
                vt_bom(i)=NaN;
            end
        elseif ~isnan(vt_ruim(i))
            if vt_ruim(i)>=str2double(get(handles.cx_int_menor,'string')) &&...
                    vt_ruim(i)<=str2double(get(handles.cx_int_maior,'string'))
                vt_tampao(i)=vt_ruim(i);
                vt_ruim(i)=NaN;
            end
        end
    end
else
    vt_tampao=NaN(1,length(dado(:,row).'));
end
assignin('base','bom',vt_bom);
assignin('base','ruim',vt_ruim);
assignin('base','tampao',vt_tampao);
set(handles.figure1,'Pointer','arrow')
if get(handles.table_hist,'value') % Histogram
    table_hist_Callback(handles.table_hist, eventdata, handles)
end
if get(handles.table_dots,'value')  %%%  Dots chart
    table_dots_Callback(handles.table_dots, eventdata, handles)
elseif get(handles.table_chart,'value') %%%  Control chart
    table_chart_Callback(handles.table_chart, eventdata, handles)
end
set(handles.tabela1,'XLim',get(handles.tabela2,'YLim'))
if get(handles.table_boxplot,'value') %Boxplot
    table_boxplot_Callback(handles.table_boxplot, eventdata, handles)
elseif get(handles.table_selxtar,'value') %Variable x Variable chart
    table_selxtar_Callback(handles.table_selxtar, eventdata, handles);
end
[strBom,strRuim,strTampao]=cont_Percent(vt_bom,vt_ruim,vt_tampao);
set(handles.caixa_pBom,'String',strBom);
set(handles.caixa_pRuim,'String',strRuim);
set(handles.caixa_pTampao,'String',strTampao);
% Hints: get(hObject,'String') returns contents of caixa_maior as text
%        str2double(get(hObject,'String')) returns contents of caixa_maior as a double
end


% --------------------------------------------------------------------
function form_Pearson_Callback(hObject, eventdata, handles)
% hObject    handle to form_Pearson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Helper to know the correlations calcs used
web('https://pt.wikipedia.org/wiki/Coeficiente_de_correlação_de Pearson')
end

% --------------------------------------------------------------------
function form_Spearman_Callback(hObject, eventdata, handles)
% hObject    handle to form_Spearman (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Helper to know the correlations calcs used
web('https://pt.wikipedia.org/wiki/Coeficiente_de_correlação_de_postos_de_Spearman')
end

% --------------------------------------------------------------------
function form_Ajuda_Callback(hObject, eventdata, handles)
% hObject    handle to form_Ajuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function tool_select_Callback(hObject, eventdata, handles)
% hObject    handle to tool_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open the variable seletion menu to software analysis

if evalin('base','loaded')~=0
    fh=select;
    waitfor(fh);
    st_options=evalin('base','st_options');
    if st_options.selectOK==1
        head=evalin('base','head');
        set(handles.combobox,'string',head(1,2:end));
        set(handles.selxtar_combobox,'string',head(1,2:end));
        combobox_Callback(handles.combobox,eventdata,handles);
    end
else
    msgbox({'Dado inexistente.' 'Carregue uma fonte de dados antes de solicitar a seleção de variáveis.'},'Erro','error');
end
end

% --- Executes on button press in check_sort.
function check_sort_Callback(hObject, eventdata, handles)
% hObject    handle to check_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Alphabetical order the values
head=evalin('base','head');
if get(hObject,'Value')==0
    set(handles.combobox,'string',head(1,2:size(head,2)))
    set(handles.selxtar_combobox,'string',head(1,2:size(head,2)))
else
    set(handles.combobox,'string',sort(head(1,2:size(head,2))));
    set(handles.selxtar_combobox,'string',sort(head(1,2:size(head,2))));
end
% Hint: get(hObject,'Value') returns toggle state of check_sort
end

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Fix button scale when the window is resised
if isdeployed
    [~,result]=system('path');
    currentDirPre=char(regexpi(result,'Path=(.*?);','tokens','once'));
    currentDir=strcat(currentDirPre,'\');
    assignin('base','currentDir',currentDir);
else
    currentDir='';
end
% javaFrame=get(handles.output,'javaframe');
% javaFrame.setFigureIcon(javax.swing.ImageIcon(strcat(currentDir,'logo.png')));
[imCorr,~,~]=imread(strcat(currentDir,'icon2.png'));
[imEstat,~,~]=imread(strcat(currentDir,'icon3.png'));
handles.btCorr.Units='pixels';
handles.btEstat.Units='pixels';
imCorr=imresize(imCorr,fliplr(handles.btCorr.Position(1,3:4)));
imEstat=imresize(imEstat,fliplr(handles.btEstat.Position(1,3:4)));
handles.btCorr.Units='normalized';
handles.btEstat.Units='normalized';
set(handles.btCorr,'CData',imCorr);
set(handles.btEstat,'CData',imEstat);
end

% --------------------------------------------------------------------
function tool_capability_Callback(hObject, eventdata, handles)
% hObject    handle to tool_capability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Start capability module
if evalin('base','loaded')~=0
    fh=capab;
    waitfor(fh);
else
    msgbox({'Dado inexistente.' 'Carregue uma fonte de dados antes de solicitar a seleção de variáveis.'},'Erro','error');
end
end

% --- Executes on button press in table_boxplot.
function table_boxplot_Callback(hObject, eventdata, handles)
% hObject    handle to table_boxplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Change second chart to Boxplot
set(handles.figure1,'Pointer','watch')
set(handles.text_Abscissa,'Visible','off');
set(handles.selxtar_combobox,'Visible','off');
if get(handles.table_selxtar,'value')==1
    set(handles.table_selxtar,'value',0);
elseif get(handles.table_hist,'value')==1
    set(handles.table_hist,'value',0);
else
    set(handles.table_boxplot,'value',1);
end
%---
dado=evalin('base','dado');
row=evalin('base','itUiTable');
reset(handles.tabela1);
boxplot(handles.tabela1,dado(:,row));
set(handles.tabela1,'XTickLabel',[]);
dadoClear=dado(~isnan(dado(:,row)),row);
dadoSorted=sort(dadoClear);
Mediana=median(dadoSorted);
Q1=median(dadoSorted(1:(length(dadoSorted)/2)));
Q3=median(dadoSorted((length(dadoSorted)/2):end));
AdjacenteMaior=Q3+1.5*(Q3-Q1);
AdjacenteMenor=Q1-1.5*(Q3-Q1);
for i=length(dadoSorted):-1:1
    if dadoSorted(i)<=AdjacenteMaior
        AdjacenteMaior=dadoSorted(i);
        break
    end
end
for i=1:length(dadoSorted)
    if dadoSorted(i)>=AdjacenteMenor
        AdjacenteMenor=dadoSorted(i);
        break
    end
end
axes(handles.tabela1)
text(0.8,AdjacenteMaior,{AdjacenteMaior},'Color','black');
text(0.8,Q3,{Q3},'Color','blue');
text(0.8,Mediana,{Mediana},'Color','red');
text(0.8,Q1,{Q1},'Color','blue');
text(0.8,AdjacenteMenor,{AdjacenteMenor},'Color','black');
set(handles.figure1,'Pointer','arrow')
% Hint: get(hObject,'Value') returns toggle state of table_boxplot
end

% --- Executes on button press in table_selxtar.
function table_selxtar_Callback(hObject, eventdata, handles)
% hObject    handle to table_selxtar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Change the fisrt chart to relation chart
% [Selected_Variable-Answer_Variable]
set(handles.figure1,'Pointer','watch')
set(handles.text_Abscissa,'Visible','on');
set(handles.selxtar_combobox,'Visible','on');
if get(handles.table_boxplot,'value')==1
    set(handles.table_boxplot,'value',0);
elseif get(handles.table_hist,'value')==1
    set(handles.table_hist,'value',0);
else
    set(handles.table_selxtar,'value',1);
end
%----
index=evalin('base','index');
dado=evalin('base','dado');
matrizcorr=evalin('base','matrizcorr');
row=evalin('base','itUiTable');
string=get(handles.combobox,'String');
rowx=strmatch(string(get(handles.selxtar_combobox,'value')),cellstr(matrizcorr(:,1)));
rowx=rowx(1);
reset(handles.tabela1);
axes(handles.tabela1);
vt_bom=evalin('base','bom');
vt_ruim=evalin('base','ruim');
vt_tampao=evalin('base','tampao');
plot(handles.tabela1,dado(:,rowx),vt_bom,'g','color','green','Marker','.','LineStyle','none');
hold on
plot(handles.tabela1,dado(:,rowx),vt_ruim,'g','color','red','Marker','.','LineStyle','none');
plot(handles.tabela1,dado(:,rowx),vt_tampao,'g','color',[0.5 0.5 0.5],'Marker','.','LineStyle','none');
hold off
set(handles.figure1,'Pointer','arrow')
% Hint: get(hObject,'Value') returns toggle state of table_selxtar
end

% --- Executes on button press in table_hist.
function table_hist_Callback(hObject, eventdata, handles)
% hObject    handle to table_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Change the first chart to Histogram
set(handles.figure1,'Pointer','watch')
set(handles.text_Abscissa,'Visible','off');
set(handles.selxtar_combobox,'Visible','off');
if get(handles.table_boxplot,'value')==1
    set(handles.table_boxplot,'value',0);
elseif get(handles.table_selxtar,'value')==1
    set(handles.table_selxtar,'value',0);
else
    set(handles.table_hist,'value',1);
end
%-----
reset(handles.tabela1);
axes(handles.tabela1);
vt_bom=evalin('base','bom');
vt_ruim=evalin('base','ruim');
if ~isempty(get(handles.cx_int_maior,'string')) && ~isempty(get(handles.cx_int_menor,'string'))
    vt_tampao=evalin('base','tampao');
    vt_bom_unido_total=[vt_bom,vt_tampao,vt_ruim];
    vt_bom_unido=[vt_tampao,vt_ruim];
    assignin('base','vt',vt_bom_unido_total);
    h1=histogram(vt_bom_unido_total);
    hold on
    classes1=ajuste_barras(h1.Data);
    h1.FaceAlpha=1;
    h1.EdgeColor=[0 0.5 0];
    h1.FaceColor='green';
    h1.DisplayName='Bom';
    %%%%
    h2=histogram(vt_bom_unido);
    classes2=ajuste_barras(h2.Data);
    h2.FaceAlpha=1;
    h2.EdgeColor=[0.5 0.5 0.5];
    h2.FaceColor=[0.827451 0.827451 0.827451];
    h2.DisplayName='Zona Tampão';
    try
        h3=histogram(vt_ruim);
        classes3=ajuste_barras(h3.Data);
        h3.FaceAlpha=1;
        h3.EdgeColor=[0.5 0 0];
        h3.FaceColor='red';
        h3.DisplayName='Ruim';
        maior=max([classes1 classes2 classes3]);
        h1.BinWidth=maior;
        h2.BinWidth=maior;
        h3.BinWidth=maior;
    catch
        maior=max([classes1 classes2]);
        h1.BinWidth=maior;
        h2.BinWidth=maior;
    end
else 
    reset(handles.tabela1);
    axes(handles.tabela1);
    vt_bom_unido=[vt_bom,vt_ruim];
    assignin('base','vt',vt_bom_unido);
    h1=histogram(vt_bom_unido);
    hold on
    classes1=ajuste_barras(h1.Data);
    h1.FaceAlpha=1;
    h1.EdgeColor=[0 0.5 0];
    h1.FaceColor='green';
    h1.DisplayName='Bom';
    %%%%
    h2=histogram(vt_ruim);
    classes2=ajuste_barras(h2.Data);
    h2.FaceAlpha=1;
    h2.EdgeColor=[0.5 0 0];
    h2.FaceColor='red';
    h2.DisplayName='Ruim';
    maior=max([classes1 classes2]);
    h1.BinWidth=maior;
    h2.BinWidth=maior;
end
hold off
rangeLim=get(handles.tabela2,'YLim');        %%%
rangeLim(1)=rangeLim(1)-rangeLim(1)*0.01;    % Set the range
rangeLim(2)=rangeLim(2)+rangeLim(2)*0.01;    % of histogram.
set(handles.tabela1,'XLim',rangeLim);        %%%
set(handles.figure1,'Pointer','arrow')
% Hint: get(hObject,'Value') returns toggle state of table_hist
end

% --- Executes on button press in table_dots.
function table_dots_Callback(hObject, eventdata, handles)
% hObject    handle to table_dots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Change the second chart to Dots chart
set(handles.figure1,'Pointer','watch')
if get(handles.table_chart,'value')==1
    set(handles.table_chart,'value',0);
else
    set(handles.table_dots,'value',1);
end
%-----
dado=evalin('base','dado');
head=evalin('base','head');
row=evalin('base','itUiTable');
vt_bom=evalin('base','bom');
vt_ruim=evalin('base','ruim');
vt_tampao=evalin('base','tampao');
strhead=char(head(2:end,1));
xhead=NaN(1,length(dado(:,row).'));
for i=1:length(dado(:,row))
    xhead(i)=datenum(strhead(i,:),'dd/mm/yyyy HH:MM:SS');    
end
datetick(handles.tabela2,'x','dd/mm/yy','keepticks')
axes(handles.tabela2);
plot(handles.tabela2,xhead,vt_bom,'g','color','green','Marker','.','LineStyle','none');
hold on
plot(handles.tabela2,xhead,vt_ruim,'g','color','red','Marker','.','LineStyle','none');
plot(handles.tabela2,xhead,vt_tampao,'g','color',[0.5 0.5 0.5],'Marker','.','LineStyle','none');
legend('Bom','Ruim','Zona Tampão')
legend('off')
hold off
datetick(handles.tabela2,'x','dd/mm/yy','keepticks')
set(handles.figure1,'Pointer','arrow')
% Hint: get(hObject,'Value') returns toggle state of table_dots
end

% --- Executes on button press in table_chart.
function table_chart_Callback(hObject, eventdata, handles)
% hObject    handle to table_chart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Change the second chart to simple control chart
set(handles.figure1,'Pointer','watch')
if get(handles.table_dots,'value')==1
    set(handles.table_dots,'value',0);
else
    set(handles.table_chart,'value',1);
end
%----
dado=evalin('base','dado');
row=evalin('base','itUiTable');
axes(handles.tabela2);
[~,plotdata]=controlchart(dado(:,row),'charttype','i','parent',handles.tabela2);
datacursormode off;
handctrl=findobj(handles.tabela2,'Type','Axes');
handctrl.Title.String='';
legend('off');
limiteSup=get(handles.tabela2,'YLim');
text(0,mean(plotdata.lcl)-(limiteSup(2)*0.02),{mean(plotdata.lcl)},'Color','red');
text(0,mean(plotdata.ucl)+(limiteSup(2)*0.02),{mean(plotdata.ucl)},'Color','red');
text(0,mean(plotdata.cl),{mean(plotdata.cl)});
set(handles.figure1,'Pointer','arrow')
% Hint: get(hObject,'Value') returns toggle state of table_chart
end

% --------------------------------------------------------------------
function fig_scatter_Callback(hObject, eventdata, handles)
% hObject    handle to fig_scatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Start ScartterPlot 3D (3D Dots chart)
if evalin('base','loaded')~=0
    fh=Scatter3D;
    waitfor(fh);
else
    msgbox({'Dado inexistente.' 'Carregue uma fonte de dados antes de solicitar a ferramenta.'},'Erro','error');
end
end

function caixa_pBom_Callback(hObject, eventdata, handles)
% hObject    handle to caixa_pBom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of caixa_pBom as text
%        str2double(get(hObject,'String')) returns contents of caixa_pBom as a double
end

% --- Executes during object creation, after setting all properties.
function caixa_pBom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caixa_pBom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function caixa_pRuim_Callback(hObject, eventdata, handles)
% hObject    handle to caixa_pRuim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of caixa_pRuim as text
%        str2double(get(hObject,'String')) returns contents of caixa_pRuim as a double
end

% --- Executes during object creation, after setting all properties.
function caixa_pRuim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caixa_pRuim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function [str_Bom,str_Ruim,str_Tampao]=cont_Percent(vt_Bom,vt_Ruim,vt_Tampao)
%Calc Good-Bad data and limit zone percentage
contBom=numel(vt_Bom(~isnan(vt_Bom)));
contRuim=numel(vt_Ruim(~isnan(vt_Ruim)));
try
    contTampao=numel(vt_Tampao(~isnan(vt_Tampao)));
catch
    contTampao=0;
end
contTotal=contBom+contRuim+contTampao;
percent_Bom=(contBom/contTotal)*100;
percent_Ruim=(contRuim/contTotal)*100;
percent_Tampao=(contTampao/contTotal)*100;
str_Bom=sprintf('%.2f%%',percent_Bom);
str_Ruim=sprintf('%.2f%%',percent_Ruim);
str_Tampao=sprintf('%.2f%%',percent_Tampao);
end

% --- Executes on selection change in selxtar_combobox.
function selxtar_combobox_Callback(hObject, eventdata, handles)
% hObject    handle to selxtar_combobox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Define Abscissas axis
set(handles.figure1,'Pointer','watch')
index=evalin('base','index');
dado=evalin('base','dado');
head=evalin('base','head');
matrizcorr=head(1,2:end).';
row=evalin('base','itUiTable');
string=get(handles.combobox,'String');
rowx=strcmp(string(get(handles.selxtar_combobox,'value')),cellstr(matrizcorr(:,1)));
reset(handles.tabela1);
axes(handles.tabela1);
vt_bom=evalin('base','bom');
vt_ruim=evalin('base','ruim');
vt_tampao=evalin('base','tampao');
plot(handles.tabela1,dado(:,rowx),vt_bom.','g','color','green','Marker','.','LineStyle','none');
hold on
plot(handles.tabela1,dado(:,rowx),vt_ruim.','g','color','red','Marker','.','LineStyle','none');
plot(handles.tabela1,dado(:,rowx),vt_tampao.','g','color',[0.5 0.5 0.5],'Marker','.','LineStyle','none');
hold off
set(handles.figure1,'Pointer','arrow')
% Hints: contents = cellstr(get(hObject,'String')) returns selxtar_combobox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selxtar_combobox
end

% --- Executes during object creation, after setting all properties.
function selxtar_combobox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selxtar_combobox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --------------------------------------------------------------------
function selector_square_OnCallback(hObject, eventdata, handles)
% hObject    handle to selector_square (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Select the graphical area and set a limit to analysed data
if get(handles.table_dots,'Value') ~= 1
    msgbox('Só é possivel utilizar a ferramenta de seleção na visualização dos dados utilizando a núvem de pontos.','Erro')
    set(handles.selector_square,'State','off');
    return
end
dado=evalin('base','dado');
set(handles.figure1,'Pointer','watch')
handleselection=imrect(handles.tabela2);
choice=questdlg('Tem certeza que deseja continuar?','Confirme a seleção','Sim','Não','Sim');
waitfor(choice)
switch choice
    case 'Sim'
        selection=getPosition(handleselection);
        xl=[selection(1) selection(1)+selection(3)];
        yl=[selection(2) selection(2)+selection(4)];
        dataObj=get(handles.tabela2,'Children');
        assignin('base','dataObj',dataObj)
%             dataObj(1) % Rectangle (imrect)
%             dataObj(2) % Limit zone
%             dataObj(3) % Bad
%             dataObj(4) % Good
        xdataBom=get(dataObj(4),'XData');
        ydataBom=get(dataObj(4),'YData');
        xdataRuim=get(dataObj(3),'XData');
        ydataRuim=get(dataObj(3),'YData');
        xdataTampao=get(dataObj(2),'XData');
        ydataTampao=get(dataObj(2),'YData');
        %---------------
        ibom=find(xdataBom>=xl(1) & xdataBom<=xl(2) & ydataBom>=yl(1) & ydataBom<=yl(2));
        iruim=find(xdataRuim>=xl(1) & xdataRuim<=xl(2) & ydataRuim>=yl(1) & ydataRuim<=yl(2));
        itampao=find(xdataTampao>=xl(1) & xdataTampao<=xl(2) & ydataTampao>=yl(1) & ydataTampao<=yl(2));
        axes(handles.tabela2);
        cla(handles.tabela2);
        row=evalin('base','itUiTable');
        for i=1:length(dado(:,1))
            if ~(any(ibom==i)||any(iruim==i)||any(itampao==i))
                dado(i,:)=NaN;
            end
        end
        assignin('base','dado',dado);
        plot(handles.tabela2,xdataBom(ibom),ydataBom(ibom),'g','color','green','Marker','.','LineStyle','none');
        hold on
        plot(handles.tabela2,xdataRuim(iruim),ydataRuim(iruim),'g','color','red','Marker','.','LineStyle','none');
        plot(handles.tabela2,xdataTampao(itampao),ydataTampao(itampao),'g','color',[0.5 0.5 0.5],'Marker','.','LineStyle','none');
        hold off
        datetick(handles.tabela2,'x','dd/mm/yy','keepticks')

        %-------------------------------------------
        head=evalin('base','head');
        iunido=[ibom iruim itampao];
        matrizcorr=head(1,2:end).';
        %---------------
        Htable=findobj('Type','uitable');
        jscrollpane=findjobj(Htable);
        jtable=jscrollpane.getViewport.getView;
        jtable.setRowSelectionAllowed(0);
        jtable.setColumnSelectionAllowed(0);
        %---------------
        index=evalin('base','index');
        progress=waitbar(0,'Carregando...');
        steps=4+length(matrizcorr(:,1).');
        step=1;
        for i=1:length(matrizcorr(:,1).')
            matrizcorr(i,9)=cellstr(sprintf('%g',min(dado(iunido,i))));
            matrizcorr(i,10)=cellstr(sprintf('%g',median(dado(~isnan(dado(:,i)),i))));
            matrizcorr(i,11)=cellstr(sprintf('%g',max(dado(iunido,i))));
        end
        %%%Pearson e Spearman(FP) (w/ pvalue)
        for i=1:length(matrizcorr(:,1).')
            try [~,pvalue_norm]=adtest(dado(:,i));
            catch
                pvalue_norm=NaN;
            end
            try correlacao=corr(dado(:,index),dado(:,i),'rows','pairwise');
            catch
                correlacao=NaN;
            end
            try correlacaofp=corr(dado(:,index),dado(:,i),'type','Spearman','rows','pairwise');
            catch
                correlacaofp=NaN;
            end
            if correlacao<0
                matrizcorr(i,2)=cellstr('-');
            end
            if correlacaofp<0
                matrizcorr(i,4)=cellstr('-');
            end
            matrizcorr(i,3)=cellstr(sprintf('%0.4f',abs(correlacao)));
            matrizcorr(i,5)=cellstr(sprintf('%0.4f',abs(correlacaofp)));
            if pvalue_norm <= 0.0005
                matrizcorr(i,7)=cellstr('<');
            end
            matrizcorr(i,8)=cellstr(sprintf('%0.6f',pvalue_norm));
            [~,msgid]=lastwarn();
            warning('off',msgid);
            assignin('base','dadoFULL',matrizcorr);
        end
        waitbar(step/steps)
        step=step+1;
        %%%------------------
        %%%Rsquare
        for i=1:length(matrizcorr(:,1).')
            mdl=fitlm(dado(iunido,index),dado(iunido,i));
            [~,msgid]=lastwarn();
            matrizcorr(i,6)=cellstr(sprintf('%0.4f',abs(mdl.Rsquared.Adjusted)));
            waitbar(step/steps)
            step=step+1;
        end
        warning('off',msgid);
        waitbar(step/steps)
        step=step+1;
        %%%---------
        %%% NaN to 0
        for i=1:length(matrizcorr(:,1).')
            if strcmp((matrizcorr{i,3}),'NaN')
                matrizcorr(i,3)=cellstr('0');
            end
            if strcmp((matrizcorr{i,5}),'NaN')
                matrizcorr(i,5)=cellstr('0');
            end
            if strcmp((matrizcorr{i,6}),'NaN')
                matrizcorr(i,6)=cellstr('0');
            end
        end
        %%%---------
        waitbar(step/steps);
        step=step+1;
        vt_bom=evalin('base','bom');
        vt_ruim=evalin('base','ruim');
        vt_tampao=evalin('base','tampao');
        assignin('base','index',index);
        assignin('base','bom',vt_bom(ibom));
        assignin('base','ruim',vt_ruim(iruim));
        assignin('base','tampao',vt_tampao(itampao));
        assignin('base','dadoFULL',matrizcorr);
        btCorr_Callback(handles.btCorr,eventdata,handles);
        waitbar(step/steps)
        close(progress)
        jtable.changeSelection(row-1,0,false,false);
        [strBom,strRuim]=cont_Percent(vt_bom(ibom),vt_ruim(iruim));
        set(handles.caixa_pBom,'String',strBom);
        set(handles.caixa_pRuim,'String',strRuim);
    case 'Não'
        delete(handleselection);
        set(handles.selector_square,'State','off');
end
set(handles.figure1,'Pointer','arrow')
end

% --------------------------------------------------------------------
function btd_setresp_Callback(hObject, eventdata, handles)
% hObject    handle to btd_setresp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Define selected value in table as target
head=evalin('base','head');
row=evalin('base','itUiTable');
matrizcorr=head(1,2:end).';
combobox_string=get(handles.combobox,'String');
[~,position]=ismember(matrizcorr(row,1),combobox_string);
set(handles.combobox,'value',position);
set(handles.uitable1,'data',[]');
combobox_Callback(handles.combobox,eventdata,handles);
end

% --------------------------------------------------------------------
function rest_data_Callback(hObject, eventdata, handles)
% hObject    handle to rest_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Restore edited data to initialized default
load=evalin('base','loaded');
if load==1
    try
        set(handles.figure1,'Pointer','watch')
        dadofix=evalin('base','dadofix');
        headfix=evalin('base','headfix');
        assignin('base','dado',dadofix);
        assignin('base','head',headfix);
        matrizcorr=cellstr(headfix(1,2:end).');
        for i=1:length(matrizcorr)
            findReturn=matrizcorr{i}==char(10);
            marker=find(findReturn);
            if marker~=0
                temp=matrizcorr{i};
                temp(marker)=' ';
                matrizcorr(i)=cellstr(temp);
            end
        end
        if get(handles.check_sort,'Value')==0
            set(handles.combobox,'string',matrizcorr);
            set(handles.selxtar_combobox,'string',matrizcorr);
        else
            set(handles.combobox,'string',sort(headfix(1,2:size(headfix,2))));
            set(handles.selxtar_combobox,'string',sort(headfix(1,2:size(headfix,2))));
        end
        assignin('base','matrizcorr',matrizcorr);
        mensagem=msgbox('Arquivo restaurado com sucesso.','Concluido');
        pause(1)
        set(handles.uitable1,'Data',[]);
        cla(handles.tabela1);
        cla(handles.tabela2);
        try close(mensagem)
        end
        set(handles.figure1,'Pointer','arrow')
    catch erro
        errordlg(sprintf('Erro ao resturar os dados.\n\n%s', erro.message),'Erro');
        set(handles.figure1,'Pointer','arrow')
    end
else
    warndlg(sprintf('Primeiramente, carregue uma base de dados.'),'Erro');
end
end

% --------------------------------------------------------------------
function selector_square_OffCallback(hObject, eventdata, handles)
% hObject    handle to selector_square (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Undo graphical select
dado=evalin('base','dadofix');
assignin('base','dado',dado);
index=evalin('base','index');
head=evalin('base','head');
itUiTable=evalin('base','itUiTable');
set(handles.figure1,'Pointer','watch')
try
    row=itUiTable;
    if index==row
        set(handles.radioBom,'Enable','on');
        set(handles.radioRuim,'Enable','on');
        set(handles.caixa_menor,'Enable','on');
        set(handles.caixa_maior,'Enable','on');
        set(handles.caixa_pBom,'Visible','on');
        set(handles.caixa_pRuim,'Visible','on');
        set(handles.str_Bom,'Visible','on');
        set(handles.str_Ruim,'Visible','on');
        set(handles.str_Tampao,'Visible','on');
    else
        set(handles.radioBom,'Enable','off');
        set(handles.radioRuim,'Enable','off');
        set(handles.caixa_menor,'Enable','off');
        set(handles.caixa_maior,'Enable','off');
        set(handles.caixa_pBom,'Visible','off');
        set(handles.caixa_pRuim,'Visible','off');
        set(handles.str_Bom,'Visible','off');
        set(handles.str_Ruim,'Visible','off');
        set(handles.str_Tampao,'Visible','off');
    end
    %---------------
    vt_bom=NaN(1,length(dado(:,index).'));
    vt_tampao=NaN(1,length(dado(:,index).'));
    vt_ruim=NaN(1,length(dado(:,index).'));
    if get(handles.radioBom,'value')==1
        for i=1:length(dado(:,row).')
            if dado(i,index)>=str2double(get(handles.caixa_menor,'string')) &&...
                dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
                vt_bom(i)=dado(i,row);
            else
                vt_ruim(i)=dado(i,row);
            end
        end
    else
        for i=1:length(dado(:,row).')
            if dado(i,index)>=str2double(get(handles.caixa_menor,'string')) &&...
                dado(i,index)<=str2double(get(handles.caixa_maior,'string'))
                vt_ruim(i)=dado(i,row);
            else
                vt_bom(i)=dado(i,row);
            end
        end
    end
    matrizcorr=head(1,2:end).';
    %---------------
    index=evalin('base','index');
    progress=waitbar(0,'Carregando...');
    steps=length(matrizcorr(:,1).');
    step=1;
    for i=1:length(matrizcorr(:,1).')
        matrizcorr(i,9)=cellstr(sprintf('%g',min(dado(:,i))));
        matrizcorr(i,10)=cellstr(sprintf('%g',median(dado(~isnan(dado(:,i)),i))));
        matrizcorr(i,11)=cellstr(sprintf('%g',max(dado(:,i))));
    end
    %%%Pearson e Spearman(FP) (w/ pvalue)
    for i=1:length(matrizcorr(:,1).')
        waitbar(step/steps)
        step=step+1;
        try [~,pvalue_norm]=adtest(dado(:,i));
        catch
            pvalue_norm=NaN;
        end
        try correlacao=corr(dado(:,index),dado(:,i),'rows','pairwise');
        catch
            correlacao=NaN;
        end
        try correlacaofp=corr(dado(:,index),dado(:,i),'type','Spearman','rows','pairwise');
        catch
            correlacaofp=NaN;
        end
        if correlacao<0
            matrizcorr(i,2)=cellstr('-');
        end
        if correlacaofp<0
            matrizcorr(i,4)=cellstr('-');
        end
        matrizcorr(i,3)=cellstr(sprintf('%0.4f',abs(correlacao)));
        matrizcorr(i,5)=cellstr(sprintf('%0.4f',abs(correlacaofp)));
        if pvalue_norm <= 0.0005
            matrizcorr(i,7)=cellstr('<');
        end
        matrizcorr(i,8)=cellstr(sprintf('%0.6f',pvalue_norm));
        [~,msgid]=lastwarn();
        warning('off',msgid);
        assignin('base','dadoFULL',matrizcorr);
    end
    steps=4+length(matrizcorr(:,1).');
    step=1;
    waitbar(step/steps)
    step=step+1;
    %%%------------------
    %%%Rsquare
    for i=1:length(matrizcorr(:,1).')
        mdl=fitlm(dado(:,index),dado(:,i));
        [~,msgid]=lastwarn();
        matrizcorr(i,6)=cellstr(sprintf('%0.4f',abs(mdl.Rsquared.Adjusted)));
        waitbar(step/steps)
        step=step+1;
    end
    warning('off',msgid);
    waitbar(step/steps)
    step=step+1;
    %%%---------
    %%% NaN to 0
    for i=1:length(matrizcorr(:,1).')
        if strcmp((matrizcorr{i,3}),'NaN')
            matrizcorr(i,3)=cellstr('0');
        end
        if strcmp((matrizcorr{i,5}),'NaN')
            matrizcorr(i,5)=cellstr('0');
        end
        if strcmp((matrizcorr{i,6}),'NaN')
            matrizcorr(i,6)=cellstr('0');
        end
    end
    %-----------
    waitbar(step/steps)
    step=step+1;
    Htable=findobj('Type','uitable');
    jscrollpane=findjobj(Htable);
    jtable=jscrollpane.getViewport.getView;
    jtable.setRowSelectionAllowed(0);
    jtable.setColumnSelectionAllowed(0);
    %%%---------
    assignin('base','index',index);
    assignin('base','bom',vt_bom);
    assignin('base','ruim',vt_ruim);
    assignin('base','tampao',vt_tampao);
    assignin('base','dadoFULL',matrizcorr);
    btCorr_Callback(handles.btCorr,eventdata,handles);
    if get(handles.table_hist,'value') %Histogram
        table_hist_Callback(handles.table_hist, eventdata, handles)
    end
    if get(handles.table_dots,'value')  %%%  Dots cahrt
        table_dots_Callback(handles.table_dots, eventdata, handles)
    elseif get(handles.table_chart,'value') %%%  Control chart
        table_chart_Callback(handles.table_chart, eventdata, handles)
    end
    rangeLim=get(handles.tabela2,'YLim');        %
    rangeLim(1)=rangeLim(1)-rangeLim(1)*0.01;    % Define the range
    rangeLim(2)=rangeLim(2)+rangeLim(2)*0.01;    % of histogram.
    set(handles.tabela1,'XLim',rangeLim);        %
    if get(handles.table_boxplot,'value') %Boxplot
        table_boxplot_Callback(handles.table_boxplot, eventdata, handles)
    elseif get(handles.table_selxtar,'value'); %Variable x Variable chart
        table_selxtar_Callback(handles.table_selxtar, eventdata, handles);
    end
    waitbar(step/steps)
    set(handles.figure1,'Pointer','arrow')
    close(progress)
    jtable.changeSelection(row-1,1,false,false);
    jtable.changeSelection(row-1,0,false,false);
end
end

% --------------------------------------------------------------------
function txt = DataCursorUpdate(~,event_obj)
% Set subtitle for each dots
pos=get(event_obj,'Position');
txt={['Valor: ',num2str(pos(2))],...
     ['Data: ',datestr(fix(pos(1)),'dd/mm/yyyy')]};
end

% --------------------------------------------------------------------
function tool_datacursor_OnCallback(hObject, eventdata, handles)
% hObject    handle to tool_datacursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacursormode('on');
dcm_obj=datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@DataCursorUpdate);
end

% --------------------------------------------------------------------
function tool_datacursor_OffCallback(hObject, eventdata, handles)
% hObject    handle to tool_datacursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dcm_obj=datacursormode(gcf);
dcm_obj.removeAllDataCursors();
datacursormode('off');
end

% --------------------------------------------------------------------
function menu_Save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rmhandles=handles;
try [filename,path]=uiputfile('*.mat','Salvar como');
    assignin('base','filename',filename);
    assignin('base','path',path);
    assignin('base','rmhandles',rmhandles);
    evalin('base','save([path,filename])')
end
end

% --------------------------------------------------------------------
function menu_Load_Callback(hObject, eventdata, handles)
% hObject    handle to menu_Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try [filename,path]=uigetfile('*.mat','Abrir');
    assignin('base','filename',filename);
    assignin('base','path',path);
    evalin('base','load([path,filename])')
    delete(handles.figure1)
end
end

% --------------------------------------------------------------------
function reg_line_Callback(hObject, eventdata, handles)
% hObject    handle to reg_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function reg_simples_Callback(hObject, eventdata, handles)
% hObject    handle to reg_simples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
combostring=get(handles.combobox,'String');
assignin('base','regno_referencia',combostring{get(handles.combobox,'Value')})
Eqs=RegressaoLinearSimples;
waitfor(Eqs)
evalin('base','clear regno_referencia');
end

% --------------------------------------------------------------------
function reg_multi_Callback(hObject, eventdata, handles)
% hObject    handle to reg_multi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
combostring=get(handles.combobox,'String');
assignin('base','regmulti_referencia',combostring{get(handles.combobox,'Value')})
Eqm=RegressaoLinearMulti;
waitfor(Eqm)
evalin('base','clear regmulti_referencia');
end

% --------------------------------------------------------------------
function reg_nonline_Callback(hObject, eventdata, handles)
% hObject    handle to reg_nonline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function reg_nosimples_Callback(hObject, eventdata, handles)
% hObject    handle to reg_nosimples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
combostring=get(handles.combobox,'String');
assignin('base','regno_referencia',combostring{get(handles.combobox,'Value')})
Eqnos=RegressaoNoLinearSimples;
waitfor(Eqnos)
evalin('base','clear regno_referencia');
end

% --------------------------------------------------------------------
function reg_nomulti_Callback(hObject, eventdata, handles)
% hObject    handle to reg_nomulti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
combostring=get(handles.combobox,'String');
assignin('base','regnomulti_referencia',combostring{get(handles.combobox,'Value')})
Eqnom=RegressaoNoLinearMulti;
waitfor(Eqnom)
evalin('base','clear regnomulti_referencia');
end

% --------------------------------------------------------------------
function neuralnet_Callback(hObject, eventdata, handles)
% hObject    handle to neuralnet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
neunet=NeuralNetFit;
waitfor(neunet)
end

% --------------------------------------------------------------------
function btd_selectTarget_Callback(hObject, eventdata, handles)
% hObject    handle to btd_selectTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

function cx_int_menor_Callback(hObject, eventdata, handles)
% hObject    handle to cx_int_menor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
caixa_menor_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of cx_int_menor as text
%        str2double(get(hObject,'String')) returns contents of cx_int_menor as a double
end

% --- Executes during object creation, after setting all properties.
function cx_int_menor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_int_menor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function cx_int_maior_Callback(hObject, eventdata, handles)
% hObject    handle to cx_int_maior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
caixa_maior_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of cx_int_maior as text
%        str2double(get(hObject,'String')) returns contents of cx_int_maior as a double
end

% --- Executes during object creation, after setting all properties.
function cx_int_maior_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cx_int_maior (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function caixa_menor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caixa_menor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function caixa_pTampao_Callback(hObject, eventdata, handles)
% hObject    handle to caixa_pTampao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of caixa_pTampao as text
%        str2double(get(hObject,'String')) returns contents of caixa_pTampao as a double
end

% --- Executes during object creation, after setting all properties.
function caixa_pTampao_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caixa_pTampao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
