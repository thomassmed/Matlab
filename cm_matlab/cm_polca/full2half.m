%@(#)   full2half.m 1.2	 94/08/12     12:10:25
%
%function khalf=full2half(knum,mminj)
%translates full-core channelnumber to half cor channel number
%left half core is mapped to 0
function khalf=full2half(knum,mminj)
ll=length(knum);
iimax=length(mminj);
iihalf=iimax/2;
khalf=zeros(size(knum));
cpos=knum2cpos(knum,mminj);  
for i=1:ll
  delta=iimax+1-mminj(cpos(i,1))-cpos(i,2);
  if cpos(i,2)>iihalf,
    khalf(i)=(knum(i)+delta)/2-delta;
  end
end
