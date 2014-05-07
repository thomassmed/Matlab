%@(#)   autoscale.m 1.2	 94/01/25     12:41:59
%
function autoscale
handles=get(gcf,'userdata');
hpl=handles(2);
ud=get(hpl,'userdata');
ud(9,1:4)='auto';
set(hpl,'userdata',ud);
if strcmp(ud(4,1:7),'MATLAB:')
  hM=get(handles(6),'userdata');
  matvar=get(hM,'userdata');
  ccplot(matvar);
else
  ccplot;
end
