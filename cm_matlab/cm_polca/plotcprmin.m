%@(#)   plotcprmin.m 1.1	 09/12/23     12:57:56
%
%function plotcprmin(sourcefil)
function plotcprmin(sourcefil)
cprmin=src2mlab(sourcefil,'cprmin');
for i=1:size(cprmin,2)
  figure;
  x=str2num(cprmin(i).FLOW);
  y=str2num(cprmin(i).TABLE);
  plot(x,y)
  legend(cprmin(i).ASYTYP);
  axis([0 14000 1 2]);
  grid;
end
