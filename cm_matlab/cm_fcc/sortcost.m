%@(#)   sortcost.m 1.2	 94/08/12     12:15:43
%
function [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax)
if nargin<6, imax=max(irad);end
antal=zeros(1,imax);meanburn=antal;uttag=antal;restsek=antal;
for i=1:max(irad)
  ibun=find(irad==i&select);
  antal(i)=length(ibun);
  if antal(i)>0,
    restsek(i)=sum(restSEK(ibun));
    meanburn(i)=mean(burnup(ibun))/1000;
    uttag(i)=sum(Uttag(ibun));
  end
end
