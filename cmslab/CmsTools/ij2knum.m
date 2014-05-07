function knum=ij2knum(icoor,jcoor,mminj,IJ)

if nargin<4 IJ=knum2cpos(1:kan,mminj);end

knum=find(IJ(:,1)>=min(icoor)&IJ(:,1)<=IJ(:,1)&IJ(:,2)>=min(jcoor)&IJ(:,2)<=max(jcoor));