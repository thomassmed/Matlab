function [my,eta,myxy,mytb,myleak]=eq_my(rho,NEIG,hx,hz,bet,beb,blext,ahext,cref);
% [my,eta,myxy,mytb,myleak]=eq_my(rho,NEIG,hx,hz,bet,beb,blext,ahext,cref);


NTOT=size(NEIG,1);
rver=hx^2/hz^2;



D=rho.*rho;
rho(NTOT+1)=0; 


%precalculation for eq 6.2.43
my1=zeros(NTOT,1);myxy=my1;mytb=my1;
for i=1:4,
  my1=my1+rho(1:NTOT).*rho(NEIG(:,i));
end
for i=5:6,
 ett_lamb=hz/bet;
 if i==6, ett_lamb=hz/beb;end  
  my1=my1+rho(1:NTOT).*rho(NEIG(:,i))*rver;       
  irand=find(NEIG(:,i)==(NTOT+1));
  mytb(irand)=mytb(irand)+D(irand)*rver*ett_lamb;
end  

%cref=-0.067;blext=1/bes;
%for the 1D case ramona sets cref=0. this works because all boundary
%conditions are lumped into the crosssecions when you go from 3D to 1D
%for the lumping the diffrent XS are weighted with the flux. philipp
 
Daver=1.652;                          
myxy=hx*D.*(blext+cref*ahext.*(D-Daver));                       %eq 6.2.14
 
my=(my1+myxy+mytb)/(hx*hx);                                     %eq 6.2.43
 
eta=D/(hx*hx);                                                  %eq 6.2.65
 

if nargout>4,
  myleak=(myxy+mytb)/(hx*hx);
end

%@(#)   eq_my.m 1.2   97/09/22     10:29:58
