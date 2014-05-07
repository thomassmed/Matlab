function [dk,fd,sdk,ord]=stabt(y,antal)
nn=floor((length(y)-antal)/400);
for n=1:nn,
  nummer=nummer+1;
  yy=y((n-1)*400+1:(n-1)*400+antal); 
  [dk(n,1),fd(n,1),sdk(n,1),ord(n,1)]=dkident(yy);
end 
