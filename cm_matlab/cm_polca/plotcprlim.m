%@(#)   plotcprlim.m 1.1	 10/05/26     12:30:50
%
%function plotcprlim(sourcefil)
function plotcprlim(sourcefil)
cprlim=src2mlab(sourcefil,'cprlim');
for i=1:size(cprlim,2)
  figure;
  x=str2num(cprlim(i).FLOW);
  y=str2num(cprlim(i).LIMIT);
  plot(x,y)
  legend(cprlim(i).ASYTYP);
  axis([0 14000 1 2]);
  grid;
end
