%@(#)   flow.m 1.1	 05/12/08     10:08:31
%
function flow(block);
[chnum,knam]=flopos(block);
fil=setprop(5);
[d,mminj]=readdist7(fil);
ij=knum2cpos(chnum,mminj);
setflag(ij,'whi');
for i=1:8,
  text(ij(i,2)+.5,ij(i,1)+.5,knam(i,:));i=get(gca,'children');set(i(1),'col','bla');
end
