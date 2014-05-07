% $Id: crwea_gui.m 70 2013-08-19 12:48:53Z rdj $
%
function varargout = crwea_gui(varargin)
% CRWEA_GUI M-file for crwea_gui.fig
%      CRWEA_GUI, by itself, creates a new CRWEA_GUI or raises the existing
%      singleton*.
%
%      H = CRWEA_GUI returns the handle to a new CRWEA_GUI or the handle to
%      the existing singleton*.
%
%      CRWEA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CRWEA_GUI.M with the given input arguments.
%
%      CRWEA_GUI('Property','Value',...) creates a new CRWEA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crwea_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crwea_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crwea_gui

% Last Modified by GUIDE v2.5 30-Mar-2012 13:15:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crwea_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @crwea_gui_OutputFcn, ...
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


% --- Executes just before crwea_gui is made visible.
function crwea_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crwea_gui (see VARARGIN)

% Choose default command line output for crwea_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

simfile_edit_Callback(handles.simfile_edit,[],handles);

% UIWAIT makes crwea_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = crwea_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function simfile_edit_Callback(hObject, eventdata, handles)
% hObject    handle to simfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simfile_edit as text
%        str2double(get(hObject,'String')) returns contents of simfile_edit as a double

simfile=get(hObject,'String');
if exist(simfile,'file')
   sim=load(simfile);
   if exist(sim.mangrpfile)
      manvec=mgrp2vec(sim.mangrpfile);
   else
      warndlg(['Can not find the mangrp-file. Path in simfile: ' ...
                sim.mangrpfile],'Warning','modal');
      return;
   end
   
   [~,mminj]=readdist7(sim.bocfile);
   handles.mminj=mminj;
   
   burfiles=strvcat(sim.bocfile, sim.filenames(1:end-1,:));
   set(handles.burnup_listbox,'String',burfiles);
   
   [mangrps,~]=strread(strtrim(sim.conrod(1,:)),'%n=%n','delimiter',',');
   handles.mangrps=mangrps;
   set(handles.grps_listbox,'String',mangrps);
   
   rods=[];
   rodsaxis={};
   for i=1:length(mangrps)
      grprods=find(manvec==mangrps(i));
      for r=1:length(grprods)
         rods=[rods grprods(r)];
         rodsaxis=[rodsaxis crpos2axis(crnum2crpos(grprods(r),mminj),0)];
      end
   end
   unique(rods);
   handles.rods=rods;
   set(handles.rods_listbox,'String',rodsaxis);
else
   warndlg('Simfile not found!','Warning','modal');
   set(handles.burnup_listbox,'String',[]);
   set(handles.grps_listbox,'String',[]);
   set(handles.rods_listbox,'String',[]);
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function simfile_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in burnup_listbox.
function burnup_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to burnup_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns burnup_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from burnup_listbox


% --- Executes during object creation, after setting all properties.
function burnup_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to burnup_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in grps_listbox.
function grps_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to grps_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grps_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grps_listbox


% --- Executes during object creation, after setting all properties.
function grps_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grps_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rods_listbox.
function rods_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to rods_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rods_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rods_listbox


% --- Executes during object creation, after setting all properties.
function rods_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rods_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in simopen_button.
function simopen_button_Callback(hObject, eventdata, handles)
% hObject    handle to simopen_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.mat','Select simfile');
if filename
    fullpath=[pathname filename];
    if exist(fullpath,'file')
        set(handles.simfile_edit,'String',fullpath);
    end
end


% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist(handles.config.resultfile,'file')
   overwrite=questdlg('Resultfile exists, do you want to overwrite?');
else
    overwrite='Yes';
end

if strcmp(overwrite,'Yes')
    % Save caseinput to resultfile
    config=handles.config;
    cases=handles.cases;
    save(config.resultfile,'config','cases');
    
    % Start run
    crwea_run(config,cases);
end

% --- Executes on button press in save_cpr_checkbox.
function save_cpr_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to save_cpr_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_cpr_checkbox


% --- Executes on selection change in cpr_dim_sel.
function cpr_dim_sel_Callback(hObject, eventdata, handles)
% hObject    handle to cpr_dim_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cpr_dim_sel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpr_dim_sel


