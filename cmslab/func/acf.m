function r=acf(x,n);
%r=acf(x,n) returns the autocorrelation function
%of the string x at n positive samples
x=x(:);
x=dtrend(x);
r=zeros(n,1);
sista2=length(x);
for num1=1:n
  sista1=length(x)-num1+1;
  x1=x(1:sista1);
  x2=x(num1:(sista2));
  r(num1)=sum(x1.*x2);
end
r=r(:);
r=r/sum(x.^2);

  
