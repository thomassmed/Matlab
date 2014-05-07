%@(#)   plotkinf.m 1.4	 94/03/16     15:07:47
%
function plotkinf(s)
if strcmp(s,'c'),kinf=kinf2mlab(remblank(setprop(5)),'NOBURC','DISTMASTER',.0...
  ,[0 1 1 1 2 3 5 9 14 21 31 44 62 84 111 142 179 215 247 282 298 288 ...
  240 149 72]);...
else kinf=kinf2mlab(remblank(setprop(5)));
end
setprop(3,'colormap(jett)');
setprop(4,'MATLAB:kinf');
setprop(9,'auto');
ccplot(kinf);
