function mdata=scaling(md,mv)
% mdata=scaling(md,mv)
% scales the mdata matrix according to the
% information in the mvar matrix.
% md stands for mdata,
% mv for mvar
[r,k]=size(mv);
lower=mv(:,1);
upper=mv(:,2);
scale=mv(:,3);
for n=1:r,
  mdata(n,:)=scale(n)*(md(n,:)/32000*(upper(n)-lower(n)))+lower(n);
end

