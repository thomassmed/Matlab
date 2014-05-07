%@(#)   setpool.m 1.1	 05/07/13     10:29:40
%
function setpool(poolfil,buidnt,bpos,hapool,hepool)
load(poolfil)
%
% A-bassäng
%
amat=get(hapool,'userdata');
c=get(hapool,'children');
ya=get(c(1),'yticklabel');
xa=get(c(1),'userdata');
i=mbucatch(bpos(:,1:2),ya);
j=mbucatch(bpos(:,3:5),xa);
j1=find(j==0);if j1~=[],i(j1)=[];j(j1)=[];end
if i~=[]
  amat(i,j)=9;
  set(hapool,'userdata',amat);
end
%
% E-bassäng
%
emat=get(hepool,'userdata');
c=get(hepool,'children');
ye=get(c(1),'yticklabel');
xe=get(c(1),'userdata');
i=mbucatch(bpos(:,1:2),ye);
j=mbucatch(bpos(:,3:5),xe);
j1=find(j==0);if j1~=[],i(j1)=[];j(j1)=[];end
if i~=[]
  emat(i,j)=9;
  set(hepool,'userdata',emat);
end
pos=[pos; bpos];
buid=[buid; buidnt];
pbox=[pbox; 'dumbox'];
evstr=['save ' poolfil ' pos buid pbox'];
eval(evstr);
