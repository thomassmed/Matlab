%@(#)   tmolcheck.m 1.10	 96/06/19     12:46:06
%
%function tmolcheck(filvec,buntypvec,flpdmat,X)
%
%ex.
%for i=1:13
%  filvec(i,:)=sprintf('%6s%2i','distr-',i);
%end
%buntypvec=['G091';'E091'];
%flpdmat=[1.00 .997 .962 .925 .867 10000
%         1.00 .997 .962 .925 .867 20000
%         1.00 1.00 .966 .921 .883 22000
%         1.00 1.00 .965 .917 .000 24000
%         1.00 1.00 .963 .000 .000 25000
%         1.00 1.00 .961 .000 .000 26000
%
%         1.00 .997 .962 .926 .888 10000
%         1.00 .997 .962 .926 .888 20000
%         1.00 1.00 .966 .922 .884 22000
%         1.00 1.00 .966 .918 .000 24000
%         1.00 1.00 .964 .000 .000 25000
%         1.00 1.00 .963 .000 .000 26000];
%X=[0 2000 4000 6000 8000];
function tmolcheck(filvec,buntypvec,flpdmat,X)
straff=1;
if nargin==1,straff=0;end
x=[10000   60000];
y=[41.500  26.000];
%ymol=[41.500 41.500 26.000];
%xmol=[0      10000  60000];
%ymol100=[40.00 32.000 21.500];
%xmol100=[0      18000  60000];
tsly=[41.50  25.4   21.000];
tslx=[0      37000  58000];
p=polyfit(x,y,1);
if straff==1,nbu=size(flpdmat,1)/size(buntypvec,1);end
figure('position',upleft);
for k=1:size(filvec,1)
  fil=remblank(filvec(k,:));
  [lhgr,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist(fil,'lhgr');
  lhgr=lhgr/1000;
  ikan=filtcr(konrod,mminj,0,98);
  if size(ikan,1)~=0
    ika=[ikan(:,1);ikan(:,2);ikan(:,3);ikan(:,4)];
    burn=readdist(fil,'burnup');
    buntyp=readdist(fil,'buntyp');
    if k==1,burnboc=burn;end
    test=100*(p(1)*burn+p(2)-lhgr)./lhgr;
    [test,imin]=min(test);
    for i=1:length(ika),
      if straff==1,j=findstring(buntyp(ika(i),:),buntypvec);else j=1;end
      if j~=[],
        burn10(i)=burn(imin(ika(i)),ika(i));
        lhgr10(i)=lhgr(imin(ika(i)),ika(i));
        ssbur(i)=burn10(i)-burnboc(imin(ika(i)),ika(i));
        if straff==1,
          Y=flpdmat((j-1)*nbu+1:j*nbu,size(flpdmat,2));
          korr=interp2(X,Y,flpdmat((j-1)*nbu+1:j*nbu,1:size(flpdmat,2)-1)...
          ,ssbur(i),burnboc(imin(ika(i)),ika(i)));
          lhgr10(i)=lhgr10(i)/korr;
        end
      end
    end
    hold on
    axis([0 60000 0 50]);
%    plot(xmol,ymol,'--');
%    plot(xmol100,ymol100,'r--');
    plot(tslx,tsly,'--');
    plot(burn10,lhgr10,'x')
    xlabel('BURNUP (MWd/tU)')
    ylabel('LHGR (kW/m)')
    rub=sprintf('%s','Max LHGR inkl. straff i reglermoduler');
    title(rub);
%    text(4000,43,'TMOL SVEA64')
    text(4000,30,'TSL SVEA100')
  end
end
hold off
grid
