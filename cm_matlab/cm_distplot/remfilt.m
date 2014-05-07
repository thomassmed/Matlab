%@(#)   remfilt.m 1.3	 97/11/04     07:42:27
%
function remfilt
handles=get(gcf,'userdata');
hpl=handles(2);
ud=get(hpl,'userdata');
wud=get(handles(22),'userdata');
s=size(wud,2);
wud(1,:)=ones(1,s);
set(handles(22),'userdata',wud)
set(handles(21),'userdata',ones(1,s))
set(handles(24),'userdata',ones(1,s))
ud(12,1:3)='no ';
set(hpl,'Userdata',ud);
if strcmp(ud(11,1:3),'yes')
  ud(11,1:3)='no ';
  set(hpl,'userdata',ud);
  h=get(0,'children');
  i=find(h==wud(3,1));
  if ~isempty(i),delete(wud(3,1)),end
end
