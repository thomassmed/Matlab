%@(#)   setbut.m 1.3	 94/03/16     14:40:02
%
function setbut(num)
h=get(gcf,'userdata');
for i=1:18
  if i~=num
    set(h(i+23),'value',0)
  end
end
