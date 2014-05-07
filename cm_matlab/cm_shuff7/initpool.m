%@(#)   initpool.m 1.2	 10/09/09     10:31:07
%
%@(#)   initpool.m 1.2	 10/09/09     10:31:07
%
%function initpool(poolfil,bunhistfil,hapool,hepool,htpool)
function initpool(poolfil,bunhistfil,hapool,hepool,htpool)
load(poolfil);
tmpbuid=[];
tmppos=[];
tmpbox=[];
load(bunhistfil);
j1=strmatch('      ',tempasyid);
j2=strmatch('         ',temppbox);
j3=findint(j1,j2);
j3=j3(find(j3));
if ~isempty(j3)
  temppos(j2(j3),:)=[];
  tempasyid(j2(j3),:)=[];
  temppbox(j2(j3),:)=[];
end
ASYID=str2mat(ASYID,'DUMMY','R001','R002','R003','R101');			
ASYID=str2mat(ASYID,'R102','R103','R104','R105','R106','R107');
ASYID=str2mat(ASYID,'R108','R109','R110','R201','R202','R203');
ASYID=str2mat(ASYID,'R204','R205','R206','R207','R208','R209');
ASYID=str2mat(ASYID,'R210','R211','R212','R213');
j1=mbucatch(ASYID,tempasyid);
j1=j1(find(j1));
j2=strmatch('      ',tempasyid);
j1=[j1;j2];
if ~isempty(j1)
  brpos=temppos(j1,:);
  frpos=temppos; frpos(j1,:)=[];
end
%
% A-bassäng
%
c=get(hapool,'children');
ya=get(c(1),'yticklabel');
xa=get(c(1),'userdata');
if isempty(htpool)
  i=mbucatch(brpos(:,1:2),ya);
  j=mbucatch(brpos(:,3:5),xa);
else
  i=mbucatch(brpos(:,3:5),ya);
  j=mbucatch(brpos(:,1:2),xa);
end
j1=find(j==0);if ~isempty(j1),i(j1)=[];j(j1)=[];end
i1=find(i==0);if ~isempty(i1),i(i1)=[];j(i1)=[];end
c1=get(c(1),'children');
m=get(c1(length(c1)),'cdata');
m=4*ones(size(m));
m=setsparse(m,i,j,9*ones(1,length(i)));
set(c1(length(c1)),'cdata',m)
set(hapool,'userdata',m)
% färska
if ~isempty(frpos)
  if isempty(htpool)
    i=mbucatch(frpos(:,1:2),ya);
    j=mbucatch(frpos(:,3:5),xa);
  else
    i=mbucatch(frpos(:,3:5),ya);
    j=mbucatch(frpos(:,1:2),xa);
  end
  j1=find(j==0);if ~isempty(j1),i(j1)=[];j(j1)=[];end
  i1=find(i==0);if ~isempty(i1),i(i1)=[];j(i1)=[];end
  m=setsparse(m,i,j,6*ones(1,length(i)));
  set(c1(length(c1)),'cdata',m)
  set(hapool,'userdata',m)
end
%
% E-bassäng
%
c=get(hepool,'children');
ye=get(c(1),'yticklabel');
xe=get(c(1),'userdata');
if isempty(htpool)
  i=mbucatch(temppos(:,1:2),ye);
  j=mbucatch(temppos(:,3:5),xe);
else
  i=mbucatch(temppos(:,3:5),ye);
  j=mbucatch(temppos(:,1:2),xe);
end
j1=find(j==0);if ~isempty(j1),i(j1)=[];j(j1)=[];end
i1=find(i==0);if ~isempty(i1),i(i1)=[];j(i1)=[];end
c1=get(c(1),'children');
m=get(c1(length(c1)),'cdata');
m=4*ones(size(m));
m=setsparse(m,i,j,9*ones(1,length(i)));
set(c1(length(c1)),'cdata',m)
set(hepool,'userdata',m)
% färska
if ~isempty(frpos)
  if isempty(htpool)
    i=mbucatch(frpos(:,1:2),ye);
    j=mbucatch(frpos(:,3:5),xe);
  else
    i=mbucatch(frpos(:,3:5),ye);
    j=mbucatch(frpos(:,1:2),xe);
  end
  j1=find(j==0);if ~isempty(j1),i(j1)=[];j(j1)=[];end
  i1=find(i==0);if ~isempty(i1),i(i1)=[];j(i1)=[];end
  m=setsparse(m,i,j,6*ones(1,length(i)));
  set(c1(length(c1)),'cdata',m)
  set(hepool,'userdata',m)
end
%
% T-bassäng
%
if ~isempty(htpool)
  c=get(htpool,'children');
  yt=get(c(1),'yticklabel');
  xt=get(c(1),'userdata');
  i=mbucatch(temppos(:,3:5),yt);
  j=mbucatch(temppos(:,1:2),xt);
  j1=find(j==0);if ~isempty(j1),i(j1)=[];j(j1)=[];end
  i1=find(i==0);if ~isempty(i1),i(i1)=[];j(i1)=[];end
  c1=get(c(1),'children');
  m=get(c1(length(c1)),'cdata');
  m=4*ones(size(m));
  m=setsparse(m,i,j,9*ones(1,length(i)));
  set(c1(length(c1)),'cdata',m)
  set(htpool,'userdata',m)
  % färska
  if ~isempty(frpos)
    i=mbucatch(frpos(:,3:5),yt);
    j=mbucatch(frpos(:,1:2),xt);
    j1=find(j==0);if ~isempty(j1),i(j1)=[];j(j1)=[];end
    i1=find(i==0);if ~isempty(i1),i(i1)=[];j(i1)=[];end
    m=setsparse(m,i,j,6*ones(1,length(i)));
    set(c1(length(c1)),'cdata',m)
    set(htpool,'userdata',m)
  end
end
evstr=['save ' poolfil ' temppos tempasyid temppbox tmppos tmpbuid tmpbox'];
eval(evstr);
