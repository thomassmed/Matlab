%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autotip_tipplot.m v1.0
% Detta är ett underprogram till Autotip_XP
% function Autotip_tipplot('tipfil',utskrift,tip_infofil)
% om tip_infofil ej anges sätts ordinarie tip_infofil som default
% Programmet är en vidareutveckling av tip_utan_top7.m
% Vidareutvecklad av Jan Karjalainen, FTB 2004 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Autotip_tipplot(tipfil,tip_infofil)

if nargin<2
  reakdir=findreakdir;
  tip_infofil=[reakdir,'fil/tip-info.txt']; % Hittar och sätter default tip_infofil.
end
tipgam=[];
tipneu=[];
[tipmea,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist...
,staton,masfil,rubrik,detpos,fu,op,au,flopos]=readdist7(tipfil,'tipmea');
ni=strmatch('TIPNEU',distlist);
gi=strmatch('TIPGAM',distlist);
if (isempty(ni) & isempty(gi)),error(['Neither TIPGAM nor TIPNEU exists on ' tipfil]);end
%if (~isempty(ni) & ~isempty(gi)),error(['Both TIPGAM and TIPNEU exists on ' tipfil]);end
if ~isempty(ni),tipneu=readdist7(tipfil,'tipneu');end
if ~isempty(gi),tipgam=readdist7(tipfil,'tipgam');end
EFPH=readdist7(tipfil,'EFPH');
nnod=mz(11);
%if ~isempty(tipneu),tipgam=tipneu;end
fid=fopen(tip_infofil,'r');
rad=fgetl(fid);
irad=sscanf(rad,'%i');
nsond=irad(1);
ntip=irad(2);
ksond=irad(3);
rad=fgetl(fid);
tipsub=sscanf(rad,'%i');
nomea=find(mean(tipmea)<0);
meas=1:nsond;
if ~isempty(nomea)
  meas(nomea)=[];
  me=tipmea;
  me(:,nomea)=[];
  mmea=mean(mean(me));
  mg=tipgam;
  mg(:,nomea)=[];
  mgam=mean(mean(mg));
else
  mmea=mean(mean(tipmea));
  mgam=mean(mean(tipgam));
