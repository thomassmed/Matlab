%@(#)   cycall.m 1.3	 95/03/29     08:19:26
%
function cycall(num)
hmat=get(gcf,'userdata');
hvec=hmat(1,:);
ll=length(hvec);
for i=1:ll-2
  set(hvec(i),'value',0)
end
set(hvec(num),'value',1)
