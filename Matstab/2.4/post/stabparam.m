function stabparam(f_polca)
% stabparam(f_polca)
% plottar stabilitetsparametrar från en polcafil
% Under utveckling

%error(' Funktion under utveckling/vdb 2001-02-08')
% kolla filen
f_polca=expand(f_polca,'dat');
fid=fopen(f_polca);
if fid==-1
  error(['Could not find polca file',10, f_polca])
end
% försök expandera till fullständig sökväg. Kan misslyckas då which inte kan hantera relativa sökvägar
tmp=which(f_polca);
if ~isempty(tmp)
  f_polca=tmp;
end
% kolla filformat	 
a=fread(fid,50,'int');
fclose(fid);
if a(50)==12348
  PolcaVer='p4';
elseif a(50)==92348
  PolcaVer='p7';
else 
  error(strcat('Unknown fileformat in file:', 10, f_polca))
end

%p=get(gcf,'position');
%set(gcf,'position',[206 108 622 814]);
clf
set(gcf,'DefaultTextFontname','courier')
if strcmp(PolcaVer,'p4')
  [power,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
   distlist,staton,masfil,rubrik,detpos,fu]=readdist(f_polca,'power');
  void=readdist(f_polca,'void');

  % Text
  %
  axes('Position',[0.12, 0.75, 0.4, 0.2]);
%  subplot(3,2,1)
  set(gcf,'paperposition',[.5 1 8 10]);
  set(gca,'visible','off');
  text(0,1,sprintf(rubrik));
  s=strvcat(...
  sprintf('Power     %6.1f %s',bb(5)/1e6,'MW'),...
  sprintf('          %6.1f %s',100*bb(1),'%'),...
  sprintf('HC-flow    %5.0f kg/s',bb(2)),...
  sprintf('CR pattern %5.0f %s',bb(65),'%'),...
  sprintf(' '),... %blankrad
  sprintf('Avg core burnup %5.0f %s',bb(89),'MWd/tU'),...
  sprintf('Avg Xenon conc %6.1f %s',bb(62)*1e-12,'T/cm3'));
  text(0,.8,s,'verticalalignment','top')
  %
  % Filnamn
  %
  maxlength=60;
  indrag=13;
  masfil=RadBrytFil(masfil,maxlength,indrag);
  f_polca=RadBrytFil(f_polca,maxlength,indrag);
  s=strvcat(...
  sprintf('Polca4 file: %s',f_polca),...
  sprintf('Master file: %s' ,masfil));
  text(0,0,s,'verticalalignment','top','interpreter','none')
  
  axes('Position',[0.57, 0.75, 0.4, 0.2]);
%  subplot(3,2,2)
  s=strvcat(...
  sprintf('Lower plenum temp    %6.1f %s',bb(10),'\circC'),...
  sprintf('Core avg void          %4.1f %s',hy(86)*100,'%'),...
  sprintf('Power peaking factor  %5.2f',bb(56)),...
  sprintf('Radial peaking factor %5.2f',bb(55)));
%  sprintf('Delayed neutrons',));
%  sprintf('FAX',));
  text(0,.8,s,'verticalalignment','top')

  set(gca,'visible','off');

  %
  % SS-karta
  %
  subplot(3,2,3);
  [hsc,hcont]=plotcont(gca,mminj);
  set(gca,'visible','off');
  set(hcont,'color','blu');
  set(hsc,'color','blu');
  lm=length(mminj);
  line([mminj(1) lm+2-mminj(1)],[1 1],'color','blu')
  line([mminj(1) lm+2-mminj(1)],[lm+1 lm+1],'color','blu')
  line([1 1],[mminj(1) lm+2-mminj(1)],'color','blu')
  line([lm+1 lm+1],[mminj(1) lm+2-mminj(1)],'color','blu')
  axis([1 1+mz(3) 1 1+mz(3)]);
  for i=1:mz(7)
    if konrod(i)<1000
      crpos=crnum2crpos(i,mminj);
      text(2*crpos(2)-1,2*(15-crpos(1)+1),sprintf('%2.0f',konrod(i)/10),'fontname','courier')
    end
  end
