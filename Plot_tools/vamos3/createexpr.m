function varargout = createexpr(varargin)
% CREATEEXPR M-file for createexpr.fig
%      CREATEEXPR, by itself, creates a new CREATEEXPR or raises the existing
%      singleton*.
%
%      H = CREATEEXPR returns the handle to a new CREATEEXPR or the handle to
%      the existing singleton*.
%
%      CREATEEXPR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATEEXPR.M with the given input arguments.
%
%      CREATEEXPR('Property','Value',...) creates a new CREATEEXPR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before createexpr_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to createexpr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help createexpr

% Last Modified by GUIDE v2.5 30-Jun-2006 14:02:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @createexpr_OpeningFcn, ...
                   'gui_OutputFcn',  @createexpr_OutputFcn, ...
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


% --- Executes just before createexpr is made visible.
function createexpr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to createexpr (see VARARGIN)

% Choose default command line output for createexpr
handles.output = hObject;

mainh = varargin{1};

handles.mainhandle = mainh;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes createexpr wait for user response (see UIRESUME)
uiwait(handles.createexpr);




% --- Outputs from this function are returned to the command line.
function varargout = createexpr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles,'output')
	varargout{1} = handles.output;
	delete(handles.createexpr);
end




% --- Executes on selection change in varbox.
function varbox_Callback(hObject, eventdata, handles)
% hObject    handle to varbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns varbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from varbox


% --- Executes during object creation, after setting all properties.
function varbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainhandles = guidata(handles.mainhandle);
selfile = get(mainhandles.filelist,'Value');
selsignal = get(mainhandles.signallist,'Value');
FILES = mainhandles.FILES(:);
for i=1:size(selsignal,2)
	oldstr = char(get(handles.varbox,'String'));
	if size(oldstr,2) > 0
		nextvar = oldstr(size(oldstr,1),1);
		handles.(char(double(nextvar)+1))  = FILES(selfile).data(selsignal(i),:);
		newstr = [ char(double(nextvar+1)) '   ' ...
			   num2str(selfile*ones(size(selfile,2),1),'(File:%02d)') ' ' ...
			   FILES(selfile).labels(selsignal(i),:) ...
			   FILES(selfile).vardesc(selsignal(i),:) ...
			   ];
		str = {oldstr; newstr};
	else
		handles.a = FILES(selfile).data(selsignal(i),:);
		newstr = [ 'a   ' ...
			   num2str(selfile*ones(size(selfile,2),1),'(File:%02d)') ' ' ...
			   FILES(selfile).labels(selsignal(i),:) ...
			   FILES(selfile).vardesc(selsignal(i),:) ...
			   ];
		str = {newstr};
	end	
	set(handles.varbox,'String',str);
end
guidata(hObject, handles);

function labelfield_Callback(hObject, eventdata, handles)
% hObject    handle to labelfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of labelfield as text
%        str2double(get(hObject,'String')) returns contents of labelfield as a double


% --- Executes during object creation, after setting all properties.
function labelfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to labelfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function unitfield_Callback(hObject, eventdata, handles)
% hObject    handle to unitfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of unitfield as text
%        str2double(get(hObject,'String')) returns contents of unitfield as a double


% --- Executes during object creation, after setting all properties.
function unitfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unitfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function descfield_Callback(hObject, eventdata, handles)
% hObject    handle to descfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of descfield as text
%        str2double(get(hObject,'String')) returns contents of descfield as a double


% --- Executes during object creation, after setting all properties.
function descfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function exprfield_Callback(hObject, eventdata, handles)
% hObject    handle to exprfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exprfield as text
%        str2double(get(hObject,'String')) returns contents of exprfield as a double


% --- Executes during object creation, after setting all properties.
function exprfield_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exprfield (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

data.label = get(handles.labelfield,'String');
data.unit = get(handles.unitfield,'String');
data.vardesc = get(handles.descfield,'String');
for i=1:size(get(handles.varbox,'String'),1)
	var = char(double('a')+i-1);
	eval([var '= handles.' var ';']);
end


if ~isempty(get(handles.labelfield,'String')) && isvarname(get(handles.labelfield,'String'))
	data.data = eval(get(handles.exprfield,'String'),'errordlg(''Not a valid expression'')');
	handles.output = data;
	guidata(hObject,handles);
	uiresume();
else
	errordlg('Label must not be empty and be a valid matlab variable name');
end


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = 0;
uiresume();

