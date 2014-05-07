%@(#)   getpoolpos.m 1.1	 05/07/13     10:29:32
%
%
function ppos=getpoolpos(poolfil,buidnt,hapool,hepool,htpool)
fig=0;
if ~isempty(htpool)     %F1 and F2
  while fig~=hapool & fig~=hepool & fig~=htpool
    fig=get(0,'PointerWindow');
  end
else                    %F3
  while fig~=hapool & fig~=hepool
    fig=get(0,'PointerWindow');
  end
end
waitforbuttonpress;
fig=get(0,'PointerWindow');
figure(fig);
c=get(gcf,'children');
yl=get(c(1),'yticklabel');
xl=get(c(1),'userdata');
[x,y,b]=ginput(1);
x=round(x);
y=round(y);
if isempty(htpool)
  ppos=[yl(y,:) xl(x,:)];
else
  ppos=[xl(x,:) yl(y,:)];
end
xr=round(x);
yr=round(y);
line([xr-.3 xr+.3 xr+.3 xr-.3 xr-.3],[yr-.3 yr-.3 yr+.3 yr+.3 yr-.3],'color','k')
ud=get(gcf,'userdata');
ud(y,x)=9;
set(gcf,'userdata',ud);
load(poolfil)
tmppos=[tmppos; ppos];
tmpbuid=[tmpbuid; buidnt];
tmpbox=[tmpbox; 'dumbox'];
evstr=['save ' poolfil ' temppos tempasyid temppbox tmppos tmpbuid tmpbox']; %buid ändrad till asyid 
eval(evstr);
