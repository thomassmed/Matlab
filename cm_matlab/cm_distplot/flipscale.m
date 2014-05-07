%@(#)   flipscale.m 1.2	 95/02/10     09:00:23
%
function flipscale
p=setprop(3);
i1=find(p=='(');
i2=find(p==')');
s=p(i1(1)+1:i2(length(i2)));
if length(i1)==1,p=['colormap(flipud' p(i1:i2) ')'];end
l=length(s);
if l>6,
  if strcmp(s(1:6),'flipud'),
    p=['colormap(' s(8:i2(length(i2)-1)-9)];
  end
else
  p=['colormap(flipud(' s ')'];
end
setprop(3,p);
goplot;
