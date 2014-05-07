dr=[];
buf=ones(1600,1)*mean(ne(1:400));
for n=1:26,
  buf(1:400)=buf(401:800);
  buf(401:800)=buf(801:1200);
  buf(801:1200)=buf(1201:1600);
  x1=(n-1)*400+1;
  x2=n*400;
  disp(n)
  x=ne(x1:x2);
  buf(1201:1600)=x;
  [dk,sdd]=f3dk(buf,nn);
  dr(n)=dk;
  sd(n)=sdd;
end
