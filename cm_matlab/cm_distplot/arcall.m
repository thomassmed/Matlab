%@(#)   arcall.m 1.2	 94/01/25     12:41:52
%
function arcall
z=get(gcf,'userdata');
for j=1:z(1)
  if z(j+1)==1,z(j+1)=0;set(z(z(1)+1+j),'value',0),end
  v=get(z(z(1)+1+j),'value');
  if v==1,z(j+1)=1;end
  set(z(z(1)+1+j),'value',z(j+1))
end
set(gcf,'userdata',z);
