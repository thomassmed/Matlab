%@(#)   applyscale.m 1.2	 94/01/25     12:41:50
%
function applyscale
h3=get(gcf,'userdata');
hand=get(h3(4),'userd');
ud=get(hand(2),'userd');
figure(h3(4));
if strcmp(ud(4,1:7),'MATLAB:')
  hM=get(hand(6),'userdata');
  matvar=get(hM,'userdata');
  ccplot(matvar);
else
  ccplot;
end
