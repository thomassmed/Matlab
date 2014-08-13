function [a11,a21,a22,cp]=read_alb7
%[a11,a21,a22,cp]=read_alb7(fue_new)
%
% a11, a21 ,a22 are NTOT-by-6 matrices with albedos
% organized column-wise as:
%
% 1 - North (i-index  -1 )
% 2 - East  (j-index  +1 )
% 3 - South (i-index  +1 )
% 4 - West  (j-index  -1 )
% 5 - Up    (k-index  +1 )
% 6 - Down  (k-index  -1 )
%
%  ntot               =  kmax                   *   kan 
% (total no. of nodes =  no. of nodes/channel times no. of channels) 

global  geom

mminj=geom.mminj;
knum=geom.knum;
kan=geom.kan;
kmax=geom.kmax;
ntot=geom.ntot;

%vec=mast2mlab7(mastfile,18,'F');

cp=0.5;
%{
ap=vec(9);
ay=vec(10);
ai=vec(11);
abot11=vec(1);
abot21=vec(2);
abot22=vec(3);
atop11=vec(5);
atop21=vec(6);
atop22=vec(7);
asid21=vec(12);
asid22=vec(13);
%}
%ap             ay              ai
%0.3700         0.3700          0.6100
ap=0.37;        ay=0.37;        ai=0.61;
abot11=0.48;    abot21=0.081;   abot22=0.5320;
%abot11=0.70;    abot21=0.10;    abot22=0.70;
atop11=0.373;   atop21=0.192;   atop22=0.7440;
%atop11=0.20;    atop21=0.10;    atop22=0.50;
%asid21          asid22
asid21=0.2400;   asid22=0.7300;
%asid21=0.15;    asid22=0.5;

a11=zeros(ntot,6);
a21=a11;a22=a11;

alb_mat=albedo_type(mminj,ap,ai,ay);

alb_mat=alb_mat(knum(:,1),:);

nstart=0;

for i=1:kan,
  for j=1:4,
    a11(nstart+1:nstart+kmax,j)=alb_mat(i,j)*ones(kmax,1);
  end
  nstart=nstart+kmax;
end

a21(:,1:4)=(a11(:,1:4)~=0)*asid21;
a21(kmax:kmax:ntot,5)=atop21;
a21(1:kmax:ntot,6)=abot21;

a22(:,1:4)=(a11(:,1:4)~=0)*asid22;
a22(kmax:kmax:ntot,5)=atop22;
a22(1:kmax:ntot,6)=abot22;

a11(kmax:kmax:ntot,5)=atop11;
a11(1:kmax:ntot,6)=abot11;

