function varargout = vamos3(varargin)
% VAMOS3 M-file for vamos3.fig
%      VAMOS3, by itself, creates a new VAMOS3 or raises the existing
%      singleton*.
%
%      H = VAMOS3 returns the handle to a new VAMOS3 or the handle to
%      the existing singleton*.
%
%      VAMOS3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VAMOS3.M with the given input arguments.
%
%      VAMOS3('Property','Value',...) creates a new VAMOS3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vamos2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vamos3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help vamos3

% Last Modified by GUIDE v2.5 24-Jun-2013 14:52:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vamos3_OpeningFcn, ...
                   'gui_OutputFcn',  @vamos3_OutputFcn, ...
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


% --- Executes just before vamos3 is made visible.
function vamos3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vamos3 (see VARARGIN)

% Aktivera dessa rader för svart i plottarna istället
%set(0,'DefaultFigureColor','k' ,...
%      'DefaultAxesCOlor','k' ,...
%      'DefaultAxesXColor','w' ,...
%      'DefaultAxesYColor','w' ,...
%      'DefaultAxesYColor','w' ,...
%      'DefaultTextColor','w' ,...
%      'DefaultLineColor','y');

set(0,'DefaultTextInterpreter','none')

nofilesloaded(hObject,handles);

handles.WINDOWS(1) = gcf;

% Set closerequest function
set(hObject,'CloseRequestFcn','vamos3(''Quit_Callback'',gcbo,[],guidata(gcbo))')

% Add windows menu
%fig_handle = gcf;
%uimenu(fig_handle, 'Label', 'Window', ...
%      'Callback', winmenu('callback'), 'Tag', 'winmenu');
%winmenu(fig_handle);  % Initialize the submenu

% Make window appear at upper right corner of screen
%scrsz = get(0,'ScreenSize');
%set(gcf,'Units','pixels');
%winsz = get(gcf,'Position');
%set(handles.WINDOWS(1),'Position',[ 0.05*scrsz(3) (0.95*scrsz(4))-winsz(4) winsz(3) winsz(4)]);
movegui('northwest');

% Choose default command line output for vamos3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Open file from commandline
if ~isempty(varargin)
	for i=1:length(varargin)
		if fopen(varargin{i}) > 0
			Open_file_Callback(hObject,[],guidata(hObject),varargin{i});
		end
	end
end

% Load saved expressions
expr_list(handles.Saved_expressions,hObject);


% UIWAIT makes vamos3 wait for user response (see UIRESUME)
% uiwait(handles.VAMOS3);

% --- Outputs from this function are returned to the command line.
function varargout = vamos3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --------------------------------------------------------------------
function Files_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Files_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Open_file_Callback(hObject, eventdata, handles,file)
% hObject    handle to Open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'FILES')
	n = 1;
else
	FILES = handles.FILES;
	n = size(FILES,1)+1;
end

pathname=[];
filename=[];

defaultpath = pwd;
%%% Mad test %%%
extlist = {[pwd filesep '*.mat'],'Mätdata (.mat)'; ...
		   [pwd filesep '*.supe'],'Bison supe-files (.supe)'; ...
		   [pwd filesep '*.racs'],'Mätdata (.racs)'
		  };