% --- Executes during object creation, after setting all properties.
function cpr_dim_sel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpr_dim_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_lhgr_checkbox.
function save_lhgr_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to save_lhgr_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_lhgr_checkbox


% --- Executes on selection change in lhgr_dim_sel.
function lhgr_dim_sel_Callback(hObject, eventdata, handles)
% hObject    handle to lhgr_dim_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lhgr_dim_sel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lhgr_dim_sel


% --- Executes during object creation, after setting all properties.
function lhgr_dim_sel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lhgr_dim_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function steps_edit_Callback(hObject, eventdata, handles)
% hObject    handle to steps_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of steps_edit as text
%        str2double(get(hObject,'String')) returns contents of steps_edit as a double


% --- Executes during object creation, after setting all properties.
function steps_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to steps_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_wd_edit_Callback(hObject, eventdata, handles)
% hObject    handle to max_wd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_wd_edit as text
%        str2double(get(hObject,'String')) returns contents of max_wd_edit as a double


% --- Executes during object creation, after setting all properties.
function max_wd_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_wd_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function resultfile_edit_Callback(hObject, eventdata, handles)
% hObject    handle to resultfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resultfile_edit as text
%        str2double(get(hObject,'String')) returns contents of resultfile_edit as a double


% --- Executes during object creation, after setting all properties.
function resultfile_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultfile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resopen_button.
function resopen_button_Callback(hObject, eventdata, handles)
% hObject    handle to resopen_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.mat','Select result file');
if filename
    fullpath=[pathname filename];
    if exist(fullpath,'file')
        set(handles.resultfile_edit,'String',fullpath);
    end
end

% --- Executes on button press in create_button.
function create_button_Callback(hObject, eventdata, handles)
% hObject    handle to create_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'config')
    config=handles.config;
end

% Set some defualt values. TODO make these user editable
config.srcfile='pol/source.txt';
config.options='TTABLE,CBH,HOLDXE';
config.symme=1;
config.press=70.0;


config.simfile=get(handles.simfile_edit,'String');
config.resultfile=get(handles.resultfile_edit,'String');

config.dstep=str2double(get(handles.steps_edit,'String'));
config.max_initial_withdrawal=str2double(get(handles.max_wd_edit,'String'));

config.run_er=get(handles.er_checkbox,'Value');
config.run_vr=get(handles.vr_checkbox,'Value');

config.lhgr_save=get(handles.save_lhgr_checkbox,'Value');
if get(handles.lhgr_dim_sel,'Value')==1
    config.lhgr_dim='2D';
else
    config.lhgr_dim='3D';
end
config.cpr_save=get(handles.save_cpr_checkbox,'Value');
if get(handles.cpr_dim_sel,'Value')==1
    config.cpr_dim='2D';
else
    config.cpr_dim='3D';
end

config.bursteps=get(handles.burnup_listbox,'Value');

selgrps=get(handles.grps_listbox,'Value');
config.grps=handles.mangrps(selgrps);

selrods=get(handles.rods_listbox,'Value');
config.rods=handles.rods(selrods);


% Create cases
cases=crwea_create_cases(config);
config.ncases=length(cases);

% Save to handles struct
handles.config=config;
handles.cases=cases;
guidata(hObject,handles);

tdata=cell(length(cases),6);
% Update cases table
for i=1:length(cases)
    tdata{i,1}=i; 
    tdata{i,2}=cases(i).burnup;
    tdata{i,3}=cases(i).mangrp;
    if ~isempty(cases(i).rod)
        tdata{i,4}=['   ' crpos2axis(crnum2crpos(cases(i).rod,handles.mminj),0)];
    end
    tdata{i,5}=cases(i).wd;
    tdata{i,6}=['   ' upper(cases(i).regmod)];
end
set(handles.cases_table,'Data',tdata);


% --- Executes on button press in show_res_button.
function show_res_button_Callback(hObject, eventdata, handles)
% hObject    handle to show_res_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resultfile=get(handles.resultfile_edit,'String');
if exist(resultfile,'file')
    crwea_vis(resultfile);
else
    warndlg('Result file not found!','Warning');
end

% --- Executes on button press in er_checkbox.
function er_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to er_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of er_checkbox


% --- Executes on button press in vr_checkbox.
function vr_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to vr_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vr_checkbox
