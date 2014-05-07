%@(#)   plotlhmax1.m 1.1	 09/12/23     12:57:56
%
%function plotlhmax1(sourcefil)
function plotlhmax1(sourcefil)
lhmax1=src2mlab(sourcefil,'lhmax1');
for i=1:size(lhmax1,2)
  figure;
  x=str2num(lhmax1(i).BURNUP);
  y=str2num(lhmax1(i).TABLE);
  plot(x,y)
  legend(lhmax1(i).SEGTYP);
  axis([0 70 0 50]);
  grid;
end
