%@(#)   findchain.m 1.1	 05/07/13     10:29:31
%
function [kedja,gonu]=findchain(to,from,ready,fuel)
mult=(to==0).*from.*fuel;
iked0=find(mult>0);   [m0,n0]=size(iked0);if m0==1, m0=n0;iked0=iked0';end
iked1=find(from.*(1-fuel)>0);
[m1,n1]=size(iked1);if m1==1, m1=n1;iked1=iked1';end
iked=[iked1;iked0];
li=length(iked);
gonu=to*0;
if li==0,
  kedja=[];
else
  kedja=zeros(li,15);
  kedja(:,1)=iked;
  kedja(:,2)=from(iked);
  gonu(kedja(m1+1:m1+m0,2))=ones(size(iked0));
  gonu(kedja(1:m1,2))=2*ones(size(iked1));
  kedja(:,3)=from(kedja(:,2));
  for i=4:15
    l=find(kedja(:,i-1)>0);
    lg=find(l<=m1);gonu(kedja(l(lg),i-1))=2*ones(size(lg));
    lgg=find(l>m1);gonu(kedja(l(lgg),i-1))=ones(size(lgg));
    if length(l)==0, break;end
    kedja(l,i)=from(kedja(l,i-1));
  end
  kedja=kedja(:,1:i-2);
end
