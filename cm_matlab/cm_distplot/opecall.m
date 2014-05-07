%@(#)   opecall.m 1.3	 05/12/08     13:40:12
%
function opecall
z=get(gcf,'userdata');
for j=4:7
  if z(j)==1,z(j)=0;set(z(4+j),'value',0),end
  v=get(z(4+j),'value');
  if v==1,z(j)=1;end
  set(z(4+j),'value',z(j))
end
set(gcf,'userdata',z);
