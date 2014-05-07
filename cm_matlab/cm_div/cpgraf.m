%@(#)   cpgraf.m 1.2	 94/02/08     12:31:12
%
function cpplot
for i=1:13
  filvec(i,:)=sprintf('%6s%2i','distr-',i);
  limit(i)=1.47;
end
limit(13)=1.51;
cprplot(filvec,limit)
