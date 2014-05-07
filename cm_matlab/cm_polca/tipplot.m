%@(#)   tipplot.m 1.8	 99/11/23     13:52:07
%
%function tipplot(tipfil,tip_infofil)
% om tip_infofil ej anges sätts ordinarie tip_infofil som default
function tipplot(tipfil,tip_infofil)

if nargin<2
  reakdir=findreakdir;
  tip_infofil=[reakdir,'fil/tip-info.txt'];
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
figure;
axes('Position',[0.12, 0.75, 0.4, 0.2]);
set(gcf,'paperposition',[1 2 20 25]);
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
print -dps tip1
%
% Enskilda TIPar
%
figure;
set(gcf,'paperposition',[1 2 20 25]);
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
print -dps tip2
%
% Enskilda sonder
%
jj=2;
for i=1:nsond
  if (i-1)/12 == round((i-1)/12)
    figure;
    set(gcf,'paperposition',[1 2 20 25]);
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
  if ii==13|i==nsond
    evstr=sprintf('print -dps tip%i',jj);
    eval(evstr);
  end
end
a=[];
a=input('Till skrivare <n>/j/skrivarnamn ','s');
for i=1:jj
  fil=sprintf('tip%i.ps',i);
  if strcmp(a,'j')|strcmp(a,'J')
    evstr=sprintf('!lpr %s',fil);
    eval(evstr);
  elseif isempty(a)|strcmp(a,'n')|strcmp(a,'N')
    break
  else
    evstr=sprintf('!lpr -P %s %s',a,fil);
    eval(evstr);
  end
  evstr=sprintf('!rm %s',fil);
  eval(evstr);
end
