%@(#)   respool.m 1.2	 10/09/09     10:46:50
%
%function respool(poolfil,buidnt,hapool,hepool)
function respool(poolfil,buidnt,hapool,hepool)
load(poolfil);
ipos=strmatch(buidnt,buid);
bpos=pos(ipos,:);
pos(ipos,:)=[];
buid(ipos,:)=[];
pbox(ipos,:)=[];
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
  figure(hapool);
  abass(i,j)=4;
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
  figure(hepool);
  emat(i,j)=4;
  set(hepool,'userdata',emat);
end
evstr=['save ' poolfil ' pos buid pbox'];
eval(evstr);
