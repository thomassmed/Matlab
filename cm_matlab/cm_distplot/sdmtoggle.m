%@(#)   sdmtoggle.m 1.3	 96/02/14     10:30:25
%
function sdmtoggle
hand=get(gcf,'userdata');
ud=get(hand(2),'userdata');
if ud(14,1:2)~='no'
  hcr=get(hand(43),'userdata');
  if hcr~=[]
    ud=get(hand(2),'userdata');
    farg=ud(14,:);
    i=find(farg==' ');farg(i)='';
    if ~strcmp(farg(1:3),'bla')
      set(hcr,'color','black','visible','on');  
      ud(14,1:5)='black';
      set(hand(2),'userdata',ud);
    elseif ~strcmp(farg(1:3),'whi')
      set(hcr,'color','white','visible','on');  
      ud(14,1:5)='white';
      set(hand(2),'userdata',ud);
    end
  end
end

dispsdm;
