function [arg,radut]=get_arg(rad,del,format);
if nargin<3, del=' ';end
rad=remleadblank(rad);
iblank=min(find(rad==del));
if isempty(iblank),
  arg=rad;
  radut=[];
else
  arg=rad(1:iblank-1); 
  radut=rad(iblank:length(rad));
end
if nargin>2,
  arg=sscanf(arg,format);
end
