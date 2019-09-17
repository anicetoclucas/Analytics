function varargout = form_Options(varargin)
% FORM_OPTIONS MATLAB code for form_Options.fig
%      FORM_OPTIONS, by itself, creates a new FORM_OPTIONS or raises the existing
%      singleton*.
%
%      H = FORM_OPTIONS returns the handle to a new FORM_OPTIONS or the handle to
%      the existing singleton*.
%
%      FORM_OPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FORM_OPTIONS.M with the given input arguments.
%
%      FORM_OPTIONS('Property','Value',...) creates a new FORM_OPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before form_Options_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to form_Options_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help form_Options

% Last Modified by GUIDE v2.5 25-Nov-2016 09:49:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @form_Options_OpeningFcn, ...
                   'gui_OutputFcn',  @form_Options_OutputFcn, ...
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

% --- Executes just before form_Options is made visible.
function form_Options_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to form_Options (see VARARGIN)

% Choose default command line output for form_Options
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

st_options=evalin('base','st_options');
switch st_options.removeOutliers
    case 0
        set(handles.radiobutton1,'value',1);
        set(handles.radiobutton2,'value',0);        
    case 1
        set(handles.radiobutton2,'value',1);
        set(handles.radiobutton1,'value',0);
end
% UIWAIT makes form_Options wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = form_Options_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output fro   m handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in btSave.
function btSave_Callback(hObject, eventdata, handles)
% hObject    handle to btSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Outliers
if get(handles.radiobutton1,'value')==1
    st_options.removeOutliers=0;
elseif get(handles.radiobutton2,'value')==1
    st_options.removeOutliers=1;
end
assignin('base','st_options',st_options);
end
% --- Executes on button press in btCancel.
function btCancel_Callback(hObject, eventdata, handles)
% hObject    handle to btCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(form_Options);
end


% --- Executes on button press in btSS.
function btSS_Callback(hObject, eventdata, handles)
% hObject    handle to btSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
btSave_Callback(handles.btSave, eventdata, handles);
close(form_Options);
end
