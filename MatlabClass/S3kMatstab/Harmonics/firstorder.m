function y=firstorder(u,a,b,y0)

if nargin<3, b=1-a;end

y=zeros(size(u));

if nargin>3, y(1)=y0;end

for i=2:length(u),
    y(i)=a*y(i-1)+b*(.5*u(i-1)+.5*u(i));
end