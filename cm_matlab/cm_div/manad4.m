%@(#)   manad4.m 1.3	 97/11/03     10:07:08
%
%function manad4(block,manad)
%
%ex. manad4('f2','1996-08')
function manad4(block,manad)
block=lower(block);
mvec=[' JANUARI ';'FEBRUARI ';'  MARS   ';'  APRIL  ';'  MAJ    ';'  JUNI   ';'  JULI   ';' AUGUSTI ';'SEPTEMBER';' OKTOBER ';'NOVEMBER ';'DECEMBER '];
ar=manad(1:4);
man=manad(6:7);
plotstart=dat2tim([str2num(ar) str2num(man) 1 00 00])-1/720;
plotstop=dat2tim([str2num(ar) str2num(man)+1 1 00 00]);
cyc=year2cyc(block,ar);
if (cyc==''),ar=num2str(str2num(ar)-1);cyc=year2cyc(block,ar);end
direc=['/cm/' block '/' cyc '/lng'];
evstr=['ls ' direc '/log-[1-9].txt'];
[s,files]=unix(evstr);
files=uxstr2mat(files);
evstr=['ls ' direc '/log-[1-9][0-9].txt'];
[s,f]=unix(evstr);
if f~=[]
  sf=size(files);
  files=[files 32*ones(sf,1)];
  f=uxstr2mat(f);
  files=[files;f];
end
ti=[];va=[];
for i=1:size(files,1)
  [time,val]=log2mlab(files(i,:),'321k801');
  ti=[ti;time];va=[va;val];
end
logstart=dat2tim([ti(1,1) ti(1,2) ti(1,3) ti(1,4) ti(1,5)]);
while logstart > plotstart
  ar=num2str(str2num(ar)-1);
  cyc=year2cyc(block,ar);
  direc=['/cm/' block '/' cyc '/lng'];
  evstr=['ls ' direc '/log-[1-9].txt'];
  [s,files]=unix(evstr);
  files=uxstr2mat(files);
  evstr=['ls ' direc '/log-[1-9][0-9].txt'];
  [s,f]=unix(evstr);
  if f~=[]
    f=uxstr2mat(f);
    sf=size(files);
    files=[files 32*ones(sf,1)];
    files=[files;f];
  end
  t=[];
  v=[];
  for i=1:size(files,1)
    [time,val]=log2mlab(files(i,:),'321k801');
    t=[t;time];v=[v;val];
  end
  ti=[t;ti];va=[v;va];
  logstart=dat2tim([ti(1,1) ti(1,2) ti(1,3) ti(1,4) ti(1,5)]);
end
lv=length(va);
ind=2;
xt=[];
xl=[];
for i=1:lv
  logtid=dat2tim([ti(i,1) ti(i,2) ti(i,3) ti(i,4) ti(i,5)]);
  if (logtid > plotstart) & (logtid < plotstop)
    if ti(i-1,3) ~= ti(i,3)
      xt=[xt logtid];
    end
    if ind==2,mname=mvec(ti(i,2),:);end
    x(ind)=logtid;
    y1(ind)=va(i);
    ind=ind+1;
  end
end
dat=tim2dat(x(ind-1));
dat(4:5)=[23 59];
x(ind)=dat2tim(dat);
y1(ind)=y1(ind-1);
x(1)=dat2tim([dat(1:2) 1 0 0]);
y1(1)=y1(2);
subplot(3,1,1)
plot(x,y1)
set(gca,'xlim',[min(x) max(x)])
set(gca,'ylim',[0 1])
set(gca,'ytick',[0 0.2 0.4 0.6 0.8 1.0])
set(gca,'xtick',xt)
set(gca,'xticklabel',xl)
set(gca,'fontname','courier')
xlabel(mname)
ylabel('uS/cm')
title('321K801 Konduktivitet primärkretsen')
%
% Plot nr 2
%
ar=manad(1:4);
man=manad(6:7);
x=[];
cyc=year2cyc(block,ar);
if (cyc==''),ar=num2str(str2num(ar)-1);cyc=year2cyc(block,ar);end
direc=['/cm/' block '/' cyc '/lng'];
evstr=['ls ' direc '/log-[1-9].txt'];
[s,files]=unix(evstr);
files=uxstr2mat(files);
evstr=['ls ' direc '/log-[1-9][0-9].txt'];
[s,f]=unix(evstr);
if f~=[]
  sf=size(files);
  files=[files 32*ones(sf,1)];
  f=uxstr2mat(f);
  files=[files;f];
end
ti=[];va=[];
for i=1:size(files,1)
  [time,val]=log2mlab(files(i,:),'321k803');
  ti=[ti;time];va=[va;val];
end
logstart=dat2tim([ti(1,1) ti(1,2) ti(1,3) ti(1,4) ti(1,5)]);
while logstart > plotstart
  ar=num2str(str2num(ar)-1);
  cyc=year2cyc(block,ar);
  direc=['/cm/' block '/' cyc '/lng'];
  evstr=['ls ' direc '/log-[1-9].txt'];
  [s,files]=unix(evstr);
  files=uxstr2mat(files);
  evstr=['ls ' direc '/log-[1-9][0-9].txt'];
  [s,f]=unix(evstr);
  if f~=[]
    f=uxstr2mat(f);
    sf=size(files);
    files=[files 32*ones(sf,1)];
    files=[files;f];
  end
  t=[];
  v=[];
  for i=1:size(files,1)
    [time,val]=log2mlab(files(i,:),'321k801');
    t=[t;time];v=[v;val];
  end
  ti=[t;ti];va=[v;va];
  logstart=dat2tim([ti(1,1) ti(1,2) ti(1,3) ti(1,4) ti(1,5)]);
end
lv=length(va);
ind=2;
xt=[];
xl=[];
for i=1:lv
  logtid=dat2tim([ti(i,1) ti(i,2) ti(i,3) ti(i,4) ti(i,5)]);
  if (logtid > plotstart) & (logtid < plotstop)
    if ti(i-1,3) ~= ti(i,3)
      xt=[xt logtid];
    end
    if ind==2,mname=mvec(ti(i,2),:);end
    x(ind)=logtid;
    y2(ind)=va(i);
    ind=ind+1;
  end
end
dat=tim2dat(x(ind-1));
dat(4:5)=[23 59];
x(ind)=dat2tim(dat);
y2(ind)=y2(ind-1);
x(1)=dat2tim([dat(1:2) 1 0 0]);
y2(1)=y2(2);
subplot(3,1,2)
plot(x,y2)
set(gca,'xlim',[min(x) max(x)])
set(gca,'ylim',[0 1])
set(gca,'ytick',[0 0.2 0.4 0.6 0.8 1.0])
set(gca,'xtick',xt)
set(gca,'xticklabel',xl)
set(gca,'fontname','courier')
xlabel(mname)
title('321K803 Sur konduktivitet primärkretsen');
ylabel('uS/cm')
set(gcf,'paperpos',[.25 .5 8 9])
%
% Plot nr 3
%
ar=manad(1:4);
man=manad(6:7);
x=[];
cyc=year2cyc(block,ar);
if (cyc==''),ar=num2str(str2num(ar)-1);cyc=year2cyc(block,ar);end
direc=['/cm/' block '/' cyc '/lng'];
evstr=['ls ' direc '/log-[1-9].txt'];
[s,files]=unix(evstr);
files=uxstr2mat(files);
evstr=['ls ' direc '/log-[1-9][0-9].txt'];
[s,f]=unix(evstr);
if f~=[]
  sf=size(files);
  files=[files 32*ones(sf,1)];
  f=uxstr2mat(f);
  files=[files;f];
end
ti=[];va=[];
for i=1:size(files,1)
  [time,val]=log2mlab(files(i,:),'521k083');
  ti=[ti;time];va=[va;val];
end
logstart=dat2tim([ti(1,1) ti(1,2) ti(1,3) ti(1,4) ti(1,5)]);
while logstart > plotstart
  ar=num2str(str2num(ar)-1);
  cyc=year2cyc(block,ar);
  direc=['/cm/' block '/' cyc '/lng'];
  evstr=['ls ' direc '/log-[1-9].txt'];
  [s,files]=unix(evstr);
  files=uxstr2mat(files);
  evstr=['ls ' direc '/log-[1-9][0-9].txt'];
  [s,f]=unix(evstr);
  if f~=[]
    f=uxstr2mat(f);
    sf=size(files);
    files=[files 32*ones(sf,1)];
    files=[files;f];
  end
  t=[];
  v=[];
  for i=1:size(files,1)
    [time,val]=log2mlab(files(i,:),'521k083');
    t=[t;time];v=[v;val];
  end
  ti=[t;ti];va=[v;va];
  logstart=dat2tim([ti(1,1) ti(1,2) ti(1,3) ti(1,4) ti(1,5)]);
end
lv=length(va);
ind=2;
xt=[];
xl=[];
for i=1:lv
  logtid=dat2tim([ti(i,1) ti(i,2) ti(i,3) ti(i,4) ti(i,5)]);
  if (logtid > plotstart) & (logtid < plotstop)
    if ti(i-1,3) ~= ti(i,3)
      xt=[xt logtid];
    end
    if ind==2,mname=mvec(ti(i,2),:);end
    x(ind)=logtid;
    y3(ind)=va(i);
    ind=ind+1;
  end
end
dat=tim2dat(x(ind-1));
dat(4:5)=[23 59];
x(ind)=dat2tim(dat);
y3(ind)=y3(ind-1);
x(1)=dat2tim([dat(1:2) 1 0 0]);
y3(1)=y3(2);
subplot(3,1,3)
plot(x,y3/1000)
set(gca,'xlim',[min(x) max(x)])
set(gca,'ylim',[0 1])
set(gca,'ytick',[0 0.2 0.4 0.6 0.8 1.0])
set(gca,'xtick',xt)
set(gca,'xticklabel',xl)
set(gca,'fontname','courier')
xlabel(mname)
title('521K083 Syrehalt primärkretsen')
ylabel('ppb(1000)')
print tmp4;
