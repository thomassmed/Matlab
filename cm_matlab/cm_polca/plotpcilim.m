%@(#)   plotpcilim.m 1.1	 09/12/23     12:57:56
%
%function plotpcilim(sourcefil)
function plotpcilim(sourcefil)
pcilim=src2mlab(sourcefil,'pcilim');
for i=1:size(pcilim,2)
  figure;
  x=str2num(pcilim(i).BURNUP);
  y=str2num(pcilim(i).THRESH);
  plot(x,y)
  legend(pcilim(i).ASYTYP);
  axis([0 80 0 50]);
  grid;
end
