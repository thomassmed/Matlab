%@(#)   lhcheck.m 1.3	 05/12/08     13:21:49
%
%function lhcheck(fil)
function lhcheck(fil)
x=[26500       60000];
% Andra har nar du vill kolla!
%                Har v
y=[100000     67600]/2.6;
%TMOL:
ymol=[108000    67600]/2.6;
xmol=[10000 60000];
p=polyfit(x,y,1);
[lhgr,mminj,konrod]=readdist7(fil,'lhgr');
ikan=filtcr(konrod,mminj,5,98);
ika=[ikan(:,1);ikan(:,2);ikan(:,3);ikan(:,4)];
burn=readdist7(fil,'burnup');
test=100*(p(1)*burn+p(2)-lhgr)./lhgr;
[test,imin]=min(test);
for i=1:length(ika),
  burn10(i)=burn(imin(ika(i)),ika(i));
  lhgr10(i)=lhgr(imin(ika(i)),ika(i));
end
figure('position',upleft);
plot(x,y);
hold on
plot(xmol,ymol,'--');
plot(burn10,lhgr10,'x')
hold off
mmult=zeros(1,size(burn,2));
mmult(ikan)=ones(size(ikan));
%test=test(14,:);
test=mmult.*test;
distplot(fil,'test',upright,test);
setprop(3,'colormap(flipud(jett))');
setprop(6,'min');
setprop(7,'-10');
setprop(8,'40');
setprop(9,'yes');
ccplot(test);
mmult=zeros(size(lhgr));
mmult(:,ika)=ones(size(lhgr,1),length(ika));
lhgr=mmult.*lhgr;
distplot(fil,'lhgr',loleft,lhgr);
setprop(6,'max');
setprop(7,'30000');
setprop(8,'40000');
setprop(9,'yes');
ccplot(lhgr);
