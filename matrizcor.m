function varargout = matrizcor(varargin)
% MATRIZCOR MATLAB code for matrizcor.fig
%      MATRIZCOR, by itself, creates a new MATRIZCOR or raises the existing
%      singleton*.
%
%      H = MATRIZCOR returns the handle to a new MATRIZCOR or the handle to
%      the existing singleton*.
%
%      MATRIZCOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATRIZCOR.M with the given input arguments.
%
%      MATRIZCOR('Property','Value',...) creates a new MATRIZCOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matrizcor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matrizcor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matrizcor

% Last Modified by GUIDE v2.5 29-May-2017 13:39:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matrizcor_OpeningFcn, ...
                   'gui_OutputFcn',  @matrizcor_OutputFcn, ...
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

% --- Executes just before matrizcor is made visible.
function matrizcor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matrizcor (see VARARGIN)

% Choose default command line output for matrizcor
handles.output = hObject;

% Update handles structure
global positionred positiongreen positionWhite positiontxtred positiontxtgreen positiontextwhite
positionred=handles.img_red.Position;
positiongreen=handles.img_green.Position;
positionWhite=handles.img_White.Position;
positiontxtred=handles.txt_red.Position;
positiontxtgreen=handles.txt_green.Position;
positiontextwhite=handles.text_white.Position;

erro=0;
try
    if isdeployed
        currentDir=evalin('base','currentDir');
    else
        currentDir='';
    end
    javaaddpath(strcat(currentDir,'ColoredFieldCellRenderer.zip'));
    cr=ColoredFieldCellRenderer(java.awt.Color.white);
catch
    errordlg('Arquivo "ColoredFieldCellRender.zip" não foi encontrado.','Erro');
    erro=1;
    close(hObject);
end
if erro ~=1
    guidata(hObject, handles);
    dado=evalin('base','dado');
    matrizcorr=evalin('base','matrizcorr');
    tam=size(matrizcorr);
    progress=waitbar(0,'Carregando...');
    steps=tam(1);
    step=1;
    for i=1:tam(1)
        if size(matrizcorr(i))>=10
            temp=matrizcorr(i);
            matrizcorr(i)=temp(1:10);
        end
        waitbar(step/steps)
        step=step+1;
    end
    vetorcharCOL=[];
    step=1;
%     for i=1:tam(1)
%         Stemp='<html><font style="position: absolute;tranform: rotate(-90deg)">';
%         Stemp=[Stemp matrizcorr{i,1}];
%         Stemp=[Stemp '</font>'];
%         waitbar(step/steps)
%         step=step+1;
%         vetorcharCOL=[vetorcharCOL;cellstr(Stemp)];
%     end
    
    for i=1:tam(1) 
        n=2;
        Stemp='<html><center>';
        Ctemp=char(matrizcorr(i,1));
        if length(Ctemp)>10
            Ctemp=Ctemp(1:10);
        end
        Stemp=[Stemp,Ctemp(1)];
        while n<=length(Ctemp)
            Stemp=[Stemp,'<br />',Ctemp(n)];
            n=n+1;
        end
        Stemp=[Stemp,'</center></html>'];
        vetorcharCOL=[vetorcharCOL;cellstr(Stemp)];
        waitbar(step/steps)
        step=step+1;
    end
    assignin('base','html',vetorcharCOL)
    set(handles.uitable1,'RowName',matrizcorr(:,1));
    %Calculo das correlações e Cores
    Htable=findobj('Type','uitable');
    jscrollpane=findjobj(Htable);
    jtable=jscrollpane.getViewport.getView;
    jtable.setAutoResizeMode(jtable.AUTO_RESIZE_OFF);
    javaaddpath('ColoredFieldCellRenderer.zip');
    cr=ColoredFieldCellRenderer(java.awt.Color.white);
    cr.setDisabled(false);
    step=1;
    for i=1:tam(1)
        for j=1:tam(1)
            correlacao=corr(dado(:,i),dado(:,j),'rows','pairwise');
            if isnan(correlacao)
                cr.setCellBgColor(i-1,j-1,java.awt.Color(1,1,1));
                cr.setCellFgColor(i-1,j-1,java.awt.Color(1,1,1));
            elseif correlacao<0
                cr.setCellBgColor(i-1,j-1,java.awt.Color(1,1-(correlacao*(-1)),1-(correlacao*(-1))));
                cr.setCellFgColor(i-1,j-1,java.awt.Color(1,1-(correlacao*(-1)),1-(correlacao*(-1))));
            else
                cr.setCellBgColor(i-1,j-1,java.awt.Color(1-correlacao,1-correlacao,1));
                cr.setCellFgColor(i-1,j-1,java.awt.Color(1-correlacao,1-correlacao,1));
            end
        end
        waitbar(step/steps)
        step=step+1;
    end
    jtable.setModel(javax.swing.table.DefaultTableModel(matrizcorr(:,1),vetorcharCOL));
    for i=1:tam(1)
        jtable.getColumnModel.getColumn(i-1).setCellRenderer(cr);
        jtable.getColumnModel.getColumn(i-1).setPreferredWidth(20);
    end
    close(progress);
end
% UIWAIT makes matrizcor wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = matrizcor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --------------------------------------------------------------------
function ajuda_Callback(hObject, eventdata, handles)
% hObject    handle to ajuda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in img_red.
function img_red_Callback(hObject, eventdata, handles)
% hObject    handle to img_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in img_green.
function img_green_Callback(hObject, eventdata, handles)
% hObject    handle to img_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in img_White.
function img_White_Callback(hObject, eventdata, handles)
% hObject    handle to img_White (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
assignin('base','positionred',handles.img_red.Position)
assignin('base','positiongreen',handles.img_green.Position)
assignin('base','positionWhite',handles.img_White.Position)
assignin('base','positiontxtred',handles.txt_red.Position)
assignin('base','positiontxtgreen',handles.txt_green.Position)
assignin('base','positiontextwhite',handles.text_white.Position)
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
end
