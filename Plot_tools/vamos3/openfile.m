function varargout = openfile(varargin)
% OPENFILE M-file for openfile.fig
%      OPENFILE, by itself, creates a new OPENFILE or raises the existing
%      singleton*.
%
%      H = OPENFILE returns the handle to a new OPENFILE or the handle to
%      the existing singleton*.
%
%      OPENFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPENFILE.M with the given input arguments.
%
%      OPENFILE('Property','Value',...) creates a new OPENFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before openfile_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to openfile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help openfile

% Last Modified by GUIDE v2.5 27-Jun-2006 08:57:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @openfile_OpeningFcn, ...
                   'gui_OutputFcn',  @openfile_OutputFcn, ...
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


% --- Executes just before openfile is made visible.
function openfile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to openfile (see VARARGIN)

% Choose default command line output for openfile
handles.output = hObject;

set(handles.loadbutton,'Enable','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes openfile wait for user response (see UIRESUME)
uiwait(handles.openfile);


% --- Outputs from this function are returned to the command line.
function varargout = openfile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isfield(handles,'output')
	varargout{1} = handles.output;
	delete(handles.openfile);
else
	varargout{1} = 0;
end


function pathedit_Callback(hObject, eventdata, handles)
% hObject    handle to pathedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathedit as text
%        str2double(get(hObject,'String')) returns contents of pathedit as a double


% --- Executes during object creation, after setting all properties.
function pathedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browsebutton.
function browsebutton_Callback(hObject, eventdata, handles)
% hObject    handle to browsebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathname=[];
filename=[];

defaultpath = '/public/alster/proj/matlab/data/';

switch get(handles.filetypepanel,'SelectedObject')
	case handles.bisonsupe
		[filename,pathname] = uigetfile({'*.supe','Bison supe-files'},'Select file',defaultpath);
		if ~isequal(filename,0) | ~isequal(pathname,0)
			set(handles.pathedit,'String',[pathname filename]);
			set(handles.loadbutton,'Enable','on');
		end
		
	case handles.bisonlist
		[filename,pathname] = uigetfile({'*.list','Bison list-files (*.list)'},'Select file',defaultpath);
		if ~isequal(filename,0) | ~isequal(pathname,0)
			set(handles.pathedit,'String',[pathname filename]);
		end
		
	case handles.f1f2measmat
		[filename,pathname] = uigetfile({'*.mat','F1/F2 measurments (*.mat)'},'Select file',defaultpath);
		if ~isequal(filename,0) | ~isequal(pathname,0)
			set(handles.pathedit,'String',[pathname filename]);
			[beskrivning] = ldracs([pathname filename]);
			set(handles.fileinfo,'String',beskrivning);
			set(handles.loadbutton,'Enable','on');
		end
		
	case handles.f1f2measdat
		[filename,pathname] = uigetfile({'*.dat','F1/F2 measurements (*.dat)'},'Select file',defaultpath);
		if ~isequal(filename,0) | ~isequal(pathname,0)
			set(handles.pathedit,'String',[pathname filename]);
		end
		
	case handles.f3measmat
		[filename,pathname] = uigetfile({'*.mat','F3 measurements (*.mat)'},'Select file',defaultpath);
		if ~isequal(filename,0) | ~isequal(pathname,0)
			set(handles.pathedit,'String',[pathname filename]);
			fileinfo = load([pathname filename],'mtext');
			set(handles.fileinfo,'String',fileinfo.mtext);
			set(handles.loadbutton,'Enable','on');
		end
		
	case handles.f3measdat
		[filename,pathname] = uigetfile({'*.dat','F3 measurments (*.dat)'},'Select file',defaultpath);
		if ~isequal(filename,0) | ~isequal(pathname,0)
			set(handles.pathedit,'String',[pathname filename]);
		end
end

% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=waitbar(0,'Loading file');
set(h,'WindowStyle','modal');
waitbar(0,h);
file = get(handles.pathedit,'String');

switch get(handles.filetypepanel,'SelectedObject')
	case handles.bisonsupe
		[bisdata namn] = superead(file,'ALL');
		
		% Store filinfo
		data.type = 'bisonsupe';
		data.file = file;
		data.desc = 'Bison supefile';
		data.nvar = size(bisdata,1);
		
		% Store timevector info
		data.t = bisdata(1,:);
		data.nsamples = size(bisdata,2);
		data.fs = 1/(bisdata(1,2) - bisdata(1,1));
		
		% Store signal data
		for i=1:data.nvar
			data.signal(i).data = bisdata(i,:);
			data.signal(i).label = namn(i,:);
			data.signal(i).unit = '';
			data.signal(i).lowlimit = '';
			data.signal(i).highlimit = '';
			data.signal(i).gain = '';
			data.signal(i).desc = '';
		end
		
		% Old style
		%data.data = bisdata;
		%data.labels = [namn char(32*ones(size(namn,1),7))];
		%data.units = char(zeros(data.nvar,7));
		%data.lowlimit = zeros(data.nvar,1); 
		%data.highlimit = zeros(data.nvar,1);
		%data.gain = zeros(data.nvar,1);
		%data.vardesc = 32*ones(data.nvar,1);
		
		handles.output = data;
	
	case handles.bisonlist
	
	case handles.f1f2measmat
		[beskrivning,b,mdata]=ldracs(file);
		
		nl = find(b == 10);
		signaler = char(zeros(size(b,2)/100,100));
		signaler(1,:) = b(1:nl(1));
		for i=2:size(nl,2)
			signaler(i,:) = b(nl(i-1):nl(i)-1);
		end
		
		% Store filinfo
		data.type = 'meas';
		data.file = file;
		data.desc = beskrivning;
		data.nvar = size(mdata,2);
		
		% Store timevector info
		data.t = mdata(:,1);
		data.nsamples = size(mdata,1);
		data.fs = 1/(mdata(2,1) - mdata(1,1));
		
		% Store signal data
		for i=1:data.nvar
			data.signal(i).data = mdata(:,i)';
			data.signal(i).label = signaler(i+2,5:21);
			data.signal(i).unit = signaler(i+2,22:28);
			data.signal(i).lowlimit = signaler(i+2,29:41);
			data.signal(i).highlimit = signaler(i+2,42:54);
			data.signal(i).gain = signaler(i+2,55:67);
			data.signal(i).desc = signaler(i+2,68:100);
		end
		
		% Old style
		%data.data = mdata';
		%data.labels = signaler(3:size(signaler,1),5:21);
		%data.units = signaler(3:size(signaler,1),22:28);
		%data.lowlimit = signaler(3:size(signaler,1),29:41);
		%data.highlimit = signaler(3:size(signaler,1),42:54);
		%data.gain = signaler(3:size(signaler,1),55:67);
		%data.vardesc = signaler(3:size(signaler,1),68:100);
		
		handles.output = data;

	case handles.f1f2measdat
	
	case handles.f3measmat
		[mdata,mtext,mvar,mvarb,sampl,t]=getf3(file);
	
		% Store filinfo
		data.type = 'meas';
		data.file = file;
		data.desc = mtext;
		data.nvar = size(mdata,2);
		
		% Store timevector info
		data.t = t;
		data.nsamples = size(mdata,1);
		data.fs = sampl(2,1);
		
		% Store signal data
		for i=1:data.nvar
			data.signal(i).data = mdata(:,i)';
			data.signal(i).label = mvar(i,4:20);
			data.signal(i).unit = mvar(i,25:31);
			data.signal(i).lowlimit = mvar(i,39:46);
			data.signal(i).highlimit = mvar(i,47:58);
			data.signal(i).gain = mvar(i,59:64);
			data.signal(i).desc = mvar(i,84:120);
		end
		
		% Old style
		%data.data = mdata';
		%data.labels = mvar(:,4:20);
		%data.units = mvar(:,25:31);
		%data.lowlimit = mvar(:,39:46);
		%data.highlimit = mvar(:,47:58);
		%data.gain = mvar(:,59:64);
		%data.vardesc = mvar(:,84:120);
		
		handles.output = data;
	
	case handles.f3measdat
end
waitbar(100,h);
delete(h);
guidata(hObject,handles);
uiresume();


% --- Executes on button press in cancelbutton.
function cancelbutton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.openfile);