else
  %
  % Polca 7
  %
  [power,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(f_polca,'power');
  void=readdist7(f_polca,'void');
  xenon=readdist7(f_polca,'xenon');
  % Text
  %
  clf
  set(gcf,'DefaultTextFontname','courier')
  axes('Position',[0.12, 0.75, 0.4, 0.2]);
  set(gcf,'paperposition',[.5 1 8 10]);
  set(gca,'visible','off');
  text(0,1,sprintf(rubrik));
  s=strvcat(...
  sprintf('Power     %6.1f %s',hy(1)*hy(11)/1e6,'MW'),...
  sprintf('          %6.1f %s',100*hy(11),'%'),...
  sprintf('HC-flow    %5.0f kg/s',hy(2)),...
  sprintf('CR pattern %5.0f %s',bb(18),'%'),...
  sprintf('EFPH       %5.0f',bb(46)),...
  sprintf(' '),... %blankrad
  sprintf('Avg core burnup %5.0f %s',bb(45)*1e3,'MWd/tU'),...
  sprintf('Avg Xenon conc %6.1f %s',bb(65)*1e-12,'T/cm3'));
  text(0,.8,s,'verticalalignment','top')
  %
  % Filnamn
  %
  maxlength=60;
  indrag=13;
  masfil=RadBrytFil(masfil,maxlength,indrag);
  f_polca=RadBrytFil(f_polca,maxlength,indrag);
  s=strvcat(...
  sprintf('Polca7 file: %s',f_polca),...
  sprintf('Master file: %s' ,masfil));
  text(0,0,s,'verticalalignment','top','interpreter','none')
  
  axes('Position',[0.57, 0.75, 0.4, 0.2]);
  set(gca,'visible','off');
  s=strvcat(...
  sprintf('Lower plenum temp     %5.1f %s',hy(15),'\circC'),...
  sprintf('Core avg void          %4.1f %s',hy(114)*100,'%'),...
  sprintf('Power peaking factor  %5.2f',bb(100)),...
  sprintf('Axial peaking factor  %5.2f',bb(106)),...
  sprintf('Radial peaking factor %5.2f',bb(99)));
%  sprintf('Delayed neutrons',));
  text(0,.8,s,'verticalalignment','top')
  %
  % SS-karta
  %
  subplot(3,2,3);
%  axes('Position',[0.12, 0.45, 0.33, 0.25]);
  [hsc,hcont]=plotcont(gca,mminj);
  set(gca,'visible','off');
  set(hcont,'color','blu');
  set(hsc,'color','blu');
  lm=length(mminj);
  line([mminj(1) lm+2-mminj(1)],[1 1],'color','blu')
  line([mminj(1) lm+2-mminj(1)],[lm+1 lm+1],'color','blu')
  line([1 1],[mminj(1) lm+2-mminj(1)],'color','blu')
  line([lm+1 lm+1],[mminj(1) lm+2-mminj(1)],'color','blu')
  axis([1 1+mz(12) 1 1+mz(12)]);
  for i=1:mz(69)
    if konrod(i)<1000
      crpos=crnum2crpos(i,mminj);
      text(2*crpos(2)-1,2*(mz(68)-crpos(1)+1),sprintf('%2.0f',konrod(i)/10),'fontname','courier')
    end
  end
end 

%
% Power and xenon
%
subplot(3,2,5)
plot(mean(power,2),1:25)
hold on
plot(mean(xenon,2)*1e-15,1:25,'--')
axis([0 2 0 25])
title('Axial power (-) and xenon(--)')

grid on
%
%Void
%
subplot(3,2,6)
plot(mean(void,2),1:25)
axis([-0.1 0.8 1 25])
title('Axial void')
grid on

function fil=RadBrytFil(fil,maxlength,indrag)
if length(fil)>maxlength
  snestreck=find(fil==filesep);
  snestreck=snestreck(max(find(snestreck<maxlength)));
  fil=[fil(1:snestreck),'...', 10,' '*ones(1,indrag),fil(snestreck+1:end)];
%  fil=tmp;
end

