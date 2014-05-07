%@(#)   sdmremove.m 1.3	 96/02/14     10:30:22
%
function sdmremove
hand=get(gcf,'userdata');
hcr=get(hand(43),'userdata');
if hcr~=[]
  [nsdm dump] = size(hcr)
  get(hcr(nsdm),'type')
  vis=get(hcr(nsdm),'visible');  
  if strcmp(vis,'on')
    set(hcr,'visible','off');  
  elseif strcmp(vis,'off')
    set(hcr,'visible','on');  
    dispsdm;
  end
end
