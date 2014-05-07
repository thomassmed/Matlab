%@(#)   globkoll.m 1.3	 10/07/09     12:21:47
function globkoll(crsupfil,globref,tlowp)
%function globkoll('crsupfil',globref,tlowp)
% Programmet hämtar indata i referensfil comp_ref_globkoll.txt som skall
% vara placerad lokalt där programmet körs.
% TLOWP ges som inargument
% En grupp i taget dras ut från crsupfilen tills globref är uppnådd

if nargin<3;
error(['usage: globkoll(crsupfil,globref,tlowp)']);
return;
end
if ~ischar(tlowp)
tlowp=num2str(tlowp);
end
if ischar(globref)
globref=str2num(globref);
end
tx=readtextfile(crsupfil);
tx=tx(2:end,:);
s=size(tx);
for i=1:(s(1)-1);
rad=tx(i,:);
[mangrupp(i,:),resten]=strtok(rad,',');
[ss_fran(i,:),resten]=strtok(resten,',');
[ss_till(i,:),resten]=strtok(resten,',');
ss_summa(i,:)=resten(1,2:end);
end

%inläsning från compref-filen
reffil='comp_ref_globkoll.txt';
tx=readtextfile(reffil);
s=size(tx);

  j=bucatch('TITLE',tx(:,1:5));
title=(tx(j,6:end));
  j=bucatch('SOUFIL',tx(:,1:6));
soufil=remblank(tx(j,7:end));
  j=bucatch('PRIFIL',tx(:,1:6));
prifil=remblank(tx(j,7:end));
  j=bucatch('IDENT',tx(:,1:5));
ident=remblank(tx(j,6:end));
  j=bucatch('OPTION',tx(:,1:6));
option=remblank(tx(j,7:end));
  j=bucatch('INCLUD',tx(:,1:6));
includ=remblank(tx(j,7:end));  
  j=bucatch('INIT',tx(:,1:4));
xenonfil=remblank(tx(j(1),5:end));
%burnupfil=remblank(tx(j(2),5:end));
  j=bucatch('SAVE',tx(:,1:4));
savefil=remblank(tx(j,5:end));
  j=bucatch('SUMFIL',tx(:,1:6));
sumfil=remblank(tx(j,7:end));
  j=bucatch('SYMME',tx(:,1:5));
symme=remblank(tx(j,6:end));
  j=bucatch('POWER',tx(:,1:5));
power=remblank(tx(j,6:end));
  j=bucatch('FLOW',tx(:,1:4));
flow=remblank(tx(j,5:end));
  j=bucatch('PRESS',tx(:,1:5));
press=remblank(tx(j,6:end));
  j=bucatch('CONROD',tx(:,1:6));
conrod=remblank(tx(j,7:end));


a=abs(savefil);
pos=find(a==61);
globfil=savefil(1:pos-1);

%skapa comp-fil

i=0;
keff=0;
while keff <= globref;
i=i+1;
compworkfil='comp_work.txt';
fid=fopen(compworkfil,'w');
fprintf(fid,['TITLE   ',title]);
fprintf(fid,'\n');
fprintf(fid,['SOUFIL   ',soufil]);
fprintf(fid,'\n');
fprintf(fid,['PRIFIL   ',prifil]);
fprintf(fid,'\n');
fprintf(fid,['IDENT    ',ident]);
fprintf(fid,'\n');
fprintf(fid,['OPTION   ',option]);
fprintf(fid,'\n');
fprintf(fid,['INCLUD   ',includ]);
fprintf(fid,'\n');
fprintf(fid,['INIT     ',xenonfil]);
fprintf(fid,'\n');
%fprintf(fid,['INIT     ',burnupfil]);
%fprintf(fid,'\n');
fprintf(fid,['SAVE     ',savefil]);
fprintf(fid,'\n');
fprintf(fid,['PRINT']);
fprintf(fid,'\n');
fprintf(fid,['SUMFIL    ',sumfil]);
fprintf(fid,'\n');
fprintf(fid,['SYMME     ',symme]);
fprintf(fid,'\n');
fprintf(fid,['POWER     ',power]);
fprintf(fid,'\n');
fprintf(fid,['FLOW      ',flow]);
fprintf(fid,'\n');
fprintf(fid,['PRESS     ',press]);
fprintf(fid,'\n');
fprintf(fid,['TLOWP       ',tlowp]);
fprintf(fid,'\n');
fprintf(fid,['CONROD       ',conrod]);
fprintf(fid,'\n');
    for j=1:i-1; 
        if strcmp(mangrupp(j,2),'0');
        mangrupp(j,2)=[' '];
        end
      fprintf(fid,['CONROD*     ',mangrupp(j,:),'=',ss_till(j,:),',']);
      fprintf(fid,'\n');
      end
        if strcmp(mangrupp(i,2),'0');
        mangrupp(i,2)=[' '];
        end
      fprintf(fid,['CONROD*     ',mangrupp(i,:),'=',ss_till(i,:)]);
      fprintf(fid,'\n');
fprintf(fid,['END']);
fclose(fid)
polcaramsa=['!polca comp_work.txt'];
eval(polcaramsa);
[dist,mminj,konrod,bb]=readdist7(globfil);
keff=bb(96);
end
disp(['uppnått keff: ',num2str(keff)]);
disp(['Styrstavsmönster blev: ',ss_summa(i,:)]);
disp(['Se styrstavsmönster i ',globfil]);
disp(['För att träffa Keff noggrannare kan man backa sista gruppen']);
disp(['i comp-work.txt, och därefter köra om POLCA'])

