%@(#)   tip2date.m 1.3	 97/11/05     09:00:17
%
function date=tip2date(tipfiles);
l=size(tipfiles,1);
for i=1:l,
  tipfil=remblank(tipfiles(i,:));
  j=find(tipfil=='-');
  date(i,:)=tipfil(j+1:j+6);
end
