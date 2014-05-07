%@(#)   ssremove.m 1.3	 96/02/14     10:30:26
%
function ssremove
hand=get(gcf,'userdata');
hcr=get(hand(32),'userdata');
[ncr dump] = size(hcr)
get(hcr(ncr),'type')
vis=get(hcr(ncr),'visible');  
if strcmp(vis,'on')
  set(hcr,'visible','off');  
elseif strcmp(vis,'off')
  set(hcr,'visible','on');
  dispcr;  
end
