%@(#)   stats.m 1.1	 94/09/02     12:45:43
%
%function [dev,aa]=stats(matr)
% dev(1:9)
%standard deviation: nodal radiell axiell
%mean: nodal radiell axiell
%max: nodal radiell axiell
function [dev,aa]=stats(matr)
if (size(matr,2)>1&size(matr,1)>1)
  dev(1)=sqrt(sum(sum(matr.*matr))/size(matr,1)/size(matr,2));
  dev(2)=std(mean(matr));
  %=sqrt(sum(mean(matr.*matr))/size(matr,1)/size(matr,2));
  dev(3)=std(mean(matr'));
  %=sqrt(sum(mean([matr.*matr]')')/size(matr,1)/size(matr,2));
%  [aa(1) bb(1)]=find(matr==dev(7))
%  matnod(:)=matr;
  dev(4)=mean(abs(matr(:)));                       
  dev(5)=mean(abs(mean(matr)));
  dev(6)=mean(abs(mean(matr')));
%  [aa(2) bb(2)]=find(matr==mean(dev(7)));
  dev(7)=max((abs(matr(:))));                       
  dev(8)=max(abs(mean(matr)));
  dev(9)=max(abs(mean(matr')));
%  [aa(3) bb(3)]=find(matr==dev(7));
else
  dev(1)=mean(abs(matr(:)));                       
  dev(2)=mean(abs(mean(matr)));
  dev(3)=mean(abs(mean(matr')));

  dev(4)=max(abs(matr(:)));                       
  dev(5)=max(abs(mean(matr)));
  dev(6)=max(abs(mean(matr')));

end
