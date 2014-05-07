%@(#)   sstoggle.m 1.3	 96/02/14     10:30:27
%
function sstoggle
hand=get(gcf,'userdata');
hcr=get(hand(32),'userdata');
ud=get(hand(2),'userdata');
farg=ud(13,:);
i=find(farg==' ');farg(i)='';
if ~strcmp(farg(1:3),'bla')
 set(hcr,'color','black','visible','on');  
 ud(13,1:5)='black';
 set(hand(2),'userdata',ud);
elseif ~strcmp(farg(1:3),'whi')
 set(hcr,'color','white','visible','on');  
 ud(13,1:5)='white';
 set(hand(2),'userdata',ud);
end


dispcr;