%%% Slut test %%%
if isempty(file)
%     [filename,pathname] = uigetfile('*.mat','Select file',[defaultpath,'\']);
    
    [filename, pathname] = uigetfile(...
   {'*.m;*.fig;*.mat;*.mdl;*.dat;*.xls;*.xlsx;*.cpt;*.supe;','MATLAB Files (*.m,*.fig,*.mat,*.mdl,*.dat,*.xls,*.xlsx,*.cpt,*.supe)';
   '*.m',  'M-files (*.m)'; ...
   '*.fig','Figures (*.fig)'; ...
   '*.mat','MAT-files (*.mat)'; ...
   '*.dat','Mätdator/APROS-files (*.dat)';...
   '*.xls;','EXCEL-files (*.xls)';...
   '*.xlsx;','EXCEL-files (*.xlsx)';...
   '*.cpt','COPTA-files (*.cpt)';...
   '*.supe','BISON-files (*.supe)';...
   '*.mdl','Models (*.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');
%MAD test	%[filename,pathname] = uigetfile(extlist,'Select file',defaultpath);
	file = [pathname filename];
end

if ~isequal(filename,0) | ~isequal(pathname,0)
	data = loadfile(file);

	if isstruct(data)
		FILES(n) = data;
		
		handles.FILES = FILES(:);
		guidata(hObject,handles);
	
		updatefilelist(handles.VAMOS2);
		
		filesloaded(hObject,handles);
	end
end

% --------------------------------------------------------------------
function Closefile_Callback(hObject, eventdata, handles)
% hObject    handle to Closefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selfile = get(handles.filelist,'Value');
FILES = handles.FILES;
fillist = 1:size(FILES,1);
FILES = FILES(fillist ~= selfile);
handles.FILES = FILES;
guidata(hObject,handles);

for i=1:length(handles.FILES)
	if strcmp(handles.FILES(i).type,'exprdata')
		handles.exprdatafile = i;
	end
	if strcmp(handles.FILES(i).type,'plotdata')
		handles.plotdatafile = i;
	end
end

if size(FILES,1) == 0;
	nofilesloaded(hObject,handles);
	set(handles.filelist,'String','');
	set(handles.filelist,'Value',1);
	set(handles.signallist,'String','');
	set(handles.signallist,'Value',1);
else
	updatefilelist(handles.VAMOS2);
end


guidata(hObject,handles);

% --------------------------------------------------------------------
function Quit_Callback(hObject, eventdata, handles)
% hObject    handle to Quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i=size(handles.WINDOWS,2):-1:1
	if ishandle(handles.WINDOWS(i))
		delete(handles.WINDOWS(i));
	end
end





% Plot menu callbacks
% --------------------------------------------------------------------
function Plot_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Time_plot_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Timeplotsingle_Callback(hObject, eventdata, handles)
timeplot(hObject,handles,'single');

% --------------------------------------------------------------------
function Timeplotmulti_Callback(hObject, eventdata, handles)
timeplot(hObject,handles,'multi');

% --------------------------------------------------------------------
function Timeplotsubplots_Callback(hObject, eventdata, handles)
timeplot(hObject,handles,'subplots');

% --------------------------------------------------------------------
function Spectrum_plot_Callback(hObject, eventdata, handles)
spectrumplot(hObject,'mainmenucall');

% --------------------------------------------------------------------
function Specgram_plot_Callback(hObject, eventdata, handles)
specgramplot(hObject,handles);

% --------------------------------------------------------------------
function Spectrogram3d_Callback(hObject, eventdata, handles)
specgram3dplot(hObject,handles);

% --------------------------------------------------------------------
function XYplot_Callback(hObject, eventdata, handles)
xyplot(hObject,handles);

% --------------------------------------------------------------------
function Sptool_Callback(hObject, eventdata, handles)
loadsptool(hObject,handles);






% --------------------------------------------------------------------
function Data_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Data_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Expressionsmenu_Callback(hObject, eventdata, handles)



% --- Executes on selection change in filelist.
function filelist_Callback(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns filelist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filelist
selfile = get(hObject,'Value');
siglist = makesignallist(handles.FILES(selfile));
set(handles.signallist,'String',siglist);
set(handles.signallist,'Value',1);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function filelist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in signallist.
function signallist_Callback(hObject, eventdata, handles)
% hObject    handle to signallist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns signallist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signallist


% --- Executes during object creation, after setting all properties.
function signallist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signallist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Project_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Project_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Filelist_Callback(hObject, eventdata, handles)
% hObject    handle to Filelist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fillista(handles.VAMOS2);

% --------------------------------------------------------------------
function Open_project_Callback(hObject, eventdata, handles)
% hObject    handle to Open_project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile();

if ~isequal(filename,0) | ~isequal(pathname,0)
	projdata = load([pathname filename]);
	if isfield(projdata,'handles')
		% Load data
		handles.FILES = projdata.handles.FILES;
		if isfield(projdata.handles,'plotdatafile')
			handles.plotdatafile = projdata.handles.plotdatafile;
		end
		if isfield(projdata.handles,'exprdatafile')
			handles.exprdatafile = projdata.handles.exprdatafile;
		end
		
		% Load windows
		h = hgload([pathname filename '.fig']);
		handles.WINDOWS = [handles.WINDOWS h'];
		
		% Update the mainhandle pointer in plot-axes
		ax = findobj(handles.WINDOWS,'Type','axes');
		for i=1:length(ax)
			ud = get(ax(i),'UserData');
			if isfield(ud,'mainhandle')
				ud.mainhandle = handles.VAMOS2;
				set(ax(i),'UserData',ud);
			end
		end
		
		guidata(hObject,handles);
		updatefilelist(handles.VAMOS2);
		filesloaded(hObject,handles);
		
	else
		errordlg('Not a valid VAMOS project file');
	end
end


% --------------------------------------------------------------------
function Save_project_Callback(hObject, eventdata, handles)
% hObject    handle to Save_project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile({'*.mat','Vamos saved project (*.mat)'}, 'Save project');
save([pathname filename],'handles');
for i=2:length(handles.WINDOWS)
	if ishandle(handles.WINDOWS(i))
		ruler_off_save(handles.WINDOWS(i));
		if exist('savewin')
			savewin(end+1) = handles.WINDOWS(i);
		else
			savewin(1) = handles.WINDOWS(i);
		end
			
	end
end
hgsave(savewin,[pathname filename '.fig']);

% --------------------------------------------------------------------
function Statistics_Callback(hObject, eventdata, handles)
% hObject    handle to Statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datastats(handles.VAMOS2);

% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_browser_Callback(hObject, eventdata, handles)
% hObject    handle to Help_browser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = ['           V A M O S        '; ...
	   '                            '; ...
	   '      Verktyg för Analys    '; ...
	   ' av Mätning Och Simulering  '; ...
	   '                            '; ...
	   '                            '; ...
	   '         Version: 3.0       '];
msgbox(str);


% --------------------------------------------------------------------
function Create_expression_Callback(hObject, eventdata, handles)
% hObject    handle to Create_expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
expr_create();
expr_list(handles.Saved_expressions,hObject);



% --------------------------------------------------------------------
function Delete_expression_Callback(hObject, eventdata, handles)
% hObject    handle to Delete_expression (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
expr_remove();
expr_list(handles.Saved_expressions,hObject);

% --------------------------------------------------------------------
function Saved_expressions_Callback(hObject, eventdata, handles)
% hObject    handle to Saved_expressions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Print_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Print_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function printeps_Callback(hObject, eventdata, handles)
% hObject    handle to printeps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function printpdf_Callback(hObject, eventdata, handles)
% hObject    handle to printpdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PrintCurrentPDF_Callback(hObject, eventdata, handles)
% hObject    handle to PrintCurrentPDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PrintAllTimePDF_Callback(hObject, eventdata, handles)
% hObject    handle to PrintAllTimePDF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function PrintCurrentEPS_Callback(hObject, eventdata, handles)
% hObject    handle to PrintCurrentEPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Savefile_Callback(hObject, eventdata, handles)
% hObject    handle to Savefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file_ind=get(handles.filelist,'Value');
[PATHSTR,NAME,EXT] = fileparts(handles.FILES(file_ind).file);

data.type=handles.FILES(file_ind).type;
data.file=handles.FILES(file_ind).file;
data.desc=handles.FILES(file_ind).desc;
nvar=handles.FILES(file_ind).nvar;
data.t=handles.FILES(file_ind).t;
data.nsamples=handles.FILES(file_ind).nsamples;
data.fs=handles.FILES(file_ind).fs;
% 
for i=1 : handles.FILES(file_ind).nvar
    dat(:,i)=handles.FILES(file_ind).signal(i).data;
    label(i,:)=handles.FILES(file_ind).signal(i).label;
    unit(i,:)=handles.FILES(file_ind).signal(i).unit;
    lowlimit(i,:)=handles.FILES(file_ind).signal(i).lowlimit;
    highlimit(i,:)=handles.FILES(file_ind).signal(i).highlimit;
    gain(i,:)=handles.FILES(file_ind).signal(i).gain;
    desc(i,:)=handles.FILES(file_ind).signal(i).desc;
end

beskrivning=handles.FILES(file_ind).desc;
data=dat;

sigrad1= 'Nr  NAME             UNIT   Lowlimit     Highlimit    Gain         COMMENTS';
sigrad2='++  ++++             ++++   ++++++++     +++++++++    ++++         +++++++++ ';
spc=char(32*ones(nvar,1));
nr=char(32*ones(nvar,3));
for i=1:nvar
    nr(i,:)=sprintf('%-3i',i);
end

for i=1:33, 
    if size(highlimit,2)<13, highlimit=[highlimit spc];end
    if size(lowlimit,2)<13, lowlimit=[lowlimit spc];end
    if size(label,2)<17, label=[label spc];end
    if size(gain,2)<13, gain=[gain spc];end
    if size(unit,2)<7, unit=[unit spc];end
    if size(desc,2)<33, desc=[desc spc];end
end

signaler=[nr label unit lowlimit highlimit gain desc];
siglen=length(signaler(1,:));
if siglen<100   % Rev MAD: Om antalet signalkolumner < 100, padda med blanksteg
    signaler=[signaler,char(32*ones(nvar,100-siglen))];
end
        
signaler=signaler(:,1:100); % Gammalt format var maximerat till 100 kolumner
signaler=char([cellstr(sigrad1);cellstr(sigrad2);cellstr(signaler)]);

TF=strcmp (EXT,'.mat');
if TF==0        % Check if not a .mat-file
    [FileName,PathName,FilterIndex] = uiputfile({'*.mat'},...
        'Save data as mat-file',...
        [PATHSTR,'\',NAME,'.mat']);
    save([PathName,FileName],'beskrivning','signaler','data');
else
    [FileName,PathName,FilterIndex] = uiputfile({'*.mat'},...
        'File already in mat-format. Overwrite in F12 mat-format?',...
        [PATHSTR,'\',NAME,'.mat']);
    save([PathName,FileName],'beskrivning','signaler','data');
end