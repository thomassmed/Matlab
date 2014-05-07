function varargout = PRM_XP(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    PRM_XP v1.0
% Genererar plottar p� kalkylerad utbr�nning av
% PRM-sonder. Anv�nder sig av PRM-indata f�r att
% extrapolera f�rv�ntad livsl�ngd. Starta programmet
% f�lj d�refter anvisningarna eller v�lj Hj�lp
% p� menyn f�r att f� ytterligare information.
%
%             Jan karjalainen, FTB 2005
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%***********************************************
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PRM_XP_OpeningFcn, ...
                   'gui_OutputFcn',  @PRM_XP_OutputFcn, ...
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
%***********************************************

% --- Executes just before PRM_XP is made visible.
function PRM_XP_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for PRM_XP
handles.output = hObject;

%***********************************************
% INITIERING AV VARIABLER
%***********************************************
% Antal sonder
antalsonder=36;
handles.antalsonder=antalsonder;

% Vilken sond om en valts
vilkensond=1;
handles.vilkensond=vilkensond;

% Startv�rde f�r ber�kning
anpasstart=0;
handles.anpasstart=anpasstart;
% Slutv�rde
anpasstop=0;
handles.anpasstart=anpasstop;

% N�sta revision �r
nastaRA=0;
handles.nasta=nastaRA;

% Utr�nningar
nastaEOC=0;
handles.nastaEOC=nastaEOC;

utbranning1=1;
handles.utbranning1=utbranning1;

utbranning2=2;
handles.utbranning2=utbranning2;

utbranning3=3;
handles.utbranning3=utbranning3;

utbranning4=4;
handles.utbranning4=utbranning4;

%***********************************************
% SLUT INITIERING AV VARIABLER
%***********************************************



% Update handles structure
guidata(hObject, handles);

%--- Outputs from this function are returned to the command line.
function varargout = PRM_XP_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%***********************************************
% radiobutton1. BER�KNA ALLA SONDER
%***********************************************
function radiobutton1_Callback(hObject, eventdata, handles)
set(handles.edit1,'Enable','on')
set(handles.pushbutton3,'Enable','on')
set(handles.radiobutton1,'Enable','off')
set(handles.radiobutton2,'Enable','off')
antalsonder=36;
handles.antalsonder=antalsonder;
guidata(hObject, handles);

%***********************************************
% radiobutton2. BER�KNA EN SOND
%***********************************************
function radiobutton2_Callback(hObject, eventdata, handles)
set(handles.listbox1,'Enable','on')
set(handles.pushbutton3,'Enable','on')
set(handles.radiobutton1,'Enable','off')
set(handles.radiobutton2,'Enable','off')
antalsonder=1;
handles.antalsonder=antalsonder;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% listbox1. SONDNUMMER
%***********************************************
function listbox1_Callback(hObject, eventdata, handles)
set(handles.edit1,'Enable','on')
sondnummer=get(handles.listbox1,'Value');
vilkensond=sondnummer-1;
handles.vilkensond=vilkensond;
guidata(hObject, handles);


%************************* MENYER*************************************
% --------------------------------------------------------------------
function Arkiv_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Ny_berakning_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Enable','on')
set(handles.radiobutton1,'Value',0)
set(handles.radiobutton2,'Enable','on')
set(handles.radiobutton2,'Value',0)
set(handles.edit1,'Enable','off')
set(handles.edit2,'Enable','off')
set(handles.edit3,'Enable','off')
set(handles.edit4,'Enable','off')
set(handles.edit5,'Enable','off')
set(handles.edit6,'Enable','off')
set(handles.edit7,'Enable','off')
set(handles.listbox1,'Enable','off')
set(handles.listbox2,'Enable','off')
guidata(hObject, handles);

% --------------------------------------------------------------------
function Print_one_Callback(hObject, eventdata, handles)
try
utskrift=questdlg('Vill du skriva ut grafen f�r den valda sonden i PRM_XP f�nstret till f1laser35? ','   Utskrift till f1laser35    ','Yes');
utskrift=length(utskrift);
if utskrift==3
sonden=handles.vilkensond;
temp1=num2str(sonden); % Skapar en str�ng av sondnummret
temp2='!lpr -Pf1laser35 graf_XP';       % 
temp3='.eps';
temp4=[temp2 temp1 temp3];   % Sammansatt namn och sondnummer
eval(temp4);
end
catch
    fel_med={' ','PRM_XP st�tte p� ett problem',' ','Troliga fel kan vara:',' ','Ingen sond �r vald.','Sonden �r �nnu inte ber�knad.'};
    errordlg(fel_med,'Fel meddelande PRM_XP','PRM_XP problem...');
end


% --------------------------------------------------------------------
function Print_alla_Callback(hObject, eventdata, handles)
try
utskrift=questdlg('Vill du skriva ut samtliga tillg�ngliga sondgrafer till f1laser35?','   Utskrift till f1laser35    ','Yes');
utskrift=length(utskrift);
if utskrift==3
    !lpr -Pf1laser35 graf_XP*.eps
end
catch
    fel_med={' ','PRM_XP st�tte p� ett problem',' ','Troligt fel �r:',' ','Ingen sond �r ber�knad.'};
    errordlg(fel_med,'Fel meddelande PRM_XP','PRM_XP problem...');
end


% --------------------------------------------------------------------
function Avsluta_Callback(hObject, eventdata, handles)
close all
!rm graf_XP*.eps
clear all

% --------------------------------------------------------------------
function Hjalp_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Instruktion_Callback(hObject, eventdata, handles)
Instr_text={' ','ALLM�NT:','PRM_XP extrapolerar och plottar PRM-sondernas utbr�nningar. Denna information anv�nder sedan FMTA f�r att skapa utbytes- och underh�llsplaner.',' ','ANV�NDNING:','V�lj om du vill extrapolera en sond eller alla sonder. Startv�rde, Slutv�rde och Ber�knad EOC anges i EFPH fr�n "Begining of life". �vriga EFPH anges som ber�knat antal EFPH per aktuell cykel enligt K4-plan.',' ','Utskrift:','Om man s� �nskar kan man v�lja att skriva ut resultatet antingen genom v�lja "Skriv ut..." under Arkiv direkt eller via utskrift fr�n respektive figur.',' ','�VRIGT:','Om du har fr�gor om programmet kontakta d� i f�rsta hand:',' ',' Jan Karjalainen, FTB'};
helpdlg(Instr_text,'PRM_XP instruktion');


% --------------------------------------------------------------------
function Om_prm_Callback(hObject, eventdata, handles)
Om_text={' ','                                  PRM_XP v1.0',' ','PRM_XP Extrapolering och plottning av PRM-sondernas utbr�nning.',' ','Ingen kopiering eller vidarespridning av PRM_XP v1.0 f�r ske utan','Forsmarks Kraftgrupp AB:s skriftliga godk�nnande.', ' ','         � Forsmarks Kraftgrupp AB, 2005, All rights reserved'};
helpdlg(Om_text,'Om PRM_XP');

%*******************************************************************



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% STARTV�RDE f�r simulering
%***********************************************
function edit1_Callback(hObject, eventdata, handles)
set(handles.listbox1,'Enable','off')
set(handles.edit2,'Enable','on')
anpasstart=str2double(get(handles.edit1,'String'));
handles.anpasstart=anpasstart;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% STOPV�RDE f�r simulering
%***********************************************
function edit2_Callback(hObject, eventdata, handles)
set(handles.edit2,'Enable','off')
set(handles.listbox2,'Enable','on')
anpasstop=str2double(get(handles.edit2,'String'));
handles.anpasstop=anpasstop;
guidata(hObject, handles);


function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% listbox2. N�STA REVISION �R...
%***********************************************
function listbox2_Callback(hObject, eventdata, handles)
set(handles.edit3,'Enable','on')
RAnummer=get(handles.listbox2,'Value');
nastaRA=RAnummer-1;
handles.nastaRA=nastaRA;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% N�sta EOC utbr�nning total v�rde fr�n f�rsta b�rjan. 
%***********************************************
function edit3_Callback(hObject, eventdata, handles)
set(handles.listbox2,'Enable','off')
set(handles.edit3,'Enable','off')
set(handles.edit4,'Enable','on')
nastaEOC=str2double(get(handles.edit3,'String'));
handles.nastaEOC=nastaEOC;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% Utbr�nning n�sta cykel
%***********************************************
function edit4_Callback(hObject, eventdata, handles)
set(handles.edit4,'Enable','off')
set(handles.edit5,'Enable','on')
utbranning1=str2double(get(handles.edit4,'String'));
handles.utbranning1=utbranning1;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% Utbr�nning n�sta cykel + 1
%***********************************************
function edit5_Callback(hObject, eventdata, handles)
set(handles.edit5,'Enable','off')
set(handles.edit6,'Enable','on')
utbranning2=str2double(get(handles.edit5,'String'));
handles.utbranning2=utbranning2;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% Utbr�nning n�sta cykel + 2
%***********************************************
function edit6_Callback(hObject, eventdata, handles)
set(handles.edit6,'Enable','off')
set(handles.edit7,'Enable','on')
utbranning3=str2double(get(handles.edit6,'String'));
handles.utbranning3=utbranning3;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%***********************************************
% Utbr�nning n�sta cykel + 3
%***********************************************
function edit7_Callback(hObject, eventdata, handles)
set(handles.edit7,'Enable','off')
set(handles.pushbutton1,'Enable','on')
utbranning4=str2double(get(handles.edit7,'String'));
handles.utbranning4=utbranning4;
guidata(hObject, handles);

%***********************************************
% pushbutton1. BER�KNA
%***********************************************
function pushbutton1_Callback(hObject, eventdata, handles)
try
start=handles.anpasstart;
stop=handles.anpasstop;
ra1_EFPH=handles.nastaEOC;
ra2_EFPH=handles.utbranning1;
ra3_EFPH=handles.utbranning2;
ra4_EFPH=handles.utbranning3;
ra5_EFPH=handles.utbranning4;
RA=handles.nastaRA;

Wbar = waitbar(0,'PRM XP Ber�knar sonder var god v�nta...','Position',[50,50,310,60]);
antal_sonder=handles.antalsonder;

if antal_sonder == 1
   sonden=handles.vilkensond;
   gkp_prm_XP(sonden,start,stop,ra1_EFPH,ra2_EFPH,ra3_EFPH,ra4_EFPH,ra5_EFPH,RA);
    waitbar(1/2,Wbar)
    waitbar(2/2,Wbar)
else
    for sond=1:1:antal_sonder
    gkp_prm_XP(sond,start,stop,ra1_EFPH,ra2_EFPH,ra3_EFPH,ra4_EFPH,ra5_EFPH,RA);
    waitbar(sond/antal_sonder,Wbar)
    end
end
close(Wbar);
catch
    fel_med={' ','PRM_XP st�tte p� ett problem',' ','Troliga fel kan vara:',' ','Du st�r inte i r�tt katalog. Kontrollera att den aktuella katalogen inneh�ller PRM-data.','Du har valt fel sond eller fel revisionsavst�llning.'};
    errordlg(fel_med,'Fel meddelande PRM_XP','PRM_XP problem...');
end
guidata(hObject, handles);


%***********************************************
% BER�KNINGS FUNKTION
%***********************************************
function gkp_prm_XP(sondnr,start,stop,ra1_EFPH,ra2_EFPH,ra3_EFPH,ra4_EFPH,ra5_EFPH,RA)
% Indata till plott
anpasstart=start;
anpasstop=stop;
linje=0.1;
ra2_EFPH=ra1_EFPH+ra2_EFPH;
ra3_EFPH=ra2_EFPH+ra3_EFPH;
ra4_EFPH=ra3_EFPH+ra4_EFPH;
ra5_EFPH=ra4_EFPH+ra5_EFPH;

RAlista={'RA05' 'RA06' 'RA07' 'RA08' 'RA09' 'RA10' 'RA11' 'RA12' 'RA13' 'RA14' 'RA15' 'RA16' 'RA17' 'RA18'};

% Slut indata

% Extrapoleringar
sondnr=num2str(sondnr);
fil=['LPRM1.',sondnr];
[x,y]=prm2mlab_XP(fil);
temp_handle=figure; %Sparar handle till f�nstret
semilogy(x,y,'b');
hold on
i=find(x>anpasstart);
p4=polyfit(x(i),log(y(i)),1);
p4kurva=polyval(p4,[x(i);anpasstop]);
semilogy([x(i);anpasstop],exp(p4kurva),'b');

axis([min(x) anpasstop 0.08 1]);

fil=['LPRM2.',sondnr];
[x,y]=prm2mlab_XP(fil);
semilogy(x,y,'g');
i=find(x>anpasstart);
p4=polyfit(x(i),log(y(i)),1);
p4kurva=polyval(p4,[x(i);anpasstop]);
semilogy([x(i);anpasstop],exp(p4kurva),'g');

fil=['LPRM3.',sondnr];
[x,y]=prm2mlab_XP(fil);
semilogy(x,y,'r');
i=find(x>anpasstart);
p4=polyfit(x(i),log(y(i)),1);
p4kurva=polyval(p4,[x(i);anpasstop]);
semilogy([x(i);anpasstop],exp(p4kurva),'r');

fil=['LPRM4.',sondnr];
[x,y]=prm2mlab_XP(fil);
semilogy(x,y,'k');
i=find(x>anpasstart);
p4=polyfit(x(i),log(y(i)),1);
p4kurva=polyval(p4,[x(i);anpasstop]);
semilogy([x(i);anpasstop],exp(p4kurva),'k');

% Plotta linje
linex=min(x):1000:anpasstop;
liney=ones(size(linex)).*linje;
line(linex,liney);
grid on

% Plotta revisioner
rax=[ra1_EFPH ra1_EFPH];
ray=[eps max(y)];
plot(rax,ray);
text(ra1_EFPH-4000,max(y)*0.65,RAlista(RA));

rax=[ra2_EFPH ra2_EFPH];
ray=[eps max(y)];
plot(rax,ray)
text(ra2_EFPH-4000,max(y)*0.55,RAlista(RA+1));

rax=[ra3_EFPH ra3_EFPH];
ray=[eps max(y)];
plot(rax,ray)
text(ra3_EFPH-4000,max(y)*0.45,RAlista(RA+2));

rax=[ra4_EFPH ra4_EFPH];
ray=[eps max(y)];
plot(rax,ray);
text(ra4_EFPH-4000,max(y)*0.35,RAlista(RA+3));

rax=[ra5_EFPH ra5_EFPH];
ray=[eps max(y)];
plot(rax,ray);
text(ra5_EFPH-4000,max(y)*0.25,RAlista(RA+4));

tit=['SOND ',sondnr,'  lprm1(bl�)  lprm2(gr�n)  lprm3(r�d)  lprm4(svart)'];
title(tit);
temp1=num2str(sondnr); % Skapar en str�ng av sondnummret
temp2='graf_XP';       % Namn man ska spara med
temp3=[temp2 temp1];   % Sammansatt namn och sondnummer
print(temp_handle,'-depsc',temp3); % Sparar filen.
hold off
fclose  all;


%***********************************************
% prm2mlab_XP L�ser in data fr�n aktuell PRM-fil
%***********************************************
function [x,y]=prm2mlab_XP(filename)
fid=fopen(filename,'r');
for i=1:5,
  line=fgetl(fid);
end
line=fgetl(fid);
x=sscanf(line,'%f');
line=fgetl(fid);
line=fgetl(fid);
y=sscanf(line,'%f');

%***********************************************
% pushbutton2. AVSLUTA
%***********************************************
function pushbutton2_Callback(hObject, eventdata, handles)
close all
!rm graf_XP*.eps
clear all

%***********************************************
% pushbutton3. �TERST�LL
%***********************************************
function pushbutton3_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Enable','on')
set(handles.radiobutton1,'Value',0)
set(handles.radiobutton2,'Enable','on')
set(handles.radiobutton2,'Value',0)
set(handles.edit1,'Enable','off')
set(handles.edit2,'Enable','off')
set(handles.edit3,'Enable','off')
set(handles.edit4,'Enable','off')
set(handles.edit5,'Enable','off')
set(handles.edit6,'Enable','off')
set(handles.edit7,'Enable','off')
set(handles.listbox1,'Enable','off')
set(handles.listbox2,'Enable','off')
guidata(hObject, handles);



