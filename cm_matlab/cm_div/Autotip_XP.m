%@(#)   Autotip_XP.m 1.6	 08/02/15     10:54:34
%
function varargout = Autotip_XP(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Autotip_XP v2.0
% Genererar automatiska bilagor till
% Tiprapporter. Starta programmet i Matlab
% genom att skriva Autotip_XP F�lj d�refter
% anvisningarna i programmet.
% Programmerad av Jan Karjalainen, FTB 2004
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F�ljande st�dprogram m�ste finnas
% tillg�ngliga f�r att programmet ska
% fungera korrekt. Vid eventuella uppdateringar
% m�ste f�r�ndringarna beaktas ocks� i
% under programmen.
% - Autotip_XP_marg.m
% - Autotip_tiputantop.m
% - Autotip_tipplot.m
% - Autotip_bilaga9
% - Autotip_bilaga8
% - Autotip_bilaga7
% - Autotip_bilaga6
% - Autotip_bilaga5
% - Autotip_bilaga9_F3
% - Autotip_bilaga8_F3
% - Autotip_bilaga7_F3
% - Autotip_bilaga6_F3
% - Autotip_bilaga5_F3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Autotip_XP_OpeningFcn, ...
                   'gui_OutputFcn',  @Autotip_XP_OutputFcn, ...
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


% --- Executes just before Autotip_XP is made visible.
function Autotip_XP_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for Autotip_XP
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initierar variablen block
block=12;
handles.block = block;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Autotip_XP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Autotip_XP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in F1/F2.
% �ndrar aktuellt block till F1/F2 samtidigt
% som datumrutan aktiveras.
function radiobutton1_Callback(hObject, eventdata, handles)
set(handles.radiobutton2,'Value',0)
block=handles.block;
block=12;
handles.block = block;
guidata(hObject, handles);
set(handles.edit1,'Enable','on')


% --- Executes on button press in F3.
% �ndrar aktuellt block till F3 samtidigt
% som datumrutan aktiveras.
function radiobutton2_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Value',0)
block=handles.block;
block=3;
handles.block = block;
guidata(hObject, handles);
set(handles.edit1,'Enable','on')

% --- Executes on change of text in YYMMDD
% N�r ett datum finns inskrivet aktiveras k�r knappen.
% Blockan blir nu inte m�jliga att �ndra.
function edit1_Callback(hObject, eventdata, handles)
set(handles.pushbutton1,'Enable','on')
set(handles.radiobutton1,'Enable','off')
set(handles.radiobutton2,'Enable','off')


% --- Executes on button press in Utskrift
% Om man kryssar i knappen f�r extra utskrift
% �ndras checkbox2.s Value till 1 st�r normalt i 0
% Tas den bort blir v�rdet 0 igen.
function checkbox2_Callback(hObject, eventdata, handles)


% --- Executes on button press in UTF�R
% Datumet och om extra utskrift ska g�ras l�ses in.
% D�refter genereras alla bilagor.
% Du f�r en fr�ga om du vill ber�kna CPR och LHGR
function pushbutton1_Callback(hObject, eventdata, handles)
datum=get(handles.edit1,'String');
Utskrift=get(handles.checkbox2,'Value');
set(handles.edit1,'Enable','off')
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton3,'Enable','off')
block=handles.block;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BEGIN F1 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
try
if block==12
    datum=num2str(datum);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % D� varje bilaga �r "unik" m�ste det
    % finnas ett program per bilaga. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tipb134='tip-';
    tipup5='Autotip_bilaga5 tip-';
    tipb6='Autotip_bilaga6 tip-';
    tipup7='Autotip_bilaga7 tip-';
    tipup_7=' tip-';
    tipb8='Autotip_bilaga8 tip-';
    tipb9='Autotip_bilaga9 tip-';
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % �ndelser p� indatafilerna
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tipup='-updat.dat';
    tipb='-base.dat';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Autogenerering av bilaga 1,3,4
    % Modifierad version av tip_utan_top7.m
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    basefil=[tipb134 datum tipb];
    Autotip_tiputantop(basefil);
    
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sammans�ttning av "r�tt" str�ng
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tipupdatb5=[tipup5 datum tipup];
    tipbasb6=[tipb6 datum tipb];
    tipupdatb7=[tipup7 datum tipb tipup_7 datum tipup];
    tipbasb8=[tipb8 datum tipb];
    tipbasb9=[tipb9 datum tipb];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Exikvering av bilageprogrammen
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    unix(tipupdatb5);
    unix(tipbasb6);
    unix(tipupdatb7);
    unix(tipbasb8);
    unix(tipbasb9);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Redigering av bilagornas utskriftformat.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bilaga5=fopen('bilaga5.txt','r+');
    bilaga=fopen('Autotip_XP_b5.txt','w+');

    for b=1:41
	    if b==4
	    blank=fgets(bilaga5);
	    elseif b==8
	    fgets(bilaga5);
	    elseif b==12
	    fgets(bilaga5);
	    else
	    rad=fgets(bilaga5);
	    fprintf(bilaga,'%s',rad);
	    end
    end

    bilaga6=fopen('bilaga6.txt','r+');
    bilaga=fopen('Autotip_XP_b6.txt','w+');

    for b=1:41
	    if b==4
    	blank=fgets(bilaga6);
	    elseif b==8
	    fgets(bilaga6);
	    elseif b==12
	    fgets(bilaga6);
	    else
	    rad=fgets(bilaga6);
	    fprintf(bilaga,'%s',rad);
	    end
    end

    bilaga8=fopen('bilaga8.txt','r+');
    bilaga=fopen('Autotip_XP_b8.txt','w+');

    for b=1:41
	    if b==4
	    blank=fgets(bilaga8);
	    elseif b==8
	    fgets(bilaga8);
	    elseif b==12
	    fgets(bilaga8);
	    else
	    rad=fgets(bilaga8);
	    fprintf(bilaga,'%s',rad);
	    end
    end

    
% Utskrift f�r poldiff, �ndrat av Cecilia 061205    
    bilaga7=fopen('bilaga7.txt','r+');
    bilaga=fopen('Autotip_XP_b7.txt','w+');

    for b=1:85
	    if b==5
	    blank=fgets(bilaga7);
	    elseif b==6 | b==9 | b==13 | b==15 | b==31 | b==52 | b==70
            fgets(bilaga7);
        else
	    rad=fgets(bilaga7);
	    fprintf(bilaga,'%s',rad);
	    end
    end
    
    
% Utskrift f�r polut
%    bilaga7=fopen('bilaga7.txt','r+');
%    bilaga=fopen('Autotip_XP_b7.txt','w+');

%    for b=1:84
%	    if b==4 | b==8 | b==9 | b==11 | b==28 | b==48 | b==49 | ...
%                 b==51 | b==68            
%	    fgets(bilaga7);
%	    else
%	    rad=fgets(bilaga7);
%	    fprintf(bilaga,'%s',rad);
%	    end
%    end

    bilaga9=fopen('bilaga9.txt','r+');
    bilaga=fopen('Autotip_XP_b9.txt','w+');

%    for b=1:87
%	    if b==4 | b==8 | b==12 | b==14 | b==31  | b==5 | b==15 | b==47 | b==51 | b==52 | b==54 | b==55 | b==71 | b==87 
%	    fgets(bilaga9);
%	    else
%	    rad=fgets(bilaga9);
%	    fprintf(bilaga,'%s',rad);
%	    end
%    end
    for b=1:88
	    if b==4 | b==5 | b==7 | b==8 | b==13 | b==15 | b==16 | b==32 | b==48 | b==52 | b==53 | b==55 | b==56 | b==72 | b==88 
	    fgets(bilaga9);
	    else
	    rad=fgets(bilaga9);
	    fprintf(bilaga,'%s',rad);
	    end
    end
    fclose('all');	
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Autogenerering av marginaler
    % Modifierad version av autotip.m
    % Sparar informationen p� Autotip_XP.lis
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    calculate=questdlg('Vill du ber�kna de s�msta marginalerna f�r LHGR- och CPR-v�rden efter kalibrering?','Ber�kning av LHGR och CPR marginaler');
    langden=length(calculate);
       
    if langden == 3
        promptlhgr{1}='Ange I positionen f�r patron med s�mst LHGR:';
        promptlhgr{2}='Ange J positionen f�r patron med s�mst LHGR:';
        promptlhgr{3}='Ange K positionen f�r patron med s�mst LHGR:';
        titlelhgr='Ber�kning av s�msta marginaler LHGR';
        default_lhgr={'17','5','4'};
        answerlhgr=inputdlg(promptlhgr,titlelhgr,1,default_lhgr);
        temp1=str2num(char(answerlhgr));
        onlposlhgr=temp1';
        promptcpr{1}='Ange I positionen f�r patron med s�mst CPR:';
        promptcpr{2}='Ange J positionen f�r patron med s�mst CPR:';
        promptcpr{3}='Ange K positionen f�r patron med s�mst CPR:';
        titlecpr='Ber�kning av s�msta marginal CPR';
        default_cpr={'20','16','23'};
        answercpr=inputdlg(promptcpr,titlecpr,1,default_cpr);
        temp2=str2num(char(answercpr));
        onlposcpr=temp2';
        updatfil=[tipb134 datum tipup];
        Autotip_XP_marg(basefil,updatfil,onlposcpr,onlposlhgr);
    end    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Flyttning, utskrifter och bortagning av bilagor.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Utskrift==1
        promptS{1}='Ange skrivare:';
        titleS='Autotip_XP utskrifter';
        default_S={'f1xerox5'};
        answerS=inputdlg(promptS,titleS,1,default_S);
        skrivare=char(answerS);
        temp_utskrifter1='tip*.ps';
        temp_utskrifter2='bilaga*.txt'; 
        utskrifter1=['lpr' ' ' '-P' skrivare ' ' temp_utskrifter1]; % Testar olika utskrift s�tt.
        utskrifter2=['!haspf.l bilaga5.txt' ' ' skrivare];
        utskrifter3=['!haspf.l bilaga6.txt' ' ' skrivare];
        utskrifter4=['!haspf.l bilaga7.txt' ' ' skrivare];
        utskrifter5=['!haspf.l bilaga8.txt' ' ' skrivare];
        utskrifter6=['!haspf.l bilaga9.txt' ' ' skrivare];
        unix(utskrifter1);
        eval(utskrifter2);
        eval(utskrifter3);
        eval(utskrifter4);
        eval(utskrifter5);
        eval(utskrifter6);
        if langden == 3 % G�rs endast om CPR och LHGR marginalerna ber�knats.
        temp_utskrifter7='Autotip_XP.lis'; 
        utskrifter7=['lpr' ' ' '-P' skrivare ' ' temp_utskrifter7];
        unix(utskrifter7);    
        end
    end    
    pathname=uigetdir('~/','Autotip_XP Spara bilagorna i katalog');
    temp_flytta1='mv Autotip_XP_b*.txt';
    temp_flytta2='mv bilaga*.eps';
    flytta1=[temp_flytta1 ' ' pathname];
    flytta2=[temp_flytta2 ' ' pathname];
    unix(flytta1);
    unix(flytta2);
    if langden == 3 % G�rs endast om CPR och LHGR marginalerna ber�knats.
    temp_flytta3='mv Autotip_XP.lis';
    flytta3=[temp_flytta3 ' ' pathname];
    unix(flytta3);
    end
    unix('rm bilaga*.txt');
    unix('rm tip*.ps');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % END F1/F2
    % BEGIN F3 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif block==3 
            datum=num2str(datum);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % D� varje bilaga �r "unik" m�ste det
    % finnas ett program per bilaga. 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tipb134='tip-';
    tipb5='Autotip_bilaga5_F3 tip-';
    tipup5=' tip-';
    tipup6='Autotip_bilaga6_F3 tip-';
    tipb7='Autotip_bilaga7_F3 tip-';
    tipup8='Autotip_bilaga8_F3 tip-';
    tipb9='Autotip_bilaga9_F3 tip-';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % �ndelser p� indatafilerna
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tipup='-updat.dat';
    tipb='-base.dat';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Autogenerering av bilaga 1,3,4
    % Modifierad version av tipplot.m
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    basefil=[tipb134 datum tipb];
    Autotip_tipplot(basefil);
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Samman s�ttning av "r�tt" str�ng
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tipbilaga5_F3=[tipb5 datum tipb tipup5 datum tipup];
    tipbilaga6_F3=[tipup6 datum tipup];
    tipbilaga7_F3=[tipb7 datum tipb];
    tipbilaga8_F3=[tipup8 datum tipup];
    tipbilaga9_F3=[tipb9 datum tipb];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Exikvering av bilageprogramen
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    unix(tipbilaga5_F3);
    unix(tipbilaga6_F3);
    unix(tipbilaga7_F3);
    unix(tipbilaga8_F3);
    unix(tipbilaga9_F3);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Redigering av bilagornas utskriftformat.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bilaga5=fopen('bilaga5.txt','r+');
    bilaga=fopen('Autotip_XP_b5_F3.txt','w+');

    for b=1:85
	    if b==5
	    blank=fgets(bilaga5);
	    elseif b==6 | b==9 | b==13 | b==15 | b==31 | b==52 | b==70
            fgets(bilaga5);
        else
	    rad=fgets(bilaga5);
	    fprintf(bilaga,'%s',rad);
	    end
    end

    bilaga6=fopen('bilaga6.txt','r+');
    bilaga=fopen('Autotip_XP_b6_F3.txt','w+');

    for b=1:41
	    if b==4
    	blank=fgets(bilaga6);
	    elseif b==8 | b==12
	    fgets(bilaga6);
	    else
	    rad=fgets(bilaga6);
	    fprintf(bilaga,'%s',rad);
	    end
    end

    bilaga7=fopen('bilaga7.txt','r+');
    bilaga=fopen('Autotip_XP_b7_F3.txt','w+');

    for b=1:41
	    if b==4 | b==8 | b==12
            fgets(bilaga7);
	    else
	    rad=fgets(bilaga7);
	    fprintf(bilaga,'%s',rad);
	    end
    end
    
    bilaga8=fopen('bilaga8.txt','r+');
    bilaga=fopen('Autotip_XP_b8_F3.txt','w+');

    for b=1:84
	    if b==4 | b==51 | b==68
	    fgets(bilaga8);
	    elseif b>=8 & b<=49
	    fgets(bilaga8);
	    else
	    rad=fgets(bilaga8);
	    fprintf(bilaga,'%s',rad);
	    end
    end

  
    bilaga9=fopen('bilaga9.txt','r+');
    bilaga=fopen('Autotip_XP_b9_F3.txt','w+');
    for b=1:128
	    if b==4 | b==45 | b==48 | b==49 | b==54 | b==56 | b==57 | b==73 | b==89 | b==93| b==96 | b==97 | b==113
	    fgets(bilaga9);
	    else
	    rad=fgets(bilaga9);
	    fprintf(bilaga,'%s',rad);
	    end
    end
    fclose('all');	
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Autogenerering av marginaler
    % Modifierad version av autotip.m
    % Sparar informationen p� Autotip_XP.lis
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    calculate=questdlg('Vill du ber�kna de s�msta marginalerna f�r LHGR- och CPR-v�rden efter kalibrering?','Ber�kning av LHGR och CPR marginaler');
    langden=length(calculate);
       
    if langden == 3
        warndlg('CPR och LHGR �r �nnu inte implementerad f�r F3. Du m�ste tyv�rr k�ra den manuellt. /Janne','Autotip_XP f�r F3','modal')
        %promptlhgr{1}='Ange I positionen f�r patron med s�mst LHGR:';
        %promptlhgr{2}='Ange J positionen f�r patron med s�mst LHGR:';
        %promptlhgr{3}='Ange K positionen f�r patron med s�mst LHGR:';
        %titlelhgr='Ber�kning av s�msta marginaler LHGR';
        %default_lhgr={'17','5','4'};
        %answerlhgr=inputdlg(promptlhgr,titlelhgr,1,default_lhgr);
        %temp1=str2num(char(answerlhgr));
        %onlposlhgr=temp1';
        %promptcpr{1}='Ange I positionen f�r patron med s�mst CPR:';
        %promptcpr{2}='Ange J positionen f�r patron med s�mst CPR:';
        %promptcpr{3}='Ange K positionen f�r patron med s�mst CPR:';
        %titlecpr='Ber�kning av s�msta marginal CPR';
        %default_cpr={'20','16','23'};
        %answercpr=inputdlg(promptcpr,titlecpr,1,default_cpr);
        %temp2=str2num(char(answercpr));
        %onlposcpr=temp2';
        %updatfil=[tipb134 datum tipup];
        %Autotip_XP_marg(basefil,updatfil,onlposcpr,onlposlhgr);
    end    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Flyttning, utskrifter och bortagning av bilagor.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if Utskrift==1
        promptS{1}='Ange skrivare:';
        titleS='Autotip_XP utskrifter';
        default_S={'f1xerox5'};
        answerS=inputdlg(promptS,titleS,1,default_S);
        skrivare=char(answerS);
        temp_utskrifter1='tip*.ps';
        utskrifter1=['lpr' ' ' '-P' skrivare ' ' temp_utskrifter1]; % Testar olika utskrift s�tt.
        utskrifter2=['!haspf.l bilaga5.txt' ' ' skrivare];
        utskrifter3=['!haspf.l bilaga6.txt' ' ' skrivare];
        utskrifter4=['!haspf.l bilaga7.txt' ' ' skrivare];
        utskrifter5=['!haspf.l bilaga8.txt' ' ' skrivare];
        utskrifter6=['!haspf.l bilaga9.txt' ' ' skrivare];
        unix(utskrifter1);
        eval(utskrifter2);
        eval(utskrifter3);
        eval(utskrifter4);
        eval(utskrifter5);
        eval(utskrifter6);
        if langden == 3 % G�rs endast om CPR och LHGR marginalerna ber�knats.
            %temp_utskrifter7='Autotip_XP.lis'; 
            %utskrifter7=['lpr' ' ' '-P' skrivare ' ' temp_utskrifter7];
            %unix(utskrifter7);    
        end
    end    
    pathname=uigetdir('~/','Autotip_XP Spara bilagorna i katalog');
    temp_flytta1='mv Autotip_XP_b*.txt';
    temp_flytta2='mv bilaga*.eps';
    flytta1=[temp_flytta1 ' ' pathname];
    flytta2=[temp_flytta2 ' ' pathname];
    unix(flytta1);
    unix(flytta2);
    if langden == 3 % G�rs endast om CPR och LHGR marginalerna ber�knats.
        %temp_flytta3='mv Autotip_XP.lis';
        %flytta3=[temp_flytta3 ' ' pathname];
        %unix(flytta3);
    end
    unix('rm bilaga*.txt');
    unix('rm tip*.ps');        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % END F3 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
catch
    errordlg('Autotip_XP st�tte p� ett problem.                                                                              Troliga fel kan vara:                                                            - Du st�r inte i ett /cm/.. tr�d.                                                                 - Det angivna datumet finns inte.                                                             - Du har valt fel block.','Fel meddelande Autotip_XP','Autotip_XP problem...')
end
handles.block = block;
handles.Utskrift = Utskrift;
guidata(hObject, handles);
set(handles.pushbutton2,'Enable','on')
set(handles.pushbutton3,'Enable','on')


% --- Executes on button press in NYRAPPORT
% �terst�ller guit till ursprungligt skick.
function pushbutton2_Callback(hObject, eventdata, handles)
set(handles.radiobutton1,'Value',0)
set(handles.radiobutton2,'Value',0)
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton1,'Enable','off')
set(handles.radiobutton1,'Enable','on')
set(handles.radiobutton2,'Enable','on')
set(handles.checkbox2,'Value',0)

