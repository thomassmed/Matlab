function varargout = gaspriceplotter(varargin)
% GASPRICEPLOTTER M-file for gaspriceplotter.fig
%      GASPRICEPLOTTER, by itself, creates a new GASPRICEPLOTTER or raises the existing
%      singleton*.
%
%      H = GASPRICEPLOTTER returns the handle to a new GASPRICEPLOTTER or the handle to
%      the existing singleton*.
%
%      GASPRICEPLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GASPRICEPLOTTER.M with the given input arguments.
%
%      GASPRICEPLOTTER('Property','Value',...) creates a new GASPRICEPLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gaspriceplotter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gaspriceplotter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gaspriceplotter

% Last Modified by GUIDE v2.5 02-Oct-2009 13:24:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gaspriceplotter_OpeningFcn, ...
                   'gui_OutputFcn',  @gaspriceplotter_OutputFcn, ...
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


% --- Executes just before gaspriceplotter is made visible.
function gaspriceplotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gaspriceplotter (see VARARGIN)

% Choose default command line output for gaspriceplotter
handles.output = hObject;

% Load data and create initial plot with lines not shown
data = load('gasprices');
handles.plot = plot(handles.OutputAxes,data.Year,data.Prices,'visible','off');
ylim(handles.OutputAxes,[0,8])
xlabel('Year'), ylabel('Price [$US]')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gaspriceplotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gaspriceplotter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in australia.
function australia_Callback(hObject, eventdata, handles)
% hObject    handle to australia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of australia
if get(hObject,'Value')
    % If checkbox is checked (value = 1), make line visible
    set(handles.plot(1),'Visible','on')
else
    % Otherwise, make it invisible
    set(handles.plot(1),'Visible','off')
end


% --- Executes on button press in canada.
function canada_Callback(hObject, eventdata, handles)
% hObject    handle to canada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of canada
if get(hObject,'Value')
    set(handles.plot(2),'Visible','on')
else
    set(handles.plot(2),'Visible','off')
end

% --- Executes on button press in france.
function france_Callback(hObject, eventdata, handles)
% hObject    handle to france (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of france
if get(hObject,'Value')
    set(handles.plot(3),'Visible','on')
else
    set(handles.plot(3),'Visible','off')
end

% --- Executes on button press in germany.
function germany_Callback(hObject, eventdata, handles)
% hObject    handle to germany (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of germany
if get(hObject,'Value')
    set(handles.plot(4),'Visible','on')
else
    set(handles.plot(4),'Visible','off')
end

% --- Executes on button press in italy.
function italy_Callback(hObject, eventdata, handles)
% hObject    handle to italy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of italy
if get(hObject,'Value')
    set(handles.plot(5),'Visible','on')
else
    set(handles.plot(5),'Visible','off')
end

% --- Executes on button press in japan.
function japan_Callback(hObject, eventdata, handles)
% hObject    handle to japan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of japan
if get(hObject,'Value')
    set(handles.plot(6),'Visible','on')
else
    set(handles.plot(6),'Visible','off')
end

% --- Executes on button press in mexico.
function mexico_Callback(hObject, eventdata, handles)
% hObject    handle to mexico (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mexico
if get(hObject,'Value')
    set(handles.plot(7),'Visible','on')
else
    set(handles.plot(7),'Visible','off')
end

% --- Executes on button press in sthkorea.
function sthkorea_Callback(hObject, eventdata, handles)
% hObject    handle to sthkorea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sthkorea
if get(hObject,'Value')
    set(handles.plot(8),'Visible','on')
else
    set(handles.plot(8),'Visible','off')
end

% --- Executes on button press in uk.
function uk_Callback(hObject, eventdata, handles)
% hObject    handle to uk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uk
if get(hObject,'Value')
    set(handles.plot(9),'Visible','on')
else
    set(handles.plot(9),'Visible','off')
end

% --- Executes on button press in usa.
function usa_Callback(hObject, eventdata, handles)
% hObject    handle to usa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of usa
if get(hObject,'Value')
    set(handles.plot(10),'Visible','on')
else
    set(handles.plot(10),'Visible','off')
end