end
tipmea=tipmea/mmea;
tipgam=tipgam/mgam;
%
% Find cykle core average EFPH
%
bb_68=min(EFPH); 
%
% Text
%
temp_handle=figure;
axes('Position',[0.12, 0.75, 0.4, 0.2]);
set(gcf,'paperposition',[1.25 2.5 20 25]);
set(gca,'visible','off');
text(0,1,sprintf(rubrik));
text(0,.8,sprintf('Power %5.1f%s',100*hy(11),'%'));
text(0,.7,sprintf('HC-flow %5.0f kg/s',hy(2)));
text(0,.6,sprintf('Temp %5.1f',hy(15)));
text(0,.5,sprintf('CR pattern %5.0f%s',bb(18),'%'));
text(0,.4,sprintf('EFPH %5.0f',bb_68));
axes('Position',[0.57, 0.75, 0.4, 0.2]);
set(gca,'visible','off');
fel=tipgam-tipmea;
fel(:,nomea)=[];
text(0,.8,sprintf('Overall stdev %3.1f%s',100*std(fel(:)),'%'));
text(0,.7,sprintf('Rad stdev %3.1f%s',100*std(mean(fel)),'%'));
text(0,.6,sprintf('Ax stdev %3.1f%s',100*std(mean(fel')),'%'));
%
% SS-karta
%
axes('Position',[0.12, 0.52, 0.33, 0.25]);
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
%
% Radiell karta
%
axes('Position',[0.57, 0.52, 0.33, 0.25]);
[hsc,hcont]=plotcont(gca,mminj);
delete(hsc);
set(gca,'visible','off');
set(hcont,'color','blu');
line([mminj(1) lm+2-mminj(1)],[1 1],'color','blu')
line([mminj(1) lm+2-mminj(1)],[lm+1 lm+1],'color','blu')
line([1 1],[mminj(1) lm+2-mminj(1)],'color','blu')
line([lm+1 lm+1],[mminj(1) lm+2-mminj(1)],'color','blu')
axis([1 1+mz(12) 1 1+mz(12)]);
for i=1:nsond
  j=find(detpos==i);
  yx=knum2cpos(j(1),mminj);
  diff=mean(tipgam(:,i)-tipmea(:,i));
  if mean(tipmea(:,i))>0
    text(yx(2)-1.0,mz(12)-yx(1)+1,sprintf('%3.0f',diff*100),'fontname','courier');
  else
    text(yx(2),mz(12)-yx(1)+1,sprintf('***'));
  end
end
%
% POLCA-TIP
%
axes('Position',[0.12, 0.1, 0.33, 0.35]);
plot(100*(mean(tipgam(:,meas)')-mean(tipmea(:,meas)')),1:nnod);
axis([-15 15 1 nnod]);
title('POLCA-TIP');
hold on
plot(zeros(1,nnod),1:nnod);
%
% Axiell medelfördelning
%
axes('Position',[0.57, 0.1, 0.33, 0.35]);
plot(mean(tipmea(:,meas)')*100,1:nnod);
hold on
plot(mean(tipgam(:,meas)')*100,1:nnod,'--');
tit=['-- TIP - - - POLCA '];
title(tit);
axis([0 200 1 nnod]);
%print -dps tip1
temp1=num2str(1); % Skapar en sträng av nummret
temp2='tip';       % Namn man ska spara med
temp3=[temp2 temp1];   % Sammansatt namn och nummer
print(temp_handle,'-dps',temp3); % Sparar filen.

% Bilagan som editeras av Autotip_XP för att passa in i Word.
%print -deps bilaga1
temp1=num2str(1); % Skapar en sträng av nummret
temp2='bilaga';       % Namn man ska spara med
temp3=[temp2 temp1];   % Sammansatt namn och nummer
print(temp_handle,'-deps',temp3); % Sparar filen.
%
%
% Enskilda TIPar
%
temp_handle2=figure;
set(gcf,'paperposition',[1.25 2.5 20 25]);
tipsub=tipsub(1:nsond);
if ~isempty(nomea),tipsub(nomea)=zeros(length(nomea));end
for i=1:ntip
  subplot(2,2,i);
  t=find(tipsub==i);
  plot((mean(tipgam(:,t)')-mean(tipmea(:,t)'))*100,1:nnod);
  hold on
  plot([0 0],[1 nnod]);
  axis([-15 15 1 nnod]);
  tit=sprintf('TIP %i POLCA-TIP',i);
  title(tit);
end
% Används om man vill ha den gamla utskriften.
% print -dps tip2
temp1=num2str(2); % Skapar en sträng av nummret
temp2='tip';       % Namn man ska spara med
temp3=[temp2 temp1];   % Sammansatt namn och nummer
print(temp_handle2,'-dps',temp3); % Sparar filen.

% Bilagan som editeras av Autotip_XP för att passa in i Word.
% print -deps bilaga3
temp1=num2str(3); % Skapar en sträng av sondnummret
temp2='bilaga';       % Namn man ska spara med
temp3=[temp2 temp1];   % Sammansatt namn och nummer
print(temp_handle2,'-deps',temp3); % Sparar filen.
%
%
% Enskilda sonder
%
l=1;
jj=2;
for i=1:nsond
  if (i-1)/12 == round((i-1)/12)
    temp_handle3=figure;
    set(gcf,'paperposition',[1.25 2.5 20 25]);
    ii=1;
    jj=jj+1;
  end
  subplot(3,4,ii);
  ii=ii+1;
  plot(tipmea(:,i),1:nnod);
  hold on
  plot(tipgam(:,i),1:nnod,'--');
  axis([0 2 1 nnod]);
  tit=sprintf('Sond %i TIP %i',i,tipsub(i));
  j=find(detpos==i);
  ikan=filtcr(konrod,mminj,0,99);
  ikan=reshape(ikan,1,size(ikan,1)*size(ikan,2));
  c=findint(j,ikan);
  if ~isempty(find(c))
    yx=knum2cpos(ikan(c(find(c))),mminj);
    yx=cpos2crpos(yx,mminj);
    crnum=crpos2crnum(yx,mminj);
    cr=sort(konrod(crnum));
    for j=1:length(cr)
      plot([j/10 j/10 j/10+.03 j/10+.03],[1 (1000-cr(j))*nnod/1000 (1000-cr(j))*nnod/1000 1]);
    end
  end
title(tit);
    % Används om man vill ha den gamla utskriften.
    if ii==13|i==nsond
    % evstr=sprintf('print -dps tip%i',jj);
    % eval(evstr);
    temp1=num2str(jj); % Skapar en sträng av sondnummret
    temp2='tip';       % Namn man ska spara med
    temp3=[temp2 temp1];   % Sammansatt namn och sondnummer
    print(temp_handle3,'-dps',temp3); % Sparar filen.
    %sparade filer JKA:
    if l==1
    % Bilagan som editeras av Autotip_XP för att passa in i Word.
    % evstr2=sprintf('print -deps bilaga4_1',jj);
    % eval(evstr2);
    temp1=num2str(1); % Skapar en sträng av sondnummret
    temp2='bilaga4_';       % Namn man ska spara med
    temp3=[temp2 temp1];   % Sammansatt namn och sondnummer
    print(temp_handle3,'-deps',temp3); % Sparar filen.
    end
    if l==2
    % Bilagan som editeras av Autotip_XP för att passa in i Word.
    % evstr2=sprintf('print -deps bilaga4_2',jj);
    % eval(evstr2);
    temp1=num2str(2); % Skapar en sträng av sondnummret
    temp2='bilaga4_';       % Namn man ska spara med
    temp3=[temp2 temp1];   % Sammansatt namn och sondnummer
    print(temp_handle3,'-deps',temp3); % Sparar filen.
    end
    if l==3
    % Bilagan som editeras av Autotip_XP för att passa in i Word.
    % evstr2=sprintf('print -deps bilaga4_3',jj);
    % eval(evstr2);
    temp1=num2str(3); % Skapar en sträng av sondnummret
    temp2='bilaga4_';       % Namn man ska spara med
    temp3=[temp2 temp1];   % Sammansatt namn och sondnummer
    print(temp_handle3,'-deps',temp3); % Sparar filen.
    end
    if l==4
    % Bilagan som editeras av Autotip_XP för att passa in i Word.
    % evstr2=sprintf('print -deps bilaga4_4',jj);
    % eval(evstr2);
    temp1=num2str(4); % Skapar en sträng av sondnummret
    temp2='bilaga4_';       % Namn man ska spara med
    temp3=[temp2 temp1];   % Sammansatt namn och sondnummer
    print(temp_handle3,'-deps',temp3); % Sparar filen.
    end
    if l==5
    % Bilagan som editeras av Autotip_XP för att passa in i Word.
    % evstr2=sprintf('print -deps bilaga4_5',jj);
    % eval(evstr2);
    temp1=num2str(5); % Skapar en sträng av sondnummret
    temp2='bilaga4_';       % Namn man ska spara med
    temp3=[temp2 temp1];   % Sammansatt namn och sondnummer
    print(temp_handle3,'-deps',temp3); % Sparar filen.
    end
    l=l+1;
    end
end
