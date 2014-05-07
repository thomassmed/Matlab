function s=expex(t)

term=1;
n=0;
s=1;
r=0;

while r~=s
    r=s;
    n=n+1;
    term=(t/n)*term;
    s=s+term;
end
