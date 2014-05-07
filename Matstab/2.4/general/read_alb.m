function [a11,a21,a22,cp]=read_alb;
%[a11,a21,a22,cp]=read_alb;
%
% a11, a21 ,a22 are ntot-by-6 matrices with albedos
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

global msopt polcadata geom termo

isym=msopt.CoreSym;
mastfile=msopt.MasterFile;
mminj=polcadata.mminj;
knum=geom.knum;
kan=geom.kan;
kmax=geom.kmax;
ntot=geom.ntot;

BB=mast2mlab(mastfile,7,'F');

cp=BB(21);
ap=BB(23);
ay=BB(24);
ai=BB(25);
abot11=BB(26);
atop11=BB(27);
asid21=BB(28);
asid22=BB(29);
abot21=BB(30);
abot22=BB(31);
atop21=BB(32);
atop22=BB(33);

clear BB;

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
