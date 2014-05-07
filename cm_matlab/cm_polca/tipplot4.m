%@(#)   tipplot4.m 1.1	 99/05/19     10:06:24
%
%function tip_utan_top(tipfil)
%okvalitetssäkrad
function tip_utan_top(tipfil)
reakdir=findreakdir;
tip_infofil=[reakdir,'fil/tip-info.txt'];
tipgam=[];
tipneu=[];
[tipmea,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist...
,staton,masfil,rubrik,detpos,fu]=readdist(tipfil,'tipmea');
ni=bucatch('TIPNEU',distlist);
gi=bucatch('TIPGAM',distlist);
if (isempty(ni) & isempty(gi)),error(['Neither TIPGAM nor TIPNEU exists on ' tipfil]);end
if (~isempty(ni) & ~isempty(gi)),error(['Both TIPGAM and TIPNEU exists on ' tipfil]);end
if ~isempty(ni),tipneu=readdist(tipfil,'tipneu');end
if ~isempty(gi),tipgam=readdist(tipfil,'tipgam');end
nnod=mz(4);
if ~isempty(tipneu),tipgam=tipneu;end
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
% Text
%
figure;
subplot(3,2,1)
set(gcf,'paperposition',[.5 1 8 10]);
set(gca,'visible','off');
text(0,1,sprintf(rubrik));
text(0,.8,sprintf('Power %5.1f%s',100*bb(1),'%'));
text(0,.7,sprintf('HC-flow %5.0f kg/s',bb(2)));
text(0,.6,sprintf('Temp %5.1f',bb(10)));
text(0,.5,sprintf('CR pattern %5.0f%s',bb(65),'%'));
text(0,.4,sprintf('Average core burnup %5.0f%s',bb(89),'MWd/tU'));
subplot(3,2,2)
set(gca,'visible','off');
fel=tipgam-tipmea;
fel(:,nomea)=[];
text(0,.8,sprintf('Overall stdev %3.1f%s',100*std(fel(:)),'%'));
text(0,.7,sprintf('Rad stdev %3.1f%s',100*std(mean(fel)),'%'));
text(0,.6,sprintf('Ax stdev %3.1f%s',100*std(mean(fel')),'%'));
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
%
% Radiell karta
%
subplot(3,2,4);
[hsc,hcont]=plotcont(gca,mminj);
delete(hsc);
set(gca,'visible','off');
set(hcont,'color','blu');
line([mminj(1) lm+2-mminj(1)],[1 1],'color','blu')
line([mminj(1) lm+2-mminj(1)],[lm+1 lm+1],'color','blu')
line([1 1],[mminj(1) lm+2-mminj(1)],'color','blu')
line([lm+1 lm+1],[mminj(1) lm+2-mminj(1)],'color','blu')
axis([1 1+mz(3) 1 1+mz(3)]);


%FIX AV DETPOS-POLCA7 TILL POLCA4
yx1=knum2cpos(detpos,mminj);
yx2=zeros(size(yx1));
yx3=yx2;
yx4=yx2;
i=1:nsond;
yx2(i,1)=yx1(i,1);
yx2(i,2)=yx1(i,2)+1;
yx3(i,1)=yx1(i,1)+1;
yx3(i,2)=yx1(i,2);
yx4(i,1)=yx1(i,1)+1;
yx4(i,2)=yx1(i,2)+1;
knum1=cpos2knum(yx1,mminj);
knum2=cpos2knum(yx2,mminj);
knum3=cpos2knum(yx3,mminj);
knum4=cpos2knum(yx4,mminj);
detpos7=zeros(length(buntyp),1);
detpos7(knum1(i))=i;
detpos7(knum2(i))=i;
detpos7(knum3(i))=i;
detpos7(knum4(i))=i;
detpos=detpos7;
% SLUT PÅ FIXEN

for i=1:nsond
  j=find(detpos==i);
  yx=knum2cpos(j(1),mminj);
  diff=mean(tipgam(:,i)-tipmea(:,i));
  if mean(tipmea(:,i))>0
    text(yx(2)-1.0,mz(3)-yx(1)+1,sprintf('%3.0f',diff*100),'fontname','courier');
  else
    text(yx(2),mz(3)-yx(1)+1,sprintf('***'));
  end
end
%
% POLCA-TIP
%
subplot(3,2,5);
plot(100*(mean(tipgam(:,meas)')-mean(tipmea(:,meas)')),1:nnod);
hold on
plot(zeros(1,nnod),1:nnod);
title('POLCA-TIP')
axis([-20 20 1 25]);
%
% Axiell medelfördelning
%
subplot(3,2,6);
plot(mean(tipmea(:,meas)')*100,1:nnod);
hold on
plot(mean(tipgam(:,meas)')*100,1:nnod,'--');
tit=['-- TIP  - - POLCA '];
title(tit)
axis([0 200 1 25]);
print -dps tip1
%
% Enskilda TIPar
%
figure;
set(gcf,'paperposition',[0.5 1 8 10]);
tipsub=tipsub(1:nsond);
if ~isempty(nomea),tipsub(nomea)=zeros(length(nomea));end
for i=1:ntip
  subplot(2,2,i);
  t=find(tipsub==i);
  plot((mean(tipgam(:,t)')-mean(tipmea(:,t)'))*100,1:nnod);
  hold on
  plot([0 0],[1 nnod]);
  axis([-20 20 1 25]);
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
    set(gcf,'paperposition',[.5 1 8 10]);
    ii=1;
    jj=jj+1;
  end
  subplot(3,4,ii);
  ii=ii+1;
  plot(tipmea(:,i),1:nnod);
  hold on
  plot(tipgam(:,i),1:nnod,'--');
  axis([0 2 1 25]);
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
a=input('Till skrivare j/<n>','s');
for i=1:jj
  fil=sprintf('tip%i.ps',i);
  if strcmp(a,'j')|strcmp(a,'J')
    evstr=sprintf('!lpr %s',fil);
    eval(evstr);
  end
  evstr=sprintf('!rm %s',fil);
  eval(evstr);
end
