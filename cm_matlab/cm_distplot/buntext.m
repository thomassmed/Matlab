%@(#)   buntext.m 1.4	 05/12/08     09:43:41
%
function buntext
[bun,mminj]=readdist7(setprop(5),'asytyp');
for i=1:size(bun,1)
  yx=knum2cpos(i,mminj);
  text(yx(2)+.1,yx(1)+.5,bun(i,:),'fontsize',8,'color','black');
end
