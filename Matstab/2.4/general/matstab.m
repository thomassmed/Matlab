function matstab(distfile,varargin);
% matstab(distfile,'param1',value1,'param2',value2,...)
%
%Calculates the dynamic eigenvalue and its eigenvector associated
%with the core stability.
%

% www.haenggi.net/matstab
%
% Thomas Smed
% Pär Lansåker
% Gustav Dominicus
%
% Forsmarks Kraftgrupp AB
% 742 03 Östhammar
% Sweden
%
% Philipp Hänggi 
% matstab@haenggi.net
%
% Atel Ltd.
% 4601 Olten
% Switzerland

%-----------------------------------------------------------------
%MATLAB version check

% set-up print file
if ~isempty(dir('mstabprint.txt'))
  delete('mstabprint.txt')
end
diary('mstabprint.txt')

ver = version;
if str2num(ver(1))<5,error('You have to run MATLAB version 5, at least!'),end

disp('MATSTAB 2.4 for Polca 7')

% Initialising the clock
tclock=clock;
tcpu=cputime;
tcpu0=tcpu;

clear global msopt polcadata geom steady termo neu fuel vec stab srcdata
global       msopt polcadata geom steady termo neu fuel vec stab 

%-----------------------------------------------------------------
% Reading defaults and input

msopt=init_msopt(distfile,varargin{:});

if strcmp(msopt.SteadyState,'on')

  get_inp;
  save(msopt.MstabFile,'msopt','polcadata','geom','fuel','neu','termo')
  
  disp(['Input and initialisation: ',num2str(cputime-tcpu),' s']);
  tcpu=cputime;


  %-----------------------------------------------------------------
  % Steady state

  steady_state;

  disp(['Steady state: ',num2str(cputime-tcpu),' s']);
  tcpu=cputime;
elseif strcmp(msopt.Global,'off')
  % With both SteadyState and Global 'off', matstab only run the initilazation phase
  % Can be used to test if the files are OK before a long verification run
    get_inp;  
    save(msopt.MstabFile,'msopt','polcadata','geom','fuel','neu','termo')
    
    disp(['Input and initialisation: ',num2str(cputime-tcpu),' s']);
    tcpu=cputime;
else
  load(msopt.MstabFile,'polcadata','geom','steady','termo','neu','fuel');
  if isempty(steady)
    error(['Not enough data saved in matstab file:' 10 msopt.MstabFile 10 ...
           'You need to re-run the steady state calculation'])
   end     
   
end

if strcmp(msopt.Global,'on')

  %-----------------------------------------------------------------
  % Building the system matrix
  
  if strcmpi(msopt.Lam,'auto')
      f=0.176*mean(steady.jm)+0.152;
      lam=f*log(0.8)+2j*pi*f;
  else
      lam=str2num(msopt.Lam);
  end
  
  [A0,B,AIm]=build_A(lam);
  
  disp(['System matrix: ',num2str(cputime-tcpu),' s']);
  tcpu=cputime;
  
  
  %-----------------------------------------------------------------
  % Reduction of the thermal hydraulics

  A=redhyd(A0,B,AIm);
  
  clear A0
  
  
  %-----------------------------------------------------------------
  % Subspace decomposition of the system matrix
  
  [At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm,Anf, ...
  Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj]=A2part(A,B,AIm);     
  
  clear A AIm
  

  %-----------------------------------------------------------------
  % Creation of a starting guess for en;
  
  en0=dist2en;
  %when distfile is not given, Ppower is used instead of power
  
  %-----------------------------------------------------------------
  % Solving for the global eigenvalue/eigenvector
  
  if strcmp(msopt.CoreOnly,'off')
  
    [An,Ant,AnIm,AntIm,lAn,uAn]=newt(lam,en0,At,Atj,Atq,Atf,Ajt,Aj,Ajf, ...
            Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj);

  else % msopt.CoreOnly is 'on'
  
    newt_core_only(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
         Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj);
         %Task: core_only is not restructured yet
  
  end
  
  disp(['Global calculation: ',num2str(cputime-tcpu),' s']);
  tcpu=cputime;
  
  
  %-----------------------------------------------------------------
  % Calculation of the left eigenvector for the global case
  
  if strcmp(msopt.LeftEig,'on')
  
    lefteig(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
            Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj,lAn,uAn);
  
  
    disp(['Left eigenvector (global): ',num2str(cputime-tcpu),' s']);
    tcpu=cputime;
  end
  
  
  %-----------------------------------------------------------------
  % Calculation of the harmonic solutions
  
  if msopt.Harmonics>0
    if msopt.CoreSym==2,
      [An,Ant,AnIm,AntIm,lAn,uAn]= ...
      newt_half(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj);
    elseif msopt.CoreSym==1,
      nr=msopt.Harmonics;
      [Keff,F]=harm_startguess(nr);
      lam=stab.lam-0.1-0.2j;
      for i=1:nr,
        if i>1, lam=stab.lamh(i-1)-0.05-0.1j; end
        fprintf(1,'Eigenvalue calculation for Harmonics no. %i: \n',i);
        en=stab.e(vec.n).*F(:,i+1);
        newt_harm(lam,en,At,Atj,Atq,Atf,Ajt,Aj,Ajf, ...
         Ant,AntIm,An,AnIm,Anf,Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,i);
      end
    end
    disp(['Harmonic calculation: ',num2str(cputime-tcpu),' s']);
    tcpu=cputime;
  end
  
  %-----------------------------------------------------------------
  % HARMONIC_LEFTEIG
  % Calculation of the left eigenvectors for the harmonic solutions
  
  if strcmp(msopt.LeftEig,'on') & msopt.Harmonics>0
  
    lefteigh(At,Atj,Atq,Atf,Ajt,Aj,Ajf,Ant,AntIm,An,AnIm, ...
             Aqt,Aqn,Aft,Afj,Afq,Af,Bt,Bf,Bj,lAn,uAn);
  
    disp(['Left eigenvector (harmonic): ',num2str(cputime-tcpu),' s']);
    tcpu=cputime;
  
  end  
%-----------------------------------------------------------------
end 

% Final saving
  
save('-append',msopt.MstabFile,'stab','vec');

if strcmp(msopt.SaveOption,'small')
  reduceMstabFile
end

disp(' ');
disp(['Total CPU-time: ',num2str(cputime-tcpu0),' s']);
disp(['Total Real time: ',num2str(etime(clock,tclock)),' s']);

diary off
fid=fopen('mstabprint.txt');
s=fread(fid);mstabprint=setstr(s');
save('-append',msopt.MstabFile,'mstabprint')

