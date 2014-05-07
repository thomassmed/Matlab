function [mdata,mtext,mvar,mvarb,sampl]=getf3(mdfil)
% [mdata,mtext,mvar,mvarb,sampl]=getf3(mdfil)
% load a file with the f3md-format
load(mdfil)
mdata=scaling(mdata,mvarb);
[r,k]=size(mvar);
if ~exist('str','var') str=[]; end
for n=1:r,
  str=str2mat(str,[num2str(n) ' ']);
end
str(1,:)=[];
mvar=[str mvar];
mdata=mdata';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
[l,m]=size(md);
mdata=zeros(l,m);
for n=1:r,
  mdata(n,:)=scale(n)*(md(n,:)/32000*(upper(n)-lower(n)))+lower(n);
end


