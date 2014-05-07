%@(#)   initvec.m 1.1	 05/07/13     10:29:33
%
%
%function [from,to,ready,fuel]=initvec(buid,buidboc,OK)
function [from,to,ready,fuel]=initvec(buid,buidboc,OK)
if size(OK,2)>1,OK=OK';end
m=mbucatch(buid,buidboc);
d=strmatch('vat',buid(:,1:3));
nbu=size(buid,1);
nr=(1:nbu)';
from=zeros(nbu,1);
to=zeros(nbu,1);
fuel=ones(nbu,1).*OK;
fuel(d)=zeros(length(d),1);
ready=(m==nr).*OK;
i=find(m.*OK);
to(i)=m(i);
from(m(i))=i;
