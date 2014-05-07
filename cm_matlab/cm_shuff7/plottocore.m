%@(#)   plottocore.m 1.1	 05/07/13     10:29:37
%
%
function [bpil,bring]=plottocore(mminj,lfrom,lto,bpil,bring)

tomkan=(lfrom'==0).*lto;
ltomkan=length(tomkan);
for i=1:ltomkan,
  if tomkan(i)>0,
    kanlist=[kanlist;tomkan(i)];
  end
end
[right,left]=knumhalf(mminj);
lkanlist=length(kanlist);

for i=1:lkanlist,
  temp=find(right==kanlist(i));
  if temp~=[],
    lright=length(right);
    if right(lright/2)<=kanlist(i),
	cf=[29.0000 26.0000];
    else
	cf=[3.0000 29.0000];
    end
  else
    lleft=length(left);
    if left(lleft/2)<=kanlist(i),
	cf=[29.0000 4.0000];
    else
	cf=[2.0000 5.0000];
    end
  end

  nupos=knum2cpos(kanlist(i),mminj);
  xled=[cf(:,2)'+.7;nupos(:,2)'+.35]; 
  yled=[cf(:,1)'+.7;nupos(:,1)'+.45];

  v=[xled(1,1)-xled(2,1) yled(1,1)-yled(2,1)];
  v=v/norm(v)*0.2;
  vort=[-v(2) v(1)]/2;
  x3=xled(2,1)+v(1)+vort(1);
  x4=xled(2,1)+v(1)-vort(1);
  xl1(:,1)=[xled(:,1);x3;x4;xled(2,1)];  
  y3=yled(2,1)+v(2)+vort(2);
  y4=yled(2,1)+v(2)-vort(2);
  yl1(:,1)=[yled(:,1);y3;y4;yled(2,1)];
  if nargin<4
    bring(i)=line(cf(1,2)+.75,cf(1,1)+.75,'linestyle','o','color','black',...
    'erasemode','none','Visible','off');  
    bpil(i)=line(xl1,yl1,'color','black','erasemode','none','Visible','off');
  else
     bring(i)=line(cf(1,2)+.75,cf(1,1)+.75,'linestyle','o','color','black',...
    'erasemode','none');  
     bpil(i)=line(xl1,yl1,'color','black','erasemode','none'); 
  end
end


