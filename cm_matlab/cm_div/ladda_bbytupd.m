function varargout = ladda_bbytupd(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            ladda_bbytupd v1.0
% Skapar en BOC-fil till LADDA utifrån
% POLCA7:s senaste EOC-fil och nya BOC-fil.
% Följ anvisningarna i programmet.
% 
% Skapad av Jan Karjalainen, FTB 2005
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ladda_bbytupd_OpeningFcn, ...
                   'gui_OutputFcn',  @ladda_bbytupd_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before ladda_bbytupd is made visible.
function ladda_bbytupd_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
handles.output = hObject;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initierar variablen egna structs
PEOCfil='default.txt';
handles.PEOCfil = PEOCfil;

PBOCfil='default.txt';
handles.PBOCfil = PBOCfil;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ladda_bbytupd wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ladda_bbytupd_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function Distributionsfil_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes during object creation, after setting all properties.
function LADDAfil_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes during object creation, after setting all properties.
function Vpolca_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Vpolca_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Vladdafil_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Vladdafil_Callback(hObject, eventdata, handles)


% --- Executes on button press in LADDAfil.
function LADDAfil_Callback(hObject, eventdata, handles)
[EOCfil,EOCvag]=uigetfile({'*.dat'},'EOC-fil från POLCA7');
PEOCfil=[EOCvag EOCfil];
handles.PEOCfil=PEOCfil;
set(handles.Distributionsfil,'Enable','on')
set(handles.Vladdafil,'String',PEOCfil);
set(handles.Vladdafil,'Visible','on');
set(handles.LADDAfil,'Visible','off')
set(handles.aterstall,'Enable','on')
guidata(hObject, handles);

% --- Executes on button press in Distributionsfil.
function Distributionsfil_Callback(hObject, eventdata, handles)
[BOCfil,BOCvag]=uigetfile({'*.dat'},'BOC-fil från POLCA7');
PBOCfil=[BOCvag BOCfil];
handles.PBOCfil = PBOCfil;
set(handles.Vpolca,'String',PBOCfil);
set(handles.Distributionsfil,'Visible','off')
set(handles.Vpolca,'Visible','on');
set(handles.kontroll,'Enable','on')
guidata(hObject, handles);

% --- Executes on button press in kontroll.
function kontroll_Callback(hObject, eventdata, handles)
try %Hantering av felmeddelanden, fungerar tillsammans med catch
PEOCfilen=get(handles.Vladdafil,'String');
PBOCfilen=get(handles.Vpolca,'String');
set(handles.kontroll,'Enable','off')
set(handles.aterstall,'Enable','on')
ladda_bbytupd_XP(PEOCfilen,PBOCfilen); % Utför skapandet av ny BOC-fil
catch
    fel_med={' ','ladda_bbytupd stötte på ett problem',' ','Troliga fel kan vara:',' ','Filerna är inte av rätt typ. Det måste vara POLCA7-filer.','Du har valt filerna i fel ordning.','Du har försökt att köra programmet i fel miljö (Unix/Linux).'};
    errordlg(fel_med,'Fel meddelande ladda_bbytupd','ladda_bbytupd problem...');
end
guidata(hObject, handles);

% --- Executes on button press in aterstall.
function aterstall_Callback(hObject, eventdata, handles)
set(handles.LADDAfil,'Visible','on')
set(handles.Vpolca,'Visible','off');
set(handles.Vladdafil,'Visible','off');
set(handles.aterstall,'Enable','off')
set(handles.Distributionsfil,'Visible','on')
set(handles.Distributionsfil,'Enable','off')



%*******************MENYER*********************************
% --- Executes on button press in Avsluta.
function Avsluta_Callback(hObject, eventdata, handles)
close all
clear all
% --------------------------------------------------------------------
function Arkiv_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function hjalp_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Instruktion_Callback(hObject, eventdata, handles)
Instr_text={' ','ALLMÄNT:','ladda_bbytupd skapar en ny BOC-fil till LADDA utifrån POLCA:s EOC-fil och nya BOC-fil.',' ','ANVÄNDNING:','Först väljs den aktuella EOC-file och sedan väljs den aktuella BOC-filen. Därefter skapar man den nya BOC-filen för LADDA. Den nya filen heter bocXX.dat-.jkl',' ','ÖVRIGT:','Om du har frågor om programmet kontakta då i första hand:',' ',' Jan Karjalainen, FTB'};
helpdlg(Instr_text,'ladda_bbytupd instruktion');
% --------------------------------------------------------------------
function om_ladda_bbytupd_Callback(hObject, eventdata, handles)
Om_text={' ','                                   ladda_bbytupd',' ','Ladda_bbytupd skapar en BOC-fil till LADDA.',' ','Ingen kopiering eller vidarespridning av ladda_bbytupd v1.0 får ske utan','Forsmarks Kraftgrupp AB:s skriftliga godkännande.', ' ','         © Forsmarks Kraftgrupp AB, 2005, All rights reserved'};
helpdlg(Om_text,'Om ladda_bbytupd');
%***********************************************************

function ladda_bbytupd_XP(eocfil,bocfil)
%från polca7
asyid1=readdist7(eocfil,'asyid');
asyid2=readdist7(bocfil,'asyid');
crident1=readdist7(eocfil,'crid');
crident2=readdist7(bocfil,'crid');

% skriva till fil
prifil=[bocfil,'-.jkl'];
fid=fopen(prifil,'w');
fprintf(fid,'%8s %9s','COREDATA ',bocfil);
fprintf(fid,'\n');
fprintf(fid,' BP-EOC BP-BOC SS-EOC SS-BOC');
fprintf(fid,'\n');
for i=1:length(crident1);
fprintf(fid,' %6s%7s%7s%7s\n',asyid1(i,:),asyid2(i,:),crident1(i,:),crident2(i,:));
end
for i=length(crident1)+1:length(asyid1);
fprintf(fid,' %6s %7s\n',asyid1(i,:),asyid2(i,:));
end
%fprintf(fid,'\n');
fprintf(fid,'END');
disp('');
temp1=['LADDA BOC-fil vid namn '];
temp2=[' skapad.'];
temp3=[temp1 prifil temp2];
disp(temp3);
disp('');
fclose(fid);
