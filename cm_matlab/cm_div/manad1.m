%@(#)   manad1.m 1.9	 06/01/04     09:57:26
%
%function manad1(block,manad)
%
%ex. manad1('f2','1996-08-01')
function manad1(block,manad)
%mvec=['    JAN';'    FEB';'    MAR';'    APR';'    MAJ';'    JUN';'    JUL';'    AUG';'    SEP';'    OKT';'    NOV';'    DEC'];
mvec=['JAN    ';'FEB    ';'MAR    ';'APR    ';'MAJ    ';'JUN    ';'JUL    ';'AUG    ';'SEP    ';'OKT    ';'NOV    ';'DEC    '];
dagar=[31 28 31 30 31 30 31 31 30 31 30 31];
ar=manad(1:4);
man=manad(6:7);
plotstart=dat2tim([str2num(ar)-1 str2num(man)+1 1 00 00])-1/720;
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
while logstart > plotstart
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
i=find(status(1,:)~=0);if ~isempty(i),logdata(:,i)=[];end
sz=size(logdata);
ind=1;
xt=[];
xl=[];
for i=1:sz(2)
  logtid=dat2tim([logdata(1,i) logdata(2,i) logdata(3,i) logdata(4,i) logdata(5,i)]);
  if (logtid > plotstart) & (logtid < plotstop)
    x(ind)=logtid;
    y(ind)=logdata(8,i);
    ind=ind+1;
  end
end
plot(x,y)
xt=dagar(1);
mstart=str2num(man);
for i=1:12
  if i<12,
    xt=[xt dagar(i+1)+xt(i)];
  end
  if mstart+i==13,mstart=mstart-12;end
  xl=[xl;mvec(mstart+i,:)];
end
sx=plotstop-plotstart;
xt=xt/365*sx+plotstart;
set(gca,'xlim',[plotstart plotstop])
set(gca,'ylim',[0 110])
set(gca,'xtick',xt)
set(gca,'xticklabel',xl)
set(gca,'fontname','courier')
ylabel('Reaktoreffekt (%)')
title(['Forsmark ' block(2) ' Drifthistorik de senaste 12 manaderna'])
ht=get(gca,'title');
set(ht,'fontsize',16);
set(gcf,'paperorientation','landscape');
set(gcf,'paperposition',[0.025 2.5 22.5 15]);
print -dps tmp1;
