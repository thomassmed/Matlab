%@(#)   updatpo.m 1.2	 10/09/09     10:45:53
%
%
%function updatpo(poolfil,buidnt,lline)
function updatpo(poolfil,buidnt,lline)
load(poolfil);
s=size(lline);
for r=1:s(1)
  i=find(lline(r,:)==',');
  if s(2)>13						%Hittar poolförflyttning
    if length(i)<4,k=size(lline,2); else k=i(4)-1;end	%Hittar poolpositioner
    topos=lline(r,i(3)+1:k);				%Hittar den nya positionen
  else
    topos='dummy';
  end
  
  if size(topos,2) == 4
  	topos = sprintf('%s%s', topos, char(32));
  end
  
  
  i=strmatch(topos,pos);					%Letar upp den nya pos blande de gamla lagrade pos
  if ~isempty(i),
buidnt(r,:)
size(buidnt)
size(asyid)
    asyid(i,:)=buidnt(r,:);
    pbox(i,1:9)='dumbox   ';
  else
    i=strmatch(buidnt(r,:),asyid);
    if ~isempty(i)
%      asyid(i,1:6)='      ';
      asyid(i,:)=char(32*ones(1,size(asyid,2)));
      pbox(i,1:9)='         ';
    end
  end
end
evstr=['save ' poolfil ' pos asyid pbox'];
eval(evstr);
