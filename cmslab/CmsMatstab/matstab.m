function matstab(s3kfile,varargin)
% matstab(s3kfile,'param1',value1,'param2',value2,...)
%
%Calculates the dynamic eigenvalue and its eigenvector associated
%with the core stability.
%
% To see available options, type help set_msopt
%
% Example
% matstab s3k-1.inp Harmonics 2 LibFile ../../cd/cd-file.lib



% www.haenggi.net/matstab
%
% Thomas Smed
% P�r Lans�ker
% Gustav Dominicus
%
% Forsmarks Kraftgrupp AB
% 742 03 �sthammar
% Sweden
%
% Philipp H�nggi 
% matstab@haenggi.net
%
% Atel Ltd.
% 4601 Olten
% Switzerland
% 
% Thomas Smed 2007-2008:
% Major rewrite to adapt to cms  
%         Base data from restartfile, lib-file and s3k input file
%         Thermo hydraulics modified (solution scheme, numbering)
%         
% TODO: shorten msopt (one short for the user, a long ms_opt for the programmer!)
%       the user should just do msopt=set_msopt;msopt.Harmonics=2;matstab(filename,msopt)
% TODO: Get rid of globals, not longer that that one can pass the blocks
% TODO: Fix left eigenvector
% 

%-----------------------------------------------------------------
%MATLAB version check
if nargin==0
    [filename,pathname]=uigetfile({'*.inp','S3K input files (*.inp)';...
        '*.*', 'All files (*.*)'},...
        'Pick a S3K input file');
    if filename==0, return, end
    filename=[pathname,filename];
    s3kfile=file('normalize',filename);
end


% set-up print file
if ~isempty(dir('mstabprint.txt'))
  delete('mstabprint.txt')
end
%diary('mstabprint.txt')
%%
tclock=clock;
%tcpu=cputime;
%tcpu0=tcpu;
%%
%ver = version;
%if str2num(ver(1))<5,error('You have to run MATLAB version 5, at least!'),end

disp(' ');
disp('********************** MATSTAB 3 for Simulate-3 **********************');

%% Initialising the clock

clear global msopt polcadata geom steady termo neu fuel vec stab
global msopt steady geom  

%-----------------------------------------------------------------
%% Reading defaults and input
msopt=init_msopt(s3kfile,varargin{:});

[fue_new,Oper]=get_inp_sim3;
%  disp(['Input and initialisation: ',num2str(cputime-tcpu),' s']);
%  tcpu=cputime;
%% Initialize from previous case if available
lam=msopt.Lam;init_flag=false;
if get_bool(msopt.Global)||msopt.Harmonics>0
    [init_flag,lam,en0]=init_from_mat(msopt,'dyn',geom.knum);
end
    %% Steady state
Xsec=steady_state(fue_new,Oper);
%  disp(['Steady state: ',num2str(cputime-tcpu),' s']);
%  tcpu=cputime;
%%
if get_bool(msopt.Global)||msopt.Harmonics>0||isnumeric(msopt.Freq)
%% Building the system matrix
[At,Atj,Atq,Atf,Ajt,Aj,Ajq,Ajf,Ant,AntIm,An,AnIm,Anf, ...
  Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,Btj,matr]=build_A(fue_new,Xsec,lam);
%  disp(['System matrix: ',num2str(cputime-tcpu),' s']);
%    tcpu=cputime;
%% Creation of a starting guess for en;
if ~init_flag
    lam=msopt.Lam;
    en0=dist2en(steady.power);
end
%-----------------------------------------------------------------
% Solving for the global eigenvalue/eigenvector

if get_bool(msopt.Freq)
    [An,Ant,AnIm,AntIm,lAn,uAn]=newtfreq(lam,en0,At,Atj,Atq,Atf,Ajt,Aj,Ajq,Ajf, ...
            Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,Btj,fue_new,Xsec,matr);
end


if get_bool(msopt.Global)
    [An,Ant,AnIm,AntIm,lAn,uAn]=newt(lam,en0,At,Atj,Atq,Atf,Ajt,Aj,Ajq,Ajf, ...
            Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,Btj,fue_new,Xsec,matr);
end

%  disp(['Global calculation: ',num2str(cputime-tcpu),' s']);
%  tcpu=cputime;
  
  %-----------------------------------------------------------------
  % Calculation of the left eigenvector for the global case
  
  if strcmp(msopt.LeftEig,'on')
  
    lefteig(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
            Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj,lAn,uAn);
  end
  
  
  %-----------------------------------------------------------------
  % Calculation of the harmonic solutions
  
  if ischar(msopt.Harmonics), msopt.Harmonics=str2double(msopt.Harmonics);end
  
  if msopt.Harmonics>0
      [An,Ant,AnIm,AntIm,lAn,uAn]= ...
      newt_half(At,Atq,Atf,Aqt,Aqn,Aft,Afq,Af,Bt,Bf,fue_new,Xsec,matr);
  end
  
  %-----------------------------------------------------------------
  % HARMONIC_LEFTEIG
  % Calculation of the left eigenvectors for the harmonic solutions
  
  if strcmp(msopt.LeftEig,'on') && msopt.Harmonics>0
  
    lefteigh(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
             Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj,lAn,uAn);
  end  
%-----------------------------------------------------------------


% Final saving
  
if strcmpi(msopt.SaveOption,'large')
    save('-append',msopt.MstabFile,'At','Atj','Atq','Atf','Ajt','Aj','Ajf', ...
            'Ant','AntIm','An','AnIm','Anf','Aqt','Aqn','Aqf','Aft','Afj','Afq','Af','Bt','Bf','Bj');
end
if strcmpi(msopt.SaveOption,'small')
  reduceMstabFile
end

disp(' ');
%disp(['Total CPU-time: ',num2str(cputime-tcpu0),' s']);
disp(['Total Real time: ',num2str(etime(clock,tclock)),' s']);


% diary off
% fid=fopen('mstabprint.txt');
% s=fread(fid);mstabprint=char(s');
% lf= mstabprint==13;mstabprint(lf)=[]; %remove line feeds
% fclose(fid);
% save('-append',msopt.MstabFile,'mstabprint')

disp(sprintf('\n%s\n%s%s','To display the results, try','cmsplot ',msopt.MstabFile));
end
