%@(#)   evalpolca7.m 1.4	 10/07/26     10:15:16
%
%function [cycles,efph,efphc,keff,keffc,nod,nodc,rad,radc,ax,axc,chdev,chdevc,keffcc,chflow,chmeas]=evalpolca7(tipfil,skip,skip2)
%Evaluates performance of CASMO4/POLCA7 based on tip-distribution files
%Input: tipfil - Name of file that contains a listing of tipfiles to
%                be used in evaluation (default= /cm/xx/div/multicycle/tipfiler)
%                Other files that are used: /cm/xx/div/multicycle/ccsumfiler
%                                           /cm/xx/cy/tip/flow-??????.txt (When flow-measurements exist)
%Output cycles - Name of cycles processed
%       efph   - EFPH for each TIP
%       efphc  - accumulated efph per cycle
%       keff   - keff for each tip-evaluation
%       keffc  - mean keff for each cycle
%       nod    - Nodal deviation (rms and max) for each tip-evaluation
%       nodc   - Nodal deviation mean, max and min for each cycle
%       rad    - Radial deviation (rms and max) for each tip-evaluation
%       radc   - Radial deviation mean, max and min for each cycle
%       ax     - Axial deviation (rms and max) for each tip-evaluation
%       axc    - Axial deviation mean, max and min for each cycle
%       chdev  - channel flow deviation (Calc.-Meas) for each TIP
%       chdevc - channel flow deviation (Rms, minmax and difference of sum(flow) in %) for each cycle
%       keffcc - Cold critical measurements for each cycle (mean and rms)
function [cycles,efph,efphc,keff,keffc,nod,nodc,rad,radc,ax,axc,chdev,chdevc,keffcc,chflow,chmeas]=evalpolca7(tipfil,skip,skip2)
dev=[];keff=[];pow=[];hc=[];efph=[];
reakdir=findreakdir;
ii=find(reakdir=='/');
unit=reakdir(ii(2)+1:ii(3)-1);
if nargin<1,
  [tipfiles,nc,cycles,efphc]=readtipfiles([reakdir,'div/multi/tipflw']);
else
  [tipfiles,nc,cycles,efphc]=readtipfiles(tipfil);
end
if nargin<2,skip=0;end
if nargin<3,skip2=0;end
date=tip2date(tipfiles);
chmeas=readtipflowmeas(tipfiles);
chflow=0*chmeas;
sumfiles=findsumcycle(cycles,readtipfiles([reakdir,'div/multi/ccsumfiler']));
gsumfiles=findsumcycle(cycles,readtipfiles([reakdir,'div/multi/cgsumfiler']));
ic=length(nc)-1;
lu=length(unit);
unit=unit(lu-1:lu);
[chnum,knam]=flopos(unit);
[dum,ik]=ascsort(knam);
chnum=chnum(ik);
for i=1:ic,
  [dee,kef,emed,efp,keofp,po,h]=tipstat(tipfiles(nc(i):nc(i+1)-1,:),skip,skip2);
  for j=nc(i):nc(i+1)-1,
    [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist]=readdist7(tipfiles(j,:));
    if length(strmatch('CHFLOW',distlist))>0,
      ch=readdist7(tipfiles(j,:),'CHFLOW');
      chflow(j,:)=ch(chnum);
%      if length(strmatch('FLWWC',distlist))>0,
%        chf=readdist7(tipfiles(j,:),'FLWWC');
%        chflow(j,:)=chflow(j,:)+chf(chnum);
%      end
      if length(strmatch('FLWORI',distlist))>0,
        chf=readdist7(tipfiles(j,:),'FLWORI');
        chflow(j,:)=chf(chnum);
      end
    else
      chflow(j,:)=chmeas(j,:);
    end
  end
  keffc(i,:)=[mean(kef) rms(kef-mean(kef))];
  rmde=0*dee;
  if size(dee,1)>1,
    dm=mean(dee);
  else
    dm=dee;
  end
  for id=1:size(dee,2), rmde(:,id)=dee(:,id)-dm(id);end
  dev=[dev;dee];
  keofpc(i)=keofp;
  i0=nc(i);
  i1=nc(i+1)-1;
  nodc(i,:)=[mean(dev(i0:i1,1)) max(dev(i0:i1,1)) min(dev(i0:i1,1))];
  radc(i,:)=[mean(dev(i0:i1,3)) max(dev(i0:i1,3)) min(dev(i0:i1,3))];
  axc(i,:)=[mean(dev(i0:i1,5)) max(dev(i0:i1,5)) min(dev(i0:i1,5))];
  keff=[keff;kef];
  pow=[pow;po];
  hc=[hc;h];
  if i>1&i<ic,
    if max(efp)+efphc(i)>efphc(i+1),
      efph=[efph;efphc(i-1)+efp];
      disp(['Warning! Assuming that no new fuel is loaded ',cycles(i,:)]);
    else    
      efph=[efph;efphc(i)+efp];
    end
  else
    efph=[efph;efphc(i)+efp];
  end
 if length(remblank(sumfiles(i,:)))>0,
%    [dum,cckeff]=readsum(remblank(sumfiles(i,:)));
    ccsum=sum2mlab7(setstr(remblank(sumfiles(i,:))));
    cckeff=ccsum(14,:);
  else
    cckeff=0;
  end
  if length(remblank(gsumfiles(i,:)))>0
    cgsum=sum2mlab7(setstr(remblank(gsumfiles(i,:))));
    cgkeff=cgsum(14,:);
  else
    cgkeff=0;
  end
  chde=chflow(i0:i1,:)-chmeas(i0:i1,:);
  ich=find(max(abs(chde'))>0&max(chmeas(i0:i1,:)')>0);
  chdev(i0:i1,:)=zeros(i1-i0+1,3);
  for j=1:length(ich),
    chdev(nc(i)-1+ich(j),:)=[std(chde(ich(j),:)),minmax(chde(ich(j),:)',0)',100*sum(chde(ich(j),:))/(sum(chmeas(nc(i)-1+ich(j),:))+1d-9)];
  end
  lich=length(ich)+eps;
  chdevc(i,:)=[sum(chdev(i0:i1,1))/lich minmax(chdev(i0:i1,2),0) sum(chdev(i0:i1,3))/lich];
  prievalcyc(unit,cycles(i,:),date(i0:i1,:),pow(i0:i1),keff(i0:i1),dev(i0:i1,:),efph(i0:i1),hc(i0:i1),chdev(i0:i1,:),efphc(i),cckeff);
  keffcc(i,:)=[mean(cckeff) rms(cckeff-mean(cckeff))];
  globkeff(i)=cgkeff;
  disp(['Cycle ',remblank(cycles(i,:)),' processed']);
end
prievaltot(unit,cycles,keffcc,globkeff,keffc,keofpc,nodc,radc,axc,chdevc);
nod=dev(:,1:2);
rad=dev(:,3:4);
ax=dev(:,5:6);
minef=floor(min(efph)/1000)*1000;
maxef=ceil(max(efph)/1000)*1000;
kaxx=[minef maxef min(floor(1000*min(keff))/1000,0.99) max(ceil(1000*max(keff))/1000,1.01)];
ploteval(unit,cycles,keffc,efphc,keff,efph,'K-eff',kaxx);
hold on; a=axis;plot(efphc,keffcc,'o');plot(efphc,globkeff,'+');axis(a);
text(-.02*a(1)+.3*a(2),a(3)+.95*(a(4)-a(3)),' x - Hot at TIP');
text(-.02*a(1)+.3*a(2),a(3)+.90*(a(4)-a(3)),' o - Cold local at BOC');
text(-.02*a(1)+.3*a(2),a(3)+.85*(a(4)-a(3)),' + - Cold global at BOC');
zz=zeros(1,length(efphc));

kaxx=[minef maxef min(floor(1000*min(keffcc(:,1)))/1000,0.98) max(ceil(1000*max(keffcc(:,1)))/1000,1.01)];
ploteval(unit,cycles,zeros(length(efphc),1),efphc,zeros(length(efph),1),efph,'Cold keff',kaxx); hold on
plot(efphc,keffcc,'o');plot(efphc,globkeff,'+');%axis(a);
%figure;plot(efphc,keffcc,'o');hold on;plot(efphc,globkeff,'+');axis(a);
for i=1:length(efphc)
  z=[keffcc(i,1)-keffcc(i,2) keffcc(i,1)+keffcc(i,2)];
  plot([efphc(i) efphc(i)],z)
end
text(-.02*a(1)+.3*a(2),a(3)+.95*(a(4)-a(3)),' | - Std dev at cold local');
text(-.02*a(1)+.3*a(2),a(3)+.90*(a(4)-a(3)),' o - Cold local at BOC');
text(-.02*a(1)+.3*a(2),a(3)+.85*(a(4)-a(3)),' + - Cold global at BOC');

Naxx=[minef maxef 0 max(12,ceil(max(nod(:,1))))];
ploteval(unit,cycles,nodc,efphc,nod(:,1),efph,'Nodal dev.',Naxx);
Raxx=[minef maxef 0 max(8,ceil(max(rad(:,1))))];
ploteval(unit,cycles,radc,efphc,rad(:,1),efph,'Radial dev.',Raxx);
Aaxx=[minef maxef 0 max(10,ceil(max(ax(:,1))))];
ploteval(unit,cycles,axc,efphc,ax(:,1),efph,'Axial dev.',Aaxx);
Faxx=[minef maxef 0 max(1,ceil(max(chdev(:,1))))];
ploteval(unit,cycles,chdevc,efphc,chdev(:,1),efph,'Flow diff RMS [kg/s]',Faxx);
