function [ia,ja]=mminjmmaxj2ij(mminj,mmaxj,iwant,iafull)
% [ia,ja]=mminjmmaxj2ij(mminj[,mmaxj,iwant,iafull])
if nargin<2, mmaxj=length(mminj)+1-mminj; end
ia=zeros(sum(mmaxj-mminj+1),1);
ja=ia;
if ~exist('mmaxj','var'), mmaxj=length(mminj)+1-mminj;end
if ~exist('iwant','var'), iwant=4;end
if ~exist('iafull','var'), iafull=length(mminj);end

switch iwant
    case {1,2}
        ioffset=iafull-length(mminj);
        joffset=iafull-length(mminj);
    case 3
        ioffset=iafull-length(mminj);
        joffset=0;
    otherwise
        ioffset=0;
        joffset=0;
end
icount=0;
for i=1:length(mminj),
    for j=mminj(i):mmaxj(i)
        icount=icount+1;
        ia(icount)=i+ioffset;
        ja(icount)=j+joffset;
    end
end