% 
% function [speed1,speed2,beta1,beta2,beta3,beta4,...
% beta5,beta6,lambd1,lambd2,lambd3,lambd4,lambd5,lambd6]=...
% delay2mstab7(disfil,Pdens)
% 
function [speed,beta,lambda]=delay2mstab7(disfil,Pdens)

global geom

kmax=geom.kmax;
knum=geom.knum;

raal=739.3094; % Density of water at 70.5 Bar
raag=36.8209;  % Density of steam at 70.5 Bar

ramcof=readdist7(disfil,'ramcof');

nramon=size(ramcof,1)/kmax;  %No. of RAMONA XS coeff
basr=0:nramon:(kmax*nramon-1);

[ref,sp1,sp2,b1,b2,b3,b4,b5,b6,ld]=rcof2mcof(nramon,'delayed');


if (ramcof(b1(1),end/2)==0)   
  % No delayed coeff exist in ramcof, return 0
  speed=0;
  beta=0;
  lambda=0;
else
  dens=ramcof(ref(1)+basr,:);
  dth=ramcof(ref(7)+basr,:);
  if max(max(Pdens))<2,
    voidref=ramcof(ref(5)+basr,:);
    ddens=(raag-raal)*(Pdens-voidref);
  else
    ddens=Pdens-dens;
  end
  ddens2=ddens.*ddens;
 
  speed1  = ramcof(sp1(1)+basr,:)+ramcof(sp1(2)+basr,:).*ddens+ramcof(sp1(3)+basr,:).*ddens2;
  %dspeed1 = ramcof(123+basr,:)+2*ramcof(124+basr,:).*ddens;
  speed2  = ramcof(sp2(1)+basr,:)+ramcof(sp2(2)+basr,:).*ddens+ramcof(sp2(3)+basr,:).*ddens2;
  %dspeed2 = ramcof(128+basr,:)+2*ramcof(129+basr,:).*ddens;
 
  beta1  = ramcof(b1(1)+basr,:)+ramcof(b1(2)+basr,:).*ddens+ramcof(b1(3)+basr,:).*ddens2;
  %dbeta1 = ramcof(133+basr,:)+2*ramcof(134+basr,:).*ddens;
  beta2  = ramcof(b2(1)+basr,:)+ramcof(b2(2)+basr,:).*ddens+ramcof(b2(3)+basr,:).*ddens2;
  %dbeta2 = ramcof(138+basr,:)+2*ramcof(139+basr,:).*ddens;
  beta3  = ramcof(b3(1)+basr,:)+ramcof(b3(2)+basr,:).*ddens+ramcof(b3(3)+basr,:).*ddens2;
  %dbeta3 = ramcof(143+basr,:)+2*ramcof(144+basr,:).*ddens;
  beta4  = ramcof(b4(1)+basr,:)+ramcof(b4(2)+basr,:).*ddens+ramcof(b4(3)+basr,:).*ddens2;
  %dbeta4 = ramcof(148+basr,:)+2*ramcof(149+basr,:).*ddens;
  beta5  = ramcof(b5(1)+basr,:)+ramcof(b5(2)+basr,:).*ddens+ramcof(b5(3)+basr,:).*ddens2;
  %dbeta5 = ramcof(153+basr,:)+2*ramcof(154+basr,:).*ddens;
  beta6  = ramcof(b6(1)+basr,:)+ramcof(b6(2)+basr,:).*ddens+ramcof(b6(3)+basr,:).*ddens2;
  %dbeta6 = ramcof(158+basr,:)+2*ramcof(159+basr,:).*ddens;
 
 
  speed1=speed1.*(1-(dens>dth));
  %dspeed1=dspeed1.*(1-(dens>dth));
  speed1=speed1+(dens>dth).*(ramcof(sp1(4)+basr,:)+ddens.*ramcof(sp1(5)+basr,:));
  %dspeed1=dspeed1+(dens>dth).*ramcof(126+basr,:);
 
  speed2=speed2.*(1-(dens>dth));
  %dspeed2=dspeed2.*(1-(dens>dth));
  speed2=speed2+(dens>dth).*(ramcof(sp2(4)+basr,:)+ddens.*ramcof(sp2(5)+basr,:));
  %dspeed2=dspeed2+(dens>dth).*ramcof(131+basr,:);
 
  beta1=beta1.*(1-(dens>dth));
  %dbeta1=dbeta1.*(1-(dens>dth));
  beta1=beta1+(dens>dth).*(ramcof(b1(4)+basr,:)+ddens.*ramcof(b1(5)+basr,:));
  %dbeta1=dbeta1+(dens>dth).*ramcof(136+basr,:);
 
  beta2=beta2.*(1-(dens>dth));
  %dbeta2=dbeta2.*(1-(dens>dth));
  beta2=beta2+(dens>dth).*(ramcof(b2(4)+basr,:)+ddens.*ramcof(b2(5)+basr,:));
  %dbeta2=dbeta2+(dens>dth).*ramcof(141+basr,:);

  beta3=beta3.*(1-(dens>dth));
  %dbeta3=dbeta3.*(1-(dens>dth));
  beta3=beta3+(dens>dth).*(ramcof(b3(4)+basr,:)+ddens.*ramcof(b3(5)+basr,:));
  %dbeta3=dbeta3+(dens>dth).*ramcof(146+basr,:);
 
  beta4=beta4.*(1-(dens>dth));
  %dbeta4=dbeta4.*(1-(dens>dth));
  beta4=beta4+(dens>dth).*(ramcof(b4(4)+basr,:)+ddens.*ramcof(b4(5)+basr,:));
  %dbeta4=dbeta4+(dens>dth).*ramcof(151+basr,:);
 
  beta5=beta5.*(1-(dens>dth));
  %dbeta5=dbeta5.*(1-(dens>dth));
  beta5=beta5+(dens>dth).*(ramcof(b5(4)+basr,:)+ddens.*ramcof(b5(5)+basr,:));
  %dbeta5=dbeta5+(dens>dth).*ramcof(156+basr,:);
 
  beta6=beta6.*(1-(dens>dth));
  %dbeta6=dbeta6.*(1-(dens>dth));
  beta6=beta6+(dens>dth).*(ramcof(b6(4)+basr,:)+ddens.*ramcof(b6(5)+basr,:));
  %dbeta6=dbeta6+(dens>dth).*ramcof(161+basr,:);
 
 
  lambd1=ramcof(ld(1)+basr,:);
  lambd2=ramcof(ld(2)+basr,:);
  lambd3=ramcof(ld(3)+basr,:);
  lambd4=ramcof(ld(4)+basr,:);
  lambd5=ramcof(ld(5)+basr,:);
  lambd6=ramcof(ld(6)+basr,:);
 
  sp1=speed1(:,knum(:,1));sp1=sp1(:)';
  sp2=speed2(:,knum(:,1));sp2=sp2(:)';
 
  b1=beta1(:,knum(:,1));b1=b1(:)';
  b2=beta2(:,knum(:,1));b2=b2(:)';
  b3=beta3(:,knum(:,1));b3=b3(:)';
  b4=beta4(:,knum(:,1));b4=b4(:)';
  b5=beta5(:,knum(:,1));b5=b5(:)';
  b6=beta6(:,knum(:,1));b6=b6(:)';
 
  l1=lambd1(:,knum(:,1));l1=l1(:)';
  l2=lambd2(:,knum(:,1));l2=l2(:)';
  l3=lambd3(:,knum(:,1));l3=l3(:)';
  l4=lambd4(:,knum(:,1));l4=l4(:)';
  l5=lambd5(:,knum(:,1));l5=l5(:)';
  l6=lambd6(:,knum(:,1));l6=l6(:)';
 
  beta=[b1; b2; b3; b4; b5; b6];
  lambda=[l1; l2; l3; l4; l5; l6];
  speed=[sp1; sp2];
end
