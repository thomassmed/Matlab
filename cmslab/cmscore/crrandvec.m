%@(#)   randvec.m 1.2	 94/08/12     12:10:46
%
%function vec=randvec(mminj)
%vec(x)=1 randpos, vec(x)=2 semirandpos
function vec=crrandvec(mminj)
lm=length(mminj);
mat=zeros(lm);
for a=1:lm
  mat(a,mminj(a))=1;
  mat(a,lm+1-mminj(a))=1;
  mat(mminj(a),a)=1;
  mat(lm+1-mminj(a),a)=1;
end
for i=2:round(lm/2)
  for j=2:round(lm/2)
    if j>mminj(i) && mat(i,j)==0 && mat(i-1,j)==1,
      mat(i,j)=2;
      mat(i,lm+1-j)=2;
      mat(lm+1-i,j)=2;
      mat(lm+1-i,lm+1-j)=2;
    end
    if j>mminj(i) && mat(i,j)==0 && mat(i,j-1)==1,
      mat(i,j)=2;
      mat(i,lm+1-j)=2;
      mat(lm+1-i,j)=2;
      mat(lm+1-i,lm+1-j)=2;
    end
    if j>mminj(i) && mat(i,j)==0,
      mat(i,j)=3;
      mat(i,lm+1-j)=3;
      mat(lm+1-i,j)=3;
      mat(lm+1-i,lm+1-j)=3;
    end
  end
end
vec=cor2vec(mat,mminj);
end
