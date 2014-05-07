%@(#)   manad3.m 1.10	 08/09/03     10:36:29
%
%function manad3(block,manad)
%
%ex. manad3('f2','1996-08')
function manad3(block,manad)
y1(1)=0;y2(1)=0;y3(1)=0;
block=lower(block);
mvec=[' JANUARI ';'FEBRUARI ';'  MARS   ';'  APRIL  ';'  MAJ    ';'  JUNI   ';'  JULI   ';' AUGUSTI ';'SEPTEMBER';' OKTOBER ';'NOVEMBER ';'DECEMBER '];
ar=manad(1:4);
man=manad(6:7);
plotstart=dat2tim([str2num(ar) str2num(man) 1 00 00]);
plotstop=dat2tim([str2num(ar) str2num(man)+1 1 00 00]);
cyc=year2cyc(block,ar);
if isempty(cyc),ar=num2str(str2num(ar)-1);cyc=year2cyc(block,ar);end
for i=1:size(cyc,1)
  fil=['/cm/' block '/' cyc(i,:) '/lng/sum-data.dat'];
  if i==1;[logdata,status]=lngsum2mlab(remblank(fil));end
  if i>1;
    [l,s]=lngsum2mlab(remblank(fil));
    logdata=[logdata l];
    status=[status s];
  end
end
logstart=dat2tim([logdata(1,1) logdata(2,1) logdata(3,1) logdata(4,1) logdata(5,1)]);
while logstart > (plotstart - 1/720)
  ar=num2str(str2num(ar)-1);
  cyc=year2cyc(block,ar);
  for i=size(cyc,1):-1:1
    fil=['/cm/' block '/' cyc(i,:) '/lng/sum-data.dat'];
    [l,s]=lngsum2mlab(remblank(fil));
    logdata=[l logdata];
    status=[s status];
    logstart=dat2tim([logdata(1,1) logdata(2,1) logdata(3,1) logdata(4,1) logdata(5,1)]);
  end
end
sz=size(logdata);
ind=2;
xt=[];
xl=[];
for i=1:sz(2)
  logtid=dat2tim([logdata(1,i) logdata(2,i) logdata(3,i) logdata(4,i) logdata(5,i)]);
  if (logtid >= plotstart) & (logtid < plotstop)
    if logdata(3,i-1) ~= logdata(3,i)
      xt=[xt logtid];
    end
    if ind==2,mname=mvec(logdata(2,i),:);end
    x(ind)=logtid;
    if status(1,i)==0, y1(ind)=logdata(8,i);else y1(ind)=y1(ind-1);end
    if status(2,i)==0, y2(ind)=logdata(9,i);else y2(ind)=y2(ind-1);end
    if status(7,i)==0, y3(ind)=logdata(14,i);else y3(ind)=y3(ind-1);end
    ind=ind+1;
  end
end
dat=tim2dat(x(ind-1));
dat(4:5)=[23 59];
x(ind)=dat2tim(dat);
y1(ind)=y1(ind-1);
y2(ind)=y2(ind-1);
y3(ind)=y3(ind-1);
x(1)=dat2tim([dat(1:2) 1 0 0]);
y1(1)=y1(2);
y2(1)=y2(2);
y3(1)=y3(2);
subplot(3,1,1)
plot(x,y1)
set(gca,'xlim',[min(x) max(x)])
set(gca,'ylim',[0 120])
set(gca,'xtick',xt)
set(gca,'xticklabel',xl)
set(gca,'fontname','courier')
xlabel(mname)
ylabel('%')
title('260KM907 Reaktoreffekt')
subplot(3,1,2)
plot(x,y2)
set(gca,'xlim',[min(x) max(x)])
set(gca,'ylim',[0 12000])
%set(gca,'ytick',[0 100 200 300 400 500 600])
set(gca,'xtick',xt)
set(gca,'xticklabel',xl)
set(gca,'fontname','courier')
xlabel(mname)
title('260KM036 HC-flöde')
ylabel('kg/s')
set(gcf,'paperposition',[.62 1.25 20 22.5])
subplot(3,1,3)
plot(x,y3)
hold on
plot(x,zeros(1,ind),'--')
set(gca,'xlim',[min(x) max(x)])
set(gca,'ylim',[-10 50])
%set(gca,'ytick',[0 100 200 300 400 500 600])
set(gca,'xtick',xt)
set(gca,'xticklabel',xl)
set(gca,'fontname','courier')
xlabel(mname)
title('260KM904 Min termisk marginal')
ylabel('%')
set(gcf,'paperposition',[.62 1.25 20 28.5])
print -dps tmp3;
