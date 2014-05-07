%@(#)   plottobas.m 1.1	 05/07/13     10:29:36
%
%
function [cpil,hcpil]=plottobas(kedja,mminj,hcpil,cpil)

hmain=gcf;
userdata=get(hmain,'userdata');
startpos=userdata(105);
delked=kedja(startpos:length(kedja),1);
ldelked=length(delked);
[right,left]=knumhalf(mminj);

for i=1:ldelked,
  temp=find(right==delked(i));
  if temp~=[],
    lright=length(right);
    if right(lright/2)<=delked(i),
	cf=[27.0000 29.0000];
    else
	cf=[2.0000 26.0000];
    end
  else
    lleft=length(left);
    if left(lleft/2)<=delked(i),
	cf=[27.0000 2.0000];
    else
	cf=[4.0000 2.0000];
    end
  end
  nupos=knum2cpos(delked(i),mminj);
  xled=[nupos(:,2)'+.7;cf(:,2)'+.35]; 
  yled=[nupos(:,1)'+.7;cf(:,1)'+.45];

  v=[xled(1,1)-xled(2,1) yled(1,1)-yled(2,1)];
  v=v/norm(v)*0.2;
  vort=[-v(2) v(1)]/2;
  x3=xled(2,1)+v(1)+vort(1);
  x4=xled(2,1)+v(1)-vort(1);
  xl1(:,1)=[xled(:,1);x3;x4;xled(2,1)];  
  y3=yled(2,1)+v(2)+vort(2);
  y4=yled(2,1)+v(2)-vort(2);
  yl1(:,1)=[yled(:,1);y3;y4;yled(2,1)];

  pfarg=[0 0 0.3
         0 0 0.8
         0 0 0
         0.3 0.3 0.3
         0.3 0 0
         0.8 0 0
         0 0.3 0
         0 0.5  0];

  ifa=size(pfarg,1);
  nfa=i-fix(i/ifa)*ifa;if nfa==0,nfa=ifa;end

  if nargin<4,                
    cpil=line(xl1,yl1,'color',pfarg(nfa,:),'erasemode','none','Visible','off');
  else
    cpil=line(xl1,yl1,'color',pfarg(nfa,:),'erasemode','none');
  end
  hcpil=[hcpil;cpil];
end
	              								              		
  
