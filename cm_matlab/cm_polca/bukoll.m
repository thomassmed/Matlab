function varargout = bukoll(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            bukoll v1.1
% Kontrollerar att härdinvenatrierna
% I POLCA och LADDA stämmer överens efter
% att förflyttningar gjorts i LADDDA
% Ytterligare instruktioner återfinns
% under menyn Hjälp i programmet.
% Skapad av Donald Duck, FTB 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bukoll_OpeningFcn, ...
                   'gui_OutputFcn',  @bukoll_OutputFcn, ...
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

% --- Executes just before bukoll is made visible.
function bukoll_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
handles.output = hObject;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initierar variablen egna structs
laddafil='default.txt';
handles.laddafil = laddafil;

distributionsfil='default.txt';
handles.distributionsfil = distributionsfil;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bukoll wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bukoll_OutputFcn(hObject, eventdata, handles)
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
[STARTfil,STARTvag]=uigetfile({'*.*'},'OBS! Härdinventariefil från LADDA');
laddafil=[STARTvag STARTfil];
handles.laddafil=laddafil;
set(handles.Distributionsfil,'Enable','on')
set(handles.Vladdafil,'String',laddafil);
set(handles.Vladdafil,'Visible','on');
set(handles.LADDAfil,'Visible','off')
set(handles.aterstall,'Enable','on')
guidata(hObject, handles);


% --- Executes on button press in Distributionsfil.
function Distributionsfil_Callback(hObject, eventdata, handles)
[STOPfil,STOPvag]=uigetfile({'*.dat'},'OBS! Härdinventariefil från POLCA');
distributionsfil=[STOPvag STOPfil];
handles.distributionsfil = distributionsfil;
set(handles.Vpolca,'String',distributionsfil);
set(handles.Distributionsfil,'Visible','off')
set(handles.Vpolca,'Visible','on');
set(handles.kontroll,'Enable','on')
guidata(hObject, handles);

% --- Executes on button press in kontroll.
function kontroll_Callback(hObject, eventdata, handles)
try %Hantering av felmeddelanden, fungerar tillsammans med catch
disp(' ')
disp(' ')
disp('------------------------------------------')
disp('             bukoll v1.1')    
disp('------------------------------------------')
disp(' ')
disp('           kontroll påbörjas!')    
disp(' ')
LADDAfilen=get(handles.Vladdafil,'String');
DISTRIBUTIONSfilen=get(handles.Vpolca,'String');
set(handles.kontroll,'Enable','off')
set(handles.aterstall,'Enable','on')

UsedOS=computer;
UsedOS=length(UsedOS);
if UsedOS == 4
    dosfix=['!dos2unix ',LADDAfilen,' laddafil.ux']; % Unix
    disp('Sun version used');
else
    dosfix=['!dos2unix -q -n ',LADDAfilen,' laddafil.ux']; % Linux -n = newfile -q = suppressing messages. not awaliable on Sun.
end
eval(dosfix);
fid=fopen('laddafil.ux','r');
line=fgetl(fid);
ladda_asy=[];
ladda_r=[];
ladda_k=[];
while line ~= -1
  i=findstr(line,'  ');
  ii=find(line==32);
  if ~isempty(i)
    asy='       ';
  else
    asy=line(ii(1)+1:ii(2)-1);
    asy=[asy setstr(32*ones(1,7-length(asy)))];
  end
  r=str2num(line(ii(2)+1:ii(3)-1));
  k=str2num(line(ii(3)+1:length(line)));
  ladda_asy=[ladda_asy;asy];
  ladda_r=[ladda_r;r];
  ladda_k=[ladda_k;k];
  line=fgetl(fid);
end
unix('rm laddafil.ux');

neumodel=polca_version(DISTRIBUTIONSfilen);
if strcmp(neumodel,'POLCA7'),
  [polca_asy,mminj,konrod]=readdist7(DISTRIBUTIONSfilen,'asyid');
  [crid]=readdist7(DISTRIBUTIONSfilen,'crid');
elseif strcmp(neumodel,'POLCA4'),
  [polca_asy,mminj,konrod]=readdist(DISTRIBUTIONSfilen,'buidnt');
  [crid]=readdist(DISTRIBUTIONSfilen,'cridnt');
end
    yx=knum2cpos(1:size(polca_asy,1),mminj);
    crpos=crnum2crpos(1:length(konrod),mminj);
    polca_r=[yx(:,1);crpos(:,1)];
    polca_k=[yx(:,2);crpos(:,2)];
    if crid == -1
    temp1=size(ladda_asy,1);
    temp2=size(polca_asy,1);
    diff=temp1-temp2;
    v=0;
    crid_saknas=[];
    while v < diff
        cr_temp='saknas';
        crid_saknas=[crid_saknas;cr_temp];
        v=v+1;
    end
    crid=crid_saknas;
  end
    polca_asy=[polca_asy;crid];
    ladda_asy=left_adjust(ladda_asy);
    polca_asy=left_adjust(polca_asy);
    polca_asy=polca_asy(:,1:size(ladda_asy,2));
    err=find(max((ladda_asy-polca_asy)')');
    resultat=fopen('bukoll_resultat.lis','w+');
    fprintf(resultat,'\n\n HÄRDINVENTARIE KONTROLL utförd med bukoll ');
    fprintf(resultat,'\n Utförd: %s ',date);
    fprintf(resultat,'\n\n Kontroll mellan LADDA:s fil: \t %s \n och POLCA:s fil: \t \t %s \n\n',LADDAfilen,DISTRIBUTIONSfilen);
        for i=1:length(err)
        fprintf(resultat,'\n %s  %s  %d  %d',ladda_asy(err(i),:),polca_asy(err(i),:),polca_r(err(i)),polca_k(err(i)));
    end
    fprintf(resultat,'\n\n Totalt %d skillnader mellan LADDA och POLCA\n\n',length(err));
    fclose('all');
    unix('nedit bukoll_resultat.lis &');
    disp(' ')
    disp('------------------------------------------')
    disp('                 Klart!')    
    disp('------------------------------------------')
    disp(' ')
    %end    
catch
    fel_med={' ','bukoll stötte på ett problem',' ','Troliga fel kan vara:',' ','Filerna är inte av rätt typ POLCA4/POLCA7.','Du har försökt att köra programmet i fel miljö (Unix/Linux).'};
    errordlg(fel_med,'Fel meddelande bukoll','bukoll problem...');
    disp('------------------------------------------')
    disp('      VARNING KONTROLL EJ GENOMFÖRD')    
    disp('------------------------------------------')
    disp(' ')
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
% --------------------------------------------------------------------
function Arkiv_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function hjalp_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Instruktion_Callback(hObject, eventdata, handles)
Instr_text={' ','ALLMÄNT:','bukoll kontrollerar om den angivna härdinventariefilen från LADDA stämmer överens med de patronidentiteter som POLCA anser ska finnas i härden.',' ','ANVÄNDNING:','En härdinventariefil från LADDA väljs som första fil och sedan väljs den aktuella BOC-filen man vill jämföra med. Om filerna skiljer sker en utskrift på skärmen som visar vilka positioner som skiljer.',' ','Utskrift:','Om man så önskar kan man välja att skriva ut resultatet antingen genom att skriva ut filen direkt från nedit eller via normal utskrift från prompt.',' ','ÖVRIGT:','Om du har frågor om programmet kontakta då i första hand:',' ',' Donald Duck, FTB'};
helpdlg(Instr_text,'bukoll instruktion');
% --------------------------------------------------------------------
function om_bukoll_Callback(hObject, eventdata, handles)
Om_text={' ','                                            bukoll',' ','bukoll kontrollerar om LADDA:s och POLCA:s härdpositioner överenstämmer.',' ','Ingen kopiering eller vidarespridning av bukoll v1.1 får ske utan','VATTENFALL Forsmarks Kraftgrupp AB:s skriftliga godkännande.', ' ','         © VATTENFALL Forsmarks Kraftgrupp AB, 2005, All rights reserved'};
helpdlg(Om_text,'Om bukoll');
%***********************************************************
