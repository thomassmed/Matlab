%@(#)   cpos2knum.m 1.3	 06/01/13     07:59:23
%
%function kannum=cpos2knum(y,x,mminj)
%or function kannum=cpos2knum(yx,mminj)
function kannum=cpos2knum(y,x,mminj)
if nargin==2, mminj=x;x=y(:,2);y=y(:,1);end
lx=min(length(x),length(y));
ll=length(mminj)+2;
kannum=zeros(lx,1);
for i=1:lx,
  %added the second condition, LM/Savantic 060110
  if min(x(i),y(i))>0 && max(x(i),y(i))<(length(mminj)+1),
    if x(i)<mminj(y(i))|x(i)>(ll-1-mminj(y(i))),
%     disp(['(',num2str(y(i)),',',num2str(x(i)),')  is outside core'])
    else
      kannum(i)=sum(ll-2*mminj(1:y(i)-1))+x(i)-mminj(y(i))+1;
    end
  end
end
