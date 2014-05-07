function [e_lp,E_lp,lpeig,nlp,lpnr,axpos,kpunkt,cfft]=mstab_vs_meas(matfil,racsfil,displ,harmonics);
% [e_lp,E_lp,lpeig,nlp,lpnr,axpos,kpunkt,cfft]=mstab_vs_meas(matfil,racsfil,displ);
% Ritar ett visardiagram med egenvektorer från mätning och matstab
%
% alternativ:
% mstab_vs_meas(polcafil,racsfil);
% Ritar bara ut mätningen
%
% displ = 0 -> only lprm's
% displ = 3 -> only inletflow
% displ = []-> displ = 0
% else lprm's and inletflow

%@(#)   mstab_vs_meas.m 1.4   05/05/19     08:21:08

if nargin<3,displ=0;end
if nargin<4,harmonics=0;end

% initalize flags
skip_case=0;
plot_polca_power=0; 

if ~isempty(matfil)
  if strcmp(matfil(end-3:end),'.mat') %matstabfil
    load(matfil,'msopt');
    disfil=msopt.DistFile;
    mstab=1;
  else
    if strcmp(matfil(end-3:end),'.dat') %polcafil, plotta endast mätning
      disfil=matfil;
      matfil=[];
      mstab=0;
      plot_polca_power=1;
    end
  end
else
  disfil=setprop(5);
  mstab=0;
end

[tmp,MATLAB_HOME]=unix('echo $MATLAB_HOME');
MATLAB_HOME(length(MATLAB_HOME))=[];

CM_HOME='/cm';

neumodel=polca_version(disfil);
if strcmp(neumodel,'POLCA4'),
 [dum,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist(disfil);
  if staton(1)=='L'
    staton='l';
  else
    staton=['f' staton(10)];
  end
elseif strcmp(neumodel,'POLCA7'),
  [dum,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flop,soufil]=readdist7(disfil);
  staton=lower(staton);
  dpos=detpos;
  for i=1:max(dpos),
    detpos(i,1)=min(find(dpos==i));
  end
end


dfil=strip(disfil);
id=findstr(dfil,'.dat');
if length(id)>0, dfil=dfil(1:id-1);end

if nargin <2|(length(racsfil)==0)
  [casenr,f_polca_list,dat,qrel,hc,drmeas,fdmeas,stdmeas,modord,racsfil_list]=...
  read_fillista([CM_HOME,filesep,staton,'/matstab/ver/input/case_list.txt']);
  racsfil=deblank(racsfil_list(strmatch(dfil,f_polca_list),:));
end

if length(findstr(racsfil,'.mat'))>0,
  if strcmp(staton,'f3'),
    [c,mtext,b,mvarb,sampl]=getf3(racsfil);
  else
    [a,b,c]=ldracs(racsfil);
  end
elseif ~isempty(racsfil),
  [a,b,c]=ldracs(racsfil);
else
  error('For plotting only simulated LPRM use function mstab_lprm');  
end

if ~exist('sampl','var')
  sampl=[];
end
[id,jd]=find(abs(c)>1e10);

% Nedanstående parti hittar "felaktiga" mätvärden och sätter dem till medelvärdet av omgivande värden.
% Har skrivit om funktionen 060508 då en felaktig användning av "find" orsakade att värden vilka inte 
% behövde sättas om sattes om och dessutom kunde funktionen inte lösa fall då första eller sista 
% mätvärdet var felaktigt (dessa (om felaktiga!) sätts nu identiska med andra respektive näst sista
% mätvärdet). / eml 060508

% c(id,jd)=(c(id+1,jd)+c(id-1,jd))/2;	% Ersatt rad enligt ovan

for ii = 1:length(id)
  if id(ii)>1 && id(ii)<size(c,1)
    c(id(ii),jd(ii))=(c(id(ii)+1,jd(ii))+c(id(ii)-1,jd(ii)))/2; 
  elseif id(ii) == 1
    c(id(ii),jd(ii)) = c(id(ii)+1,jd(ii));
  else
    c(id(ii),jd(ii)) = c(id(ii)-1,jd(ii));
  end
end         

if skip_case==0
  [nlp,lpnr,axpos,kpunkt,apnr,r_kpunkt]=racsb2lprm(b,strcmp(staton,'f3'),sampl);
 
  if ~isempty(sampl)
    T=1/sampl(2,1);
  else
    T=c(3,1)-c(2,1);
  end
  nn=size(c,1);
  if nn>8192, nn=8192;end
  cfft=fft(detrend(c(1:nn,:)));
  % sampla ner till ca 12.5 Hz
  r=max(floor(1/T/12.5),1);
  lpeig=fft2e(idresamp(c(:,apnr(1)),r),idresamp(c(:,nlp),r),T*r);
  %lpeig=lpeig.';
  %[dum,nmax]=max(abs(cfft(1:round(nn/2),apnr(1))));
  %fd=(nmax-1)/nn/T
  %lpeig=cfft(nmax,nlp);

  if mstab==1,
    [efi1,evoid,efi2]=f_matstab2dist(matfil,harmonics);
 
    e_lp=e_mstab(efi2,disfil,lpnr,axpos);
    E_lp=e_lp;%*mean(lpeig)/mean(e_lp);
    lpeig=lpeig*mean(e_lp)/mean(lpeig);
    
  else
    sca=max(abs(lpeig))/5;
  end
 
 
  if mstab==1,
    % matstab fil finns
    distplot(disfil,'abs(efi2)',upleft,abs(efi2));
  end
  if plot_polca_power==1
    % matstab fil finns inte, plotta polcas power istället
  distplot(disfil,'power');
  end
 
  if displ ~= 3
    ij=knum2cpos(detpos(lpnr),mminj);
    if mstab == 1,
      sca=max(abs(E_lp))/5;
      x=ij(:,2)'+1;
      y=ij(:,1)'+1;
      x=[x;x+real(E_lp)/sca];y=[y;y-imag(E_lp)/sca];
      h=line(x,y);
      set(h,'color','bla','LineWidth',2.0);
    end
    x=ij(:,2)'+1;
    y=ij(:,1)'+1;
    x=[x;x+real(lpeig)/sca];y=[y;y-imag(lpeig)/sca];
    h=line(x,y);
    set(h,'color','w','LineWidth',2.0);
    if mstab==0,
      set(h,'color',[0 0 0.5],'LineWidth',2.0);
    end
  end
 
  if displ
    [nfl,flnr,flkpunkt]=racsb2flow(b);
    fltid=c(:,nfl);
    fleig=fft2e(c(:,apnr),c(:,nfl),T);
  %  fleig=fleig.';
  %  fleig=cfft(nmax,nfl);
    [eWl]=Wl_matstab2dist(matfil);
    [e_lp e_fl]=e_mstab(efi2,disfil,lpnr,axpos,eWl,flkpunkt);
    E_fl=e_fl*mean(lpeig)/mean(e_lp);
    
    [chnum,knam]=flopos(staton);
    ii=mbucatch(knam,flkpunkt);
 
    ij=knum2cpos(chnum,mminj);
    sca=max(abs(fleig)/5);
 
     x=ij(:,2)'+.5;
     y=ij(:,1)'+.5;
     x=[x;x+real(E_fl)/sca];y=[y;y-imag(E_fl)/sca];
     h=line(x,y);
     set(h,'color','bla','LineWidth',2.0);
 
    x=ij(:,2)'+.5;
    y=ij(:,1)'+.5;
    x=[x;x+real(fleig)/sca];y=[y;y-imag(fleig)/sca];
    h = line(x,y);
    set(h,'color','w','LineWidth',2.0);
  end
elseif skip_case==1
  [e_lp,E_lp,lpeig,nlp,lpnr,axpos,kpunkt]=deal([]);
end

