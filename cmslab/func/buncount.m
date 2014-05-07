function list=buncount(buntyp,batchlist)
%list=buncount(buntyp,batchlist)

[rr,kk]=size(batchlist);
list=zeros(rr,1);
for n=1:rr,
 j1=strmatch(batchlist(n,:),buntyp);
 list(n,:)=length(j1);
end