% --- Executes on button press in Avsluta.
% Avslutar guit och st�nger alla f�nster.
function pushbutton3_Callback(hObject, eventdata, handles)
close all

% --------------------------------------------------------------------
% Initierar en "File meny"
% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selecting Avsluta from the File menyn.
% --------------------------------------------------------------------
function Avsluta_Callback(hObject, eventdata, handles)
close all

% --- Executes when selecting Om Autotip_XP from the Hj�lp menyn.
% --------------------------------------------------------------------
function Om_1_Callback(hObject, eventdata, handles)
Om_text={'                                     Autotip_XP',' ',' - Autotip_XP generera bilagor till Tiprapporten. Den hittar ocks� s�msta marginalerna f�r LHGR och CPR. Dessa sparas p� filen Autotip_XP.lis.',' ',' - Ingen kopiering eller vidarespridning av Autotip_XP v2.0 f�r ske utan','             Forsmarks Kraftgrupp AB:s skriftliga godk�nnande.', ' ','         � Forsmarks Kraftgrupp AB, 2004, All rights reserved'};
helpdlg(Om_text,'Om Autotip_XP');

% --------------------------------------------------------------------
% Initierar en "Hj�lp meny"
% --------------------------------------------------------------------
function Hjalp_1_Callback(hObject, eventdata, handles)


