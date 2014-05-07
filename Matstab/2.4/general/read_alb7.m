function [a11,a21,a22,cp]=read_alb7;
%[a11,a21,a22,cp]=read_alb(f_master,mminj);
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

global msopt polcadata geom termo neu

isym=msopt.CoreSym;
mminj=polcadata.mminj;
knum=geom.knum;
kan=geom.kan;
kmax=geom.kmax;
ntot=geom.ntot;

if isempty(msopt.MasterFile) | ~exist(msopt.MasterFile,'file')
	abotdata=neu.src_albedo_abot;
	atopdata=neu.src_albedo_atop;
	asiddata=neu.src_albedo_asid;
	cp=0.5;
	ap=asiddata(1);
	ay=asiddata(2);
	ai=asiddata(3);
	abot11=abotdata(1);
	abot21=abotdata(2);
	abot22=abotdata(3);
	atop11=atopdata(1);
	atop21=atopdata(2);
	atop22=atopdata(3);
	asid21=asiddata(4);
	asid22=asiddata(5);
else
	vec=mast2mlab7(msopt.MasterFile,18,'F');	
	cp=0.5;
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
end




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
%@(#)   read_alb.m 1.3   99/12/30     11:03:40
