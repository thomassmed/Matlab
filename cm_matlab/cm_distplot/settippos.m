%@(#)   settippos.m 1.3	 94/10/21     12:16:25
%
function settippos(col)
handles=get(gcf,'userdata');
hpl=handles(2);
if gca~=hpl, axes(hpl);end
ud=get(hpl,'userdata');
htip=get(handles(37),'userdata');
i=find(col==' ');col(i)='';
if ~strcmp(col(1:6),'delete')
  ud(19,1:length(col))=col;
  set(hpl,'Userdata',ud);
  if strcmp(ud(4,1:7),'MATLAB:')
    hM=get(handles(6),'userdata');
    matvar=get(hM,'userdata');
    ccplot(matvar);
  else
    ccplot;
  end
else
  if max(size(htip))>0, delete(htip);end
  ud(19,1:2)='no';
  set(hpl,'Userdata',ud);
end  