% --- Executes when selecting Instruktion from the Hj�lp meny.
% --------------------------------------------------------------------
function Instruktion_1_Callback(hObject, eventdata, handles)
Instr_text={' ','ALLM�NT:',' - Autotip_XP generera bilagorna till Tiprapporten. Programmet anv�nder sig av POLUT, POLDIFF och modifierade versioner av tip_utan_top (F1/F2), tiptop (F3) och autotip.m. Den genererar och sparar utskrifterna p� ett format anpassat f�r Word.',' ','ANV�NDNING:',' - Programmet m�ste k�ras fr�n r�tt dist katalog p� cm-tr�det. Den enda parameter som beh�ver anges �r tipk�rningens datum. Datumet ges p� formatet YYMMDD. Bilagorna sparas p� den katalog som anges, vanligen hemkatalogen. D�rifr�n kopieras bilagorna manuellt till PC-milj�n och katalogen ../FX/Autotip.',' ','CPR och LHGR ber�kning:','Om man s� �nskar utf�r Autotip_XP en ber�kning av de s�msta marginalerna f�r LHGR och CPR. Ska s�msta LHGR och CPR ber�knas m�ste respektive patronposition och nod anges. D� genereras, f�rrutom bilagorna, ocks� en fil med de s�msta marginalerna f�r LHGR och CPR. Filer heter Autotip_XP.lis.',' ','�VRIGT:',' - Om du har fr�gor om programmet kontakta d� i f�rsta hand:',' ',' Jan Karjalainen, FTB'};
helpdlg(Instr_text,'Autotip_XP instruktion');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLUT P� PROGRAMMET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

