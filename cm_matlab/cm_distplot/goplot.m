%@(#)   goplot.m 1.2	 94/01/25     12:42:41
%
function goplot
dname=setprop(4);
if (size(dname,2)>6)
  if strcmp(dname(1:7),'MATLAB:')
    hand=get(gcf,'userdata');
    hM=get(hand(6),'userdata');
    matvar=get(hM,'userdata');
    ccplot(matvar);
  else
   ccplot;
  end
else
  ccplot;
end
