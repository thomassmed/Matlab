function resinfo=AnalyzeRes(restart_file)
% read_restart_bin  Reads from binary restart file
%
% [fue_new,Oper,Title,Parameters,Dimensions,Derived_Terms,Fuel_Data,Grid,Segment,Core]=read_restart_bin(restart_file,XPO)
% [limits,Xpo,Titles]=read_restart_bin(filename,-1); 
%
% Input
%   restart_file - restart file name (.res)
%   XPO - exposure point, 10000 is first, 20000 is last, -1 gives file overview
%   limits(1),limits(2) - reads between specified limits
%   
% Output
%   fue_new     - Structured variable with history data (burnup, vhist, crdhist, etc
%   oper        - Structured variable with operating data (power, flow, tinlet etc)
%   Title       - Cell array with contents of label 'TITLE' in restart file
%   Parameters  - Cell array with contents of label 'PARAMETERS' in restart file
%   Dimensions  - Cell array with contents of label 'DIMENSIONS' in restart file
%   Derived_Terms - Cell array with contents of label 'DERIVED TERMS' in restart file
%   Fuel_Data   - Cell array with contents of label 'FUEL' in restart file
%   Grid        - Cell array with contents of label 'GRID' in restart file
%   Segment     - Cell array with contents of label 'SEGMENT' in restart file
%   Core        - Cell array with contents of label 'CORE' in restart file
%
% Example:
%
% [fue_new,Oper]=read_restart_bin('s3.res');
% [fue_new,Oper,Title,Parameters,Dimensions,Derived_Terms,Fuel_Data,...
% Grid,Segment,Core]=read_restart_bin('s3-case-1.res');
% To read the second state point:
% [limits,Xpo,Titles]=read_restart_bin('s3.res',-1); 
% [fue_new,Oper]=read_restart_bin('s3.res',limits(2),limits(3));
%
% See also cmsplot, reads3_out, read_simfile

%
%[fue_new,Oper,[varargout]}=read_restart_bin(filename,'Iteration','DerivedTerms',...
%TODO: More systematic move around based on all the dimensional variables in Parameters!
%TODO: Save memory: put integers in integer type etc (maybe not, it's less convenient)


%% Open the file
[fid,msg]=fopen(restart_file,'r','ieee-be');
if fid<=0,
    error([msg,': ',restart_file]);
end
testa=fread(fid,1,'int');
if testa>1e6,
    fclose(fid);
    [fid,msg]=fopen(restart_file,'r','ieee-le');
end
% Determine the size of real and integers in a platform-independent manner
% simply by reading and see how far the file pointer moves ahead
fseek(fid,0,-1);fread(fid,1,'int');i_int=ftell(fid);
fseek(fid,0,-1);fread(fid,1,'float');ifloat=ftell(fid);
%% If two input arguments are give, the second is the desired exposurepoint
fseek(fid,0,1);
neof=ftell(fid);
fseek(fid,0,-1);
nstart=0;nstop=neof;
%%
label='PARAMETERS    ';
llab=length(label);
%% Parameters
clear FORMAT nr
FORMAT=cell(3,4);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=-1;  FORMAT{1,2}='int';   nr{1,2}=91; FORMAT{1,3}='int'; nr{1,3}=1; FORMAT{1,4}='int'; nr{1,4}=-1;
                                FORMAT{2,2}='float'; nr{2,2}=1;
                                FORMAT{3,2}='int';   nr{3,2}=-1;
next_record=get_next_record(fid,'PARAMETERS',1000,FORMAT,nr,nstart,nstop);
Parameters=next_record.data;
Lab=cell(1000,1);Adr=nan(1000,1);
ico=1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
LMPAR=double(Parameters{1,1});
limaclo=LMPAR(1);   limc=LMPAR(2);      limseg=LMPAR(3);    limhyd=LMPAR(4);    limid=LMPAR(5);     limfue=LMPAR(16);
limnht=LMPAR(17);   limpas=LMPAR(18);   limray=LMPAR(19);   limreg=LMPAR(20);   limtfu=LMPAR(22);   limzon=LMPAR(23);   lmnhyd=LMPAR(24);
LMPAR2=double(Parameters{1,2});
limnd=LMPAR2(1);    limctp=LMPAR2(2);   limspa=LMPAR2(3);   limtab=LMPAR2(4);   limtv1=LMPAR2(5);   limtv2=LMPAR2(6);   limele=LMPAR2(7);
limcrd=LMPAR2(8);   lcrzon=LMPAR2(9);   limch1=LMPAR2(29);  limzmd=LMPAR2(30);  limlkg=LMPAR2(33);  limwtr=LMPAR2(35);  limsup=LMPAR2(36);
limir=LMPAR2(58);   limct=LMPAR2(65);   nsegch=LMPAR2(91);
limbat=Parameters{1,3};
lngng=Parameters{1,4}(1); lnstp=Parameters{1,4}(2); lngngstp=Parameters{1,4}(3);  lnrestp=Parameters{1,4}(4);
%% Title 
clear FORMAT nr
FORMAT=cell(2,3);nr=FORMAT;
FORMAT{1,1}='*char';   FORMAT{1,2}='*char';   FORMAT{1,3}='float'; nr{1,3}=3;
                                            FORMAT{2,3}='int=>int';
next_record=get_next_record(fid,'TITLE',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Title=next_record.data;
%% Dimensions
clear FORMAT nr
FORMAT=cell(2,4);nr=FORMAT;
FORMAT{1,1}='*char'; nr{1,1}=3;   FORMAT{1,2}='int=>int'; nr{1,2}=12;   FORMAT{1,3}='*char';     FORMAT{1,4}='int=>int'; nr{1,4}=-1; 
FORMAT{2,1}='int=>int'; nr{2,1}=4;                                      
next_record=get_next_record(fid,'DIMENSIONS',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Dimensions=next_record.data;
lwr=char(Dimensions{1,1});
iafull=double(Dimensions{2,1}(1));
irmx=double(Dimensions{2,1}(2));
ilmx=double(Dimensions{2,1}(3));
iofset=double(Dimensions{2,1}(4));
ihaveu=double(Dimensions{1,2}(1));
if2x2=double(Dimensions{1,2}(3));
kmax=double(Dimensions{1,2}(2));
isymc=double(Dimensions{1,2}(6));
ida=double(Dimensions{1,2}(7));
jda=double(Dimensions{1,2}(8));
id=double(Dimensions{1,2}(9));
jd=double(Dimensions{1,2}(10));
kd=double(Dimensions{1,2}(11));
nrefa=double(Dimensions{1,2}(12));
%% Derived Terms
clear FORMAT nr
FORMAT=cell(2,3);nr=FORMAT;
FORMAT{1,1}='double';               FORMAT{1,2}='float';  nr{1,2}=6;    FORMAT{1,3}='float'; nr{1,3}=-1;
FORMAT{2,1}='float'; nr{2,1}=5;     FORMAT{2,2}='int=>int';    nr{2,2}=5;
next_record=get_next_record(fid,'DERIVED TERMS',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Derived_Terms=next_record.data;
kan=round(Derived_Terms{1,2}(6));
%% Bpshuffle
clear FORMAT nr
FORMAT=cell(1,5);nr=FORMAT;
FORMAT{1,1}='int';nr{1,1}=-1;FORMAT{1,2}='*char';nr{1,2}=-1;FORMAT{1,3}='float';nr{1,3}=-1;FORMAT{1,4}='*char';nr{1,4}=-1;
FORMAT{1,5}='*char';nr{1,5}=-1;
search_str='BPSHUFFLE         ';
next_record=get_next_record(fid,search_str,10000,FORMAT,nr,nstart,nstop);
%%


%% Core
clear FORMAT nr
FORMAT=cell(1,5);nr=FORMAT;
FORMAT{1,1}='float'; nr{1,1}=26;       FORMAT{1,2}='int=>int'; nr{1,2}=5;    FORMAT{1,3}='float'; nr{1,3}=1;
FORMAT{1,4}='int=>int'; nr{1,4}=2;          FORMAT{1,5}='float'; nr{1,5}=1;
search_str=['CORE                ',0];
next_record=get_next_record(fid,search_str,10000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Core=next_record.data;
dxassm=Core{1,1}(1);
hcore=Core{1,1}(2);
powden=Core{1,1}(3);
floden=Core{1,1}(4)/3600;    % Convert to /s from /h
perctp=Core{1,1}(5);
percwt=Core{1,1}(6);
pr1=Core{1,1}(7);
pr2=Core{1,1}(8);
pr3=Core{1,1}(9);
poi=Core{1,1}(10);
hinlet=Core{1,1}(11);
delho=Core{1,1}(12);
ebsq=Core{1,1}(13);
bsq=Core{1,1}(14);
nebsq=Core{1,1}(15);
alphax=Core{1,1}(16);
alphaz=Core{1,1}(17);
ctptot=Core{1,1}(18);
cwttot=Core{1,1}(19);
tinlet=Core{1,1}(20);
subcol=Core{1,1}(21);
ctprat=Core{1,1}(22);
cwtrat=Core{1,1}(23);
fgamma=Core{1,1}(24);
fchtmp=Core{1,1}(25);
%% Custom
clear FORMAT nr
FORMAT=cell(1,3);nr=FORMAT;
FORMAT{1,1}='*char'; nr{1,1}=16;        FORMAT{1,2}='int=>int'; nr{1,2}=1;    FORMAT{1,3}='*char'; nr{1,3}=400;
next_record=get_next_record(fid,'CUSTOM',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Custom=next_record.data;
%% Iteration
clear FORMAT nr
FORMAT=cell(2,6);nr=FORMAT;
FORMAT{1,1}='int=>int'; nr{1,1}=3;           FORMAT{1,2}='int=>int'; nr{1,2}=8;       FORMAT{1,3}='double'; nr{1,3}=2;
                                                                            FORMAT{2,3}='float';  nr{2,3}=4;
FORMAT{1,4}='float';  nr{1,4}=5;        FORMAT{1,5}='int=>int';  nr{1,5}=8;      FORMAT{1,6}='int=>int';    nr{1,6}=1;
next_record=get_next_record(fid,'ITERATION',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Iteration=next_record.data;
%% Depletion
clear FORMAT nr
FORMAT=cell(3,3);nr=FORMAT;
FORMAT{1,1}='float'; nr{1,1}=5;    FORMAT{1,2}='float'; nr{1,2}=1;       FORMAT{1,3}='int=>int';  nr{1,3}=1;
FORMAT{2,1}='int=>int'; nr{2,1}=1;
FORMAT{3,1}='float'; nr{3,1}=3;
next_record=get_next_record(fid,'DEPLETION',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Depletion=next_record.data;
%% SDC-Data
clear FORMAT nr
FORMAT=cell(2,5);nr=FORMAT;
FORMAT{1,1}='float'; nr{1,1}=3; FORMAT{1,2}='int=>int'; nr{1,2}=-1;   FORMAT{1,3}='float'; nr{1,3}=1; 
FORMAT{2,1}='int=>int'; nr{2,1}=-1;                                           FORMAT{1,4}='*char'; FORMAT{1,5}='*char';
next_record=get_next_record(fid,'SDCDATA',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
SDC_Data=next_record.data;
%% Fuel
%TODO: first read limspa as the first record, then read the other ones (more stable)
clear FORMAT nr
FORMAT=cell(6,3);nr=FORMAT;
FORMAT{1,1}='int=>int';  FORMAT{1,2}='int=>int';   nr{1,2}=limzon*limfue;    FORMAT{1,3}='int';  nr{1,3}=limfue;
nr{1,1}=1;          FORMAT{2,2}='float'; nr{2,2}=(limzon+1)*limfue;  FORMAT{2,3}='*char'; nr{2,3}=limfue*20;
                    FORMAT{3,2}='int=>int';   nr{3,2}=limreg*limfue;
                    FORMAT{4,2}='float'; nr{4,2}=limreg*limfue;
                    FORMAT{5,2}='int=>int';   nr{5,2}=3*limfue;
                    FORMAT{6,2}='float'; nr{6,2}=-1;                    
 %                   FORMAT{6,2}='float'; nr{6,2}=limspa*lmnhyd;
                    
next_record=get_next_record(fid,'FUEL              ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Fuel_Data=next_record.data;
Nzon=reshape(Fuel_Data{1,2}',limzon,limfue);
Zzon=reshape(Fuel_Data{2,2}',limzon+1,limfue);
nregin=Fuel_Data{3,2};
ifassm=Fuel_Data{5,2}(1:limfue);
kmnf=Fuel_Data{5,2}(limfue+1:2*limfue);
kmxf=Fuel_Data{5,2}(2*limfue+1:3*limfue);
zspacr=Fuel_Data{6,2};
zspacr=reshape(zspacr,limspa,lmnhyd)';
zspacr=rensa(zspacr,0);
nhyd=Fuel_Data{1,3};
asmnam=reshape(Fuel_Data{2,3},20,limfue)';
%% Grid
clear FORMAT nr
FORMAT=cell(2,5);nr=FORMAT;
FORMAT{1,1}='int=>int'; nr{1,1}=3;   FORMAT{1,2}='float'; nr{1,2}=4; FORMAT{1,3}='*char'; nr{1,3}=-1; 
    FORMAT{1,4}='int=>int'; nr{1,4}=20;     FORMAT{1,5}='*char'; nr{1,5}=-1;
    FORMAT{2,4}='float'; nr{2,4}=776;   
next_record=get_next_record(fid,'GRID                ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Grid=next_record.data;
%% Segment
clear FORMAT nr
FORMAT=cell(5,5);nr=FORMAT;
nr{1,1}=limseg*nsegch;
FORMAT{1,1}='*char';            FORMAT{1,2}='int=>int'; nr{1,2}=-1;  FORMAT{1,3}='float'; nr{1,3}=9*limseg;
FORMAT{2,1}='int=>int'; nr{2,1}=limseg;                              FORMAT{2,3}='float'; nr{2,3}=8*limseg;
FORMAT{3,1}='int=>int'; nr{3,1}=limseg;
FORMAT{4,1}='int=>int'; nr{4,1}=limseg;
FORMAT{5,1}='int=>int'; nr{5,1}=limseg;
            FORMAT{1,4}='float';  nr{1,4}=-1;   FORMAT{1,5}='float';  nr{1,5}=-1;
next_record=get_next_record(fid,'SEGMENT           ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Segment=next_record.data;
segments=reshape(Segment{1,1},20,length(Segment{1,1})/20)';
heavym=Segment{1,4}(limtfu*limseg+1:(limtfu+1)*limseg);

%% Tables
% clear FORMAT nr
% FORMAT{1,1}='int=>int'; nr{1,1}=-1;  FORMAT{1,2}='float'; nr{1,2}=-1;  FORMAT{1,3}='int=>int'; nr{1,3}=-1;
%         FORMAT{1,4}='int=>int'; nr{1,4}=-1;        FORMAT{1,5}='float'; nr{1,5}=-1;  
% for i=6:13,        
%   FORMAT{1,i}='int=>int'; nr{1,i}=2;
%   FORMAT{2,i}='float'; nr{2,i}=-1;
% end
%                                      
% next_record=get_next_record(fid,'TABLES           ',1000,FORMAT,nr,nstart,nstop);
% Tables=next_record.data;
%% Hydraulics
clear FORMAT nr
FORMAT=cell(4,6);nr=FORMAT;
FORMAT{1,1}='float'; nr{1,1}=limc;      FORMAT{1,2}='int=>int'; nr{1,2}=2*lmnhyd;      
FORMAT{2,1}='float'; nr{2,1}=limhyd;    FORMAT{2,2}='float'; nr{2,2}=13*lmnhyd+limnht+2+limbat+limele;
                                        FORMAT{3,2}='int'; nr{3,2}=1;
                                        FORMAT{4,2}='float'; nr{4,2}=9;
       for i=3:5, FORMAT{1,i}='float=>real*4';nr{1,i}=1;end;    FORMAT{1,6}='int'; nr{1,6}=1;
                                                                FORMAT{2,6}='float'; nr{2,6}=-1;

next_record=get_next_record(fid,'HYDRAULICS        ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Hydraulics=next_record.data;
fue_new.C=Hydraulics{1,1};

aht=Hydraulics{2,2}(1:lmnhyd);                  
afl=Hydraulics{2,2}(lmnhyd+1:2*lmnhyd);      
dhe=Hydraulics{2,2}(2*lmnhyd+3:3*lmnhyd+2);    
xcin=Hydraulics{2,2}(4*lmnhyd+3:(4*lmnhyd+2+limnht));
fricm=Hydraulics{2,2}(4*lmnhyd+limnht+3:(4*lmnhyd+limnht+2+limbat));
diafue=Hydraulics{2,2}(4*lmnhyd+limnht+limbat+3:(5*lmnhyd+limnht+2+limbat));
diawtr=Hydraulics{2,2}(5*lmnhyd+limnht+limbat+3:(6*lmnhyd+limnht+2+limbat));
chanel=Hydraulics{2,2}(6*lmnhyd+limnht+limbat+3:(10*lmnhyd+limnht+2+limbat));
chanel=reshape(chanel,4,lmnhyd);
elevat=Hydraulics{2,2}(10*lmnhyd+limnht+limbat+3:(10*lmnhyd+limnht+2+limbat+limele));
xkspac=Hydraulics{2,2}((10*lmnhyd+limnht+3+limbat+limele):(11*lmnhyd+limnht+2+limbat+limele));
kltp=Hydraulics{2,2}((11*lmnhyd+limnht+3+limbat+limele):(12*lmnhyd+limnht+2+limbat+limele));
kutp=Hydraulics{2,2}((12*lmnhyd+limnht+3+limbat+limele):(13*lmnhyd+limnht+2+limbat+limele));
nsepat=Hydraulics{3,2}(1);
ksepat=Hydraulics{4,2}(1);
wlorif=Hydraulics{4,2}(9);
ispacr=Hydraulics{1,6}(1);
spavoi=Hydraulics{2,6}(1);
dzflow=Hydraulics{2,6}(2);
voidpt=Hydraulics{2,6}(3);
voifac=Hydraulics{2,6}(4);
Profil=Hydraulics{2,6}(5);
%% Uniform MDT
clear FORMAT nr
FORMAT=cell(1,4);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=1;  FORMAT{1,2}='float'; nr{1,2}=lmnhyd;  FORMAT{1,3}='int'; nr{1,3}=lmnhyd; 
            FORMAT{1,4}='float'; nr{1,4}=limnht*lmnhyd;

next_record=get_next_record(fid,'UNIFORM MDT       ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
UMDT=next_record.data;
chanel5=UMDT{1,2};
if size(chanel5,2)==size(chanel,2), chanel=[chanel;chanel5]; end
nwrods=UMDT{1,3};
xxcin=UMDT{1,4};
xxcin=reshape(xxcin,limnht,lmnhyd)';
xxcin=rensa(xxcin,-10000);
%% Axial MDT
clear FORMAT nr
FORMAT=cell(1,6);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=2;  FORMAT{1,2}='float'; nr{1,2}=lmnhyd*limspa;  
for i=3:6, FORMAT{1,i}='float'; nr{1,i}=limzmd*lmnhyd; end 

next_record=get_next_record(fid,'AXIAL MDT       ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
AxMDT=next_record.data;
dimzmd=AxMDT{1,1}(1);
dimspa=AxMDT{1,1}(2);
if dimspa~=limspa||dimzmd~=limzmd,
    FORMAT{1,2}='float'; nr{1,2}=lmnhyd*dimspa;
    for i=3:6, FORMAT{1,i}='float'; nr{1,i}=dimzmd*lmnhyd; end 
    fseek(fid,-4*(lmnhyd*limspa+4*limzmd*lmnhyd)-200,0);
    next_record=get_next_record(fid,'AXIAL MDT       ',1000,FORMAT,nr,nstart,nstop);
    ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
    AxMDT=next_record.data;
end
xxkspa=reshape(AxMDT{1,2},dimspa,lmnhyd)';
aflmdt=reshape(AxMDT{1,3},dimzmd,lmnhyd)';
dhymdt=reshape(AxMDT{1,4},dimzmd,lmnhyd)';
phmdt=reshape(AxMDT{1,5},dimzmd,lmnhyd)';
zmdt=reshape(AxMDT{1,6},dimzmd,lmnhyd)';
%% CORWIJ (flow measurement in internal pumps, fix details later)
%clear FORMAT nr
%for i=1:5, FORMAT{1,i}='int'; nr{1,i}=-1; end
%
%next_record=get_next_record(fid,'CORWIJ            ',1000,FORMAT,nr,nstart,nstop);


%% Bypass Flow
clear FORMAT nr
FORMAT=cell(6,6);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=4;  FORMAT{1,2}='int';   nr{1,2}=2;  FORMAT{1,3}='float'; nr{1,3}=lmnhyd; 
                               FORMAT{2,2}='float'; nr{2,2}=2;  FORMAT{2,3}='float'; nr{2,3}=lmnhyd;
                               FORMAT{3,2}='int';   nr{3,2}=1;
                               FORMAT{4,2}='float'; nr{4,2}=1;  
                               FORMAT{5,2}='int';   nr{5,2}=1;
                               FORMAT{6,2}='float'; nr{6,2}=1;                                 
                               

FORMAT{1,4}='float'; nr{1,4}=-1; FORMAT{1,5}='int'; nr{1,5}=limwtr*lmnhyd; FORMAT{1,6}='int'; nr{1,6}=limsup;
                                 FORMAT{2,5}='float'; nr{2,5}=-1;          FORMAT{2,6}='float'; nr{2,6}=-1;


next_record=get_next_record(fid,'BYPASS FLOW       ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Bypass_flow=next_record.data;
dimlkg=Bypass_flow{1,1}(1);
dimbat=Bypass_flow{1,1}(2);
dimwtr=Bypass_flow{1,1}(3);
dimsup=Bypass_flow{1,1}(4);
%MODFLD,MAXITF,WLORIF,DPEPS,ITWIN,EPSWIN,ITLKG,EPSLKG = Bypass_flow{1,2}
ele_ltp=Bypass_flow{1,3};
ele_utp=Bypass_flow{2,3};
dinwtr=reshape(Bypass_flow{2,5}(2*dimwtr*lmnhyd+1:3*dimwtr*lmnhyd)',dimwtr,lmnhyd)'; 
% If model is 'GEN', dinwtr is actually an area!  See below in Bypass Void
dowtr=reshape(Bypass_flow{2,5}(3*dimwtr*lmnhyd+1:4*dimwtr*lmnhyd)',dimwtr,lmnhyd)'; 
% If model is 'GEN', dowtr is actually the inside wetted perimeter! See below in Bypass Void. 
kinwtr=reshape(Bypass_flow{2,5}(4*dimwtr*lmnhyd+1:5*dimwtr*lmnhyd)',dimwtr,lmnhyd)'; 
% If model is 'GEN', kinwtr will be 0. See below in Bypass Void. 
kexwtr=reshape(Bypass_flow{2,5}(5*dimwtr*lmnhyd+1:6*dimwtr*lmnhyd)',dimwtr,lmnhyd)'; 
% If model is 'GEN', kexwtr will be 0. See below in Bypass Void. 
nsup=Bypass_flow{1,6}(1:dimsup);
nsup0=find(nsup==0);nsup(nsup0)=[];
lsup=length(nsup);
casup=Bypass_flow{2,6}(1:lsup);
cbsup=Bypass_flow{2,6}(dimsup+1:dimsup+lsup);
ccsup=Bypass_flow{2,6}(2*dimsup+1:2*dimsup+lsup);
rho_ref_bypass=Bypass_flow{2,6}(3*dimsup+1:3*dimsup+lsup);
%% Bypass Void
clear FORMAT nr
FORMAT=cell(2,12);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=3;            FORMAT{1,2}='int';   nr{1,2}=-1;          FORMAT{1,3}='float'; nr{1,3}=-1; 
                                                                 
FORMAT{1,4}='float'; nr{1,4}=-1;         FORMAT{1,5}='float'; nr{1,5}=-1;          FORMAT{1,6}='*char';

FORMAT{1,7}='*char';                     FORMAT{1,8}='int'; nr{1,8}=limwtr*lmnhyd; FORMAT{1,9}='int'; nr{1,9}=limwtr*lmnhyd; 
                                         FORMAT{2,8}='float'; nr{2,8}=-1;          FORMAT{2,9}='float'; nr{2,9}=-1;

FORMAT{1,10}='int'; nr{1,10}=2;          FORMAT{1,11}='float'; nr{1,11}=-1;        FORMAT{1,12}='float'; nr{1,12}=-1;


next_record=get_next_record(fid,'BYPASS VOID       ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Bypass_void=next_record.data;
dimwtr=Bypass_void{1,1}(1);
dimrin=Bypass_void{1,1}(2);
dimrex=Bypass_void{1,1}(3);

ninwrg=Bypass_void{1,8};ninwrg=reshape(ninwrg',dimwtr,lmnhyd)';
zinwrg=Bypass_void{2,8}(1:dimwtr*dimrin*lmnhyd);
zinwrg=reshape(zinwrg',dimrin*dimwtr,lmnhyd)';
kinwrg=Bypass_void{2,8}(dimwtr*dimrin*lmnhyd+1:2*dimwtr*dimrin*lmnhyd);
kinwrg=reshape(kinwrg',dimrin*dimwtr,lmnhyd)';

nexwrg=Bypass_void{1,9};nexwrg=reshape(nexwrg',dimwtr,lmnhyd)';
zexwrg=Bypass_void{2,9}(1:dimwtr*dimrex*lmnhyd);
zexwrg=reshape(zexwrg',dimrex*dimwtr,lmnhyd)';
kexwrg=Bypass_void{2,9}(dimwtr*dimrex*lmnhyd+1:2*dimwtr*dimrex*lmnhyd);
kexwrg=reshape(kexwrg',dimrex*dimwtr,lmnhyd)';
bypass_card=reshape(Bypass_void{1,7}',8,lmnhyd)';
bypass_type=reshape(Bypass_void{1,6}',dimwtr*4,lmnhyd)';
AMDT=Bypass_void{1,3}(1:lmnhyd);
BMDT=Bypass_void{1,3}(lmnhyd+1:2*lmnhyd);
CMDT=Bypass_void{1,3}(2*lmnhyd+1:3*lmnhyd);
AWTR=reshape(Bypass_void{1,3}(3*lmnhyd+1:3*lmnhyd+lmnhyd*limwtr),limwtr,lmnhyd)';
BWTR=reshape(Bypass_void{1,3}(3*lmnhyd+lmnhyd*limwtr+1:3*lmnhyd+2*lmnhyd*limwtr),limwtr,lmnhyd)';
%%
clear FORMAT nr
FORMAT=cell(1,5);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='int'; nr{1,2}=-1;   FORMAT{1,3}='int'; nr{1,3}=-1;    FORMAT{1,4}='float'; nr{1,4}=-1;
FORMAT{1,5}='int'; nr{1,5}=-1;
next_record=get_next_record(fid,'CORWIJ        ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
corwij=next_record.data;
%%
clear FORMAT nr
FORMAT=cell(1,1);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=1;   
next_record=get_next_record(fid,'VOIDQUAL        ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
if ~isempty(next_record.data),
    modvq=next_record.data{1};
else
    modvq=[];
end
%%
clear FORMAT nr
FORMAT=cell(1,5);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='float'; nr{1,2}=-1;    FORMAT{1,3}='float'; nr{1,3}=-1;

FORMAT{1,4}='float'; nr{1,4}=-1;  FORMAT{1,5}='float'; nr{1,5}=-1;
next_record=get_next_record(fid,'EPRIMOD       ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
%%
clear FORMAT nr
FORMAT=cell(1,2);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='int'; nr{1,2}=-1;   
next_record=get_next_record(fid,'UNITS       ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
ifmeti=next_record.data{1}(1);
ifmeto=next_record.data{1}(2);
idepop=next_record.data{1}(3);
ideprm=next_record.data{2}(1);
%% HEAVY Metal
clear FORMAT nr
FORMAT=cell(1,1);nr=FORMAT;
FORMAT{1,1}='float'; nr{1,1}=iafull*iafull;
next_record=get_next_record(fid,'HEAVY METAL    ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
hvy741=reshape(next_record.data{1},iafull,iafull);
%% Fixed Maps
fseek(fid,30000,0);
clear FORMAT nr
FORMAT=cell(1,6);nr=FORMAT;
FORMAT{1,1}='float'; nr{1,1}=id*jd;
for i=[3 4 5], FORMAT{1,i}='float'; nr{1,i}=ida*jda; end
for i=[2 6], FORMAT{1,i}='int'; nr{1,i}=ida*jda; end
next_record=get_next_record(fid,'FIXED MAPS        ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
Fixed_Maps=next_record.data;
yy=reshape(Fixed_Maps{1,1},id,jd);
nht=reshape(Fixed_Maps{1,2},ida,jda);
flow=reshape(Fixed_Maps{1,3},ida,jda);
hin_c=reshape(Fixed_Maps{1,4},ida,jda);
xk=reshape(Fixed_Maps{1,5},ida,jda);
lring=reshape(Fixed_Maps{1,6},ida,jda);
%% CRD STP
clear FORMAT nr
FORMAT=cell(1,8);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=-1;   FORMAT{1,2}='*char';  FORMAT{1,3}='*char';
FORMAT{1,4}='*char';             FORMAT{1,5}='*char';  FORMAT{1,6}='*char';
FORMAT{1,7}='*char';             FORMAT{1,8}='int'; nr{1,8}=-1;%lnrestp;

next_record=get_next_record(fid,'CRD STP        ',1000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
crdstp=next_record.data;
%temp=textscan(crdstp{4},'%5s');crdid=temp{1};
crdid={};
crdgng=reshape(crdstp{5},lngng*5,lngngstp)';% gives a readable gang map
mxrods=find(all(abs(crdgng')==32),1,'first');
crdgng(mxrods:end,:)=[];
% TODO: translate it to a cell matrix
clear temp

%% Control Rod
clear FORMAT nr
FORMAT=cell(5,6);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=3; for i=2:4, FORMAT{1,i}='int'; nr{1,i}=irmx*irmx; end;    FORMAT{1,5}='float'; nr{1,5}=lcrzon*limcrd;
FORMAT{2,1}='int=>int'; nr{2,1}=limray*limpas;                                         FORMAT{2,5}='float'; nr{2,5}=2*(limct+1);
FORMAT{3,1}='int'; nr{3,1}=2;           % Note on nr{2,5}: it should not be
FORMAT{4,1}='float'; nr{4,1}=-1;         % like this, but it has to to make
                                        % it work! It should really be
                                        % nr{2,5}=2*limct; !!!
                                                                                        FORMAT{3,5}='int';   nr{3,5}=lcrzon*limcrd;
                                                                                        FORMAT{4,5}='int';   nr{4,5}=limcrd;
                                                                                        FORMAT{5,5}='*char'; nr{5,5}=-1;

FORMAT{1,6}='float'; nr{1,6}=-1;
                                                                                        
next_record=get_next_record(fid,'ROD                ',100000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
CRD_Data=next_record.data;
% notch=CRD_Data{2,1};
npfw=CRD_Data{3,1}(1);
konrod=double(reshape(CRD_Data{1,2},irmx,irmx));
iarray=double(reshape(CRD_Data{1,3},irmx,irmx));
crtyp_map=double(reshape(CRD_Data{1,4},irmx,irmx));
crdzon=reshape(CRD_Data{1,5},lcrzon,limcrd);
ncrd=reshape(CRD_Data{3,5},lcrzon,limcrd);
crd_gray=reshape(CRD_Data{1,6},lcrzon,limcrd);
NoOfCRD=find(ncrd(1,:), 1, 'last' );
crdnam=CRD_Data{5,5};
Crdnam=cellstr(reshape(crdnam,10,length(crdnam)/10)');
Crdnam=Crdnam(1:NoOfCRD);
%% Detector
%fseek(fid,50000,0);
clear FORMAT nr
FORMAT=cell(1,1);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=-1;  
next_record=get_next_record(fid,'DETECTOR  ',30000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
detloc=reshape(next_record.data{1,1},ilmx,ilmx);
%% Version 2.20 (DZSTEP)
clear FORMAT nr
FORMAT=cell(1,1);nr=FORMAT;
FORMAT{1,1}='float'; nr{1,1}=-1;      
next_record=get_next_record(fid,'VERSION 2.20    ',30000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
dzstep=next_record.data{1};
%% Version 2.40
clear FORMAT nr
FORMAT=cell(4,1);nr=FORMAT;
FORMAT{1,1}='int'; nr{1,1}=kd;      
FORMAT{2,1}='float'; nr{2,1}=kd;    
FORMAT{3,1}='int'; nr{3,1}=kd;      
FORMAT{4,1}='float'; nr{4,1}=2;    

next_record=get_next_record(fid,'VERSION 2.40    ',30000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
idetz=next_record.data{1};
ddetz=next_record.data{2};
%% Version 2.60 (cd-file name)
%fseek(fid,50000,0);
clear FORMAT nr
FORMAT=cell(2,4);nr=FORMAT;
FORMAT{1,1}='int=>int'; nr{1,1}=1;       FORMAT{1,2}='int=>int'; nr{1,2}=1;      FORMAT{1,3}='*char'; nr{1,3}=-1;
FORMAT{2,1}='*char'; nr{2,1}=-1;    %FORMAT{2,1}='*char'; nr{2,2}=-1;

FORMAT{1,4}='int';  nr{1,4}=5;
FORMAT{2,4}='float'; nr{2,4}=-1;

next_record=get_next_record(fid,'VERSION 2.60    ',30000,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
cd_file=deblank(next_record.data{1,3});
bwr_wlt_dim=next_record.data{1,4};
bwr_wlt_table=next_record.data{2,4};
if_wlt=bwr_wlt_dim(1);
limwlw=bwr_wlt_dim(2);
limwlp=bwr_wlt_dim(3);
nwlcwt=bwr_wlt_dim(4);
nwlctp=bwr_wlt_dim(5);
wlt_cwt=bwr_wlt_table(1:nwlcwt);
wlt_ctp=bwr_wlt_table(limwlw+1:limwlw+nwlctp);
bwr_wlt_table(1:(limwlw+limwlp))=[];
wlt_bypass_frac=reshape(bwr_wlt_table',limwlw,limwlp);
wlt_bypass_frac=wlt_bypass_frac(1:nwlcwt,1:nwlctp)';
%% Assembly data
rd_block_size=nstop-ftell(fid);
clear FORMAT nr
FORMAT=cell(1,1);nr=FORMAT;
FORMAT{1,1}='uchar';nr{1,1}=-1;
first_record=get_next_record(fid,'ASSEMBLY DATA       ',rd_block_size,FORMAT,nr,nstart,nstop);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
ifind=first_record.ifind;
kan=length(ifind);
fseek(fid,next_record.abs_pos,-1);
blk_size=fread(fid,1,'int');
fue_new.iaf=zeros(kan,1);
fue_new.jaf=fue_new.iaf;
fue_new.nload=fue_new.iaf;
fue_new.nfta=fue_new.iaf';
fue_new.lab=char(zeros(kan,6));
fue_new.ser=char(zeros(kan,6));
fue_new.xenon=zeros(kmax,kan);
label_record=get_next_record(fid,'ASSEMBLY LABELS   ',rd_block_size,FORMAT,nr,nstart,nstop);
blk_size1=fread(fid,1,'int');
ifind1=label_record.ifind(1:kan);
clear FORMAT nr
FORMAT=cell(4,1);nr=FORMAT;
FORMAT{1,1}='int';  nr{1,1}=3;
FORMAT{2,1}='*char'; nr{2,1}=6;
FORMAT{3,1}='*char'; nr{3,1}=6;
FORMAT{4,1}='int';   nr{4,1}=2;
for i=1:kan,
    fseek(fid,ifind(i)+blk_size+(3+6)*i_int+ifloat,-1);
    fue_new.nfta(i)=fread(fid,1,'int32');
    fue_new.ibat(i)=fread(fid,1,'int32');
%    ibatf(i)=fread(fid,1,'int32');
%    bpsa(i)=fread(fid,1,'float32');
    fseek(fid,16,0);
    fue_new.iodine(:,i)=fread(fid,kmax,'float32');
    fseek(fid,8,0);
    fue_new.xenon(:,i)=fread(fid,kmax,'float32');
    fseek(fid,8,0);
    fue_new.promethium(:,i)=fread(fid,kmax,'float32');
    fseek(fid,8,0);
    fue_new.samarium(:,i)=fread(fid,kmax,'float32');
    fseek(fid,8,0);
    fue_new.burnup(:,i)=fread(fid,kmax,'float32');
    fseek(fid,8,0);
    fue_new.vhist(:,i)=fread(fid,kmax,'float32');
    fseek(fid,8,0);    
    fue_new.crdhist(:,i)=fread(fid,kmax,'float32');
    fseek(fid,8,0);
    fue_new.tfuhist(:,i)=fread(fid,kmax,'float32');
    fseek(fid,ifind1(i)-10,-1);
    next_record=get_next_record(fid,'ASSEMBLY LABELS',100,FORMAT,nr);
    ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
    fue_new.iaf(i)=next_record.data{1}(2);
    fue_new.jaf(i)=next_record.data{1}(3);
    fue_new.lab(i,:)=next_record.data{2};
    fue_new.ser(i,:)=next_record.data{3};
    fue_new.nload(i)=next_record.data{4}(1);
    fue_new.nfra(i)=next_record.data{4}(2);
end
%% find mminj that is needed in the next section
[mminj,sym,knum,ia,ja]=ij2mminj(fue_new.iaf,fue_new.jaf,fue_new.nload);
kkan=sum(length(mminj)-2*(mminj-1));
%%
clear FORMAT nr 
FORMAT=cell(1,kmax+2);nr=FORMAT;
id=double(Dimensions{1,2}(9));
jd=double(Dimensions{1,2}(10));

for i=1:kmax+2,
  FORMAT{1,i}='float'; nr{1,i}=id*jd;
end

next_record=get_next_record(fid,'3D NODAL RPF    ',1000,FORMAT,nr);
ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;

%TODO: fix the other symmetries
switch sym
    case 'FULL'
        power=NaN(kmax,kkan);
        for i=2:kmax+1,
            plan=next_record.data{i};
            plan=reshape(plan,id,jd);
            plan(:,jd)=[];
            plan(id,:)=[];
            if if2x2==2,
                if id==(length(mminj)+4),
                    plan(:,jd-1)=[];
                    plan(id-1,:)=[];
                end
            end
            plan(1,:)=[];
            plan(:,1)=[];
            if if2x2==2,
                if id==(length(mminj)+4),
                    plan(:,1)=[];
                    plan(1,:)=[];
                end
            end
            power(i-1,:)=cor2vec(plan,mminj);
        end
    case 'SE'
         power=NaN(kmax,kkan);
         for i=2:kmax+1,
            plan=next_record.data{i};
            plan=reshape(plan,id,jd);
            plan(:,jd)=[];
            plan(id,:)=[];
            if if2x2==2,
                if id==(length(mminj)/2+2),
                    plan(:,jd-1)=[];
                    plan(id-1,:)=[];
                end
            end
            zp=NaN(size(plan));
            plan=[zp zp
                  zp plan];
            power(i-1,:)=cor2vec(plan,mminj);
         end
         power=sym_full(power(:,knum(:,1)),knum);
    case 'S'
         power=NaN(kmax,kkan);
         for i=2:kmax+1,
            plan=next_record.data{i};
            plan=reshape(plan,id,jd);
            plan(id,:)=[];
            plan(:,jd)=[];
            plan(:,1)=[];
            zp=NaN(size(plan));
            plan=[zp
                 plan];
            power(i-1,:)=cor2vec(plan,mminj);
         end
         power=sym_full(power(:,knum(:,1)),knum);         
    case 'E'
         power=NaN(kmax,kkan);
         for i=2:kmax+1,
            plan=next_record.data{i};
            plan=reshape(plan,id,jd);
            plan(:,jd)=[];
            plan(id,:)=[];
            plan(1,:)=[];
            zp=NaN(size(plan));
            plan=[zp plan];
            power(i-1,:)=cor2vec(plan,mminj);
         end
         power=sym_full(power(:,knum(:,1)),knum);
    case 'ESE'
        for i=2:kmax+1,
            plan=next_record.data{i};
            plan=reshape(plan,id,jd);            
            plan(:,jd)=[];
            plan(id,:)=[];
            zp=NaN(size(plan));
            plan=[zp zp
                  zp plan];
              power(i-1,:)=cor2vec(plan,mminj);
        end
        power=sym_full(power(:,knum(:,1)),knum);
end
%%
% clear FORMAT nr 
% FORMAT=cell(2,3);nr=FORMAT;
% 
% FORMAT{1,1}='float'; nr{1,1}=-1;      FORMAT{1,2}='float'; nr{1,2}=-1;      FORMAT{1,3}='float'; nr{1,3}=4;
%                                                                             FORMAT{2,3}='*char';   nr{2,3}=-1;
% next_record=get_next_record(fid,'S3K BYPASS        ',1000,FORMAT,nr);
% ico=ico+1;Lab{ico}=next_record.label;Adr(ico)=next_record.abs_pos;
%%
if ~isempty(next_record.data),
    wlk_wt=next_record.data{1,1}(3);
    wbyxy=reshape(next_record.data{1,2},id,jd);
    switch sym
        case 'FULL'
            wbyxy(:,jd)=[]; % Remove reflector layers
            wbyxy(id,:)=[];
            wbyxy(1,:)=[];
            wbyxy(:,1)=[];
            wby=cor2vec(wbyxy,mminj);
        case 'SE'
            wbyxy(:,jd)=[]; % Remove reflector layers
            wbyxy(id,:)=[];
            zp=zeros(size(wbyxy));
            wbyxy=[zp zp
                zp wbyxy];
            wby=cor2vec(wbyxy,mminj);
            wby=sym_full(wby(knum(:,1)),knum);
        case 'S'
            wbyxy(:,jd)=[]; % Remove reflector layers
            wbyxy(id,:)=[];
            wbyxy(:,1)=[];
            zp=zeros(size(wbyxy));
            wbyxy=[zp;wbyxy];
            wby=cor2vec(wbyxy,mminj);
            wby=sym_full(wby(knum(:,1)),knum);
        case 'E'
            wbyxy(:,jd)=[]; % Remove reflector layers
            wbyxy(id,:)=[];
            wbyxy(1,:)=[];
            zp=zeros(size(wbyxy));
            wbyxy=[zp wbyxy];
            wby=cor2vec(wbyxy,mminj);
            wby=sym_full(wby(knum(:,1)),knum);
        case 'ESE'
            wbyxy(:,jd)=[]; % Remove reflector layers
            wbyxy(id,:)=[];
            zp=zeros(size(wbyxy));
            wbyxy=[zp zp
                zp wbyxy];
            wby=cor2vec(wbyxy,mminj);
            wby=sym_full(wby(knum(:,1)),knum);
    end
else
    wby=[];
    wlk_wt=[];
end
%%
fclose(fid);
%% Arrange some more output variables
fue_new.nhyd=nhyd(fue_new.nfta);
fue_new.mminj=mminj;
fue_new.sym=sym;
fue_new.ihaveu=ihaveu;
fue_new.iofset=iofset;
fue_new.isymc=isymc;
fue_new.knum=knum;
kan_res=double(round(Derived_Terms{1,2}(6)));
fue_new.kan_res=kan_res;
fue_new.kan=kkan;
fue_new.kmax=kmax;
fue_new.iafull=iafull;
fue_new.hx=double(Derived_Terms{1,2}(1));
fue_new.hz=double(Derived_Terms{1,2}(2));
fue_new.dxassm=dxassm;
fue_new.hcore=hcore;
active_hcore=mean(max(Zzon(:,fue_new.nfta)));
fue_new.active_hcore=active_hcore;
kan=sum(length(mminj)-2*(mminj-1));
Qnom=fue_new.dxassm*fue_new.dxassm*active_hcore*powden*kan;  % W
              
Wnom=dxassm*dxassm*kan*floden;      % Nominal core flow (kg/s)
%%

Wrel=percwt;                        % Relative Core flow (%)
Wtot=Wnom*Wrel/100;                 % Core flow (kg/s)

Oper.Qrel=perctp;                   % Core relative power (%)
Oper.Qtot=Qnom*Oper.Qrel/100;       % Core Total power (W)
Oper.Qnom=Qnom;                     % Core nominal (=100%) power
Oper.Wtot=Wtot;         
Oper.Wrel=Wrel;
Oper.Wnom=Wnom;
Oper.powden=powden;
Oper.floden=floden*3600;
Oper.floden_hour=floden;
Oper.p=pr1;

Oper.Hinlet=hinlet;
Oper.Hinlet_BTU_lb=hinlet;
Oper.keff=Derived_Terms{1,1};
Oper.Power=power;
%% Get the segment in every node in core
% Zzon and Nzon from Fuel, see above
nfta_list=[];
for i=min(fue_new.nfta):max(fue_new.nfta);
    ii=find(fue_new.nfta==i);
    if ~isempty(ii)
        lim=Zzon(2:end,i);
        ibort=find(lim==0);
        lim(ibort)=[];
        lim=[0;lim];
        number=Nzon(:,i);
        ibort=find(number==0);
        number(ibort)=[];
        number(1)=[];
        [nodal,nodal2,w2,nodal3,w3]=set_nodal_value(number,lim,fue_new.hz,fue_new.kmax);
        nfta_list=[nfta_list i];
        for j=1:length(ii),
            Core_Seg(:,ii(j))=nodal;
            Core_Seg2(:,ii(j))=nodal2;
            Core_Seg3(:,ii(j))=nodal3;
            Seg2_w(:,ii(j))=w2;
            Seg3_w(:,ii(j))=w3;
        end
    end
end
fue_new.Core_Seg{1}=Core_Seg;
fue_new.Core_Seg{2}=Core_Seg2;
fue_new.Core_Seg{3}=Core_Seg3;
fue_new.Seg_w{1}=1-Seg2_w-Seg3_w;
fue_new.Seg_w{2}=Seg2_w;
fue_new.Seg_w{3}=Seg3_w;
fue_new.Segment=segments;
iseg=unique([fue_new.Core_Seg{1}(:);fue_new.Core_Seg{2}(:)]);
iseg(iseg==0)=[];
segnodw=heavym(iseg)*dxassm*dxassm*fue_new.hz/1e3;
iseg1=fue_new.Core_Seg{1};
iseg2=fue_new.Core_Seg{2};
wseg1=zeros(size(iseg1));wseg2=wseg1;
for i=1:length(iseg),
    wseg1(iseg1==iseg(i))=segnodw(i);
    wseg2(iseg2==iseg(i))=segnodw(i);
end
fue_new.NodeWCas=fue_new.Seg_w{1}.*wseg1+fue_new.Seg_w{2}.*wseg2;
Wfac=cor2vec(hvy741,mminj)./sum(sym_full(fue_new.NodeWCas,knum));
Wfac=repmat(Wfac,kmax,1);
fue_new.NodeW=sym_full(fue_new.NodeWCas,knum).*Wfac;
fue_new.fueloa=hvy741;
fue_new.cd_file=cd_file;
fue_new.lwr=lwr;
%%
if strncmp(lwr,'BWR',3),
    Kin_wtr={};
    Kex_wtr={};
    Kin_wr_lump={};
    Kex_wr_lump={};
    hz=double(Derived_Terms{1,2}(2));
    nhyd_in_core=unique(nhyd(unique(fue_new.nfta)));
    iwtr=0;
    for i=nhyd_in_core,                           % find max no of wtr rods
        iwtr=max(iwtr,length(find(ninwrg(i,:))));
        iwtr=max(length(find(kinwtr(i,:))),iwtr);
    end
    % Preallocate and Predimension
    A_wr=cell(1,iwtr);
    Ph_wr=cell(1,iwtr);
    Dhy_wr=cell(1,iwtr);
    for i=1:iwtr,
        A_wr{i}=zeros(1,kan_res);
        Ph_wr{i}=zeros(1,kan_res);
        Dhy_wr{i}=zeros(1,kan_res);
    end
    
    for i=nhyd_in_core,                           % i loops over mechanical types in core
        i_nhyd=find(nhyd(fue_new.nfta)==i);
        iwtr=length(find(ninwrg(i,:)));
        iwtr=max(length(find(kinwtr(i,:))),iwtr);
        for i1=1:iwtr,                                     % i1 loops over types of water rods
            rod_type=remblank(bypass_type(i,(i1-1)*4+1:i1*4));
            switch rod_type
                case 'GEN'
                    A_wr{i1}(i_nhyd)=dinwtr(i,i1);           % For case 'GEN', Area is to be found in dinwtr!
                    Ph_wr{i1}(i_nhyd)=dowtr(i,i1);           % and inside wetted perimeter in dowtr!!
                    Dhy_wr{i1}(i_nhyd)=4*A_wr{i1}(i_nhyd)./Ph_wr{i1}(i_nhyd); % cf SUBROUTINE setbwr in S3
                case 'TUBE'
                    Dhy_wr{i1}(i_nhyd)=dinwtr(i,i1);
                    A_wr{i1}(i_nhyd)=pi*Dhy_wr{i1}(i_nhyd).*Dhy_wr{i1}(i_nhyd)/4;
                    Ph_wr{i1}(i_nhyd)=pi*Dhy_wr{i1}(i_nhyd);
            end
            switch bypass_card(i,:)
                case 'BWR.WTG '
                    one_sqrt_Klump=0;
                    for j=1:ninwrg(i,i1),                              % j loops over number of inlets to water rod
                        Kin_wtr{i1,j}(i_nhyd)=kinwrg(i,(i1-1)*dimrin+j);
                        one_sqrt_Klump=one_sqrt_Klump+1/sqrt(kinwrg(i,(i1-1)*dimrin+j));
                    end
                    Kin_wr_lump{i1}(i_nhyd)=1/(one_sqrt_Klump)^2;
                    one_sqrt_Klump=0;
                    for j=1:nexwrg(i,i1)                               % j loops over number of exits from water rod
                        Kex_wtr{i1,j}(i_nhyd)=kexwrg(i,(i1-1)*dimrin+j);
                        one_sqrt_Klump=one_sqrt_Klump+1/sqrt(kexwrg(i,(i1-1)*dimrin+j));
                    end
                    Kex_wr_lump{i1}(i_nhyd)=1/(one_sqrt_Klump)^2;
                case 'BWR.WTR '
                    Kin_wtr{i1}(i_nhyd)=kinwtr(i);
                    Kin_wr_lump{i1}(i_nhyd)=kinwtr(i);
                    Kex_wtr{i1}(i_nhyd)=kexwtr(i);
                    Kex_wr_lump{i1}(i_nhyd)=kexwtr(i);
            end
        end
    end
    %%
    ftcm=30.48;
    afuel=zeros(kmax,kan_res);dhfuel=afuel;phfuel=afuel;
    uniflag=ones(length(nhyd_in_core),1);
    Xcin=zeros(1,kan_res);vhifuel=Xcin;vhofuel=Xcin;
    for i=nhyd_in_core,
        if aflmdt(i,1)==0,
            uniflag(i)=1;
        else
            uniflag(i)=0;
        end
        if isnan(xxcin(i,1)),
            XCIN=xcin(1);
        else
            XCIN=xxcin(i,1);
        end
        if uniflag(i),
            AFL(1:kmax,1)=afl(i)*ftcm*ftcm;   % These are in feet
            DHY(1:kmax,1)=diafue(i)*ftcm;
            PH(1:kmax,1)=dhe(i)*ftcm;
        else
            zmdti=rensa(zmdt(i,:),-10000);
            aflmdti=rensa(aflmdt(i,:),0);
            [number,lim]=set_lim(aflmdti,zmdti,kmax,hz);
            AFL=set_nodal_value(number,lim,hz,kmax);
            dhymdti=rensa(dhymdt(i,:),0);
            [number,lim]=set_lim(dhymdti,zmdti,kmax,hz);
            DHY=set_nodal_value(number,lim,hz,kmax);
            lz=length(find(~isnan(zmdti)));
            if lz==1,
                PH(1:kmax,1)=phmdt(i,1);
            else
                [number,lim]=set_lim(phmdt(i,:),zmdti,kmax,hz);
                PH=set_nodal_value(number,lim,hz,kmax);
            end
        end
        i_nhyd=find(nhyd(fue_new.nfta)==i);
        for i1=1:kmax,
            afuel(i1,i_nhyd)=AFL(i1);
            dhfuel(i1,i_nhyd)=DHY(i1);
            phfuel(i1,i_nhyd)=PH(i1);
        end
        Xcin(i_nhyd)=XCIN*AFL(1)^2/1e4;               % First we just assume normal orifice, we deal with specials later
        vhifuel(i_nhyd)=kltp(i);                      % Reference area = 100 cm2, thus 1e4 (=Aref^2)
        vhofuel(i_nhyd)=kutp(i);
    end
    %%
    orityp=cor2vec(nht,mminj,knum,sym);                     % Now fix the special orifices
    orityp=orityp(knum(:,1)');
    num_orityp=length(unique(orityp));
    for j=2:num_orityp
        for i=nhyd_in_core
            if isnan(xxcin(i,1)),
                kvot=xcin(j)/xcin(1);
            else
                kvot=xxcin(i,j)/xxcin(i,1);
            end
            ind=find(orityp==j&nhyd(fue_new.nfta)==i);
            Xcin(ind)=Xcin(ind)*kvot;
        end
    end
    %%
    fue_new.chanel=chanel;
    fue_new.elevat=elevat;
    fue_new.afuel=afuel;
    fue_new.dhfuel=dhfuel;
    fue_new.phfuel=phfuel;
    fue_new.xxcin=xxcin;
    fue_new.A_wr=A_wr;
    fue_new.Ph_wr=Ph_wr;
    fue_new.Dhy_wr=Dhy_wr;
    % TODO fix this properly! (i.e. find out what Kin_wr_lump should be!)
    if exist('Kin_wr_lump','var'),
        for i=1:length(Kin_wr_lump),
            if length(Kin_wr_lump{i})<kan_res,
                Kin_wr_lump{i}(kan_res)=0;
            end
        end
        % TODO fix this properly! (i.e. preallocate instead)
        for i=1:length(Kex_wr_lump),
            if length(Kex_wr_lump{i})<kan_res,
                Kex_wr_lump{i}(kan_res)=0;
            end
        end
    else
        Kin_wr_lump=[];Kex_wr_lump=[];
    end
    fue_new.Kin_wr=Kin_wr_lump;
    fue_new.Kex_wr=Kex_wr_lump;
    fue_new.Kin_wtr=Kin_wtr;
    fue_new.Kex_wtr=Kex_wtr;
    fue_new.vhifuel=-vhifuel;
    fue_new.vhofuel=-vhofuel;
    fue_new.Xcin=-Xcin;
    fue_new.orityp=orityp;
    fue_new.amdt=AMDT(fue_new.nhyd);
    fue_new.bmdt=BMDT(fue_new.nhyd);
    fue_new.cmdt=CMDT(fue_new.nhyd);
    fue_new.awtr=AWTR;
    fue_new.bwtr=BWTR;
    if length(find(crtyp_map(:)))==irmx*irmx,
        crmminj=mminj2crmminj(mminj,irmx);
    else
        crmminj=mminj2crmminj(crtyp_map);
    end
    crtyp_vec=cor2vec(crtyp_map,crmminj);
    konrod=cor2vec(konrod,crmminj);
    fue_new.crtyp=crtyp_vec;
    fue_new.crmminj=crmminj;
else % PWR
    fue_new.crtyp_map=crtyp_map;
    if if2x2==2,
        fue_new.ia=ia;
        fue_new.ja=ja;
        fue_new.mminjh=(mminj(1:2:end)+1)/2;
        fue_new.crmminj=fue_new.mminjh;
        fue_new.crtyp=cor2vec(crtyp_map,fue_new.crmminj);
        fue_new.konrod_map=konrod;
        konrod=cor2vec(konrod,fue_new.crmminj);
    end
end
fue_new.if2x2=if2x2;
fue_new.konrod=konrod;
fue_new.detloc=detloc;
fue_new.idetz=idetz;
fue_new.ddetz=ddetz;
fue_new.det_axloc=det_axloc(idetz,ddetz);
fue_new.xxkspa=xxkspa;
fue_new.xkspac=xkspac;
fue_new.zspacr=zspacr;
fue_new.asmnam=asmnam(unique(fue_new.nfta),:);
fue_new.irmx=irmx;
fue_new.crdnam=Crdnam;
if ~isempty(crdid),
    ncr=sum(length(crmminj)-2*(crmminj-1)); % No of Control rods
    CrMap=vec2cor(1:ncr,crmminj);
    newindex=cor2vec(CrMap',crmminj); % Note ' for transpose
    crdid(newindex)=crdid;
end
fue_new.crdid=crdid;
fue_new.crdgng=crdgng;
fue_new.dzstep=dzstep;
fue_new.crdsteps=npfw;
fue_new.crdzon=crdzon;
fue_new.crd_gray=crd_gray;
fue_new.ncrd=ncrd;
fue_new.if_wlt=if_wlt;
fue_new.casup=casup;
fue_new.cbsup=cbsup;
fue_new.ccsup=ccsup;
fue_new.rhoref_bypass=rho_ref_bypass;
Oper.wlt_cwt=wlt_cwt;
Oper.wlt_ctp=wlt_ctp;
Oper.wlt_bypass_frac=wlt_bypass_frac;
Oper.wby=wby;
Oper.wlk_wt=wlk_wt;
fue_new.ifmeti=ifmeti;
Oper.Qloss=fue_new.C(44)*Oper.Qnom;
Oper.Qcu=fue_new.C(45)*Oper.Qnom;
Oper.Wcrd=fue_new.C(43)*Oper.Wnom;
Oper.Xco=fue_new.C(41);

if ifmeti,
    ftcm=30.48;
    Btu_kJ=1.05505585;
    lbkg=0.45359237;
    Btulb_kJkg=Btu_kJ/lbkg;
    vmtove=lbkg/(ftcm/100)^3;
    psipas=6894.75729;                              % 1 psi 6894.75729 Pa 
    lbh_kgs=126e-6;                                 % 1 lb/h = 126e-6 kg/s
    fue_new.casup=casup*lbh_kgs/sqrt(psipas);       % Convert from lb_m/(h*psi^0.5) to kg/(s pa^.5) = kg^0.5*m^0.5
    fue_new.cbsup=cbsup*lbh_kgs/psipas;             % Convert from lb_m/(h*psi) to kg/(s pa) = ms
    fue_new.ccsup=ccsup*lbh_kgs/psipas^2;           % Convert from lb_m/(h*psi^2) to kg/(s pa^2)= m^2s^3/kg
    fue_new.rhoref_bypass=rho_ref_bypass*vmtove;
    Oper.p_psia=pr1+pr2*perctp+pr3*perctp*perctp;
    Oper.pr1=pr1;
    Oper.pr2=pr2;
    Oper.pr3=pr3;
    Oper.p=Oper.p_psia*psipas;       
    Oper.Hinlet=Oper.Hinlet*Btulb_kJkg;
    Press=Oper.p;
    H_kJkg=Oper.Hinlet;
else
    Press=psi2pas(Oper.ps);
    H_kJkg=Btu2kJkg(Oper.Hinlet);
end

if exist('h_v')==2,
    tlp=fzero(@(x) h_v(x,Press)-H_kJkg,270+273.15)-273.15;
    Oper.tlp=tlp;
    Oper.tlp_F=C2F(Oper.tlp);
end

Lab(ico+1:end)=[];
Adr(ico+1:end)=[];
fue_new.Lab=Lab;
fue_new.Adr=Adr;
