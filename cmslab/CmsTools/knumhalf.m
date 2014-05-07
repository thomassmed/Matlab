%
%function [right,left]=knumhalf(mminj)
function [right,left]=knumhalf(mminj)
lc=length(mminj);
ll=lc+2;
right=[];
kannum=0;
for i=1:lc
  right=[right,kannum+ll/2-mminj(i)+1:kannum+ll-2*mminj(i)];
  kannum=kannum+ll-2*mminj(i);
end
right=right';
kan=sum(length(mminj)-2*(mminj-1));
left=kan+1-right;
