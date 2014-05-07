%@(#)   plotlhlim1.m 1.7	 10/09/06     13:57:45
%
%function plotlhlim1(sourcefil)
function plotlhlim1(sourcefil)
lhlim1=src2mlab(sourcefil,'lhlim1');
for i=1:size(lhlim1,2)
  figure;
  if ~isempty(strmatch('PINBUR',fieldnames(lhlim1))),
    if ~isempty(lhlim1(i).PINBUR),x=str2num(lhlim1(i).PINBUR);fn='PINBUR';end
  end
  if ~isempty(strmatch('NODBUR',fieldnames(lhlim1))),
    if ~isempty(lhlim1(i).NODBUR),x=str2num(lhlim1(i).NODBUR);fn='NODBUR';end
  end
  y=str2num(lhlim1(i).LIMIT);
  plot(x,y)
  xlabel(fn);
  ylabel('LHGR [kW/m]');
  legend(lhlim1(i).SEGTYP);
  axis([0 70 0 50]);
  grid;
end
