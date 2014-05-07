%@(#)   arsplot.m 1.2	 97/11/03     10:40:20
%
%function arsplot(lngfile1,lngfile2,sumfil1,sumfil2);
function arsplot(lngfile1,lngfile2,sumfil1,sumfil2);
[logdata1,status]=readlngsum(lngfile1);
i=find(status(10,:)==1);
if i~=[],logdata1(12,i)=zeros(size(i));end
i=find(status(12,:)==1);
if i~=[],logdata1(14,i)=50*ones(size(i));end
[logdata2,status]=readlngsum(lngfile2);
i=find(status(10,:)==1);
if i~=[],logdata2(12,i)=zeros(size(i));end
i=find(status(12,:)==1);
if i~=[],logdata2(14,i)=50*ones(size(i));end
i=find(logdata1(2,:)==1);
if i~=[],tmp1=logdata1(:,i(1):size(logdata1,2));end
i=find(logdata2(2,:)==1);
if i~=[],tmp2=logdata2(:,1:i(1)-1);end
logdata=[tmp1 tmp2];
s1=sum2mlab(sumfil1);
i=find(s1(5,:)==1);
if i~=[],tmp1=s1(:,i(1):size(s1,2));end
s2=sum2mlab(sumfil2);
i=find(s2(5,:)==1);
if i~=[],tmp2=s2(:,1:i(1)-1);end
sumdata=[tmp1 tmp2];
for i=2:12
  j1=find(logdata(2,:)==(i-1));
  j2=find(logdata(2,:)==i);
  j1=j1(1);
  j2=j2(1)-1;
  shf(i-1)=max(logdata(12,j1:j2));
  marg(i-1)=min(logdata(14,j1:j2));
  j1=find(sumdata(5,:)==(i-1));
  j2=find(sumdata(5,:)==i);
  j1=j1(1);
  j2=j2(1)-1;
  burn(i-1)=max(sumdata(7,j1:j2));
end
j1=find(logdata(2,:)==11);
j2=size(logdata,2);
shf(12)=max(logdata(12,j1:j2));
marg(12)=min(logdata(14,j1:j2));
j1=find(sumdata(5,:)==11);
j2=size(sumdata,2);
burn(12)=max(sumdata(7,j1:j2));
figure
subplot(3,1,1)
plot(.5:1:11.5,marg,'x')
set(gca,'yscale','log')
grid
set(gca,'xtick',1:12)
set(gca,'fontname','courier')
set(gca,'xticklabel',['JAN    ';'FEB    ';'MAR    ';'APR    ';'MAJ    ';'JUN    ';'JUL    ';'AUG    ';'SEP    ';'OKT    ';'NOV    ';'DEC    '])
ylabel('%')
title('Min termisk marginal under 1995')
subplot(3,1,2)
plot(.5:1:11.5,shf,'x')
grid
set(gca,'xtick',1:12)
set(gca,'fontname','courier')
set(gca,'xticklabel',['JAN    ';'FEB    ';'MAR    ';'APR    ';'MAJ    ';'JUN    ';'JUL    ';'AUG    ';'SEP    ';'OKT    ';'NOV    ';'DEC    '])
ylabel('W/cm2')
title('Max SHF under 1995')
subplot(3,1,3)
plot(.5:1:11.5,burn,'x')
grid
set(gca,'xtick',1:12)
set(gca,'fontname','courier')
set(gca,'xticklabel',['JAN    ';'FEB    ';'MAR    ';'APR    ';'MAJ    ';'JUN    ';'JUL    ';'AUG    ';'SEP    ';'OKT    ';'NOV    ';'DEC    '])
ylabel('MWd/TU')
title('Max medelutbranning under 1995')
set(gcf,'paperpos',[.4 1.5 8 9])
