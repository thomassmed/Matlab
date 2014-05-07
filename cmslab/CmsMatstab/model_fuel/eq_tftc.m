function [tf,tc,tfs] =...
eq_tftc(tw,qtherm,power,dzz,rf,e1,e2,gca0,gca1,gca2,gcamx,...
rlca,rca,drca,rcca,p,delta,nrods)

% temperature distribution for steady state
%
% [tf,tc] =...
% eq_tftc(tw,qtherm,power,dzz,rf,e1,e2,gca0,gca1,gca2,gcamx,...
% rlca,rca,drca,rcca,p,delta,nrods);
%
% see ScP cladding-report and Ramona teplo.F
%
% this function can be substituted with eq_tc, eq_tf
% which are an explicit implementation of the equations in the
% Wulff-Report. The results are a bit diffrent, but they are
% no black box anymore.

% Philipp Haenggi, Leibstadt 30.5.96

global geom fuel

ntot=geom.ntot;
mm=fuel.mm;
mmc=fuel.mmc;

p_neu = p*ones(ntot,1);
tsat = cor_tsat(p_neu);

drc=drca/mmc;
drc5=0.5*drc;
drf=rf.*(1-sqrt((mm-1)/mm));
drf5=0.5*drf;

for i=1:mmc
  rc(:,i)=rf+drc/2*(2*(i-1)+1);
end

rlcm(:,1)=rf;
for i=2:mmc
  rlcm(:,i)=rlca.*(rc(:,i-1)+rc(:,i))./drc/2;
end
rlcm(:,mmc+1)=rlca.*(rc(:,mmc)+rca)./drc;

rlcc=drc5.*rca./rlca./(rca-drc5*0.5);

qk=power*qtherm*(1-delta)./ntot./nrods;
as=2*dzz/100*pi.*rca;
qas=qk./as;

tc(:,mmc+1)=tw;
tc(:,mmc)=tc(:,mmc+1)+qas.*rlcc;

for i=mmc-1:-1:1
  tc(:,i)=tc(:,i+1)+rlcm(:,i+2)./rlcm(:,i+1).*(tc(:,i+1)-tc(:,i+2));
end

tc=tc(:,1:mmc);

gcat=tsat;
ae=e1*4*mm*dzz/100*pi;
qe=power*qtherm*(1-delta)./ntot./nrods.*e2;
o=(0:mm+1).^0.5;

for itr=1:3
gca = gca0 + (gca1 + gca2.*gcat).*gcat;
temp=find(gca>gcamx);
gca(temp) = gcamx(temp);

rkgc=1./(1./gca+drc5./rlca);
tfs=tc(:,1)+rlcm(:,2).*(tc(:,1)-tc(:,2))./rkgc./rlcm(:,1);
alm=e1./(1+e2.*tfs);
tfm0=zeros(ntot,1);
tf(:,mm)=tfs+(tfs-tc(:,1)).*rkgc.*rf.*drf5./alm./(rf-0.5*drf5);
alm=e1./(1+e2.*(tfs+tf(:,mm))*.5);

while max(abs(tf(:,mm)-tfm0))>0.01
  tfm0=tf(:,mm);
  tf(:,mm)=tfs+(tfs-tc(:,1)).*rkgc.*rf.*drf5./alm./(rf-0.5*drf5);
  alm=e1./(1+e2.*(tfs+tf(:,mm))*.5);
end

qk=(1 - delta).*power.*qtherm/pi./rf.^2./(dzz/100)./ntot./nrods;

x1=rf.^2/4/mm;
x2=e1./(1+e2.*tf(:,mm))./(sqrt(mm/(mm-1))-sqrt((mm-2)/(mm-1)));
x3=rf.*(tf(:,mm)-tc(:,1))./(rf.*(1-sqrt(1-1/mm))./e1.*(1+e2.*tfs)+2./gca+drc./rlca);

tf(:,mm-1)=tf(:,mm)-x1.*qk./x2+x3./x2;

qk=qtherm*(1-delta)./ntot./nrods.*power;

for i=mm-2:-1:1
  tf(:,i)=(tf(:,i+1).*(ae+o(i+1).*qe*(o(i+1)-o(i)))+o(i+1).*qk.*(o(i+2)-o(i)))./(ae-o(i+1).*qe*(o(i+2)-o(i+1)));
end

gcat=mean(tf')';
end




