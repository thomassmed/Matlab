%@(#)   clearpool.m 1.2	 10/09/09     10:31:15
%
%
%function clearpool(poolfil,buidnt,hapool,hepool,htpool,angra)
function clearpool(poolfil,buidnt,hapool,hepool,htpool,angra)
if nargin<6, angra=0;end
if angra==1,
  handles=get(gcf,'userdata');
  bocfile=get(handles(91),'userdata');
  buidboc=readdist7(bocfile,'asyid');
  bocburn=readdist7(bocfile,'burnup');
  iboc=strmatch(buidnt,buidboc);
  bur=mean(bocburn(:,iboc));
  if bur==0, matvalue=6;else matvalue=9;end
end
load(poolfil);
i=strmatch(buidnt,tempasyid);
if ~isempty(i)
  ppos=temppos(i,:);
else
  i=strmatch(buidnt,tmpbuid);
  if angra==1,
    ppos=tmppos(i,:);    
  else
    ppos=tmppos(i,:);
    tmppos(i,:)=[];
    tmpbuid(i,:)=[];
    tmpbox(i,:)=[];
  end
end
%
% A-bassäng
%
amat=get(hapool,'userdata');
c=get(hapool,'children');
ya=get(c(1),'yticklabel');
xa=get(c(1),'userdata');
if isempty(htpool)
  i=strmatch(ppos(1:2),ya);
  j=strmatch(ppos(3:5),xa);
else
  i=strmatch(ppos(3:5),ya);
  j=strmatch(ppos(1:2),xa);
end
if ~isempty(j) & ~isempty(i) 
  figure(hapool);
  if angra==1,
    amat(i,j)=matvalue;
  else
    line([j-.3 j+.3 j+.3 j-.3 j-.3],[i-.3 i-.3 i+.3 i+.3 i-.3],'color','k')
    amat(i,j)=4;
  end
  set(hapool,'userdata',amat);
end
%
% E-bassäng
%
emat=get(hepool,'userdata');
c=get(hepool,'children');
ye=get(c(1),'yticklabel');
xe=get(c(1),'userdata');
if isempty(htpool)
  i=strmatch(ppos(1:2),ye);
  j=strmatch(ppos(3:5),xe);
else
  i=strmatch(ppos(3:5),ye);
  j=strmatch(ppos(1:2),xe);
end
if ~isempty(j) & ~isempty(i)
  figure(hepool);
  if angra==1,
    emat(i,j)=matvalue;
  else
    line([j-.3 j+.3 j+.3 j-.3 j-.3],[i-.3 i-.3 i+.3 i+.3 i-.3],'color','k')
    emat(i,j)=4;
  end
  set(hepool,'userdata',emat);
end
%
% T-bassäng
%
if ~isempty(htpool)
  tmat=get(htpool,'userdata');
  c=get(htpool,'children');
  yt=get(c(1),'yticklabel');
  xt=get(c(1),'userdata');
  i=strmatch(ppos(3:5),yt);
  j=strmatch(ppos(1:2),xt);
  if ~isempty(i)
    figure(htpool);
    if angra==1,
      tmat(i,j)=matvalue;
    else
      line([j-.3 j+.3 j+.3 j-.3 j-.3],[i-.3 i-.3 i+.3 i+.3 i-.3],'color','k')
      tmat(i,j)=4;
    end
    set(htpool,'userdata',tmat);
  end
end
evstr=['save ' poolfil ' temppos tempasyid temppbox tmppos tmpbuid tmpbox'];
%eval(evstr);
