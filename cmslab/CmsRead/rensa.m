function x=rensa(x,value)
% Takes away extra 'void' in arrays
[ix,jx]=size(x);
inan=find(x==value);x(inan)=NaN;
jbort=find(all(isnan(x)));
x(:,jbort)=[];
if isempty(x), x=NaN(ix,1); end
%ibort=find(all(isnan(x')));
%x(ibort,:)=[];
