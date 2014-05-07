function dist=old2core(oldvec,geom)
%%
k=geom.nin(5):geom.nout(geom.ncc+5);
k(1:geom.ncc+1)=[];
k((geom.ncc+1):(geom.ncc+1):end)=[];
%%
i_dist=zeros(geom.kmax,geom.ncc);
for i=1:geom.kmax,
    i_dist(i,:)=k(((i-1)*geom.ncc+1):geom.ncc*i);
end
i_dist=i_dist(:);
dist=oldvec(i_dist);
dist=reshape(dist,geom.kmax,geom.ncc);
if size(geom.knum,2)>1,
    dist=sym_full(dist,geom.knum);
end