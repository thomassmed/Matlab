%@(#)   xsec2mlab.m 1.2	 04/03/25     09:06:35
%
function  [d1,d2,sigr,siga1,siga2,nsf1,nsf2,ny,dd1,dd2,dsigr,dsiga1,dsiga2,dnsf1,dnsf2,dny]...
                      =xxsec2mstab(f_polca,power,void,f_master);

% [d1,d2,sigr,siga1,siga2,nsf1,nfs2,ny,dd1,dd2,dsigr,dsiga1,dsiga2,dnsf1,dnsf2,dn] ...
%                     =xxsec2mstab(f_polca,power,void,f_master);

[burnup,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,distlist,staton,masfil,rubrik,detpos,fu,au]...
                      =dist2mlab(f_polca,'burnup');

burn0=find(burnup==0);
burnup(burn0)=1; % burnup=0 is badly defined in the table
vhist=readdist(f_polca,'vhist');
sshist=readdist(f_polca,'sshist');
xenon=readdist(f_polca,'xenon');
fuerod=readdist(f_polca,'fuerod');
burc=readdist(f_polca,'burc');

if nargin == 3
  f_master=masfil;
end

buntyp=mast2mlab(f_master,86,'I');
dxsadr=mast2mlab(f_master,101,'I');
doxesh=mast2mlab(f_master,111,'F');
spacer=mast2mlab(f_master,82,'F');
xsec=mast2mlab(f_master,117,'F');
xsecad=mast2mlab(f_master,107,'I');
diffcr=mast2mlab(f_master,112,'F');
diffad=mast2mlab(f_master,102,'I');
thadr=mast2mlab(f_master,41,'I');
thdata=mast2mlab(f_master,81,'F');
spacad=mast2mlab(f_master,83,'I');

nfmax=mz(18);
empty=zeros(size(power));

crtyp=floor(fuerod/1000000);                 % Control rod type
%crold=crpre;
crpre=floor((fuerod-crtyp*1000000)/1000);    % Control rod withdrawel
notcr=not(crpre);
ftyp=fuerod-crtyp*1000000-floor(crpre*1000); % Fuel Type
chist=vhist+sshist;
tabpos=xsecad(ftyp);
satop=bb(20);
if burc~=-1
  erc=burc;
else
  erc=0*burnup;
end

cr=find(crpre);
crpre=crpre(cr);
z=mod(cr,mz(4));
cov=crpre/100;
fre=1-cov;
i0=find(z==1);
i25=find(z==mz(4));
ix=find(z>1 & z<mz(4));
der=zeros(size(cr));
der(i0)= (power(cr(i0 )+1)-power(cr(i0 )  ))/2;
der(i25)=(power(cr(i25)  )-power(cr(i25)-1))/2;
der(ix)= (power(cr(ix )+1)-power(cr(ix )-1))/4;
pss=power(cr)-der.*fre;
pns=power(cr)+der.*cov;
hvoid=0.01;
dvoid=void+hvoid;
tut=cell(8,1);
tutcr=cell(2,1);
dtut=cell(8,1);
dtutcr=cell(2,1);

for i=1:8
  tut{i}=empty;
  dtut{i}=empty;
end

for i=1:8
  tutcr{i}=empty;
  dtutcr{i}=empty;
end

for i=find(hist(ftyp(:),1:max(max(ftyp))));
  k=find(ftyp==i);
  tpos=xsecad(i);
  h=xsec(tpos+(0:6));
  xseck=xsec(tpos+(0:prod(h(1:4))+sum(h(2:4))+7));
  tutk=tabint(burnup(k),void(k),chist(k),xseck);
  dtutk=tabint(burnup(k),dvoid(k),chist(k),xseck);
  for j=1:8
    tut{j}(k)=tutk{j};
    dtut{j}(k)=dtutk{j};
  end
  if any(crtyp(k))
    crk=find(crtyp(k));
    tpos=diffad(i+nfmax*(crtyp(k(crk(1)))-1));
    h=diffcr(tpos+(0:6));
    diffcrk=diffcr(tpos+(0:prod(h(1:4))+sum(h(2:4))+20));
    tutk=tabint(burnup(k(crk)),void(k(crk)),chist(k(crk)),diffcrk);
    dtutk=tabint(burnup(k(crk)),dvoid(k(crk)),chist(k(crk)),diffcrk);
    for j=1:8
      tutcr{j}(k(crk))=tutk{j};
      dtutcr{j}(k(crk))=dtutk{j};
    end
  end
end

% Controlled fuel

kinfcr=((tutcr{6}(cr)+tut{6}(cr))+(tutcr{7}(cr)+tut{7}(cr)).*(tutcr{3}(cr)+tut{3}(cr))...
       ./(tutcr{5}(cr)+tut{5}(cr)))./(tutcr{4}(cr)+tutcr{3}(cr)+tut{4}(cr)+tut{3}(cr));
dkinfcr=((dtutcr{6}(cr)+dtut{6}(cr))+(dtutcr{7}(cr)+dtut{7}(cr)).*(dtutcr{3}(cr)+dtut{3}(cr))...
       ./(dtutcr{5}(cr)+dtut{5}(cr)))./(dtutcr{4}(cr)+dtutcr{3}(cr)+dtut{4}(cr)+dtut{3}(cr));
 tut{5}(cr)= tut{5}(cr)+satop*fre;
dtut{5}(cr)=dtut{5}(cr)+satop*fre;
 kinf=( tut{6}(cr)+ tut{7}(cr).* tut{3}(cr)./ tut{5}(cr))./( tut{4}(cr)+ tut{3}(cr));
dkinf=(dtut{6}(cr)+dtut{7}(cr).*dtut{3}(cr)./dtut{5}(cr))./(dtut{4}(cr)+dtut{3}(cr));
kprim= ( kinf.*pns.*fre+cov.* kinfcr.*pss)./(pns.*fre+pss.*cov);
dkprim=(dkinf.*pns.*fre+cov.*dkinfcr.*pss)./(pns.*fre+pss.*cov);
for i=1:8
   tut{i}(cr)= tut{i}(cr)+cov.* tutcr{i}(cr);
  dtut{i}(cr)=dtut{i}(cr)+cov.*dtutcr{i}(cr);
end
 tut{7}(cr)= tut{5}(cr)./ tut{3}(cr).*( kprim.*( tut{4}(cr)+ tut{3}(cr))- tut{6}(cr));
dtut{7}(cr)=dtut{5}(cr)./dtut{3}(cr).*(dkprim.*(dtut{4}(cr)+dtut{3}(cr))-dtut{6}(cr));

 tut{5}(1:25:end)= tut{5}(1:25:end)+satop*notcr(1:25:end);
dtut{5}(1:25:end)=dtut{5}(1:25:end)+satop*notcr(1:25:end);

crend=[find(diff(cr)>1);length(cr)];
 tut{5}(cr(crend)+1)= tut{5}(cr(crend)+1)+satop*crpre(crend)/100;
dtut{5}(cr(crend)+1)=dtut{5}(cr(crend)+1)+satop*crpre(crend)/100;

% Spacer

sp=reshape(spacer,mz(4),length(spacer)/mz(4));

dsig=sp(:,spacad(buntyp(mz(22)+1:2*mz(22)))/mz(4)+1);
 tut{5}= tut{5}+dsig;
dtut{5}=dtut{5}+dsig;

%Doppler Correcton

dxs=dxsadr(ftyp(:));
th=thdata(thadr(buntyp(mz(22)+1:2*mz(22)))+25);
th=(th*ones(1,mz(4)))';
aplh=bb(5)*power*(1-hy(51))./(prod(size(power))*th);
xi=aplh(:)*(1e-4);
ix=floor(xi);
ii=ix+3;
tact=doxesh(dxs+ii)+(xi-ix).*(doxesh(dxs+ii+1)-doxesh(dxs+ii));
e=burnup(:);
 dokinf=empty;
ddokinf=empty;
 dokinf(:)=(1+e.*(doxesh(dxs+9)+e.*(doxesh(dxs+10)+e.*doxesh(dxs+11)))).*...
      (doxesh(dxs+12)+ void(:).*doxesh(dxs+13)).*(tact-doxesh(dxs+2));
ddokinf(:)=(1+e.*(doxesh(dxs+9)+e.*(doxesh(dxs+10)+e.*doxesh(dxs+11)))).*...
      (doxesh(dxs+12)+dvoid(:).*doxesh(dxs+13)).*(tact-doxesh(dxs+2));
 ddopp= dokinf.* tut{5}./ tut{7}.*( tut{4}+ tut{3});
dddopp=ddokinf.*dtut{5}./dtut{7}.*(dtut{4}+dtut{3});

 tut{3}= tut{3}+ ddopp;
dtut{3}=dtut{3}+dddopp;
 tut{4}= tut{4}- ddopp;
dtut{4}=dtut{4}-dddopp;

%Xenon Correction

yiod=au(24)*(1+au(25)*burnup).*(1+au(26)*chist);
yxen=au(27)*(1+au(28)*burnup).*(1+au(29)*chist);
eutb=au(33)*(1+au(34)*burnup).*(1+au(35)*chist);


qtab=empty;
sigxe=empty;
dsigxe=empty;

 sigxe(:)=(doxesh(dxs+14)+e.*doxesh(dxs+15)).*(doxesh(dxs+16)+void(:).*(doxesh(dxs+17)+void(:).*doxesh(dxs+18)));
dsigxe(:)=(doxesh(dxs+14)+e.*doxesh(dxs+15)).*(doxesh(dxs+16)+dvoid(:).*(doxesh(dxs+17)+dvoid(:).*doxesh(dxs+18)));
c1tab=bb(73)./eutb;
c2tab=(yiod+yxen).*c1tab;
qtab(:)=doxesh(dxs+1)./bb(60);
 sigfis=( tut{7}+ tut{6}.* tut{5}./ tut{3})./ tut{8};
dsigfis=(dtut{7}+dtut{6}.*dtut{5}./dtut{3})./dtut{8};
 fi0=qtab.*c1tab./sigfis;
dfi0=qtab.*c1tab./dsigfis;
 decyx0=sigxe.* fi0+au(22);
ddecyx0=dsigxe.*dfi0+au(22);
 xe0=qtab.*c2tab./decyx0;
dxe0=qtab.*c2tab./ddecyx0;
 tut{5}= tut{5}+(xenon- xe0).* sigxe;
dtut{5}=dtut{5}+(xenon-dxe0).*dsigxe;



d1=tut{1};
d2=tut{2};
sigr=tut{3};
siga1=tut{4};
siga2=tut{5};
nsf1=tut{6};
nsf2=tut{7};
ny=tut{8};

dd1=(dtut{1}-tut{1})/hvoid;
dd2=(dtut{2}-tut{2})/hvoid;
dsigr=(dtut{3}-tut{3})/hvoid;
dsiga1=(dtut{4}-tut{4})/hvoid;
dsiga2=(dtut{5}-tut{5})/hvoid; %is only accurate to 1e-2 because of loss due to substraction
dnsf1=(dtut{6}-tut{6})/hvoid;
dnsf2=(dtut{7}-tut{7})/hvoid;
dny=(dtut{8}-tut{8})/hvoid; %is only accurate to 1e-3 because of loss due to substraction










