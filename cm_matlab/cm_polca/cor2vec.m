%@(#)   cor2vec.m 1.2	 94/08/12     12:09:56
%
%function vector=cor2vec(core,mminj)
%convert core-matrix to channel number vector
function vector=cor2vec(core,mminj)
k=0;
l=length(mminj);
for i=1:l
  for j=1:l
    if j>=mminj(i) & j<=(l+1-mminj(i))
      k=k+1;
      vector(k)=core(i,j);
    end
  end
end
