%@(#)   powgraf.m 1.1	 05/06/14     12:26:35
%
function powgraf
%for i=1:13
%  filvec(i,:)=sprintf('%6s%2i','distr-',i);
%end
load sim/simfile
%powplot(filvec)
powplot(filenames)
%for i=1:4
%  figure(i);
%  set(gcf,'paperposition',[.3 .5 8 9])
%  print graf
%  !lpr -Pftb-ps graf.ps
%  !pageview graf.ps
%  delete(i)
%end
