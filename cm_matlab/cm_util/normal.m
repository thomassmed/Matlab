%@(#)   normal.m 1.2	 94/02/08     12:31:40
%
%function FI=normal(x)
function FI=normal(x)
for i=1:length(x),
  if x(i)>11,
    FI(i)=1;
  else
    FI(i)=quad('normdens',0,x(i))+0.5;
  end
end
